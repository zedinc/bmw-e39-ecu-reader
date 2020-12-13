use strict;
use warnings;
# use Utils;
use File::Temp;

use constant GNUPLOT => 'C:\Program Files\gnuplot\bin\gnuplot.exe' ;

sub prepare_data {
    
    my ( $data ) = @_ ;
    
    my $fh = File::Temp->new( UNLINK => 1, SUFFIX => '.dat' );
    print $fh->filename, "\n";
    
    for my $set ( @$data ) {
        
        print $fh join( "\t" => @$set ), "\n";
    }
    
    # $fh->seek( 0, SEEK_SET );
	# print while <$fh>;
    return $fh;
}

sub prepare_matrix_data {
    
    my ( $data ) = @_ ;
    
    my @grid_data = grid_data( @$data ) ;
    
    my $fh = File::Temp->new( UNLINK => 1, SUFFIX => '.dat' );
    print $fh->filename, "\n";
    
    for my $set ( @grid_data ) {
        
        print $fh join( "\t" => @$set ), "\n";
    }
    
    # $fh->seek( 0, SEEK_SET );
	# print while <$fh>;
    return $fh;
}

sub prepare_script {
    
    my ( $template, $vars ) = @_ ;
    
    for my $key ( keys %$vars ) {
        
        $template =~ s{\[\s*%\s*?$key\s*?%\s*?]}/$vars->{$key}/ig;
    }
    
    my $fh = File::Temp->new( UNLINK => 1, SUFFIX => '.plot' );
    print $fh->filename, "\n";
    print $fh $template;
    
    return $fh;
}

sub generate_plot {
    
    my ( $data, $script_template, %data ) = @_ ;
    
    my $data_fh = prepare_data( $data ) ;
    
    $data{data_file} = $data_fh->filename ;
    
    my $script_fh = prepare_script( $script_template, \%data );
    
    system( GNUPLOT, $script_fh->filename );
    
    
}

sub generate_matrix_plot {
    
    my ( $data, $script_template, %data ) = @_ ;
    
    my $data_fh = prepare_matrix_data( $data ) ;
    
    $data{data_file} = $data_fh->filename ;
    
    my $script_fh = prepare_script( $script_template, \%data );
    
    system( GNUPLOT, $script_fh->filename );
    
    
}

1;