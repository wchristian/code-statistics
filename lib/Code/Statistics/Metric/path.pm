use strictures 2;

package Code::Statistics::Metric::path;

# ABSTRACT: measures the starting column of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 incompatible_with
    Returns true if the given target is explicitly not supported by this metric.

    Returns false for this class, since it is never measured and just serves as a placeholder for the path column.
=cut

sub incompatible_with {
    my ( $class, $target ) = @_;
    return 1;
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
