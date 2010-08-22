use strict;
use warnings;

package Code::Statistics::Metric::sdepth;

# ABSTRACT: measures the scope depth of a target

use Moose;
extends 'Code::Statistics::Metric';

=head2 measure
    Returns the scope depth of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;

    my @parent_list = $class->get_parents( $target );

    my $depth = @parent_list - 1;

    return $depth;
}

sub get_parents {
    my ( $class, $target ) = @_;
    my $parent = $target->parent;
    return $target if !$parent;
    return ( $target, $class->get_parents( $parent ) );
}

1;
