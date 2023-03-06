#!/usr/bin/env bash

export $(cat .env | xargs)

echo -e ">>> Executing database dump <<< \n"

PSQL_CMD="psql --host "$PSQL_HOST"  -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=postgres"



for dbname in "${PSQL_DB}" "${PSQL_DBF}"; do
   echo "SELECT 'CREATE DATABASE "${dbname}" 
        WITH OWNER "${PSQL_USER}"
        ENCODING "UTF8"' WHERE NOT EXISTS (
      SELECT FROM pg_database WHERE datname = '"${dbname}"')\gexec" | ${PSQL_CMD}

done

# PostgreSQL create ROLE
echo "[II] creating ROLES for database."

for dbusers in "$POSTGRES_USER" "Read_only" "administrador" "dengue" "infodenguedev" "forecast"; do
  echo "[II] SELECT ROLE "${dbusers}""
  echo "SELECT 'CREATE USER "${dbusers}"' 
    WHERE NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '"${dbusers}"'
      )\gexec" | ${PSQL_CMD}

done

# PostgreSQL Alter role with password
echo "[II] alter role wirh passwd."
for dbusers in "$POSTGRES_USER" "infodenguedev"; do

  if [[ "${dbusers}" = "infodenguedev" ]]; then
    echo "ALTER ROLE "${dbusers}" WITH PASSWORD 'infodenguedev';" | ${PSQL_CMD}
  else
    echo "ALTER ROLE "${dbusers}" WITH PASSWORD '"${PSQL_PASSWORD}"';" | ${PSQL_CMD}
  fi

done
