use strict;
use warnings;

package Code::Statistics::Target::Block;

sub class { return 'PPI::Structure::Block' }

sub supports {
    my ( $class, $metric ) = @_;
    my %metrics = ( size => 1, );
    return $metrics{$metric};
}

1;
