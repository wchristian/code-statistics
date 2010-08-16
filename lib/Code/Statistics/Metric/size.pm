use strict;
use warnings;

package Code::Statistics::Metric::size;

# ABSTRACT: measures the byte size of a target

=head2 measure
    Returns the byte size of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $size = length $target->content;
    return $size;
}

1;
