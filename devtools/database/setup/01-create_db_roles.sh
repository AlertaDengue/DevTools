#!/usr/bin/env bash

export $(cat .env | xargs)

PSQL_CMD="psql --host ${PSQL_HOST} -p 5432 --username infodenguedev"

# PostgreSQL create DATABASES
for dbname in "${PSQL_DB}" "${PSQL_DBF}";  do
   echo "SELECT 'CREATE DATABASE "${dbname}"
    WITH OWNER "infodenguedev"
    ENCODING "UTF8"' WHERE NOT EXISTS (
      SELECT FROM pg_database
      WHERE datname = '"${dbname}"')\gexec" | PGPASSWORD=${PSQL_PASSWORD} ${PSQL_CMD} --dbname=${POSTGRES_DB}
done

for dbusers in "postgres" "dengueadmin" '"Read_only"' '"Dengue"' "administrador" "dengue" "infodenguedev" "forecast"; do
  # PostgreSQL create ROLE
  echo "SELECT 'CREATE USER "${dbusers}"'
    WHERE NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '"${dbusers}"'
      )\gexec" | PGPASSWORD=${PSQL_PASSWORD} ${PSQL_CMD} --dbname=${POSTGRES_DB}

  # PostgreSQL set attributes
  if [[ "${dbusers}" = "infodenguedev" ]] | [ "${dbusers}" = "Read_only" ] ; then
    echo "ALTER ROLE ${dbusers} WITH PASSWORD ${PSQL_PASSWORD}
      NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN
      NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';" | PGPASSWORD=${PSQL_PASSWORD} ${PSQL_CMD} --dbname=${POSTGRES_DB}

  elif [[ "${dbusers}" = "dengueadmin" ]] | [ "${dbusers}" = "forecast" ] ; then
    echo "ALTER ROLE ${dbusers} WITH PASSWORD NULL
      SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN
      NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';" | PGPASSWORD=${PSQL_PASSWORD} ${PSQL_CMD} --dbname=${POSTGRES_DB}

  elif [[ "${dbusers}" = "administrador" ]] | [ "${dbusers}" = "Dengue" ] | [ "${dbusers}" = "dengue" ] ; then
    echo "ALTER ROLE ${dbusers} WITH PASSWORD NULL
      SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN
      NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';" | PGPASSWORD=${PSQL_PASSWORD} ${PSQL_CMD} --dbname=${POSTGRES_DB}
  fi

done
