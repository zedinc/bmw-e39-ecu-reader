use strict;
use warnings;
use FindBin '$Bin';
use lib $Bin;
use ECUReader;
use Utils;

my $raw_hex = read_data( +shift );
my $addr = hex( +shift );

pretty_print
  grid_data( get( hexdump    => $raw_hex,
                  start_addr => $addr,
                           x => { digits => 4 },
                           y => { digits => 4 },
                           z => { digits => 2,
                                  # manipulation => sub { sprintf '%.3f', $_[0] / (1<<15) }
                                },
                )
           );

exit 0;