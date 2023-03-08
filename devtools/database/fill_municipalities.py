import csv
import functools
import logging
from multiprocessing.pool import Pool

import geojson
from devtools.database.data.initials import initials
from devtools.database.models import counties_save
from devtools.database.settings import BASE_DIR, GEOJSON_PATH

# logging.getLogger().setLevel(logging.INFO)
logger = logging.getLogger("fill_counties")


@functools.lru_cache(maxsize=None)
def uf_geojson(uf: str) -> geojson.feature.FeatureCollection:
    filename = f"{GEOJSON_PATH}/{uf}-municipalities.json"

    return geojson.load(open(filename, "r"))


def county_polygon(uf: str, county_code: int) -> str(geojson.GeoJSON):
    for feature in uf_geojson(uf)["features"]:
        if feature["properties"].get("code_muni") == int(county_code):
            return geojson.dumps(feature)
    else:
        logging.warning(
            f"""
            {county_code} is not in this geojson {uf},
            run get_geosbr.py first..."""
        )


def to_row(county):
    county_code = county["Código Município Completo"]
    name = county["Nome_Município"]
    uf = county["Nome_UF"]
    geojson = county_polygon(initials[uf], county_code)
    logging.warning(county_code, "|", name, "|", uf)

    return dict(
        county_code=county_code,
        name=name,
        geojson=geojson,
        uf=uf,
        population=0,
    )


def fill_cities():
    """ """
    data_csv = BASE_DIR / "data/DBT_2022_Municipios.csv"
    rows = Pool().map(to_row, csv.DictReader(open(data_csv)))

    try:
        counties_save(rows, schema="Dengue_global", table="Municipio")
        logger.warning("Import geojson data successfully!")
    except Exception as e:
        print(e)

    return


if __name__ == "__main__":
    fill_cities()
