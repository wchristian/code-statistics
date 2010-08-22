use strict;
use warnings;

package Code::Statistics::Metric::line;

# ABSTRACT: measures the line number of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 measure
    Returns the line number of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $line = $target->location->[0];
    return $line;
}

1;
