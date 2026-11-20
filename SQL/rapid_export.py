from __future__ import annotations

import logging
import re
from pathlib import Path
from typing import Any, Iterator

import pandas as pd
import yaml
import numbers


BASE_DIR = Path("C:/Users/mlabrams/Documents/RAPID/rapids-prototype-main")
SPECS_DIR = BASE_DIR / "test-cp-main" / "cps"     
OUT_DIR = BASE_DIR / "SQL"
CDM_SCHEMA = "omop"
COUNTS = "all"

log = logging.getLogger("feature_codes")

YAML_SUFFIXES = {".yml", ".yaml"}

MASTER_NAME = "_all_feature_codes.sql"
MANIFEST_NAME = ".feature_codes_manifest.txt"

CODES_KEY = "codes"
DISJUNCTS_KEY = "disjuncts"
DESC_KEY = "include_descendants"
GENE_KEYS = ["gene_symbol", "hgnc_id", "interpretations"]
LIST_CONTEXT_KEYS = {"interpretations"} 
CONTEXT_KEYS = {
    "cp_name": "cp_name",
    "id": "feature_id",
    "module": "module",
    "vocabulary": "vocabulary",
    DESC_KEY: DESC_KEY,
    **{k: k for k in GENE_KEYS},
}
GROUP_CONTEXT_KEYS = {k: CONTEXT_KEYS[k] for k in (DESC_KEY, *GENE_KEYS)}
NESTED_CONTEXT_KEYS = {"genetic"}
CORE_COLS = ["cp_name", "feature_id", "module", "vocabulary", "code"]
STAGE_COLS = CORE_COLS + [DESC_KEY] + GENE_KEYS
REQUIRED_CONTEXT = ["cp_name", "feature_id", "module", "vocabulary"]
NOT_NULL = {"cp_name", "feature_id", "code", DESC_KEY}
COL_TYPES = {"vocabulary": "VARCHAR(20)", "code": "VARCHAR(50)", DESC_KEY: "BIT"}

TRUE_VALUES = {"true", "yes", "y", "1", "on"}
FALSE_VALUES = {"false", "no", "n", "0", "off", ""}

DISJ_COLS = ["cp_name", "criterion_id", "feature_id", "label"]
DISJ_NOT_NULL = {"cp_name", "criterion_id", "feature_id"}

DOMAIN_TABLES = {
    "Condition":   ("condition_occurrence", "condition_concept_id",   "condition_occurrence_id"),
    "Measurement": ("measurement",          "measurement_concept_id", "measurement_id"),
    "Drug":        ("drug_exposure",        "drug_concept_id",        "drug_exposure_id"),
    "Procedure":   ("procedure_occurrence", "procedure_concept_id",   "procedure_occurrence_id"),
    "Observation": ("observation",          "observation_concept_id", "observation_id"),
    "Device":      ("device_exposure",      "device_concept_id",      "device_exposure_id"),
    "Visit":       ("visit_occurrence",     "visit_concept_id",       "visit_occurrence_id"),
    "Specimen":    ("specimen",             "specimen_concept_id",    "specimen_id"),
}


def iter_yaml_files(root: Path) -> Iterator[Path]:
    for p in sorted(root.rglob("*")):
        if p.is_file() and p.suffix.lower() in YAML_SUFFIXES:
            yield p


def load_docs(path: Path) -> list[Any]:
    with open(path, encoding="utf-8") as f:
        return [d for d in yaml.safe_load_all(f) if d is not None]


def _take(out: dict, src: dict, keys: dict) -> None:
    for yaml_key, col in keys.items():
        if yaml_key not in src or src[yaml_key] is None:
            continue                                 
        v = src[yaml_key]
        if isinstance(v, list) and yaml_key in LIST_CONTEXT_KEYS:
            out[col] = v                             
        elif not isinstance(v, (dict, list)):
            out[col] = v


def update_context(context: dict, node: dict, keys: dict = CONTEXT_KEYS) -> dict:
    out = dict(context)
    _take(out, node, keys)
    gene_keys = {k: c for k, c in keys.items() if k in GENE_KEYS}
    for name in NESTED_CONTEXT_KEYS:
        sub = node.get(name)
        if isinstance(sub, dict):
            _take(out, sub, gene_keys)
    return out


