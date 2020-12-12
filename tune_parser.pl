use strict;
use warnings;
use subs qw( say pretty_print );
use ECUReader;
use Utils;

# Diagnostics
use Carp qw( confess cluck );
local $SIG{__DIE__} = \&Carp::confess;
local $SIG{__WARN__} = \&Carp::cluck;
# use Data::Dump 'dd';

use constant {
                DYNO_REV_LIMITER_ADDR        => 0x0070, 
                REV_LIMIT_ADDR               => 0x03b0, #
                VANOS_INTAKE_ADDR            => 0x10AE, 
                VANOS_EXHAUST_ADDR           => 0x13D2, 
                SMG_GEAR_RATIOS_ADDR         => 0x1BA8, 
                SPORT_BUTTON_MEMORY_ADDR     => 0x4026, #
                LIMP_MODE_THROTTLE_ADDR      => 0x414c, #
                SPORT_MODE_THROTTLE_ADDR     => 0x4176, #
                COMFORT_MODE_THROTTLE_ADDR   => 0x41a0, #
                KNOCK_SENSOR_1_MAP_ADDR      => 0x4CDC, #
                KNOCK_SENSOR_2_MAP_ADDR      => 0x4D64, #
                KNOCK_SENSOR_3_MAP_ADDR      => 0x4DEC, #
                KNOCK_SENSOR_4_MAP_ADDR      => 0x4E74, #
                KNOCK_SENSOR_5_MAP_ADDR      => 0x4EFC, #
                KNOCK_SENSOR_6_MAP_ADDR      => 0x4F84, #
                KNOCK_SENSOR_7_MAP_ADDR      => 0x500C, #
                KNOCK_SENSOR_8_MAP_ADDR      => 0x5094, #
                WARMUP_LIGHT_ADDR            => 0x5510, 
                IGNITION_FULL_THROTTLE_ADDR  => 0x57AA, 
                IGNITION_MINIMUM_ADDR        => 0x594A, 
                IGNITION_BASE_ADDR           => 0x55BC, 
                THROTTLE_MAP_ADDR            => 0x6346,
                SPEED_GOVERNOR_ADDR          => 0x6f42,
                STEER_SERVO_ASST_NORMAL_ADDR => 0x7f28,
                STEER_SERVO_ASST_SPORT_ADDR  => 0x7f52,
            };

# Get the ECU binary hex dump

my $file = +shift;  # Pass .read file

my $raw_hex =     do { # Important to open this as 'raw', else CRLF characters get consumed
                    
                    open my $fh, '<:raw', $file or die "Unable to open file '$file': $!";
                    local $/;
                    unpack( 'H*', <$fh> );
                };

# Read in values/maps
                
my $sport_memory = read_addr( $raw_hex, SPORT_BUTTON_MEMORY_ADDR, 2 );

   my @limp =    get(
                    hexdump     => $raw_hex,
                    start_addr  => LIMP_MODE_THROTTLE_ADDR,
                    x => { digits => 4, manipulation => sub { $_[0] / 10 } },
                    y => { digits => 4, manipulation => sub { $_[0] / 10 } },
                );
  my @sport =    get(
                    hexdump     => $raw_hex,
                    start_addr  => SPORT_MODE_THROTTLE_ADDR,
                    x => { digits => 4, manipulation => sub { $_[0] / 10 } },
                    y => { digits => 4, manipulation => sub { $_[0] / 10 } },
                );
my @comfort =    get(
                    hexdump     => $raw_hex,
                    start_addr  => COMFORT_MODE_THROTTLE_ADDR,
                    x => { digits => 4, manipulation => sub { $_[0] / 10 } },
                    y => { digits => 4, manipulation => sub { $_[0] / 10 } },
                );

my @speed_limits =    get(
                        hexdump     => $raw_hex,
                        start_addr  => SPEED_GOVERNOR_ADDR,
                                  x => { digits => 4, manipulation => sub {   $_[0]  } },
                                  y => { digits => 4, manipulation => sub { $_[0]/16 } },
                    );

