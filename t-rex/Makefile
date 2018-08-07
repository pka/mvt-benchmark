sw = t-rex
exec = docker-compose run --rm t-rex
result_prefix = ../results/results_
ts = $(shell date '+%Y-%m-%dT%TZ')
region_bbox = 5.361328,45.336702,30.058594,58.950008

seed_world: $(result_prefix)seed_world.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) generate --config mvtbench.toml --maxzoom=6 --extent=-180,-90,180,90
	@echo Statistics written to $<

seed_region: $(result_prefix)seed_region.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< $(exec) generate --config mvtbench.toml --maxzoom=6 --extent=$(region_bbox)
	@echo Statistics written to result_$@.csv

seed_region_4: $(result_prefix)seed_region_4.csv
	time -f "$(ts),$(sw),%E,%U,%S" -a -o $< sh -c '$(exec) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=0 --extent=$(region_bbox) & \
	$(exec) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=1 --extent=$(region_bbox) & \
	$(exec) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=2 --extent=$(region_bbox) & \
	$(exec) generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=3 --extent=$(region_bbox)'
	@echo Statistics written to $<

$(result_prefix)seed_world.csv:
	echo time_started,software,real,user,sys >$@

$(result_prefix)seed_region.csv:
	echo time_started,software,real,user,sys >$@

$(result_prefix)seed_region_4.csv:
	echo time_started,software,real,user,sys >$@

serve:
	docker-compose run -p 127.0.0.1:6767:6767 t-rex serve --config mvtbench.toml --openbrowser=false

http:
	# 1 connection
	docker run --rm --net=host -v $$PWD:/bench williamyeh/wrk -H 'Accept-Encoding: gzip' -H 'Connection: keep-alive' --latency -d 5 -c 4 --timeout 8 -t 1 -s /bench/httpbench.lua http://127.0.0.1:6767
	# 4 connections
	docker run --rm --net=host -v $$PWD:/bench williamyeh/wrk -H 'Accept-Encoding: gzip' -H 'Connection: keep-alive' --latency -d 5 -c 4 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	# 32 connections
	docker run --rm --net=host -v $$PWD:/bench williamyeh/wrk -H 'Accept-Encoding: gzip' -H 'Connection: keep-alive' --latency -d 5 -c 32 --timeout 8 -t 4 -s /bench/httpbench.lua http://127.0.0.1:6767
	@echo Statistics written to results_http.csv

stats:
	find /tmp/mvtcache/ne_countries -name '*pbf' | wc -l
	du -s /tmp/mvtcache/ne_countries

clean:
	rm -rf /tmp/mvtcache
