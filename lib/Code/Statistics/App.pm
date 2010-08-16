use strict;
use warnings;

package Code::Statistics::App;

use App::Cmd::Setup -app;

use Code::Statistics;

use File::HomeDir;
use Path::Class qw(file);

sub global_opt_spec {
    my $conf_file = '.codestatrc';
    my $global_conf_file = file( File::HomeDir->my_home, $conf_file )->stringify;
    return (
        [ 'global_conf_file|g=s' => 'path to the global config file', { default => $global_conf_file } ],
        [ 'conf_file|c=s' => 'path to the local config file', { default => $conf_file } ],
        [ 'profile|p=s' => 'a configuration profile' ],
    );
}

sub cstat {
    my ( $self, %command_args ) = @_;
    
    my %args = (
        %{ $self->global_options },
        command =>  ($self->get_command( @ARGV ))[0],
    );

    return Code::Statistics->new( %args, args => \%command_args );
}

1;
