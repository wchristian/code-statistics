use strict;
use warnings;

package Code::Statistics;

use Code::Statistics::Config;
use Code::Statistics::Collector;

use Moose;

has args => (
    is => 'ro',
    isa => 'HashRef',
);

has conf_file => (
    is => 'ro',
    isa => 'Str',
);

has profile => (
    is => 'ro',
    isa => 'Str',
);

has command_config => (
    is => 'ro',
    isa => 'HashRef',
    default => \&build_command_config,
);

sub build_command_config {
    my ( $self ) = @_;
    my $config = Code::Statistics::Config->new( cstat => $self )->assemble;
    return $config;
}

sub collect {
    my ( $self ) = @_;
    Code::Statistics::Collector->new( $self->command_config )->collect;
    return;
}

1;
