use strict;
use warnings;

package Code::Statistics::Target;

# ABSTRACT: base class for Code::Statistic targets

use 5.004;

use Module::Pluggable search_path => __PACKAGE__, sub_name => 'all';

=head2 find_targets
    Returns an arrayref to a list of targets found in the given file.
    Is called with the target class name and a Code::Statistics::File object.
    This function should be overridden with specific logic to actually retrieve
    the target list.

=cut

sub find_targets {
    my ( $class, $file ) = @_;
    return [];
}

=head2 incompatible_with
    Returns true if the given metric is explicitly not supported by this target.
    Is called with the target class name and a string representing the metric
    identifiers after 'Code::Statistics::Metric::'.
    Default is that all targets are compatible with all metrics.
=cut

sub incompatible_with {
    my ( $class, $target ) = @_;
    return 0;
}

=head2 supports
    Returns true if the given metric is supported by this target.
    Is called with the target class name and a string representing the metric
    identifiers after 'Code::Statistics::Metric::'.
    Default is that all targets are compatible with all metrics.

    Has higher precedence than 'incompatible_with' and should be used to
    incompatibilities set by other metrics.
=cut

sub supports {
    my ( $class, $target ) = @_;
    return 1;
}

1;
