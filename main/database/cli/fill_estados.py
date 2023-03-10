#!/usr/bin/env python
import glob
import logging
import os

import geojson
import psycopg2

from main.database.settings import GEOJSON_PATH, PSQL_URI


def load_geojson(fname):
    with open(fname, "r") as f:
        return geojson.load(f)


if __name__ == "__main__":
    conn = psycopg2.connect(**PSQL_URI)
    with conn.cursor() as cur:
        for fname in glob.glob(os.path.join(GEOJSON_PATH, "*-state.json")):
            print("Processing {}".format(fname))
            uf = os.path.split(fname)[1].split("-")[0]
            geo_json = load_geojson(fname)
            properties = geo_json["features"][0]["properties"]
            nome = properties["NM_ESTADO"]
            geocodigo = properties["CD_GEOCODU"]
            regiao = properties["NM_REGIAO"]
            cur.execute(
                'INSERT INTO "Dengue_global".estado (uf, nome, regiao, geocodigo, geojson) VALUES (%s,%s,%s,%s, %s)',
                (
                    uf,
                    nome,
                    regiao,
                    geocodigo,
                    geojson.dumps(geo_json["features"][0]),
                ),
            )
        conn.commit()
        logger.warning("All fields were updated!")
