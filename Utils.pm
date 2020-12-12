use strict;
use warnings;

sub uniq { my %seen; grep ! $seen{$_}++, @_ }

sub say { print @_, "\n" }

sub pretty_print { say join "\t", @$_ for @_ }

sub ascending  { @_ < 2 || ( ! grep { $_[$_-1] > $_[$_] } 1 .. $#_ ) && $_[0] != $_[-1] }

sub descending { @_ < 2 || ( ! grep { $_[$_-1] < $_[$_] } 1 .. $#_ ) && $_[0] != $_[-1] }

sub constant_list {
    my $return = 1;
    for ( 1 .. $#_ ) {
        
        if ( $_[$_-1] != $_[$_] ) {
            $return = 0;
            last;
        }
    }
    $return;
}

sub read_file {
    
    my ( $file ) = @_ ;
    
    local $/;
    open my $fh, '<', $file or die "Unable to slurp file '$file': $!";
    return <$fh> ;
}

sub grid_data {
    
    my @data = @_ ; # Expects regular X,Y,Z triplets
    
    my ( $x_cntr, $x_ordr, $y_cntr, $y_ordr );
    my ( %data, %x );
    for ( @data ) {
        
        my ( $x, $y, $z ) = @$_ ;
        
        $x_ordr->{$x} = $x_cntr++ unless exists $x_ordr->{$x};
        $y_ordr->{$y} = $y_cntr++ unless exists $y_ordr->{$y};
        
        $x{$x}++;
        $data{ $y }{ $x } = $z ;
    }
    
    my @grid;
    for my $y ( sort { $y_ordr->{$a} <=> $y_ordr->{$b} } keys %data ) {
        
        my @y_data;
        for my $x ( sort { $x_ordr->{$a} <=> $x_ordr->{$b} } keys %x ) {
            
            push @y_data, $data{$y}{$x};
        }
        
        unshift @y_data, $y;
        
        push @grid, \@y_data ;
    }
    
    unshift @grid, [ "#", sort { $x_ordr->{$a} <=> $x_ordr->{$b} } keys %x ] ;
    
    return @grid ;
}

sub looks_like_rpm {
    my $test_status = 
                    + ( @_ == grep { ! $_ % 100  } @_ ) # All are multiples of 100
                    + ( @_ == grep {   $_ > 500  } @_ ) # RPM > 500
                    + ( @_ == grep {   $_ < 8000 } @_ ) # RPM < 8000
					;
    return $test_status >= 2 ; # At least two tests should pass
}

sub simple_sequence { @_ - 1 == grep { $_[$_-1] + 1 == $_[$_] } 1 ..$#_ }


1;