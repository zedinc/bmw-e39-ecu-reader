use strict;
use warnings;
use FindBin '$Bin';
use lib $Bin;

use ECUReader;
use Gnuplot;
use Utils;
use List::Util qw'min max';

# Get the ECU binary hex dump

my $raw_hex =  read_data( +shift );

my %known_addresses = (
                         0x0070 => 'DYNO_REV_LIMITER_ADDR'       , 
                         0x03B0 => 'REV_LIMIT_ADDR'              , #
                         0x10AE => 'VANOS_INTAKE_ADDR'           , 
                         0x13D2 => 'VANOS_EXHAUST_ADDR'          , 
                         0x1BA8 => 'SMG_GEAR_RATIOS_ADDR'        , 
                         0x4026 => 'SPORT_BUTTON_MEMORY_ADDR'    , #
                         0x414C => 'LIMP_MODE_THROTTLE_ADDR'     , #
                         0x4176 => 'SPORT_MODE_THROTTLE_ADDR'    , #
                         0x41A0 => 'COMFORT_MODE_THROTTLE_ADDR'  , #
                         0x4CDC => 'KNOCK_SENSOR_1_MAP_ADDR'     , #
                         0x4D64 => 'KNOCK_SENSOR_2_MAP_ADDR'     , #
                         0x4DEC => 'KNOCK_SENSOR_3_MAP_ADDR'     , #
                         0x4E74 => 'KNOCK_SENSOR_4_MAP_ADDR'     , #
                         0x4EFC => 'KNOCK_SENSOR_5_MAP_ADDR'     , #
                         0x4F84 => 'KNOCK_SENSOR_6_MAP_ADDR'     , #
                         0x500C => 'KNOCK_SENSOR_7_MAP_ADDR'     , #
                         0x5094 => 'KNOCK_SENSOR_8_MAP_ADDR'     , #
                         0x5510 => 'WARMUP_LIGHT_ADDR'           , 
                         0x57AA => 'IGNITION_FULL_THROTTLE_ADDR' , 
                         0x594A => 'IGNITION_MINIMUM_ADDR'       , 
                         0x55BC => 'IGNITION_BASE_ADDR'          , 
                         0x6346 => 'THROTTLE_MAP_ADDR'           ,
                         0x6F42 => 'SPEED_GOVERNOR_ADDR'         ,
                         0x7F28 => 'STEER_SERVO_ASST_NORMAL_ADDR',
                         0x7F52 => 'STEER_SERVO_ASST_SPORT_ADDR' ,
                      );

my $lookup_addr = 0x0;
# my $lookup_addr = 0x10000;
my @potential;

while ( $lookup_addr < 0x7ffb ) {
# while ( $lookup_addr < 0x11000 ) {
    # say $lookup_addr;
    my %potential = sniff( hexdump    => $raw_hex,
								       start_addr => $lookup_addr,
									   x => { digits => 4 },
									   y => { digits => 4 },
									   z => { digits => 2 },
									 );
    
    if ( %potential ) {
        
        say sprintf "%#.4X : %02d x %02d  till %#.4X", @potential{ qw< start_addr num_x num_y last_addr> };
        push @potential, \%potential;
        $lookup_addr = $potential{last_addr} + 1 ;
    }
    else {
        
        $lookup_addr++;
    }
}

my $counter = 0;
for my $potential_addr ( @potential ) {
    
	if ( exists $known_addresses{ $potential_addr->{start_addr} } ) {
        $counter ++ for $potential_addr->{start_addr} .. $potential_addr->{last_addr} ;
    }
}

say "$counter potential bytes out of ", 0x7FFF ;

# for my $candidate ( @potential ) {
    
    # next unless $candidate->{num_y} == 0 ; # 2D functions only (for now)
    
    # my %info = ( title => sprintf( "%#.4X", $candidate->{start_addr} ),
                 # output_file => sprintf( "%#.4X", $candidate->{start_addr} ). '.png' );
    
    # my $data = get( hexdump    => $raw_hex,
                    # start_addr => $candidate->{start_addr},
                             # x => { digits => 4 },
                             # y => { digits => 4 },
                             # z => { digits => 4 },
                  # );
    
    # generate_plot( $data, GNUPLOT_TEMPLATE_2D, %info );
    
    # # sleep 50;
    # # last;
    
    # # pretty_print grid_data( get( hexdump    => $raw_hex,
								 # # start_addr => $candidate,
								 # # x => { digits => 4 },
								 # # y => { digits => 4 },
								 # # z => { digits => 4 }, ) );
# }

sub sniff {
    
    my %inputs = @_;
    my ( $hex, $start_addr, $x_data, $y_data, $z_data ) = @inputs{ qw< hexdump start_addr x y z > } ;
    
    my %block = get_addr_block_info( %inputs );
    
    return
      if $block{last_addr} > ( length($raw_hex) / 2 - 1 ) ; # 0x7FFF is the last hex address in 16K, beyond will be undefined

    if ( $block{num_y} > 0 ) {            # Early bailout
        return
          unless $block{num_x} > 2 
              && $block{num_y} > 2;       # 3D function
    }
    else {
        return unless $block{num_x} > 2;  # 2D function
    }
    
    my @x = read_addr_list( $hex, $block{x_start}, $block{num_x}, $x_data );
    my @y = read_addr_list( $hex, $block{y_start}, $block{num_y}, $y_data );
    # my @z = read_addr_list( $hex, $block{z_start}, $block{num_z}, $z_data );
    
    return                         # Filter out unwanted
      unless   ascending( @x )
            && ascending( @y )
            && @x == uniq( @x )
            && @y == uniq( @y )
            # && ( min( @z ) != 0 || max( @z ) != 0 ); 
            ; 
    
    return wantarray ? %block : \%block ;
}
