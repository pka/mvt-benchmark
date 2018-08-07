set terminal jpeg size 500,500
# This sets the aspect ratio of the graph
set size 1, 1
set output "benchmark.jpg"
# The graph title
set title "seed region"
# Where to place the legend/key
set key left top
# Draw gridlines oriented on the y axis
set grid y
# Specify that the y-series data is time data
set ydata time
# Specify the *input* format of the time data
set timefmt "%M:%S"
# Specify the *output* format for the y-axis tick labels
set format y "%.1tS"
set xtics auto
set ylabel "duration (s)"
# Use CSV delimiter instead of spaces (default)
set datafile separator ','
# Plot the data
plot "results_seed_region.csv" every ::2 using (1):3:(0):2 with boxplot
exit
