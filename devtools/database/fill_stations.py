import csv
import logging

from devtools.database.settings import BASE_DIR
from models import save

logger = logging.getLogger("fill_stations")


def fill_stations():
    """ """
    data_csv = BASE_DIR / "data/airport_stations_seed.csv"
    rows = csv.DictReader(open(data_csv))

    try:
        save(rows, schema="Municipio", table="Estacao_wu")
        logger.warning("Import stations data successfully!")
    except Exception as e:
        logger.error(f"ERROR! {e}")

    return


if __name__ == "__main__":
    fill_stations()
