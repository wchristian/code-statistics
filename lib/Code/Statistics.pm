use strict;
use warnings;

package Code::Statistics;

# ABSTRACT: collects and reports statistics on perl code

use Code::Statistics::Config;
use Code::Statistics::Collector;
use Code::Statistics::Reporter;

use Moose;
use MooseX::HasDefaults::RO;
use Code::Statistics::SlurpyConstructor;

has config_args => (
    is      => 'ro',
    slurpy  => 1,
);

sub _command_config {
    my ( $self ) = @_;
    my $config = Code::Statistics::Config->new( %{ $self->config_args } )->assemble;
    return $config;
}

=head2 collect
    Dispatches configuration to the statistics collector module.
=cut

sub collect {
    my ( $self ) = @_;
    return Code::Statistics::Collector->new( $self->_command_config )->collect;
}

=head2 report
    Dispatches configuration to the statistics reporter module.
=cut

sub report {
    my ( $self ) = @_;
    return Code::Statistics::Reporter->new( $self->_command_config )->report;
}

1;
