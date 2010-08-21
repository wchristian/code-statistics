use strict;
use warnings;

package Code::Statistics::Metric::col;

# ABSTRACT: measures the starting column of a target

=head2 measure
    Returns the starting column of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $line = $target->location->[2];
    return $line;
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
