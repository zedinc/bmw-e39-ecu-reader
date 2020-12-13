use strict;
use warnings;
use FindBin '$Bin';
use lib $Bin;

use ECUReader;
use Utils;

my $raw_hex = read_data( +shift );
my $addr = hex( +shift );

say sprintf "%#x", $addr;
pretty_print
# say join "\t", @$_ for grid_data
  ( get( hexdump    => $raw_hex,
         start_addr => $addr,
                  # x => { digits => 4 },
                  x => { digits => 4, 
                         manipulation => sub { sprintf "%.3f", $_[0] / 32 * 5 },
                       },
                  y => { digits => 4, 
                         manipulation => sub { $_[0] / 4 },
                         # manipulation => sub { sprintf "%.0f%%", 100 * $_[0] / ( 1<<15 ) },
                       },
                  z => { digits => 4 },
       )
  );

exit 0;