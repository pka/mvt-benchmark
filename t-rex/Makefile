sw = t-rex
result_csv = results_seed.csv
ts = $(shell date '+%Y-%m-%dT%TZ')
region_bbox = 5.361328,45.336702,30.058594,58.950008

seed_world: $(result_csv)
	time -f "$(ts),$(sw),$@,%E,%U,%S" -a -o $(result_csv) t_rex generate --config mvtbench.toml --maxzoom=6 --extent=-180,-90,180,90
	@echo Statistics written to $(result_csv)

seed_region: $(result_csv)
	time -f "$(ts),$(sw),$@,%E,%U,%S" -a -o $(result_csv) t_rex generate --config mvtbench.toml --maxzoom=6 --extent=$(region_bbox)
	@echo Statistics written to $(result_csv)

seed_region_4: $(result_csv)
	time -f "$(ts),$(sw),$@,%E,%U,%S" -a -o $(result_csv) sh -c 't_rex generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=0 --extent=$(region_bbox) & \
	t_rex generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=1 --extent=$(region_bbox) & \
	t_rex generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=2 --extent=$(region_bbox) & \
	t_rex generate --config mvtbench.toml --maxzoom=6 --progress=false --nodes=4 --nodeno=3 --extent=$(region_bbox)'
	@echo Statistics written to $(result_csv)

$(result_csv):
	echo time_started,software,test_name,real,user,sys >$@

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
