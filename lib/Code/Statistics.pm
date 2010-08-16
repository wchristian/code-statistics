use strict;
use warnings;

package Code::Statistics;

use Code::Statistics::Config;
use Code::Statistics::Collector;

use Moose;
use MooseX::HasDefaults::RO;

has args => (
    isa => 'HashRef',
);

has conf_file => (
    isa => 'Str',
);

has profile => (
    isa => 'Str',
);

has command_config => (
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
