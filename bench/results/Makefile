all: seed.jpg seed-quick.jpg http.jpg http-quick.jpg

seed.jpg: seed.g results_seed.csv results_seed_4.csv
	gnuplot seed.g

seed-quick.jpg: seed-quick.g results_seed_region.csv results_seed_region_4.csv
	gnuplot seed-quick.g

http.jpg: http.g results_http.csv
	gnuplot http.g

http-quick.jpg: http-quick.g results_http_quick.csv
	gnuplot http-quick.g

clean:
	rm -f *.csv
