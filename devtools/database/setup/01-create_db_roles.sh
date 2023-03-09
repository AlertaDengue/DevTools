#!/usr/bin/env bash

export $(cat .env | xargs)

PSQL_CMD="psql --host "$PSQL_HOST"  -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=postgres"

# PostgreSQL create DATABASES
for dbname in "${PSQL_DB}" "${PSQL_DBF}";  do
   echo "SELECT 'CREATE DATABASE "${dbname}"
        WITH OWNER "${PSQL_USER}"
        ENCODING "UTF8"' WHERE NOT EXISTS (
      SELECT FROM pg_database WHERE datname = '"${dbname}"')\gexec" | ${PSQL_CMD}

done

for dbusers in "dengueadmin" '"Read_only"' '"Dengue"' "administrador" "dengue" "infodenguedev" "forecast"; do
  # PostgreSQL create ROLE
  echo "SELECT 'CREATE USER "${dbusers}"'
    WHERE NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '"${dbusers}"'
      )\gexec" | ${PSQL_CMD}

  # PostgreSQL set attributes
  if [[ "${dbusers}" = "infodenguedev" ]] | [ "${dbusers}" = "Read_only" ] ; then
    echo "ALTER ROLE "${dbusers}" WITH PASSWORD 'infodenguedev'
      NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN
      NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';"

  elif [[ "${dbusers}" = "dengueadmin" ]] | [ "${dbusers}" = "forecast" ] ; then
    echo "ALTER ROLE "${dbusers}" WITH PASSWORD "${PSQL_PASSWORD}"
      SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN
      NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';"

  elif [[ "${dbusers}" = "administrador" ]] | [ "${dbusers}" = "Dengue" ] | [ "${dbusers}" = "dengue" ] ; then
    echo "ALTER ROLE "${dbusers}" WITH PASSWORD NULL
      SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN
      NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';"
  fi

done
