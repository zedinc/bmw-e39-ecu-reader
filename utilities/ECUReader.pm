use strict;
use warnings;
use FindBin '$Bin';
use lib $Bin;
use Data::Dump 'dd';

sub read_data {
    
    my $file = +shift;  # Pass .read file

    my $raw_hex =   do { # Important to open this as 'raw', else CRLF characters get consumed
                        
                        open my $fh, '<:raw', $file or die "Unable to open file '$file': $!";
                        local $/;
                        unpack( 'H*', <$fh> );
                    };
    
    return $raw_hex;
}

sub get {
    
    my %inputs = @_;
    my ( $hex, $start_addr, $x_data, $y_data, $z_data ) = @inputs{ qw< hexdump start_addr x y z > } ;
    
    my $x_count = read_addr( $hex, $start_addr++, 2 );  # Move to next address for y
    my $y_count = read_addr( $hex, $start_addr++, 2 );  # Move to next address for data
    
    # say 'X count : ', $x_count;
    # say 'Y count : ', $y_count;
    
    my @data;
    if ( $y_count == 0 ) {  # 'Values' - 1-to-1 mapping
        
        my $num_entries = $x_count;
        
        @data = get_values(
                    hexdump     => $hex,
                    start_addr  => $start_addr,
                    num_entries => $num_entries,
                              x => $x_data,
                              y => $y_data,
                );
    }
    else { # Map - 2-to-1 mapping
        
        die "Need to specify digits (& possibly manipulation) for Z-values"
          unless defined $z_data;
        
        @data = get_map(
                    hexdump    => $hex,
                    start_addr => $start_addr,
                    num_x      => $x_count,
                    num_y      => $y_count,
                    x          => $x_data,
                    y          => $y_data,
                    z          => $z_data,
                );
    }
    
    return wantarray ? @data : \@data ;
}

sub get_values {
    
    my %inputs = @_;
    my ( $hex, $start_addr, $num_entries, $x_data, $y_data ) = @inputs{ qw< hexdump start_addr num_entries x y > } ;
    
    my $offset = $x_data->{digits} * $num_entries / 2 ;  # Will be multiplied by 2 internally
    
    my @x = read_addr_list( $hex, $start_addr          , $num_entries, $x_data );
    my @y = read_addr_list( $hex, $start_addr + $offset, $num_entries, $y_data );
    
    # printf "Started x-values at : %#x\n", $start_addr ;
    # printf "Started y-values at : %#x\n", $start_addr + $offset ;
    
    die "Something's up in get_values(), x-length and y-lengths don't match"
      unless @x == @y ;
    
    my @results = map [ $x[$_], $y[$_] ], 0 .. $#x ;  # @x, @y guaranteed to be of equal length here
    
    return @results;
}

sub get_map {
    
    my %inputs = @_;
    my ( $hex, $start_addr, $num_x, $num_y, $x_data, $y_data, $z_data ) = @inputs{ qw< hexdump start_addr num_x num_y x y z > } ;
    
    my $x_offset = $x_data->{digits} * $num_x / 2 ;  # Will be multiplied by 2 internally
    my $y_offset = $y_data->{digits} * $num_y / 2 ;  # Will be multiplied by 2 internally
    
    # say "Start addr : $start_addr";
    # say "X Offset : $x_offset"; exit 0;
    
    my @x = read_addr_list( $hex, $start_addr            , $num_x, $x_data );
    my @y = read_addr_list( $hex, $start_addr + $x_offset, $num_y, $y_data );
    
    # dd \@x; dd \@y; exit 0;
    
    # printf "Started x-values at : %#x\n", $start_addr ;
    # printf "Started y-values at : %#x\n", $start_addr + $x_offset ;
    
    my $curr_addr = $start_addr + $x_offset + $y_offset ;
    # printf "Started z-values at : %#x\n", $curr_addr ;
    
    my ( $z_digits, $z_manipulation ) = @{$z_data}{ qw< digits manipulation > };
    
    my @results;
    for my $y ( @y ) {
        for my $x ( @x ) {
            
            my $z_raw_value = read_addr( $hex, $curr_addr, $z_digits );
            my $z = defined $z_manipulation ? $z_manipulation->( $z_raw_value ) : $z_raw_value ;
            
            push @results, [ $x, $y, $z ]; # dd [ $x, $y, $z ];
            $curr_addr += $z_digits / 2 ;
        }
    }
    
    return @results;
}

sub get_addr_block_info {
    
    my %inputs = @_;
    my ( $hex, $start_addr, $x_data, $y_data, $z_data ) = @inputs{ qw< hexdump start_addr x y z > } ;
    
    my $num_x = read_addr( $hex, $start_addr, 2 );  # Move to next address for y
    my $num_y = read_addr( $hex, $start_addr+1, 2 );  # Move to next address for data
    my $num_z = $num_y ? $num_x * $num_y : $num_x  ;  # If $num_y == 0, function is 2D, else 3D
    
    my $x_offset = $x_data->{digits} * $num_x / 2 ;  # Will be multiplied by 2 internally
    my $y_offset = $y_data->{digits} * $num_y / 2 ;  # Will be multiplied by 2 internally
    my $z_offset = $z_data->{digits} * $num_z / 2 ;  # Will be multiplied by 2 internally
    
    my $x_start   = $start_addr + 2 ;
    my $y_start   = $x_start + $x_offset ;
    my $z_start   = $x_start + $x_offset + $y_offset;
    my $last_addr = $z_start + $z_offset - 1;
    
    my %block_info;
    @block_info{ qw< num_x num_y num_z x_start y_start z_start start_addr last_addr > }
      = ( $num_x, $num_y, $num_z, $x_start, $y_start, $z_start, $start_addr, $last_addr );
    
    return %block_info;
}

sub read_addr_list {
    
    my ( $hex, $start_addr, $num_entries, $series_data ) = @_ ;
    my ( $digits, $manipulation ) = @{$series_data}{ qw< digits manipulation > };
    
    warn('This hex address is off-the-charts: ', sprintf '%#x', $start_addr ),
      return if length( $hex ) < 2 * $start_addr;
    
    my @values;
    for ( 1 .. $num_entries ) {
        
        my $raw_value = read_addr( $hex, $start_addr, $digits ) ;
        
        push @values, defined $manipulation ? $manipulation->( $raw_value ) : $raw_value;
        $start_addr += $digits / 2;  # Will be multiplied by 2 internally
    }
    # dd @values;
    return @values;
}

sub read_addr {
    
    my ( $hex, $addr, $digits ) = @_ ;  # 2 digits =  8-bit, 4 digits = 16-bit
    
    my $offset = 2 * $addr;
    my $raw_string = substr $hex, $offset, $digits ;
    
    # printf "Start address in read_addr() : %#x\tOffset : %d\tRaw string : %s\n",
        # $addr, $offset, $raw_string;
    
    return unpack "s", pack 'S', hex $raw_string ;
    # return hex $raw_string ;
}

1;