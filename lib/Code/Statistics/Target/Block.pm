use strict;
use warnings;

package Code::Statistics::Target::Block;
# ABSTRACT: represents a block in perl code

sub class { return 'PPI::Structure::Block' }

sub supports {
    my ( $class, $metric ) = @_;
    my %metrics = ( size => 1, );
    return $metrics{$metric};
}

1;
