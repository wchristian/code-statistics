use strictures 2;

package Code::Statistics::Metric::size;

# ABSTRACT: measures the byte size of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 measure
    Returns the byte size of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $size = length $target->content;
    return $size;
}

1;
