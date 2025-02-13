use strictures 2;

package Code::Statistics::Target::SubAnon;

# ABSTRACT: represents a sub in perl code

use Moose;
extends 'Code::Statistics::Target';

=head2 find_targets
    Returns all PPI::Structure::Block elements found in the given file.
=cut

sub find_targets {
    my ( $class, $file ) = @_;
    return [
        grep {
            my $d = $_->sprevious_sibling;
            $d && $d->isa('PPI::Token::Word') && $d->content eq 'sub';
        } @{ $file->ppi->find('PPI::Structure::Block') || [] }
    ];
}

1;
