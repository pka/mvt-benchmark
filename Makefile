tilecache = ./tiles

bench:
	chmod go+rw $(tilecache)
	cd t-rex && make data_ready clean_tilecache
	cd t-rex && make bench_seed tile_stats clean_tilecache
	cd t-rex && make bench_seed_4 tile_stats clean_tilecache
	cd t-rex && make data_teardown
	cd bench/results && make benchmark.jpg

quick_bench:
	chmod go+rw $(tilecache)
	cd t-rex && make data_ready clean_tilecache
	cd t-rex && make bench_seed_region tile_stats clean_tilecache
	cd t-rex && make bench_seed_region_4 tile_stats clean_tilecache
	cd t-rex && make data_teardown
	cd bench/results && make benchmark-quick.jpg

seed_http_bench_cache:
	cd t-rex && make data_ready bench_seed_region data_teardown

quick_bench_http:
	cd t-rex && make mvtserver_teardown
	cd t-rex && make mvtserver_ready bench_http mvtserver_teardown

	#cd t-rex && make data_ready
	#cd t-rex && RUST_LOG=error TREX_DATASOURCE_URL=postgresql://mvtbench:mvtbench@127.0.0.1:5439/mvtbench /usr/bin/t_rex serve --config mvtbench.toml --openbrowser false &
	#cd t-rex && make bench_http sw="t-rex 0.8.2"
	#sleep 3
	#cd t-rex && make data_teardown

	cd bench/results && make http-quick.jpg

clean_tilecache:
	rm -rf $(tilecache)/*

# Optional benchmarks

t_rex_0_8_2: /tmp/t-rex-v0.8.2-x86_64-unknown-linux-gnu.deb
	cd t-rex && make data_ready
	make clean_tilecache
	cd t-rex && TREX_DATASOURCE_URL=postgresql://mvtbench:mvtbench@127.0.0.1:5439/mvtbench make bench_seed exec=/usr/bin/t_rex sw="t-rex 0.8.2" tile_stats
	make clean_tilecache
	cd t-rex && TREX_DATASOURCE_URL=postgresql://mvtbench:mvtbench@127.0.0.1:5439/mvtbench make bench_seed_4 exec=/usr/bin/t_rex sw="t-rex 0.8.2" tile_stats
	make clean_tilecache
	cd t-rex && make data_teardown

/tmp/t-rex-v0.8.2-x86_64-unknown-linux-gnu.deb:
	cd /tmp && curl -O -L https://github.com/t-rex-tileserver/t-rex/releases/download/v0.8.2/t-rex-v0.8.2-x86_64-unknown-linux-gnu.deb && sudo dpkg -i t-rex-v0.8.2-x86_64-unknown-linux-gnu.deb
