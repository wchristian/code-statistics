use strict;
use warnings;

package Code::Statistics::Metric::lines;

# ABSTRACT: measures the line count of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 measure
    Returns the line count of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my @lines = split( '\n', $target->content );
    return scalar @lines;
}

1;