def flatten_codes(v: Any, context: dict, path: str, group: str | None = None) -> Iterator[dict]:
    if isinstance(v, list):
        for i, item in enumerate(v):
            yield from flatten_codes(item, context, f"{path}[{i}]", group)
    elif isinstance(v, dict):
        if "code" in v:
            yield {**context, "code_group": group, **v, "path": path}
        else:
            context = update_context(context, v, GROUP_CONTEXT_KEYS)
            for k, sub in v.items():
                if k in GROUP_CONTEXT_KEYS or k in NESTED_CONTEXT_KEYS:
                    continue
                if isinstance(sub, (list, dict)):
                    g = k if group is None else f"{group}.{k}"
                    yield from flatten_codes(sub, context, f"{path}.{k}", g)
                else:
                    yield {**context, "code_group": group, "code": k,
                           "value": sub, "path": f"{path}.{k}"}
    elif v is not None:
        yield {**context, "code_group": group, "code": v, "path": path}

def walk_codes(node: Any, context: dict | None = None, path: str = "") -> Iterator[dict]:
    context = dict(context or {})
    if isinstance(node, dict):
        context = update_context(context, node)
        for k, v in node.items():
            child = f"{path}.{k}" if path else str(k)
            if k == CODES_KEY:
                yield from flatten_codes(v, context, child)
            elif k == DISJUNCTS_KEY:
                continue
            else:
                yield from walk_codes(v, context, child)
    elif isinstance(node, list):
        for i, item in enumerate(node):
            yield from walk_codes(item, context, f"{path}[{i}]")


def flatten_disjuncts(v: Any, context: dict, path: str) -> Iterator[dict]:
    items = v if isinstance(v, list) else [v]
    for i, d in enumerate(items):
        p = f"{path}[{i}]"
        if not isinstance(d, dict):
            yield {**context, "path": p}          
            continue
        feats = d.get("feature", d.get("features"))
        feats = feats if isinstance(feats, list) else [feats]
        for f in feats:
            yield {**context, "criterion_id": d.get("id"), "feature_id": f,
                   "label": d.get("label"), "path": p}


def walk_disjuncts(node: Any, context: dict | None = None, path: str = "") -> Iterator[dict]:
    context = dict(context or {})
    if isinstance(node, dict):
        if "cp_name" in node and not isinstance(node["cp_name"], (dict, list)):
            context["cp_name"] = node["cp_name"]
        for k, v in node.items():
            child = f"{path}.{k}" if path else str(k)
            if k == DISJUNCTS_KEY:
                yield from flatten_disjuncts(v, context, child)
            else:
                yield from walk_disjuncts(v, context, child)
    elif isinstance(node, list):
        for i, item in enumerate(node):
            yield from walk_disjuncts(item, context, f"{path}[{i}]")


def extract_file(path: Path) -> tuple[pd.DataFrame, pd.DataFrame]:
    codes, disj = [], []
    for i, doc in enumerate(load_docs(path)):
        codes += [{**r, "doc": i} for r in walk_codes(doc)]
        disj += [{**r, "doc": i} for r in walk_disjuncts(doc)]
    return (pd.DataFrame(codes),
            pd.DataFrame(disj, columns=DISJ_COLS + ["path", "doc"]))


def parse_flag(v: Any) -> int | None:
    if v is None or (not isinstance(v, (list, dict)) and pd.isna(v)):
        return 0
    if isinstance(v, bool):
        return int(v)
    if isinstance(v, (int, float)):
        return int(bool(v))
    s = str(v).strip().lower()
    if s in TRUE_VALUES:
        return 1
    if s in FALSE_VALUES:
        return 0
    return None

def format_item(x: Any) -> str | None:
    if isinstance(x, dict):
        label = x.get("label")
        code = x.get("code")
        ref = f"{x.get('vocabulary')}:{code}" if code not in (None, "") else None
        if label and ref:
            return f"{label} [{ref}]"
        return label or ref
    return None if x is None else str(x)


