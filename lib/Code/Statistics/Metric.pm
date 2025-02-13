use strictures 2;

package Code::Statistics::Metric;

# ABSTRACT: base class for Code::Statistic metrics

use 5.004;

use Module::Pluggable
  search_path => __PACKAGE__,
  require     => 1,
  sub_name    => 'all';

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

=head2 short_name
    Allows a metric to return a short name, which can be used by shell report
    builders for example.
    Default is the class name, with 'Code::Statistics::Metric::' stripped out.
    Override to customize.
=cut

sub short_name {
    my ($class) = @_;
    $class =~ s/Code::Statistics::Metric:://;
    return $class;
}

=head2 is_insignificant
    Returns true if the metric is considered statistically insignificant.
    Default is false.
=cut

sub is_insignificant {
    my ($class) = @_;
    return 0;
}

=head2 import

    Custom import to ensure that all possible metric plugins are loaded when
    this module is loaded.

=cut

sub import {
    Code::Statistics::Metric->all;
    return;
}

1;
