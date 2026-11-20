
# Data Loader
 
Takes the T-SQL in `SQL/_all_feature_codes.sql`, translates it to whatever database you point it at, runs it, and writes the results to a CSV in the result spec format. Small counts are suppressed before anything is written.
 
## Setup
 
```
pip install sqlglot sqlalchemy pyyaml
```
 
You also need the SQLAlchemy driver for your database (`pyodbc` for SQL Server, `psycopg2` for Postgres, `pyathena` for Athena, and so on).
 
## Config
 
The script reads `config.yaml` from the directory you run it in. Example:
 
```yaml
database:
  drivername: mssql+pyodbc
  username: dbuser
  password: dbpassword
  host: servername
  port: 1433
  database: mydb
  query:
    driver: ODBC Driver 18 for SQL Server
    TrustServerCertificate: true
 
columns:
  site_code: SITE01
  data_snapshot_date: 2026-11-09
 
suppression:
  enabled: true
  threshold: 10
  complementary: true
```
 
`database` is passed to SQLAlchemy as a URL. Booleans under `query` are converted to `yes`/`no`.
 
`suppression` is optional. `enabled: false` turns suppression off completely and writes the counts exactly as the query returned them (a note is printed so it doesn't go unnoticed). `threshold` is the number counts have to reach to be reported (anything from 1 up to threshold - 1 is suppressed), and `complementary` turns the second-cell suppression described below on or off. If the section is left out, the defaults are `true`, 10 and `true`.
 
`columns` holds the values that go on every row but don't come from the query. Don't commit real credentials, keep `config.yaml` out of the repo.
 
The dialect of the target database is picked up from `drivername` provided.
 
## Running it
 
```
python db_exp.py
python db_exp.py -o my_results.csv
python db_exp.py --translate-only
```
 
| Option | What it does |
| --- | --- |
| `-o`, `--output` | Output path. Defaults to `results.csv`. |
| `--translate-only` | Writes the translated SQL to a `.sql` file and stops, without connecting to anything. Good for checking the translation. |
 
All statements run in one transaction. If more than one returns rows, only the last result set is written and a warning is printed.
 
## Output
 
The CSV always has these columns in this order:
 
```
site_code, result_spec_version, generated_at, cp_name, run_date,
data_snapshot_date, row_type, criterion_id, population_n,
population_basis, population_basis_note, count_value, count_status
```
 
`generated_at` (UTC) and `run_date` are set by the script. Everything else comes from the query or `config.yaml`, and if both have a column, the config value wins. Columns that aren't in the list are dropped with a warning.
 
## Exit codes
 
`0` on success, `1` if anything raised an error (the message is printed).
 