def join_list(v: Any) -> Any:
    if isinstance(v, list):
        parts = [p for p in (format_item(x) for x in v) if p]
        return "; ".join(parts) if parts else pd.NA
    return v

def prepare(df: pd.DataFrame, rel: str, issues: list) -> pd.DataFrame:
    df = df.copy()
    df["file"] = rel
    for col in CORE_COLS:
        if col not in df:
            df[col] = pd.NA
        df[col] = df[col].astype("string")
    for col in REQUIRED_CONTEXT:
        n = int(df[col].isna().sum())
        if n:
            issues.append({"file": rel, "issue": f"{n} rows missing {col}"})

    raw = df[DESC_KEY] if DESC_KEY in df else pd.Series([None] * len(df), index=df.index)
    parsed = raw.map(parse_flag)
    bad = parsed.isna()
    if bad.any():
        vals = ", ".join(sorted({str(x) for x in raw[bad]})[:5])
        issues.append({"file": rel,
                       "issue": f"{int(bad.sum())} rows with unrecognised {DESC_KEY} ({vals}); treated as false"})
    df[DESC_KEY] = parsed.map(lambda x: 0 if x is None else x).astype(int)

    for col in GENE_KEYS:
        if col not in df:
            df[col] = pd.NA
        df[col] = df[col].map(join_list).astype("string")

    return df


def prepare_disjuncts(disj: pd.DataFrame, codes: pd.DataFrame, rel: str,
                      issues: list) -> pd.DataFrame:
    disj = disj.copy()
    disj["file"] = rel
    for col in DISJ_COLS:
        disj[col] = disj[col].astype("string")

    bad = disj[sorted(DISJ_NOT_NULL)].isna().any(axis=1)
    if bad.any():
        where = ", ".join(disj.loc[bad, "path"].astype(str).unique()[:5])
        issues.append({"file": rel,
                       "issue": f"{int(bad.sum())} disjunct rows missing cp_name/id/feature ({where})"})
    disj = disj[~bad]

    known = set(zip(codes["cp_name"], codes["feature_id"]))
    unknown = sorted({f"{c}/{f}" for c, f in zip(disj["cp_name"], disj["feature_id"])
                      if (c, f) not in known})
    if unknown:
        issues.append({"file": rel,
                       "issue": f"disjunct features not found in codes: {', '.join(unknown)}"})

    return disj.drop_duplicates(subset=DISJ_COLS)


def sql_literal(v: Any) -> str:
    if v is None or pd.isna(v):
        return "NULL"
    if isinstance(v, numbers.Integral):
        return str(int(v))
    return "N'" + str(v).replace("'", "''") + "'"


        
def temp_table_sql(df: pd.DataFrame, table: str, cols: list[str], not_null: set[str],
                   index_cols: list[str], batch: int = 1000) -> str:
    def width(col: str, floor: int = 10) -> int:
        lengths = df[col].dropna().astype(str).str.len() if col in df else pd.Series(dtype=int)
        n = int(lengths.max()) if len(lengths) else 0
        return max(floor, n * 2)

    def col_type(c: str) -> str:
        if c in COL_TYPES:
            return COL_TYPES[c]
        w = width(c)
        return f"NVARCHAR({w})" if w <= 4000 else "NVARCHAR(MAX)"

    col_defs = ",\n".join(
        f"    {c:<12} {col_type(c)}{' NOT NULL' if c in not_null else ''}" for c in cols
    )
    parts = [f"DROP TABLE IF EXISTS {table};", f"CREATE TABLE {table} (\n{col_defs}\n);"]

    data = df.reindex(columns=cols).drop_duplicates()
    for start in range(0, len(data), batch):
        chunk = data.iloc[start:start + batch]
        values = ",\n".join("(" + ", ".join(sql_literal(v) for v in row) + ")"
                            for row in chunk.itertuples(index=False))
        parts.append(f"INSERT INTO {table} ({', '.join(cols)}) VALUES\n{values};")

    parts.append(f"CREATE INDEX ix_{'_'.join(index_cols)} ON {table} ({', '.join(index_cols)});")
    return "\n\n".join(parts)


