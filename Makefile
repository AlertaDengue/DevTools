
### devtools

# .PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

# ---
# Dump database
.PHONY: dump-dbschemas
dump-dbschemas: ## Dump database to sql file
	bash devtools/database/scripts/dump_dbschemas.sh

.PHONY: prepare-db-data
prepare-db-data: ## Create database and import schemas
	bash devtools/database/scripts/prepare_db_data.sh

# ---
.PHONY: get-geosbr
get-geosbr: ## Download spatial datasets and convert to JSON
	python devtools/database/get_geosbr.py

.PHONY: run-fill-municipalities
run-fill-municipalities: ## Read from the JSON and insert data into table for each municipality
	python devtools/database/fill_municipalities.py

.PHONY: update-mun-pop
run-fill-population: ## Update population statistics from CSV file
	python devtools/database/fill_population.py

.PHONY: run-fill-states
run-fill-states: ## Read JSON files by States and insert georeferenced data in the table.
	python devtools/database/fill_states.py

.PHONY: update-run-fill-stations
run-fill-stations: ## Import the weather station code from CSV file
	python devtools/database/fill_stations.py

.PHONY: test-all
test-all: ## Make tests
	py.test -vv

.PHONY: clean
clean: ## Clean all artifacts
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
