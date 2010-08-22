use strict;
use warnings;

package Code::Statistics::Metric::col;

# ABSTRACT: measures the starting column of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 measure
    Returns the starting column of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $line = $target->location->[2];
    return $line;
}

1;
