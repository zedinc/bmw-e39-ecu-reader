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
# use constant ADDR => [ 0x7F28 , 0x7F52 ];

foreach my $set ( { addr => 0x7F28, title => 'Servotronic Assist, Normal Mode', output_file => 'servo_assist_normal.png'},
                  { addr => 0x7F52, title => 'Servotronic Assist, Sport Mode' , output_file => 'servo_assist_sport.png' }, ) {

    my @data   = get(  hexdump    => $raw_hex,
                        start_addr => $set->{addr},
                                 x => { digits => 4,
                                        manipulation => sub { $_[0] / (1<<10) * 5 }
                                      },
                                 y => { digits => 4,
                                        manipulation => sub { unpack 's', pack 'S', $_[0] },
                                      },
                                 z => { digits => 2,
                                        manipulation => sub { unpack 'c', pack 'C', $_[0] },
                                      },
                     );
    
    my %options = (
                          title => $set->{title},
                   x_axis_label => 'X',
                   y_axis_label => 'Y',
                 x_label_offset => 3,
                 y_label_offset => -0.5,
                    output_file => $set->{output_file},
                  );
    
    generate_plot( \@data, GNU_TEMPLATE, %options );
}