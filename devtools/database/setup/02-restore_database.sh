#!/usr/bin/env bash

export $(cat .env | xargs)

# PSQL_CMD="psql --host "$PSQL_HOST"  -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=postgres"
PSQL_CMD="psql -h localhost -p 5432 -U infodenguedev"

if [[ "${PG_RESTORE_STAGING}" = "dumps" ]]
then
    echo "[II] restore database from ${PG_RESTORE_STAGING} to production..."
    gunzip -c /"${PG_RESTORE_STAGING}"/latest_dengue.sql.gz | ${PSQL_CMD} -d ${PSQL_DB}
    gunzip -c /"${PG_RESTORE_STAGING}"/latest_infodengue.sql.gz | ${PSQL_CMD} -d ${PSQL_DBF}
elif [[ "${PG_RESTORE_STAGING}" = "schemas" ]]
then
    echo "[II] creating ${PG_RESTORE_STAGING} for the demo database."
    PGPASSWORD="infodenguedev" ${PSQL_CMD} --dbname=${PSQL_DB} < devtools/database/"${PG_RESTORE_STAGING}"/schemas_dengue.sql
else
    echo "[ERR]: ${PG_RESTORE_STAGING} is not a valid dump file! You have to choose between schemas or dumps"
fi
