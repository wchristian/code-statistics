use strict;
use warnings;

package Code::Statistics::Config;

use Moose;

has cstat => (
    is => 'ro',
    isa => 'Code::Statistics',
    required => 1,
);

sub assemble {
    my ( $self ) = @_;

    my $config = {};

    $self->copy( $self->global_config, $config );
    $self->copy( $self->local_config, $config );
    $self->copy( $self->cstat->args, $config );

    return $config;
}

sub copy {
    my ( $self, $source, $target ) = @_;
    $target->{$_} = $source->{$_} for keys %{$source};
    return;
}

sub local_config {
    return {};
}

sub global_config {
    return {};
}

1;
