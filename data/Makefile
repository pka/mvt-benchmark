DBNAME = mvtbench

createdb:
	psql postgres -c "DROP DATABASE IF EXISTS $(DBNAME)"
	psql postgres -c "CREATE DATABASE $(DBNAME)"
	psql $(DBNAME) -c "CREATE EXTENSION postgis"

gpkgrestore:
	ogr2ogr -lco GEOMETRY_NAME=wkb_geometry -f PostgreSQL PG:dbname=$(DBNAME) mvtbench.gpkg

dockerbuild:
	docker build -t sourcepole/mvtbenchdb .
