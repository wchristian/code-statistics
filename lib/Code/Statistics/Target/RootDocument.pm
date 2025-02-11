use strictures 2;

package Code::Statistics::Target::RootDocument;

# ABSTRACT: represents the root PPI document of a perl file

use Moose;
extends 'Code::Statistics::Target';

=head2 find_targets
    Returns the root PPI document of the given perl file.
=cut

sub find_targets {
    my ( $class, $file ) = @_;
    return [ $file->ppi ];
}

1;
