# SETTINGS

import os
from pathlib import Path

from dotenv import find_dotenv, load_dotenv

load_dotenv(find_dotenv())

# PATHS
GEOJSON_PATH = Path(os.getenv("GEOJSON_PATH"))
GEOJSON_PATH.mkdir(parents=True, exist_ok=True)
GEOS_PATH = Path(os.getenv("GEOS_PATH"))
BASE_DIR = Path(__file__).resolve(strict=True).parent


# CONNECTIONS
PSQL_URI = {
    "database": os.getenv("PSQL_DB"),
    "user": os.getenv("PSQL_USER"),
    "password": os.getenv("PSQL_PASSWORD"),
    "host": os.getenv("PSQL_HOST"),
    "port": os.getenv("PSQL_PORT"),
}
