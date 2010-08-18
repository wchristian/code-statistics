use strict;
use warnings;

package Code::Statistics::Metric::line;

# ABSTRACT: measures the line number of a target

=head2 measure
    Returns the line number of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $line = $target->location->[0];
    return $line;
}

=head2 supports
    Returns the targets this metric supports.
=cut

sub supports {
    my ( $class, $target ) = @_;
    my %targets = ( 'Block' => 1, );
    return $targets{$target};
}

1;
