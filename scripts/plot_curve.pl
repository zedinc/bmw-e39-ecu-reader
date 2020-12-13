use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
use Gnuplot;
use Utils;
use ECUReader;
use Data::Dump 'dd';
use Getopt::Long;

my $raw_hex = read_data( +shift );
my $addr    = hex( +shift );

use constant GNU_TEMPLATE => read_file( 'maf_plot.gnu' );

my @data   = get(  hexdump    => $raw_hex,
                    start_addr => $addr,
                             x => { digits => 4,
                                    manipulation => sub { $_[0] / 32 * 5 }
                                    # manipulation => sub { unpack 's', pack 'S', $_[0] },
                                  },
                             y => { digits => 4,
                                    manipulation => sub { sprintf "%.1f", $_[0] / 4 },
                                    # manipulation => sub { unpack 's', pack 'S', $_[0] },
                                  },
                                    # manipulation => sub { unpack 'c', pack 'C', $_[0] },
                                  # },
                 );

my %options = (
                      title => sprintf( "%#X", $addr ),
               x_axis_label => 'Voltage, V',
               y_axis_label => 'Air Flow, kg/h',
             x_label_offset => 0,
             y_label_offset => -1,
                output_file => sprintf( "%#X", $addr ).'.png',
              );

generate_plot( \@data, GNU_TEMPLATE, %options );