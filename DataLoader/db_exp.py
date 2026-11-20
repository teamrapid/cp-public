import argparse
import csv
import os
import sys
import sqlglot
import yaml
from pathlib import Path
from sqlalchemy.engine import URL
from sqlalchemy import create_engine, MetaData, Table, select
from datetime import datetime,timezone
import pandas as pd
import re

EXPORT_SQL_FILE = Path(__file__).resolve().parent.parent / "SQL" / "_export_omop_tables.sql"
COHORT_TABLE = "#feature_codes_cohort"        # temp table name that _all_feature_codes.sql creates
SQL_FILE = Path(__file__).resolve().parent.parent  /  "SQL" / "_all_feature_codes.sql"         # SQL file to translate and run
SOURCE_DIALECT = "tsql"         # dialect SQL_FILE is written in 
YAML_FILE = "config.yaml"       # database settings + extra columns
OUTPUT_FILE = "results.csv"     # default output path
OUTPUT_DIRECTORY = Path(__file__).resolve().parent
EXPORT_DIRECTORY = OUTPUT_DIRECTORY / "OMOP_EXTRACT"

GROUP_KEYS = ("site_code", "cp_name", "data_snapshot_date")
SUMMARY_ROW_TYPE = "summary"

SCHEMA_NAME = "omop"
EXCLUDED_PREFIXES = ("ZBU", "XSTG")


# SQLAlchemy URL -> sqlglot dialect name 
BACKEND_TO_DIALECT = {
    "postgresql": "postgres",
    "mssql": "tsql",
    "mariadb": "mysql",
    "awsathena": "athena",
}

def load_config(path):
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    return data

def build_db_url(config):
    db = config.get("database")
    return URL.create(
        drivername=db["drivername"],
        username=db.get("username"),
        password=db.get("password"),
        host=db.get("host"),
        port=db.get("port"),
        database=db.get("database"),
        query=stringify_query(db.get("query") or {}),
    )

# URL.create wants string values in query, but yaml hands back ints/bools    
def stringify_query(query):
    result = {}
    for key, value in query.items():
        string_key = str(key)
        if isinstance(value, bool):
            string_value = "yes" if value else "no"
        else:
            string_value = str(value)
        result[string_key] = string_value
    return result
    
    
def dialect_from_url(url):
    backend = url.get_backend_name()
    return BACKEND_TO_DIALECT.get(backend, backend)

# returns a list of statements, one per ; in the source file
def translate_sql(sql, source, target):
    return sqlglot.transpile(sql, read=source, write=target, pretty=True)


def write_sql_file(statements, output):
    with open(output, "w", encoding="utf-8") as f:
        f.write(";\n\n".join(statements) + ";\n")

def to_number(value):
    # count_value can come back as int, Decimal, str or None depending on the driver
    if value is None or value == "":
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None
 
 
def blank_out(record):
    record["count_value"] = ""
    record["count_status"] = "suppressed"
 
def suppress_small_counts(records, threshold, complementary):

    primary = set()
    for i, rec in enumerate(records):
        n = to_number(rec.get("count_value"))
        if n is not None and 0 < n < threshold:
            blank_out(rec)
            primary.add(i)
 
    if not complementary:
        return
 
    # secondary suppression: if a group has exactly one hidden cell
    groups = {}
    for i, rec in enumerate(records):
        key = tuple(rec.get(k) for k in GROUP_KEYS)
        groups.setdefault(key, []).append(i)
 
    for key, idxs in groups.items():
        hidden = [i for i in idxs if i in primary]
        if len(hidden) != 1:
            continue

        candidates = []
        summary_candidates = []
        for i in idxs:
            if i in primary:
                continue
            n = to_number(records[i].get("count_value"))
            if n is None or n <= 0:
                continue
            if records[i].get("row_type") == SUMMARY_ROW_TYPE:
                summary_candidates.append((n, i))
            else:
                candidates.append((n, i))
        if not candidates:
            candidates = summary_candidates
 
        if not candidates:
            print(f"Warning: could not find a second cell to suppress for {key}; "
                  f"the hidden count may be recoverable", file=sys.stderr)
            continue
 
        # smallest one loses the least information
        candidates.sort()
        blank_out(records[candidates[0][1]])
        
def check_name(name):
    """Allow only letters, digits, underscores, dots and a leading # (temp tables)."""
    if not re.fullmatch(r"[A-Za-z_#][A-Za-z0-9_.]*", name):
        raise ValueError(f"Invalid SQL name: {name!r}")
        