my @rev_limits   =    get(
                        hexdump     => $raw_hex,
                        start_addr  => REV_LIMIT_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                    );

my @throttle_map =    get(
                        hexdump     => $raw_hex,
                        start_addr  => THROTTLE_MAP_ADDR,
                                  x => { digits => 4, manipulation => sub { $_[0] } },
                                  y => { digits => 4, manipulation => sub { $_[0] } },
                                  z => { digits => 4, manipulation => sub { $_[0] } },
                    );

my @knock_map_1  =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_1_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_2 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_2_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_3 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_3_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_4 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_4_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_5 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_5_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_6 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_6_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_7 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_7_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @knock_map_8 =    get(
                        hexdump     => $raw_hex,
                        start_addr  => KNOCK_SENSOR_8_MAP_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @warmup_lights  = read_addr_list( $raw_hex, WARMUP_LIGHT_ADDR, 7,
                                     {
                                        digits       => 2,
                                        manipulation => sub { $_[0] - 48 },
                                     }
                                    );

my $dyno_rev_limit = read_addr( $raw_hex, DYNO_REV_LIMITER_ADDR, 4 );

my @smg_gear_ratio = read_addr_list( $raw_hex, SMG_GEAR_RATIOS_ADDR, 8,
                                     {
                                        digits       => 2,
                                        manipulation => sub { sprintf '%.3f', $_[0] / 60 },
                                     }
                                    );

my @base_ignition = get(
                        hexdump     => $raw_hex,
                        start_addr  => IGNITION_BASE_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @wot_ignition = get(
                        hexdump     => $raw_hex,
                        start_addr  => IGNITION_FULL_THROTTLE_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @min_ignition = get(
                        hexdump     => $raw_hex,
                        start_addr  => IGNITION_MINIMUM_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4 },
                                  z => { digits => 4 },
                    );

my @vanos_intake = get(
                        hexdump     => $raw_hex,
                        start_addr  => VANOS_INTAKE_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4, manipulation => sub { sprintf '%.3f', $_[0] / (1<<15) } },
                                  z => { digits => 2 },
                    );

my @vanos_exhaust = get(
                        hexdump     => $raw_hex,
                        start_addr  => VANOS_EXHAUST_ADDR,
                                  x => { digits => 4 },
                                  y => { digits => 4, manipulation => sub { sprintf '%.3f', $_[0] / (1<<15) } },
                                  z => { digits => 2 },
                    );

####----####----####----####----

say 'Sport button memory:';
say $sport_memory;

say 'Limp mode throttle:';
pretty_print @limp;

say 'Sport mode throttle:';
pretty_print @sport;

say 'Comfort mode throttle:';
pretty_print @comfort;

say 'Speed governor limits:';
pretty_print @speed_limits;

say 'Rev limits';
pretty_print @rev_limits;

say 'Throttle plate angle map';
pretty_print grid_data( @throttle_map );

say 'Knock control 1';
pretty_print grid_data( @knock_map_1 );

say 'Knock control 2';
pretty_print grid_data( @knock_map_2 );

say 'Knock control 3 map';
pretty_print grid_data( @knock_map_3 );

say 'Knock control 4 map';
pretty_print grid_data( @knock_map_4 );

say 'Knock control 5 map';
pretty_print grid_data( @knock_map_5 );

say 'Knock control 6 map';
pretty_print grid_data( @knock_map_6 );

say 'Knock control 7 map';
pretty_print grid_data( @knock_map_7 );

say 'Knock control 8 map';
pretty_print grid_data( @knock_map_8 );

say 'Warmup lights : ', "@warmup_lights";

say 'Dyno rev limiter : ', $dyno_rev_limit ;

say 'SMG gear ratios : ';
say $_ for @smg_gear_ratio;
# say read_addr( $raw_hex, $_, 2 ) / 60 for 0x1BA8 .. 0x1BAF;

say 'Base ignition';
pretty_print grid_data( @base_ignition );

say 'Full throttle ignition';
pretty_print grid_data( @wot_ignition );

say 'Minimum ignition';
pretty_print grid_data( @min_ignition );