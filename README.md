MVT Benchmark
=============

Benchmark for MVT vector tile creation and delivery from a PostGIS database.

The benchmark uses a minimal subset of the [NaturalEarth](http://www.naturalearthdata.com/) 4.1 data set.

Measurement targets:
* How long does it take to generate all tiles (single node / multiple nodes)
* How many requests/s does the tile server deliver in web server mode (with and without tile cache)

DB Setup
--------

    # Set Postgresql environment variables when needed: PGHOST, PGPORT, PGUSER, PGPASSWORD
    cd data
    make createdb

Import GeoPackage with ogr2ogr:

    make gpkgrestore


Run benchmark
-------------

    cd t-rex
    make clean seed_region stats
    make clean seed_region_4 stats

Http test:

    t_rex serve mvtbench.toml
    make http
