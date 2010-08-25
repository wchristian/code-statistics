use strict;
use warnings;

package Code::Statistics;

# ABSTRACT: collects and reports statistics on perl code

=head1 SYNOPSIS

On a terminal:

    # collect statistics on the current directory and sub-directories,
    # then store results in codestat.out as json
    codestat collect

    # compile a report from codestat.out and print to the terminal
    codestat report

=cut

=head1 DESCRIPTION

This is a framework to collect various metrics on a codebase and report them
in a summarized manner. It is meant to be as extensible as possible.

The current collection workflows are as follow:

=head2 Collection

All files in the search path are collected.

Target constructs as defined by modules living under Code::Statistics::Target:: are collected for all files.

Metrics as defined by modules living under Code::Statistics::Metric:: are collected for all targets.

All data is dumped as json to C<codestat.out>.

=head2 Reporting

Data from the local C<codestat.out> is read.

Data is grouped by target and for each target type the following is printed:

Averages of all non-location metrics.

Tables with the top ten and bottom ten for each significant metric.

=cut

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

=head1 SUBROUTINES/METHODS

This module acts mostly as a dispatcher and collects configuration data,
then forwards it to actual action modules. These are the methods it
currently provides.

=cut

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

=head1 TODO

Possibly elevate metrics to objects to allow parametrized metrics during
collection. Not sure if i want this or whether making more generic metrics is a
better idea. http://gist.github.com/549132

=head1 SEE ALSO

PPI::Tester

=cut

1;
