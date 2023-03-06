
### devtools


# Dump database
dump_dbschemas: # create initials schemas and tables
	bash devtools/database/scripts/dump_database.sh


# Create database and import schemas
create_dbschemas: # create initials schemas and tables
	bash devtools/database/scripts/create_schemas.sh

# Convert and save geopandas to JSON
get_geosbr:
	cd DevTools \
	&& mkdir -p devtools/geo_json \
	&& python devtools/get_geosbr.py

# Update geojson data
run_fill_counties:
	cd DevTools \
	&& python devtools/fill_counties.py

# Update population statistics
update_mun_pop:
	cd DevTools \
	&& python devtools/update_mun_w_pop.py

# Update population statistics
update_fill_stations:
	cd DevTools \
	&& python devtools/fill_stations.py

# Update population statistics
update_fill_states:
	cd DevTools \
	&& python devtools/fill_estados.py

# Tests
.PHONY: test-all
test-all:
	py.test -vv


# Python
.PHONY: clean
clean: ## clean all artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	rm -fr .idea/
	rm -fr */.eggs
	rm -fr db
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -fr {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
	find . -name '*.ipynb_checkpoints' -exec rm -rf {} +
	find . -name '*.pytest_cache' -exec rm -rf {} +
