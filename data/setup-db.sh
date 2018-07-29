#!/bin/bash
set -e

psql -c "CREATE ROLE mvtbench SUPERUSER LOGIN PASSWORD 'mvtbench'"

export PGUSER=mvtbench
make createdb gpkgrestore

psql -c "ALTER ROLE mvtbench NOSUPERUSER"
