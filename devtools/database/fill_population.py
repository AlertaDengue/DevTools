#!/usr/bin/env python
"""
Atualiza tabela de municípios com dados da população estimada
"""
import logging

import pandas as pd
import psycopg2
from devtools.database.settings import BASE_DIR, PSQL_URI

logger = logging.getLogger("update-pop")


def fill_population():
    """ """
    conn = psycopg2.connect(**PSQL_URI)

    with conn.cursor() as cur:
        data_csv = BASE_DIR / "data/POP2022_Municipios_Edit.csv"

        df = pd.read_csv(data_csv, header=0, sep=",")

        sql = """
            UPDATE "Dengue_global"."Municipio" SET populacao=%s
            WHERE geocodigo=%s;
            """

        for i, row in df.iterrows():
            logger.warning(f"{row.geocodigo} => {row.populacao}")
            cur.execute(sql, (row.populacao, row.geocodigo))

    conn.commit()
    cur.close()

    logger.warning("Update successful in database!")

    return


if __name__ == "__main__":
    fill_population()
