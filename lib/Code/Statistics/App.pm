use strict;
use warnings;

package Code::Statistics::App;

use App::Cmd::Setup -app;

use Code::Statistics;

sub global_opt_spec {
    return (
        [ 'conf_file|c=s' => 'path to a config file', { default => '.codestatrc' } ],
        [ 'profile|p=s' => 'a configuration profile', { default => '' } ],
    );
}

sub cstat {
    my ( $self, %command_args ) = @_;

    my %args = (
        conf_file => $self->global_options->conf_file,
        profile => $self->global_options->profile,
        command =>  ($self->get_command( @ARGV ))[0],
    );

    return Code::Statistics->new( %args, args => \%command_args );
}

1;
