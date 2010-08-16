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

has conf_file => (
    is => 'ro',
    isa => 'Str',
);

sub collect {
    my ( $self ) = @_;
    Code::Statistics::Collector->new( $self->args )->collect;
}

1;
