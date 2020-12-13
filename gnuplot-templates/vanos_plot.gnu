reset
set terminal pngcairo enhanced font 'Verdana,10'
set output '[ % OUTPUT_FILE % ]' ###
set autoscale xy

set title "[ % TITLE % ]"  ###

#set xrange [-0.5:15.5]
#set xtics 0,1,15
set xtics ([ % X_TICS % ]) rotate by 90 right enhanced
#set xtics ( '500' 0, '600' 1, '900' 2, '1100' 3, '1200' 4, '1400' 5, '1550' 6, '1700' 7, '2000' 8, '2100' 9, '2400' 10, '2800' 11, '2900' 12, '3500' 13, '5000' 14, '6800' 15) rotate by 90 right enhanced

set xlabel 'RPM' 
set ylabel 'Load'

set palette defined (0 "web-blue", 1 "gray60", 2 "goldenrod", 3 "red" )
unset key
unset colorbox
plot '[ % DATA_FILE % ]' matrix rowheaders using 1:2:3 with image, \
     '[ % DATA_FILE % ]' matrix rowheaders using 1:2:(sprintf("%d",$3)) with labels

#plot 'vanos_exhaust.dat' using 1:2:3 with image, \
#     'vanos_exhaust.dat' using 1:2:(sprintf("%d",$3)) with labels