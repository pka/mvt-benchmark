MVT Benchmark
=============

Benchmark for MVT vector tile creation and delivery from a PostGIS database.

The benchmark uses a minimal subset of the [NaturalEarth](http://www.naturalearthdata.com/) 4.1 data set.

Measurement targets:
* How long does it take to generate all tiles (single node / multiple nodes)
* How many requests/s does the tile server deliver in web server mode


Tileset defition
----------------

* Tileset name: `ne_countries`
* Maxzoom level for tile data: 6
* SRS (data and tiles: EPSG:3857 (Web Mercator)

Layer definition:

| Name               | Geom. type      | Buffer | Simplify | Table                                 | Attributes         | Conditions      |
|--------------------|-----------------|--------|----------|---------------------------------------|--------------------|-----------------|
| country            | MULTIPOLYGON    |   3    |   yes    | ne_10m_admin_0_countries              | adm0_a3, mapcolor7 | min_zoom <= {z} |
| country-name       | POINT           |   0    |   no     | ne_10m_admin_0_country_points         | abbrev, name       | -               |
| geo-lines (z=1..4) | MULTILINESTRING |   0    |   no     | ne_50m_geographic_lines               | name               | -               |
| geo-lines (z=5..6) | MULTILINESTRING |   0    |   no     | ne_10m_geographic_lines               | name               | -               |
| land-border        | MULTILINESTRING |   0    |   yes    | ne_10m_admin_0_boundary_lines_land    | -                  | min_zoom <= {z} |
| state              | MULTILINESTRING |   0    |   yes    | ne_10m_admin_1_states_provinces_lines | adm0_a3            | min_zoom <= {z} |

The database can be started within a Docker container with `docker-compose up -d mvtbenchdb`.


Display style
-------------

A reference Mapbox GL JS style for the produced tiles is [natural-earth-countries.json](maps/natural-earth-countries.json).

Screenshot:

![natural-earth-countries](maps/style-screenshot.jpg)


Run benchmark
-------------

Requirements:
* Make
* Docker & docker-compose
* gnuplot

Quick benchmark:

    make quick_bench

Full benchmark:

    make bench

Graph:

    x-www-browser results/benchmark.jpg


Local DB Setup
--------------

    # Set Postgresql environment variables when needed: PGHOST, PGPORT, PGUSER, PGPASSWORD
    cd data
    make createdb

Import GeoPackage with ogr2ogr:

    make gpkgrestore
