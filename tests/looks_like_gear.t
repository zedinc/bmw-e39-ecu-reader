use strict;
use warnings;
use Test::More;

use ECUReader;
use Utils;

my @pass = (
                [ 0 .. 7 ],
           );

my @fail = (
             
           );

ok(   simple_sequence( @$_ ) ) for @pass ;
ok( ! simple_sequence( @$_ ) ) for @fail ;


done_testing();