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

is( length($raw_hex)/2-1, 0x7FFF, 'Last address in hex dump');

my %tests = (
                0x10AE => {
                                num_x => 16,       num_y => 16,       num_z => 256,
                              x_start => 0x10B0, y_start => 0x10D0, z_start => 0x10F0,
                            last_addr => 0x12EF,
                          },
                0x29EC => {
                                num_x => 12,       num_y => 18,       num_z => 216,
                              x_start => 0x29EE, y_start => 0x2A06, z_start => 0x2A2A,
                            last_addr => 0x2BD9,
                          },
                0x714E => {
                                num_x => 5,        num_y => 0,        num_z => 5,
                              x_start => 0x7150, y_start => 0x715A, z_start => 0x715A,
                            last_addr => 0x7163,
                          },
            );
for my $test_addr ( keys %tests ) {
    
    my %info = get_addr_block_info( hexdump    => $raw_hex,
                                    start_addr => $test_addr,
                                    x => { digits => 4 },
                                    y => { digits => 4 },
                                    z => { digits => 4 }, );
    
    is_deeply( \%info, $tests{$test_addr}, sprintf( '%#X', $test_addr ) );
}

done_testing();