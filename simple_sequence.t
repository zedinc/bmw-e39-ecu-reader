use strict;
use warnings;
use Test::More;

use ECUReader;
use Utils;

my @pass = (
                [ 600, 700,  900, 1200, 1300, 1600, 1700, 2000, 2400, 2700, 2800, 3000, 3500, 4000, 4600, 5200, 5800, 6600 ],
                [ 600, 800, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000 ],
           );

my @fail = (
                [   2, 100, 200, 300, 400, 500, 600, 700, 800, 1000 ], # Throttle position
                [ 100, 200, 300, 400, 600, 800, 1000, 1200 ],          # Relative fill
                [ 200, 250, 300, 400, 500, 600, 700, 800, 900, 1000 ], # Relative fill
                [  89, 178, 266, 355, 444, 533, 621, 710, 799, 888, 977, 1065 ], # Relative fill
           );

ok(   looks_like_rpm( @$_ ) ) for @pass ;
ok( ! looks_like_rpm( @$_ ) ) for @fail ;
ok( ascending() );

done_testing();