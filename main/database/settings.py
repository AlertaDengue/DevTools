# SETTINGS

import os
from pathlib import Path
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())


GEOJSON_PATH = Path(os.getenv("GEOJSON_PATH"))
GEOJSON_PATH.mkdir(parents=True, exist_ok=True)

PSQL_URI = {
    "database": os.getenv("PSQL_DB"),
    "user": os.getenv("PSQL_USER"),
    "password": os.getenv("PSQL_PASSWORD"),
    "host": os.getenv("PSQL_HOST"),
    "port": os.getenv("PSQL_PORT"),
}



