import json
import unittest
from pathlib import Path

from devtools.database.cli.fill_counties import uf_geojson
from devtools.database.cli.get_geosbr import np, read_municipality
from devtools.database.data.initials import initials
from devtools.database.settings import GEOJSON_PATH
from numpy import int64


class TestGetGeosBr(unittest.TestCase):
    def setUp(self):
        # devtools.testing = True
        self.UF = initials.get("Rio de Janeiro").upper()

    def test_initials(self):
        """ """

        self.assertEqual(self.UF, "RJ", msg="expected 'RJ' ")

    def test_get_geobr(self):
        """ """

        # Get data from GeoBR API
        df = read_municipality(code_muni=self.UF, year=2020)
        self.assertEqual(
            df.shape, (92, 8), msg=f"{df.shape}, is not a good shape"
        )

        # Cast columns
        cols = ["code_muni", "code_state", "code_region"]
        df[cols] = df[cols].applymap(np.int64)
        for d in df[cols].dtypes:
            # assert d.type is np.int64
            self.assertEqual(d.type, int64, msg=None)

        # Load json from dataframe
        result = df.to_json()
        parsed = json.loads(result)

        # Dump json to path
        fname = f"{GEOJSON_PATH}/{self.UF}-municipalities.json"
        with open(fname, "w") as f:
            json.dump(parsed, f)

        # Fetch file dumped
        fname_path = Path(f"{GEOJSON_PATH}").glob("**/*")
        json_file = str(*[x for x in fname_path if x.is_file()])

        assert fname == json_file


class TestFillCounties(unittest.TestCase):
    def setUp(self):
        # devtools.testing = True
        self.UF = initials.get("Rio de Janeiro").upper()

    def test_uf_geojson(self):
        """ """

        return_uf_geojson = uf_geojson(self.UF)

        expected_feat_prop = {
            "abbrev_state": "RJ",
            "code_muni": 3304557,
            "code_region": 3,
            "code_state": 33,
            "name_muni": "Rio De Janeiro",
            "name_region": "Sudeste",
            "name_state": "Rio de Janeiro",
        }

        self.assertEqual(
            return_uf_geojson["features"][67]["properties"], expected_feat_prop
        )

    def test_county_polygon(self):
        """ """

        list_of_county_codes = []

        for feature in uf_geojson("RJ")["features"]:
            list_of_county_codes.append(feature["properties"].get("code_muni"))

        self.assertIn(int(3304557), list_of_county_codes)


class TestUpdateWorldPop(unittest.TestCase):
    def test_update_population():
        pass


if __name__ == "__main__":
    unittest.main()
