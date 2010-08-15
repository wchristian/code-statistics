use strict;
use warnings;

package Code::Statistics::Metric::size;

sub measure {
    my ( $class, $target ) = @_;
    my $size = length $target->content;
    return $size;
}

1;
