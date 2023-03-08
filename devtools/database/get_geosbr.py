import json
import logging

import numpy as np
from devtools.database.data.initials import initials
from devtools.database.settings import GEOJSON_PATH
from geobr import read_municipality

logging.getLogger().setLevel(logging.INFO)
logger = logging.getLogger("get_geosbr")


def get_geobr():
    """ """
    for k, UF in initials.items():
        ufs = UF.upper()
        #
        df = read_municipality(code_muni=ufs, year=2020)
        cols = ["code_muni", "code_state", "code_region"]
        df[cols] = df[cols].applymap(np.int64)
        #
        result = df.to_json()
        parsed = json.loads(result)
        #
        fname = f"{GEOJSON_PATH}/{UF}-municipalities.json"

        with open(fname, "w") as f:
            json.dump(parsed, f)
            logger.warning(f"Saving the JSON to {k} state in {fname}")

    print("\n")
    logger.warning("All files were downloaded successfully!")


if __name__ == "__main__":
    get_geobr()
