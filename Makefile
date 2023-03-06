
### UTILITIES


# Dump database
dump_dbschemas: # create initials schemas and tables
	bash main/database/scripts/dump_database.sh


# Create database and import schemas
create_dbschemas: # create initials schemas and tables
	bash main/database/scripts/create_schemas.sh

# Convert and save geopandas to JSON
get_geosbr:
	cd DevTools \
	&& mkdir -p utilities/geo_json \
	&& python utilities/get_geosbr.py

# Update geojson data
run_fill_counties:
	cd DevTools \
	&& python utilities/fill_counties.py

# Update population statistics
update_mun_pop:
	cd DevTools \
	&& python utilities/update_mun_w_pop.py

# Update population statistics
update_fill_stations:
	cd DevTools \
	&& python utilities/fill_stations.py

# Update population statistics
update_fill_states:
	cd DevTools \
	&& python utilities/fill_estados.py
