sw = mapserver
exec = docker-compose run --rm mapcache
result_prefix = ../bench/results/results_
ts = $(shell date '+%Y-%m-%dT%TZ')
region_bbox = 596820,5674685,3346107,8169590
tilecache = ../tiles

quick_bench:
	# Seeding benchmarks
	make data_ready clean_tilecache
	make mapserver_ready
	make bench_seed_region tile_stats clean_tilecache
	make bench_seed_region_4 tile_stats
	make tilechecks
	# Tile serving benchmarks (with seeded tilecache)
	make mvtserver_teardown
	make mvtserver_ready bench_http duration=5 csv=http_quick.csv mvtserver_teardown
	make data_teardown

bench:
	# Seeding benchmarks
	make data_ready clean_tilecache
	make mapserver_ready
	make bench_seed tile_stats clean_tilecache
	make bench_seed_4 tile_stats
	make tilechecks
	# Tile serving benchmarks (with seeded tilecache)
	make mvtserver_teardown
	make mvtserver_ready bench_http mvtserver_teardown
	make data_teardown

# Seeding benchmarks

data_ready:
	docker-compose up -d mvtbenchdb

data_teardown:
	docker-compose stop mvtbenchdb

mapserver_ready: data_ready
	docker-compose up -d mapserver

mapserver_teardown:
	docker-compose stop mapserver

bench_seed: $(result_prefix)seed.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) mapcache_seed -c /etc/mapcache/mapcache.xml -t ms_mvt -z 1,6
	@echo Statistics written to $<

bench_seed_4: $(result_prefix)seed_4.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) mapcache_seed -c /etc/mapcache/mapcache.xml -t ms_mvt -z 1,6 -n 4
	@echo Statistics written to $<

tilechecks:
	docker-compose run gdal ogrinfo -al -so /var/data/tiles/ms_mvt/6/34/21.mvt

# Tile serving benchmarks

mvtserver_ready: mapserver_ready
	docker-compose up -d mapcache

mvtserver_teardown:
	docker-compose stop mapcache

csv = http.csv
wkr_cmd = docker run --rm --user=$$UID --net=host -e SW="$(sw)" -e CSV_NAME=$(csv) -e CONNECTIONS=[CONN] -v $$PWD/../bench:/bench -v $$PWD/paths.txt:/paths.txt:ro williamyeh/wrk -H 'Accept-Encoding: gzip' -H 'Connection: keep-alive'
duration = 20

bench_http:
	@# From first entry only title is displayed on plot
	$(wkr_cmd:[CONN]=1) --latency -d 1 -c 1 --timeout 8 -t 1 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=1) --latency -d $(duration) -c 1 --timeout 8 -t 1 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=4) --latency -d $(duration) -c 4 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=32) --latency -d $(duration) -c 32 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=64) --latency -d $(duration) -c 64 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=128) --latency -d $(duration) -c 128 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	$(wkr_cmd:[CONN]=256) --latency -d $(duration) -c 256 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	@echo >>$(result_prefix)${csv}
	@echo >>$(result_prefix)${csv}
	@echo Statistics written to $(result_prefix)${csv}

# Quick benchmarks

bench_seed_region: $(result_prefix)seed_region.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) mapcache_seed -c /etc/mapcache/mapcache.xml -t ms_mvt -z 1,6 -e $(region_bbox)
	@echo Statistics written to result_$@.csv

bench_seed_region_4: $(result_prefix)seed_region_4.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) mapcache_seed -c /etc/mapcache/mapcache.xml -t ms_mvt -z 1,6 -n 4 -e $(region_bbox)
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
	find $(tilecache)/ms_mvt -name '*mvt' | wc -l
	du -s $(tilecache)/ms_mvt

clean_tilecache:
	@# Delete files as user www-data
	docker-compose run --rm --entrypoint /bin/rm mapcache "-rf" "/var/sig/tiles/ms_mvt"
