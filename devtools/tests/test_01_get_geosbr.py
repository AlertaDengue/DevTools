import json
import os
from pathlib import Path

import pytest
from devtools.database.cli.get_geosbr import np, read_municipality
from devtools.database.cli.initials import initials
from devtools.database.settings import GEOJSON_PATH
from numpy import int64


def test_initials():
    UF = initials.get("Rio de Janeiro").upper()
    assert UF == "RJ", f"expected {UF}"


def test_get_geobr():
    UF = "RJ"

    # Get data from GeoBR API
    df = read_municipality(code_muni=UF, year=2020)
    assert df.shape == (92, 8), f"{df.shape}, is not a good shape"

    # Cast columns
    cols = ["code_muni", "code_state", "code_region"]
    df[cols] = df[cols].applymap(np.int64)
    for d in df[cols].dtypes:
        assert d.type is np.int64

    # Load json from dataframe
    result = df.to_json()
    parsed = json.loads(result)

    # Dump json to path
    fname = f"{GEOJSON_PATH}/{UF}-municipalities.json"
    with open(fname, "w") as f:
        json.dump(parsed, f)

    # Fetch file dumped
    fname_path = Path(f"{GEOJSON_PATH}").glob("**/*")
    json_file = str(*[x for x in fname_path if x.is_file()])

    assert fname == json_file