def export_omop_tables(conn, sql_path, schema, cohort_table,
                       source_dialect, target_dialect, output_dir):
    check_name(schema)
    check_name(cohort_table)

    sql_text = Path(sql_path).read_text(encoding="utf-8")
    sql_text = sql_text.replace("{schema}", schema)
    cohort_subquery = f"(SELECT DISTINCT person_id FROM {cohort_table})"
    sql_text = sql_text.replace("{cohort_table}", cohort_subquery)
    sql_text = sql_text.replace("{cohort_table}", cohort_table)

    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Everything before the first "-- table:" marker is just the file header
    blocks = sql_text.split("-- table:")[1:]

    for block in blocks:
        table_name, _, statement = block.partition("\n")
        table_name = table_name.strip()

        # Translate like the main SQL
        statement = translate_sql(statement, source_dialect, target_dialect)[0]

        result = conn.exec_driver_sql(statement)
        columns = list(result.keys())
        output_path = output_dir / f"{table_name}.csv"
        row_count = 0

        with open(output_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(columns)

            while True:
                rows = result.fetchmany(10000)
                if not rows:
                    break
                writer.writerows(rows)
                row_count += len(rows)

        print(f"Wrote {row_count} rows to {output_path}") 

def execute_and_write_csv(statements, url, config_columns, output, suppression=None):
    
    engine = create_engine(url)
    result_columns, result_rows = None, None

    with engine.begin() as conn:
        for i, stmt in enumerate(statements, start=1):
            result = conn.exec_driver_sql(stmt)
            if result.returns_rows:
                if result_columns is not None:
                    print(
                        f"Warning: statement {i} also returned rows; "
                        f"only the last statement will be written.",
                        file=sys.stderr,
                    )
                result_columns = list(result.keys())
                result_rows = result.fetchall()
                
          # Same connection, so the temp table still exists
        export_omop_tables(
            conn, EXPORT_SQL_FILE, SCHEMA_NAME, COHORT_TABLE,
            SOURCE_DIALECT, dialect_from_url(url), EXPORT_DIRECTORY,
        )


    if result_columns is None:
        raise RuntimeError("None of the statements returned rows; nothing to write.")
    
    FIELD_ORDER = [
        "site_code",
        "result_spec_version",
        "generated_at",
        "cp_name",
        "run_date",
        "data_snapshot_date",
        "row_type",
        "criterion_id",
        "population_n",
        "population_basis",
        "population_basis_note",
        "count_value",
        "count_status",
    ]

    now = datetime.now(timezone.utc)

    extras = dict(config_columns)
    extras["generated_at"] = now.strftime("%Y-%m-%dT%H:%M:%SZ")
    extras["run_date"] = now.strftime("%Y-%m-%d")
    result_columns = [column.lower() for column in result_columns]
    for column in list(result_columns) + list(extras):
        if column not in FIELD_ORDER:
            print(f"Warning: column '{column}' is not in the schema and was not written")  
    records = []
    for row in result_rows:
        values = {}
        for index, column in enumerate(result_columns):
            values[column] = row[index]
        # config wins over query output if both have the same column
        values.update(extras)
        records.append(values)
 
    suppression = suppression or {}
    threshold = suppression.get("threshold")
    complementary = suppression.get("complementary")
    if suppression.get("enabled"):
        suppress_small_counts(records, threshold, complementary)
    else:
        print("Note: suppression is turned off, small counts are written as-is", file=sys.stderr)
 
    with open(output, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(FIELD_ORDER)
        for values in records:
            # missing columns just come out blank
            writer.writerow([values.get(column, "") for column in FIELD_ORDER])
            

    print(f"Wrote {len(result_rows)} rows to {output}")

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--output", "-o", type=Path, default=None)
    p.add_argument("--translate-only", action="store_true")
    args = p.parse_args()

    try:
        config = load_config(Path(YAML_FILE))
        url = build_db_url(config)
        target_dialect = dialect_from_url(url)
        sql = Path(SQL_FILE).read_text(encoding="utf-8")
        statements = translate_sql(sql, SOURCE_DIALECT, target_dialect)
        output = args.output or Path(OUTPUT_FILE)
        if args.translate_only:
            if args.output is None:
                output = output.with_suffix(".sql")
            write_sql_file(statements, output)
            print(f"Wrote {len(statements)} translated statement(s) to {output}")
            return 0
        execute_and_write_csv(statements, url, config.get("columns"), output, config.get("suppression"))
        return 0
    except Exception as e: 
        print(f"Execution error: {e}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
