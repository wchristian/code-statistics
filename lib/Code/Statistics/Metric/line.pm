use strictures 2;

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

=head2 is_insignificant
    Returns true if the metric is considered statistically insignificant.

    Returns false for this class, since it only identifies the location of a
    target.
=cut

sub is_insignificant {
    my ( $class ) = @_;
    return 1;
}

1;
