set terminal jpeg
set output "benchmark.jpg"

set multiplot layout 2,1

# Where to place the legend/key
set key left top
# Draw gridlines oriented on the y axis
set grid y
# Specify that the y-series data is time data
set ydata time
set yrange [0:]
# Specify the *input* format of the time data
set timefmt "%M:%S"
# Specify the *output* format for the y-axis tick labels
set format y "%.1tS"
set xtics auto
set ylabel "duration (s)"

# Use CSV delimiter instead of spaces (default)
set datafile separator ','

# graph title
set title "seed"
unset key
plot "results_seed.csv" using (1):3:(0):2 with boxplot

set title "seed 4 nodes"
unset key
plot "results_seed_4.csv" using (1):3:(0):2 with boxplot

unset multiplot
