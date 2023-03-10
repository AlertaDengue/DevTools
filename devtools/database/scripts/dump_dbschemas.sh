#!/usr/bin/env bash

export $(cat .env | xargs)

PSQL_CMD="psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER""

CURRENT_DATE=$(date -I)


echo ">>> [ II ] Starting the dump with schemas for dengue database... <<<"
PGPASSWORD="$PSQL_PASSWORD" pg_dump --host "$PSQL_HOST" --username "$PSQL_USER" --port 5432 -s --compress=1 -f "devtools/database/schemas/${CURRENT_DATE}.schemas.dengue.sql.gz" "$PSQL_DB"
