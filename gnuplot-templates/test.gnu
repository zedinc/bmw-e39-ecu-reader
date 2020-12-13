# reset
# set terminal pngcairo enhanced font 'Verdana,10'
# set style line  1 lc 'blue' pt 1 ps 1 lt 1 lw 2
# set style line 12 lc 'black' lt 0 lw 1
# set grid back linestyle 12
# set output '[ % OUTPUT_FILE % ]'
# set title '[ % TITLE % ]'
# unset key
# set autoscale xy
# plot '[ % DATA_FILE % ]' with linespoints ls 1 pt 7 ps 1,'' using 1:2:(sprintf("%.2g",$2)) with labels offset -1,1

reset
set terminal pngcairo enhanced font 'Verdana,10'
# set style line  1 lc 'blue' pt 1 ps 1 lt 1 lw 2
# set style line 12 lc 'black' lt 0 lw 1
# set grid back linestyle 12
set output 'trial3d.png'
set title 'trial'
set dgrid3d
set contour surf
set cntrparam levels discrete 10, 20, 30, 40, 50
set palette maxcolors 5
set palette defined (0 "steelblue", \
                     1 "orange",\
                     2 "gray70",\
                     3 "gold",\
                     4 "navy"        )

unset key
set autoscale xy
set view 70, 14
splot 'vanos_matrix.dat' matrix using 1:2:3 with lines lc palette
