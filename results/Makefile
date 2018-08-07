all: benchmark.jpg

benchmark.jpg: results_seed_region.csv
	gnuplot seed.g

clean:
	rm -f *.csv
