use strict;
use warnings;

package Code::Statistics::Metric::size;

# ABSTRACT: measures the byte size of a target

=head2 measure
    Returns the byte size of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;
    my $size = length $target->content;
    return $size;
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
