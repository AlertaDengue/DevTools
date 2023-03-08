# DevTools

##### -- Requirements --
```bash
#
mamba env create -f conda/dev.yaml 
``` 
Then
```bash
#
poetry install 
``` 

##### -- Makefile Commands --
```  
dump-dbschemas          Dump database to sql file
create-dbschemas        Create database and import schemas
get-geosbr              Download spatial datasets and convert to JSON
run-fill-municipalities Read from the JSON and insert data into table for each municipality
run-fill-population     Update population statistics from CSV file
run-fill-states         Read JSON files by States and insert georeferenced data in the table.
run-fill-stations       Import the weather station code from CSV file
test-all                Make tests
clean                   Clean all artifacts
``` 
