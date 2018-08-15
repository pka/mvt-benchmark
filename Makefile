tilecache = ./tiles

.PHONY: bench
bench:
	@#Handle file permissions
	chmod go+rw $(tilecache)
	touch bench/results/results_http.csv

	cd t-rex && make bench

	cd bench/results && make

quick_bench:
	@#Handle file permissions
	chmod go+rw $(tilecache)
	touch bench/results/results_http_quick.csv

	cd t-rex && make quick_bench

	cd bench/results && make

clean_tilecache:
	rm -rf $(tilecache)/*

clean_results:
	cd bench/results && make clean
