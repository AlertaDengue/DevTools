#!/usr/bin/env bash


./devtools/database/setup/01-create_db_roles.sh
./devtools/database/setup/02-restore_database.sh
exec tar -zxf devtools/database/data/JSON.geos.tar.gz --directory devtools/database/data/
