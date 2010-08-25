use strict;
use warnings;

package Code::Statistics::Metric::deviation;

# ABSTRACT: measures the starting column of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 incompatible_with
    Returns true if the given target is explicitly not supported by this metric.

    Returns false for this class, since it is never measured and just serves as
    a placeholder for the deviation column, which can be calculated by the
    reporter.
=cut

sub incompatible_with {
    my ( $class, $target ) = @_;
    return 1;
}

=head2 is_insignificant
    Returns true if the metric is considered statistically insignificant.

    Returns false for this class, since it is calculated from other significant
    statistics.
=cut

sub is_insignificant {
    my ( $class ) = @_;
    return 1;
}

=head2 short_name
    Allows a metric to return a short name, which can be used by shell report
    builders for example.
    This metric defines the short name "Dev.".
=cut

sub short_name {
    my ( $class ) = @_;
    return "Dev.";
}

1;
