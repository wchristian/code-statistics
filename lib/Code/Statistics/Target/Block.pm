use strict;
use warnings;

package Code::Statistics::Target::Block;
# ABSTRACT: represents a block in perl code

=head2 class
    Returns the PPI class name associated with this target.
=cut
sub class { return 'PPI::Structure::Block' }

=head2 supports
    Returns the metrics this target supports.
=cut
sub supports {
    my ( $class, $metric ) = @_;
    my %metrics = ( size => 1, );
    return $metrics{$metric};
}

1;
