use strict;
use warnings;

package Code::Statistics::Config;
# ABSTRACT: merges configuration options from various sources

use Moose;
use MooseX::HasDefaults::RO;

use Hash::Merge qw( merge );
use Config::INI::Reader;

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
    my ( $self ) = @_;

    return $self->_merged_conf_from( $self->cstat->conf_file );
}

sub global_config {
    my ( $self ) = @_;

    return $self->_merged_conf_from( $self->cstat->global_conf_file );
}

sub _merged_conf_from {
    my ( $self, $file ) = @_;

    return {} if !-e $file;

    my $conf = Config::INI::Reader->read_file( $file );

    my $merge;
    my @sections = grep { defined } ( '_', $self->cstat->command, $self->_profile_section );
    for( @sections ) {
        next if !$conf->{$_};
        $merge = merge( $conf->{$_}, $merge );
    }

    return $merge;
}

sub _profile_section {
    my ( $self ) = @_;

    my $section = $self->cstat->command;
    $section .= '::'.$self->cstat->profile if $self->cstat->profile;

    return $section;
}

1;
