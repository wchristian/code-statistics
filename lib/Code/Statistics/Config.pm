use strict;
use warnings;

package Code::Statistics::Config;

use Moose;
use MooseX::HasDefaults::RO;

use Hash::Merge qw( merge );

has cstat => (
    isa => 'Code::Statistics',
    required => 1,
);

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
