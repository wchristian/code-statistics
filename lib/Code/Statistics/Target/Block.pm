use strict;
use warnings;

package Code::Statistics::Target::Block;

# ABSTRACT: represents a block in perl code

=head2 find_targets
    Returns the PPI Blocks found in the given file.
=cut

sub find_targets {
    my ( $class, $file ) = @_;
    return $file->ppi->find( 'PPI::Structure::Block' );
}

=head2 supports
    Returns the metrics this target supports.
=cut

sub supports {
    my ( $class, $metric ) = @_;
    my %metrics = ( size => 1, );
    return $metrics{$metric};
}

1;
