sw = martin
exec = docker-compose run --rm martin
result_prefix = ../bench/results/results_
ts = $(shell date '+%Y-%m-%dT%TZ')
region_bbox = 5.361328,45.336702,30.058594,58.950008
tilecache = ../tiles

quick_bench:
	# Start Database
	make data_ready
	# Cleanup tile cache
	#
	# Run benchmarks within $(region_bbox) on one processor
	# Append the measured time to ../bench/results/results_seed_region.csv
	# Cleanup tile cache
	# Run benchmarks within $(region_bbox) on 4 processors
	# Append the measured time to ../bench/results/results_seed_region_4.csv
	#
	# Run tile serving benchmarks with seeded tile cache
	#
	# Cleanup tile cache
	# Stop Database

bench:
	# Start Database
	make data_ready
	# Clean tile cache
	#
	# Run benchmarks on one processor
	# Append the measured time to ../bench/results/results_seed.csv
	# Clean tile cache
	# Run benchmarks on 4 processors
	# Append the measured time to ../bench/results/results_seed_4.csv
	#
	# Run tile serving benchmarks with seeded tile cache
	#
	# Cleanup tile cache
	# Stop Database

# Seeding benchmark example/skeleton targets

data_ready:
	docker-compose up -d mvtbenchdb

data_teardown:
	docker-compose stop mvtbenchdb

bench_seed: $(result_prefix)seed.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< [execution parameters]
	@echo Statistics written to $<

# Tile serving benchmark example/skeleton targets

mvtserver_ready: data_ready
	# Run MVT server listening on http://127.0.0.1:6767
	docker-compose run -p 127.0.0.1:6767:6767 --rm [...]

mvtserver_teardown:
	docker stop [...]

csv = http.csv
wkr_cmd = docker run --rm --user=$$UID --net=host -e SW="$(sw)" -e CSV_NAME=$(csv) -e CONNECTIONS=[CONN] -v $$PWD/../bench:/bench williamyeh/wrk -v $$PWD/../bench/paths.txt:/paths.txt:ro -H 'Accept-Encoding: gzip' -H 'Connection: keep-alive'
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

# Helpers

$(result_prefix)seed.csv:
	echo "#time_started,software,real,user,sys" >$@

$(result_prefix)seed_4.csv:
	echo "#time_started,software,real,user,sys" >$@

$(result_prefix)seed_region.csv:
	echo "#time_started,software,real,user,sys" >$@

$(result_prefix)seed_region_4.csv:
	echo "#time_started,software,real,user,sys" >$@