def omop_concept_sql(cdm_schema: str, stage: str, final: str, map_to_standard: bool = True) -> str:
    concept = f"{cdm_schema}.concept"
    rel = f"{cdm_schema}.concept_relationship"
    ancestor = f"{cdm_schema}.concept_ancestor"

    std_cols = std_joins = std_index = ""
    if map_to_standard:
        std_cols = """,
    cs.concept_id        AS standard_concept_id,
    cs.concept_name      AS standard_concept_name,
    cs.domain_id         AS standard_domain_id"""
        std_joins = f"""
LEFT JOIN {rel} AS cr
       ON cr.concept_id_1    = c.concept_id
      AND cr.relationship_id = 'Maps to'
      AND cr.invalid_reason IS NULL
LEFT JOIN {concept} AS cs
       ON cs.concept_id       = cr.concept_id_2
      AND cs.standard_concept = 'S'
      AND cs.invalid_reason IS NULL"""
        std_index = f"\nCREATE INDEX ix_final_std ON {final} (standard_concept_id);"

        desc_anchor = "COALESCE(f.standard_concept_id, f.concept_id)"
        desc_cols = ("concept_id, concept_name, domain_id, concept_class_id, standard_concept, "
                     "invalid_reason, standard_concept_id, standard_concept_name, standard_domain_id")
        desc_vals = """f.concept_id, f.concept_name, f.domain_id, f.concept_class_id,
    f.standard_concept, f.invalid_reason,
    d.concept_id, d.concept_name, d.domain_id"""
    else:
        desc_anchor = "f.concept_id"
        desc_cols = "concept_id, concept_name, domain_id, concept_class_id, standard_concept, invalid_reason"
        desc_vals = """d.concept_id, d.concept_name, d.domain_id, d.concept_class_id,
    d.standard_concept, d.invalid_reason"""

    return f"""DROP TABLE IF EXISTS {final};

SELECT
    s.cp_name,
    s.feature_id,
    s.module,
    s.vocabulary,
    s.code,
    s.include_descendants,
    s.gene_symbol,
    s.hgnc_id,
    s.interpretations,
    c.concept_id,
    c.concept_name,
    c.domain_id,
    c.concept_class_id,
    c.standard_concept,
    c.invalid_reason{std_cols},
    CAST(NULL AS BIGINT) AS descendant_of
INTO {final}
FROM {stage} AS s
LEFT JOIN {concept} AS c
       ON c.vocabulary_id = s.vocabulary
      AND c.concept_code  = s.code{std_joins};

INSERT INTO {final} (cp_name, feature_id, module, vocabulary, code, include_descendants,
                     gene_symbol, hgnc_id, interpretations,
                     {desc_cols}, descendant_of)
SELECT DISTINCT
    f.cp_name, f.feature_id, f.module, f.vocabulary, f.code, f.include_descendants,
    f.gene_symbol, f.hgnc_id, f.interpretations,
    {desc_vals},
    a.ancestor_concept_id
FROM {final} AS f
JOIN {ancestor} AS a
  ON a.ancestor_concept_id   = {desc_anchor}
 AND a.descendant_concept_id <> a.ancestor_concept_id
JOIN {concept} AS d
  ON d.concept_id       = a.descendant_concept_id
 AND d.standard_concept = 'S'
 AND d.invalid_reason IS NULL
WHERE f.include_descendants = 1
  AND f.descendant_of IS NULL;

CREATE INDEX ix_final_concept ON {final} (concept_id);{std_index}

SELECT cp_name, feature_id, module, vocabulary, code
FROM {final}
WHERE concept_id IS NULL
ORDER BY vocabulary, code;"""

