use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
use Gnuplot;
use Utils;
use ECUReader;
use Data::Dump 'dd';

my $raw_hex = read_data( +shift );

use constant GNU_TEMPLATE => read_file( 'C:\Users\Zaid\OneDrive\BMW\gnuplot_templates\vanos_plot.gnu' );
use constant INTAKE_ADDR  => 0x10AE ;
use constant EXHAUST_ADDR => 0x13D2 ;
# use constant INTAKE_ADDR  => 0x11F0 ;
# use constant EXHAUST_ADDR => 0x1514 ;


my @inlet   = get(  hexdump    => $raw_hex,
                    start_addr => INTAKE_ADDR,
                             x => { digits => 4 },
                             y => { digits => 4,
                                    manipulation => sub { sprintf "%.1f%%", 100 * $_[0] / ( 1<<15 ) }
                                  },
                             z => { digits => 2,
                                    manipulation => sub { unpack 'c', pack 'C', $_[0] },
                                  },
                 );

my @exhaust = get(  hexdump    => $raw_hex,
                    start_addr => EXHAUST_ADDR,
                             x => { digits => 4 },
                             y => { digits => 4,
                                    manipulation => sub { sprintf "%.1f%%", 100 * $_[0] / ( 1<<15 ) }
                                  },
                             z => { digits => 2,
                                    manipulation => sub { unpack 'c', pack 'C', $_[0] },
                                  },
                 );

# die "VANOS inlet vs exhaust data mismatch"
  # unless @inlet == @exhaust; 

# pretty_print( grid_data( @inlet ) );
# pretty_print( grid_data( @exhaust ) );

# my @diff;
# for my $index ( 0 .. $#inlet ) {
    
    # my @inlet   = @{  $inlet[$index]  };
    # my @exhaust = @{ $exhaust[$index] };
    
    # die "Expecting a triplet" unless @inlet == 3 && @exhaust == 3;
    # die "Data mismatch in variable X at index '$index'" unless $inlet[0] eq $exhaust[0];
    # die "Data mismatch in variable Y at index '$index'" unless $inlet[1] eq $exhaust[1];
    
    # push @diff, [ $inlet[0], $inlet[1], $inlet[2] - $exhaust[2] ];
# }

# dd @diff;

my @plots = (
    { title => 'US Map (Rontgen) - Intake Angle',   output_file => 'vanos_intake.png',   data => \@inlet,   x_tics => prepare_xtics( @inlet )   },
    { title => 'US Map (Rontgen) - Exhaust Angle',  output_file => 'vanos_exhaust.png',  data => \@exhaust, x_tics => prepare_xtics( @exhaust ) },
    # { title => 'Rontgen Original - VANOS Intake Angle',   output_file => 'vanos_intake.png',   data => \@inlet,   x_tics => prepare_xtics( @inlet )   },
    # { title => 'Rontgen Original - VANOS Exhaust Angle',  output_file => 'vanos_exhaust.png',  data => \@exhaust, x_tics => prepare_xtics( @exhaust ) },
    # { title => 'US Map (Rontgen) - Relative Angle', output_file => 'vanos_relative.png', data => \@diff,    x_tics => prepare_xtics( @diff )   },
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