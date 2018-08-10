all: benchmark.jpg

benchmark.jpg: seed.g results_seed.csv results_seed_4.csv
	gnuplot seed.g

benchmark-quick.jpg: seed-quick.g results_seed_region.csv results_seed_region_4.csv
	gnuplot seed-quick.g

http-quick.jpg: http-quick.g results_http.csv
	gnuplot http-quick.g

clean:
	rm -f *.csv
