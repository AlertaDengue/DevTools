#!/usr/bin/env bash


source devtools/database/setup/01-create_db_roles.sh
source devtools/database/setup/02-restore_database.sh
exec tar -zxf devtools/database/data/JSON.geos.tar.gz --directory devtools/database/data/
