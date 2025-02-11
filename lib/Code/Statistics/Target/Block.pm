use strictures 2;

package Code::Statistics::Target::Block;

# ABSTRACT: represents a block in perl code

use Moose;
extends 'Code::Statistics::Target';

=head2 find_targets
    Returns all PPI::Structure::Block elements found in the given file.
=cut

sub find_targets {
    my ( $class, $file ) = @_;
    return $file->ppi->find( 'PPI::Structure::Block' );
}

1;
