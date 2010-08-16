use strict;
use warnings;

package Code::Statistics;

use Code::Statistics::Collector;

use Moose;

has args => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { {} },
);

sub collect {
    my ( $self ) = @_;
    Code::Statistics::Collector->new( $self->args )->collect;
}

1;
