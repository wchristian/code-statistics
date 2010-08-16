use strict;
use warnings;

package Code::Statistics::App;

use App::Cmd::Setup -app;

use Code::Statistics;

sub global_opt_spec {
    return (
        [ 'conf_file|c=s' => 'path to a config file', { default => '.codestatrc' } ],
    );
}

sub cstat {
    my ( $self, %command_args ) = @_;

    my %args = (
        conf_file => $self->global_options->conf_file,
    );

    return Code::Statistics->new( %args, args => \%command_args );
}

1;
