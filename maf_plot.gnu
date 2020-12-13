reset
set terminal pngcairo enhanced font 'Verdana,10'
set style line  1 lc 'blue' pt 1 ps 1 lt 1 lw 2
set style line 12 lc 'black' lt 0 lw 1
set style line 13 lc 'black' lt 0 lw 2
set mxtics
set mytics
set grid xtics ytics mxtics mytics back ls 12, ls 12
# set grid xtics ytics back ls 12, ls 12
set output '[ % OUTPUT_FILE % ]'
set title '[ % TITLE % ]'
set xlabel '[ % X_AXIS_LABEL % ]'
set ylabel '[ % Y_AXIS_LABEL % ]'
unset key
set autoscale xy
plot '[ % DATA_FILE % ]' using 1:2 with linespoints ls 1 pt 7 ps 1 \
   , '[ % DATA_FILE % ]' using 1:2:2 with labels offset [ % X_LABEL_OFFSET % ],[ % Y_LABEL_OFFSET % ] rotate by 90 right
