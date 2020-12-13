use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
use Gnuplot;
use Utils;
use ECUReader;
use Data::Dump 'dd';

use constant GNU_TEMPLATE => read_file( 'gnuplot_templates\vanos_plot.gnu' );
my $raw_hex = read_data( +shift );
my $addr    = hex( +shift );

my @map   = get(  hexdump    => $raw_hex,
                  start_addr => $addr,
                           x => { digits => 4 },
                           y => { digits => 4,
                                  manipulation => sub { sprintf "%.1f%%", 100 * $_[0] / ( 1<<15 ) }
                                },
                           z => { digits => 2,
                                  manipulation => sub { unpack 'c', pack 'C', $_[0]  },
                                },
               );

my @plots = (
    { title => sprintf( "%#X", $addr ),   output_file => sprintf( "%#X", $addr ).'.png',   data => \@map,   x_tics => prepare_xtics( @map )   },
);

for my $plot_specifics ( @plots ) {
    
    my $data = $plot_specifics->{data};
    
    generate_matrix_plot( $data, GNU_TEMPLATE, %$plot_specifics );
}

sub prepare_xtics {
    
    my @data = @_ ;
    
    my @x_values = uniq( map $_->[0], @data );
    
    my $str = join ', ', map { "'$x_values[$_]' $_" } 0 .. $#x_values ;
    return $str ;
}