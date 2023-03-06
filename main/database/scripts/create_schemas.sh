#!/usr/bin/env bash

set -e

# PSQL_CMD="psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER""

# echo "[II] creating ${PG_RESTORE_STAGING} for the demo database."
source main/database/setup/01-prepare_database.sh

# psql -h localhost dengue < crawlclima/utilities/dbschema/roles-infodengue_roles.sql0
# echo "[II] creating ${PG_RESTORE_STAGING} for the demo database."
psql --host "$PSQL_HOST"  -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d ${PSQL_DB} < main/database/setup/00-infodengue_roles.sql

# gunzip -c crawlclima/utilities/dbschema/schemas_dengue_2021_10_04.sql.gz | psql -h localhost -U postgres dengue
# echo "[II] creating ${PG_RESTORE_STAGING} for the demo database."
# gunzip -c ../schemas/latest_dengue.sql.gz | ${PSQL_CMD} -d ${PSQL_DB}