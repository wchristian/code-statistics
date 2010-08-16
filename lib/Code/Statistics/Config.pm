use strict;
use warnings;

package Code::Statistics::Config;
# ABSTRACT: merges configuration options from various sources

use Moose;
use MooseX::HasDefaults::RO;

use Hash::Merge qw( merge );

has cstat => (
    isa => 'Code::Statistics',
    required => 1,
);

=head2 assemble
    Builds the command-related configuration hash. The hash contains all config
    options from the global config file, local file and command line arguments.
=cut
sub assemble {
    my ( $self ) = @_;

    my $config = {};

    $config = merge( $self->global_config, $config );
    $config = merge( $self->local_config, $config );
    $config = merge( $self->cstat->args, $config );

    return $config;
}

sub local_config {
    return {};
}

sub global_config {
    return {};
}

1;
