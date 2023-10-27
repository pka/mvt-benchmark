# PostgreSQL/PostGIS database with benchmark data

FROM postgis/postgis:16-3.4

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y make gdal-bin \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV POSTGRES_DB=mvtbench
ENV POSTGRES_USER=mvtbench
ENV POSTGRES_PASSWORD=mvtbench

COPY mvtbench.gpkg Makefile /
COPY setup-db.sh /docker-entrypoint-initdb.d/
