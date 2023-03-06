from devtools.database.cli.fill_counties import uf_geojson, county_polygon


def test_uf_geojson():
    """
    Arguments:
        STATE: is the state abbreviation

    """
    STATE = "RJ"

    return_uf_geojson = uf_geojson(STATE)

    expected_feat_prop = {
        "abbrev_state": "RJ",
        "code_muni": 3304557,
        "code_region": 3,
        "code_state": 33,
        "name_muni": "Rio De Janeiro",
        "name_region": "Sudeste",
        "name_state": "Rio de Janeiro",
    }

    assert (
        return_uf_geojson["features"][67]["properties"] == expected_feat_prop
    )


def test_county_polygon():
    # dd = county_polygon("RJ", 3304557)

    assert dd == 0
    pass