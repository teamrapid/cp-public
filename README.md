# Computable Phenotype Pipeline

Translate Computable Phenotypes into SQL, run that SQL against your database, and export the results in the Mendelian `result.csv` format.

```
Computable Phenotype  -->  SQL/  -->  DataLoader/  -->  result.csv
   (definition)         (queries)    (execute + format)   (Mendelian format)
```

## Repository Structure

```
.
├── SQL/             # Computable Phenotype -> SQL translation
├── DataLoader/      # Runs the SQL and writes result.csv
└── README.md
```

## SQL

Contains the SQL generated from each Computable Phenotype definition.

- One complete SQL file with all of the phenotypes combined.
- Queries are written to return the fields needed by the DataLoader

## DataLoader

Takes the SQL from `SQL/`, executes it against your database, and writes the output in the Mendelian `result.csv` format.

**Steps performed**

1. Load Complete SQL file from `SQL/`
2. Connect to the configured database
3. Execute final compiled query
4. Map the query output to the Mendelian `result.csv` columns
5. Write `result.csv`

## Getting Started

### Prerequisites

- Access to the target database
- Python 3.13 (or your runtime of choice)
- Required packages: `pip install sqlglot sqlalchemy pyyaml`

### Configuration

Set your database connection details (example using environment variables):

```bash
database:
  drivername: drivername for database
  host: host for database server
  port: post for database server
  database: database to use
  username: username for database
  password: password for database
  schema: schema for database
  query: 
    driver: optional driver needed for SQL server
    TrustServerCertificate: optional server cert needed for SQL server
columns:                       
  site_code: Site name to add to results.csv
  data_snapshot_date: data snapshot date to add to results.csv
```

### Usage

```bash
python DataLoader/dbexp.py
```
## Output

The DataLoader produces a `result.csv` file in the Mendelian result format.