def counts_sql(cdm_schema: str, final: str, disj: str, map_to_standard: bool = True) -> str:
    concepts = f"{final}_concepts"
    events = f"{final}_events"
    counts = f"{final}_counts"
    feats = f"{final}_feature_counts"
    crit = f"{final}_criteria"
    pop = f"{final}_population"
    cohort = f"{final}_cohort"
    cid = "COALESCE(standard_concept_id, concept_id)" if map_to_standard else "concept_id"
    dom = "COALESCE(standard_domain_id, domain_id)" if map_to_standard else "domain_id"

    unions = "\n    UNION ALL\n".join(
        f"""    SELECT c.cp_name, c.feature_id, c.domain_id,
           CAST(t.{pk} AS BIGINT) AS event_id, t.person_id
    FROM {concepts} AS c
    JOIN {cdm_schema}.{table} AS t ON t.{col} = c.concept_id
    WHERE c.domain_id = '{domain}'"""
        for domain, (table, col, pk) in DOMAIN_TABLES.items()
    )
    handled = ", ".join(f"'{d}'" for d in DOMAIN_TABLES)

    return f"""DROP TABLE IF EXISTS {concepts};

SELECT DISTINCT
    cp_name,
    feature_id,
    {cid} AS concept_id,
    {dom} AS domain_id
INTO {concepts}
FROM {final}
WHERE {cid} IS NOT NULL;

CREATE INDEX ix_concepts ON {concepts} (domain_id, concept_id) INCLUDE (cp_name, feature_id);

DROP TABLE IF EXISTS {events};

WITH e AS (
{unions}
)
SELECT *
INTO {events}
FROM e;

CREATE INDEX ix_events ON {events} (cp_name, feature_id) INCLUDE (domain_id, event_id, person_id);

DROP TABLE IF EXISTS {counts};

WITH ev AS (
    SELECT DISTINCT cp_name, domain_id, event_id, person_id
    FROM {events}
)
SELECT
    cp_name,
    CAST(CASE WHEN GROUPING(domain_id) = 1 THEN 'All domains' ELSE domain_id END
         AS VARCHAR(20))          AS domain_id,
    COUNT_BIG(*)                  AS n_records,
    COUNT(DISTINCT person_id)     AS n_persons,
    CAST(NULL AS VARCHAR(30))     AS note
INTO {counts}
FROM ev
GROUP BY GROUPING SETS ((cp_name, domain_id), (cp_name));

INSERT INTO {counts} (cp_name, domain_id, n_records, n_persons, note)
SELECT DISTINCT c.cp_name, c.domain_id, 0, 0,
       CASE WHEN c.domain_id NOT IN ({handled}) THEN 'domain not counted' END
FROM {concepts} AS c
WHERE NOT EXISTS (SELECT 1 FROM {counts} AS f
                  WHERE f.cp_name = c.cp_name AND f.domain_id = c.domain_id);

INSERT INTO {counts} (cp_name, domain_id, n_records, n_persons, note)
SELECT DISTINCT c.cp_name, 'All domains', 0, 0, NULL
FROM {concepts} AS c
WHERE NOT EXISTS (SELECT 1 FROM {counts} AS f
                  WHERE f.cp_name = c.cp_name AND f.domain_id = 'All domains');

SELECT *
FROM {counts}
ORDER BY cp_name,
         CASE WHEN domain_id = 'All domains' THEN 1 ELSE 0 END,
         domain_id;

DROP TABLE IF EXISTS {pop};

SELECT
    CAST(N'all_persons' AS NVARCHAR(20))  AS population_type,
    COUNT(DISTINCT person_id)        AS n_persons
INTO {pop}
FROM {cdm_schema}.person
UNION ALL
SELECT N'observation_time', COUNT(DISTINCT person_id)
FROM {cdm_schema}.observation_period
WHERE observation_period_start_date is not null;

DROP TABLE IF EXISTS {feats};

SELECT
    f.cp_name,
    f.feature_id,
    COUNT_BIG(e.event_id)       AS n_records,
    COUNT(DISTINCT e.person_id) AS n_persons
INTO {feats}
FROM (SELECT DISTINCT cp_name, feature_id FROM {final}) AS f
LEFT JOIN {events} AS e
       ON e.cp_name    = f.cp_name
      AND e.feature_id = f.feature_id
GROUP BY f.cp_name, f.feature_id;

SELECT * FROM {feats} ORDER BY cp_name, feature_id;

DROP TABLE IF EXISTS {cohort};

SELECT DISTINCT
    e.person_id,
    d.cp_name,
    d.criterion_id,
    d.feature_id
INTO {cohort}
FROM {disj} AS d
JOIN {events} AS e
  ON e.cp_name    = d.cp_name
 AND e.feature_id = d.feature_id;

CREATE INDEX ix_cohort ON {cohort} (cp_name, criterion_id, person_id) INCLUDE (feature_id);

DROP TABLE IF EXISTS {crit};

WITH crit_events AS (
    SELECT DISTINCT d.cp_name, d.criterion_id, e.domain_id, e.event_id, e.person_id
    FROM {disj} AS d
    JOIN {events} AS e
      ON e.cp_name    = d.cp_name
     AND e.feature_id = d.feature_id
),
criteria AS (
    SELECT cp_name, criterion_id, MIN(label) AS label
    FROM {disj}
    GROUP BY cp_name, criterion_id
),
crit_counts AS (
    SELECT cp_name, criterion_id,
           COUNT_BIG(*) AS n_records, COUNT(DISTINCT person_id) AS n_persons
    FROM crit_events
    GROUP BY cp_name, criterion_id
),
file_events AS (
    SELECT DISTINCT cp_name, domain_id, event_id, person_id
    FROM {events}
),
summary AS (
    SELECT cp_name, COUNT_BIG(*) AS n_records, COUNT(DISTINCT person_id) AS n_persons
    FROM file_events
    GROUP BY cp_name
),
cps AS (
    SELECT DISTINCT cp_name FROM {final}
)
SELECT
    CAST('summary' AS VARCHAR(10))  AS row_type,
    p.cp_name,
    CAST(NULL AS NVARCHAR(1))       AS criterion_id,
    CAST(NULL AS NVARCHAR(1))       AS label,
    COALESCE(s.n_persons, 0)        AS n_persons,
    COALESCE(s.n_records, 0)        AS n_records
INTO {crit}
FROM cps AS p
LEFT JOIN summary AS s ON s.cp_name = p.cp_name
UNION ALL
SELECT
    'count',
    c.cp_name,
    c.criterion_id,
    c.label,
    COALESCE(k.n_persons, 0),
    COALESCE(k.n_records, 0)
FROM criteria AS c
LEFT JOIN crit_counts AS k
       ON k.cp_name      = c.cp_name
      AND k.criterion_id = c.criterion_id;

SELECT
    NULL                          AS SITE_CODE,
    RIGHT(c.cp_name, 7)           AS RESULT_SPEC_VERSION,
    NULL                          AS GENERATED_AT,
    c.cp_name                     AS CP_NAME,
    NULL                          AS RUN_DATE,
    NULL                          AS DATA_SNAPSHOT_DATE,
    c.row_type                    AS ROW_TYPE,
    c.label                       AS LABEL,
    COALESCE(c.criterion_id, N'') AS CRITERION_ID,
    p.n_persons                   AS POPULATION_N,
    p.population_type             AS POPULATION_BASIS,
    NULL                          AS POPULATION_BASIS_NOTE,
    c.n_persons                   AS COUNT_VALUE,
    NULL                          AS COUNT_STATUS
FROM {crit} AS c
LEFT JOIN {pop} AS p
       ON c.row_type = 'summary'
ORDER BY c.cp_name,
         CASE WHEN c.row_type = 'summary' THEN 0 ELSE 1 END,
         c.criterion_id,
         p.population_type DESC;"""

