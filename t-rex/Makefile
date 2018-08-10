sw = t-rex
exec = docker-compose run --rm t-rex
result_prefix = ../bench/results/results_
ts = $(shell date '+%Y-%m-%dT%TZ')
region_bbox = 5.361328,45.336702,30.058594,58.950008
tilecache = ../tiles

# Seeding benchmarks

data_ready:
	docker-compose up -d mvtbenchdb

data_teardown:
	docker-compose stop mvtbenchdb

bench_seed: $(result_prefix)seed.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) generate --config mvtbench.toml --maxzoom=6
	@echo Statistics written to $<

bench_seed_4: $(result_prefix)seed_4.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< sh -c '$(exec:t-rex=--name t_rex_0 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=0 & \
	$(exec:t-rex=--name t_rex_1 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=1 & \
	$(exec:t-rex=--name t_rex_2 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=2 & \
	$(exec:t-rex=--name t_rex_3 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=3'
	@echo Statistics written to $<

# Tile serving benchmarks

mvtserver_exec = docker-compose run -p 127.0.0.1:6767:6767 --rm --name=t_rex_serve -d t-rex

mvtserver_ready: data_ready
	$(mvtserver_exec) serve --config mvtbench.toml --loglevel error --openbrowser false

mvtserver_teardown:
	docker stop t_rex_serve || true
	docker rm t_rex_serve || true

wkr_cmd = docker run --rm  --user=$$UID --net=host -e SW="$(sw)" -e CONNECTIONS=[CONN] -v $$PWD/../bench:/bench williamyeh/wrk -H 'Accept-Encoding: gzip' -H 'Connection: keep-alive'

bench_http:
	@# From first entry only title is displayed on plot
	$(wkr_cmd:[CONN]=1) --latency -d 1 -c 1 --timeout 8 -t 1 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=1) --latency -d 5 -c 1 --timeout 8 -t 1 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=4) --latency -d 5 -c 4 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=32) --latency -d 5 -c 32 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=64) --latency -d 5 -c 64 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=128) --latency -d 5 -c 128 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=256) --latency -d 5 -c 256 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	@echo >>../bench/results/results_http.csv
	@echo >>../bench/results/results_http.csv
	@echo Statistics written to results_http.csv

# Quick benchmarks

bench_seed_region: $(result_prefix)seed_region.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) generate --config mvtbench.toml --maxzoom=6 --extent=$(region_bbox)
	@echo Statistics written to result_$@.csv

bench_seed_region_4: $(result_prefix)seed_region_4.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< sh -c '$(exec:t-rex=--name t_rex_0 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=0 --extent=$(region_bbox) & \
	$(exec:t-rex=--name t_rex_1 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=1 --extent=$(region_bbox) & \
	$(exec:t-rex=--name t_rex_2 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=2 --extent=$(region_bbox) & \
	$(exec:t-rex=--name t_rex_3 t-rex) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=3 --extent=$(region_bbox)'
	@echo Statistics written to $<

# Helpers

$(result_prefix)seed.csv:
	echo "#time_started,software,real,user,sys" >$@

$(result_prefix)seed_4.csv:
	echo "#time_started,software,real,user,sys" >$@

$(result_prefix)seed_region.csv:
	echo "#time_started,software,real,user,sys" >$@

$(result_prefix)seed_region_4.csv:
	echo "#time_started,software,real,user,sys" >$@

tile_stats:
	find $(tilecache) -name '*pbf' | wc -l
	du -s $(tilecache)

clean_tilecache:
	@# Delete files as user www-data
	docker-compose run --rm --entrypoint /bin/rm t-rex "-rf" "$(tilecache)/ne_countries"
