DBNAME = mvtbench
TAG = v1.2

createdb:
	psql postgres -c "DROP DATABASE IF EXISTS $(DBNAME)"
	psql postgres -c "CREATE DATABASE $(DBNAME)"
	psql $(DBNAME) -c "CREATE EXTENSION postgis"

gpkgrestore:
	ogr2ogr -lco GEOMETRY_NAME=wkb_geometry -f PostgreSQL PG:dbname=$(DBNAME) ne_extracts_3857.gpkg

dockerbuild:
	docker build -t sourcepole/mvtbenchdb .
	docker tag sourcepole/mvtbenchdb sourcepole/mvtbenchdb:$(TAG)