def build_script(df: pd.DataFrame, disj: pd.DataFrame, stage: str, final: str,
                 cdm_schema: str, include_counts: bool = True) -> str:
    sections = [
        temp_table_sql(df, stage, STAGE_COLS, NOT_NULL, ["vocabulary", "code"]),
        omop_concept_sql(cdm_schema=cdm_schema, stage=stage, final=final),
    ]
    if include_counts:
        disj_table = f"{final}_disjuncts"
        sections.append(temp_table_sql(disj, disj_table, DISJ_COLS, DISJ_NOT_NULL,
                                       ["cp_name", "feature_id"]))
        sections.append(counts_sql(cdm_schema=cdm_schema, final=final, disj=disj_table))
    return "\n\n".join(sections) + "\n"


def safe_name(s: str) -> str:
    return re.sub(r"\W+", "_", s).strip("_").lower()


def write_if_changed(path: Path, text: str) -> str:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and path.read_text(encoding="utf-8") == text:
        return "unchanged"
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    return "written"


def remove_stale(out_dir: Path, current: set[str]) -> list[str]:
    """Delete files generated by a previous run when the YAML no longer exists."""
    manifest = out_dir / MANIFEST_NAME
    previous = set(manifest.read_text(encoding="utf-8").split()) if manifest.exists() else set()

    removed = []
    for rel in sorted(previous - current):
        p = out_dir / rel
        if p.is_file():
            p.unlink()
            removed.append(rel)
            parent = p.parent
            while parent != out_dir and parent.exists() and not any(parent.iterdir()):
                parent.rmdir()
                parent = parent.parent

    write_if_changed(manifest, "\n".join(sorted(current)) + "\n")
    return removed


