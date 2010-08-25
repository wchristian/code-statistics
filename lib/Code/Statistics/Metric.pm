use strict;
use warnings;

package Code::Statistics::Metric;

# ABSTRACT: base class for Code::Statistic metrics

use 5.004;

use Module::Pluggable search_path => __PACKAGE__, require => 1, sub_name => 'all';

=head2 measure
    Returns the metric of the given target.
    Is called with the metric class name and a target object of unspecified
    type.
    This function should be overridden with specific logic to actually retrieve
    the metric data.
=cut

sub measure {
    my ( $class, $target ) = @_;
    return;
}

=head2 incompatible_with
    Returns true if the given target is explicitly not supported by this metric.
    Is called with the metric class name and a string representing the target
    identifiers after 'Code::Statistics::Target::'.
    Default is that all metrics are compatible with all targets.
=cut

sub incompatible_with {
    my ( $class, $target ) = @_;
    return 0;
}

=head2 force_support
    Returns true if the given target is forcibly supported by this metric.
    Is called with the metric class name and a string representing the target
    identifiers after 'Code::Statistics::Target::'.
    Default is that no forcing happens.

    Has higher precedence than 'incompatible_with' and should be used to
    override incompatibilities set by other targets.
=cut

sub force_support {
    my ( $class, $target ) = @_;
    return 0;
}

1;
