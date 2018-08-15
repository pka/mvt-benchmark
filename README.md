MVT Benchmark
=============

Benchmark for MVT vector tile creation and delivery from a PostGIS database.

The benchmark uses a minimal subset of the [NaturalEarth](http://www.naturalearthdata.com/) 4.1 data set.

Measurement targets:
* How long does it take to generate all tiles (single node / multiple nodes)
* How many requests/s does the tile server deliver in web server mode


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