def generate_all(specs_dir: Path, out_dir: Path, cdm_schema: str, counts: str = "all"
                 ) -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    specs_dir, out_dir = Path(specs_dir).resolve(), Path(out_dir).resolve()
    if not specs_dir.is_dir():
        raise FileNotFoundError(f"Specs folder not found: {specs_dir}")
    out_dir.mkdir(parents=True, exist_ok=True)

    per_file_counts = counts == "all"
    master_counts = counts in ("all", "master")

    frames, disj_frames, issues, current = [], [], [], set()
    stats = {"written": 0, "unchanged": 0}

    for p in iter_yaml_files(specs_dir):
        rel = p.relative_to(specs_dir)
        rel_s = rel.as_posix()
        try:
            df, disj = extract_file(p)
        except (yaml.YAMLError, UnicodeDecodeError) as e:
            issues.append({"file": rel_s, "issue": f"could not read: {e}"})
            continue
        if df.empty:
            issues.append({"file": rel_s, "issue": "no codes found"})
            continue

        df = prepare(df, rel_s, issues)
        disj = prepare_disjuncts(disj, df, rel_s, issues)
        name = safe_name(rel.with_suffix("").as_posix())
        target = out_dir / rel.with_suffix(".sql")
        script = build_script(df, disj, f"#fc_{name}_stage", f"#fc_{name}", cdm_schema,
                              include_counts=per_file_counts)
        stats[write_if_changed(target, script)] += 1
        current.add(target.relative_to(out_dir).as_posix())
        frames.append(df)
        disj_frames.append(disj)

    all_df = (pd.concat(frames, ignore_index=True) if frames
              else pd.DataFrame(columns=STAGE_COLS + ["file"]))
    all_disj = (pd.concat(disj_frames, ignore_index=True) if disj_frames
                else pd.DataFrame(columns=DISJ_COLS + ["file"]))

    if frames:
        master = out_dir / MASTER_NAME
        script = build_script(all_df, all_disj, "#feature_codes_stage", "#feature_codes",
                              cdm_schema, include_counts=master_counts)
        stats[write_if_changed(master, script)] += 1
        current.add(MASTER_NAME)

    removed = remove_stale(out_dir, current)

    log.info("Specs:  %s", specs_dir)
    log.info("Output: %s", out_dir)
    log.info("%d YAML file(s) compiled, %d code rows, %d disjunct rows",
             len(frames), len(all_df), len(all_disj))
    log.info("SQL files: %d written, %d unchanged, %d removed",
             stats["written"], stats["unchanged"], len(removed))
    for r in removed:
        log.info("  removed %s", r)

    return all_df, all_disj, pd.DataFrame(issues, columns=["file", "issue"])


logging.basicConfig(level=logging.INFO, format="%(message)s", force=True)

all_df, disj_df, issues_df = generate_all(SPECS_DIR, OUT_DIR, CDM_SCHEMA, COUNTS)

if issues_df.empty:
    print("\nNo issues found.")
else:
    print(f"\n{len(issues_df)} issue(s):")
    display(issues_df)

display(all_df.head(50))
display(disj_df.head(50))
