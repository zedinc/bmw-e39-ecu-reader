use strict;
use warnings;
use Test::More;

use ECUReader;
use Utils;


my $file = +shift;  # Pass .read file

my $raw_hex = 	do {
					open my $fh, '<:raw', $file or die "Unable to open file '$file': $!";
					local $/;
					unpack( 'H*', <$fh> );
				};

# ok( read_addr( $raw_hex, 0x0000, 2 ) == 0x02 );           # ok
# ok( read_addr( $raw_hex, 0x16d3, 2 ) == 0x0a );           # ok
# ok( read_addr( $raw_hex, 0x1719, 2 ) == 0xe8 );           # ok
# ok( read_addr( $raw_hex, 0x228b, 2 ) == 0x01 );           # ok
# ok( read_addr( $raw_hex, 0x228c, 2 ) == 0x00 );           # ok
# ok( read_addr( $raw_hex, 0x228d, 2 ) == 0x00 );           # ok
# ok( read_addr( $raw_hex, 0x228e, 2 ) == 0x00 );           # ok
# ok( read_addr( $raw_hex, 0x228f, 2 ) == 0x29 );           # ok
# ok( read_addr( $raw_hex, 0x26d1, 2 ) == 0x37 );           # ok
# ok( read_addr( $raw_hex, 0x3002, 2 ) == 0x6c );           # ok
# ok( read_addr( $raw_hex, 0x32a1, 2 ) == 0xd6 );           # ok
# ok( read_addr( $raw_hex, 0x3301, 2 ) == 0x90, '0x3301' ); # ok
# ok( read_addr( $raw_hex, 0x3302, 2 ) == 0x01, '0x3302' ); # ok
# ok( read_addr( $raw_hex, 0x3303, 2 ) == 0xf4, '0x3303' ); # ok
# ok( read_addr( $raw_hex, 0x3304, 2 ) == 0x02, '0x3304' ); # ok
# ok( read_addr( $raw_hex, 0x3305, 2 ) == 0x58, '0x3305' ); # ok
# ok( read_addr( $raw_hex, 0x3306, 2 ) == 0x05, '0x3306' ); # ok
# ok( read_addr( $raw_hex, 0x3307, 2 ) == 0x05, '0x3307' ); # ok
# ok( read_addr( $raw_hex, 0x3308, 2 ) == 0x05, '0x3308' ); # ok
# ok( read_addr( $raw_hex, 0x3309, 2 ) == 0x07, '0x3309' ); # ok
# ok( read_addr( $raw_hex, 0x330a, 2 ) == 0x0a, '0x330a' ); # ok
# ok( read_addr( $raw_hex, 0x330b, 2 ) == 0x07, '0x330b' ); # ok
# ok( read_addr( $raw_hex, 0x330c, 2 ) == 0x07, '0x330c' ); # ok
# ok( read_addr( $raw_hex, 0x330d, 2 ) == 0x07, '0x330d' ); # ok
# ok( read_addr( $raw_hex, 0x330e, 2 ) == 0x0a, '0x330e' ); # ok
# ok( read_addr( $raw_hex, 0x330f, 2 ) == 0x0a, '0x330f' ); # ok
# ok( read_addr( $raw_hex, 0x3310, 2 ) == 0x0a, '0x3310' ); # ok
# ok( read_addr( $raw_hex, 0x3314, 2 ) == 0x0c, '0x3314' ); # ok
# ok( read_addr( $raw_hex, 0x3315, 2 ) == 0x0a, '0x3315' ); # ok
# ok( read_addr( $raw_hex, 0x3316, 2 ) == 0x0a, '0x3316' ); # ok
# ok( read_addr( $raw_hex, 0x3317, 2 ) == 0x0a, '0x3317' ); # ok
# ok( read_addr( $raw_hex, 0x3318, 2 ) == 0x0b, '0x3318' ); # ok
# ok( read_addr( $raw_hex, 0x3319, 2 ) == 0x0d, '0x3319' ); # not ok, Start of the offset
# ok( read_addr( $raw_hex, 0x331a, 2 ) == 0x0a, '0x331a' ); # not ok
# ok( read_addr( $raw_hex, 0x3320, 2 ) == 0x9c, '0x3320' ); # not ok
# ok( read_addr( $raw_hex, 0x3321, 2 ) == 0x40 );
# ok( read_addr( $raw_hex, 0x3333, 2 ) == 0xc0 );
# ok( read_addr( $raw_hex, 0x3eb3, 2 ) == 0x02 );

# ok( ascending( 4,5,6 ) );
# ok( ! ascending( 4,7,6 ) );

# get_map(
           # hexdump    => $raw_hex,
           # start_addr => 0x4cde,
           # num_x      => 16,
           # num_y      => 3,
           # x          => { digits => 4 },
           # y          => { digits => 4 },
           # z          => { digits => 4 },
       # );

	   
done_testing();