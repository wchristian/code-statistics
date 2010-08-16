use strict;
use warnings;

package Code::Statistics::Metric::size;
# ABSTRACT: measures the byte size of a target

sub measure {
    my ( $class, $target ) = @_;
    my $size = length $target->content;
    return $size;
}

1;
