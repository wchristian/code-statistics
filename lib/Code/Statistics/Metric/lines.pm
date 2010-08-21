use strict;
use warnings;

package Code::Statistics::Metric::lines;

# ABSTRACT: measures the line count of a target

=head2 measure
    Returns the line count of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my @lines = split( '\n', $target->content );
    return scalar @lines;
}

=head2 supports
    Returns the targets this metric supports.
=cut

sub supports {
    my ( $class, $target ) = @_;
    my %targets = (
        'Block' => 1,
        'RootDocument' => 1,
    );
    return $targets{$target};
}

1;
