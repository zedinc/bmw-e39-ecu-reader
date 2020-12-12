use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
use Gnuplot;
use Utils;
use ECUReader;
use Data::Dump 'dd';

my $raw_hex = read_data( +shift );

use constant GNU_TEMPLATE => read_file( 'C:\Users\Zaid\OneDrive\BMW\gnuplot_templates\maf_plot.gnu' );
use constant ADDR => 0x5F5A ;

my @data   = get(  hexdump    => $raw_hex,
                    start_addr => ADDR,
                             x => { digits => 4,
                                    manipulation => sub { $_[0] / 100 }
                                  },
                             y => { digits => 4,
                                    manipulation => sub { unpack 's', pack 'S', $_[0] },
                                  },
                             z => { digits => 2,
                                    manipulation => sub { unpack 'c', pack 'C', $_[0] },
                                  },
                 );

my %options = (
                      title => 'Mass Air Flow vs. MAF Voltage',
               x_axis_label => 'Voltage, V',
               y_axis_label => 'Air Mass Flow, kg/h',
             x_label_offset => 3,
             y_label_offset => -0.5,
                output_file => 'maf_voltage.png',
              );

generate_plot( \@data, GNU_TEMPLATE, %options );