use strictures 2;

package Code::Statistics::App;

# ABSTRACT: handles global command configuration and cstat instantiation

use App::Cmd::Setup -app;

use Code::Statistics;

sub global_opt_spec {
    my @opts             = (
        [ 'global_conf_file|g=s' => 'path to the global config file' ],
        [ 'conf_file|c=s'        => 'path to the local config file' ],
        [ 'profile|p=s'          => 'a configuration profile' ],
    );
    return @opts;
}

=head2 cstat
    Creates a Code::Statistics object with the given commandline args.
=cut

sub cstat {
    my ( $self, %command_args ) = @_;

    my %args = ( %{ $self->global_options }, command => ( $self->get_command( @ARGV ) )[0], );

    return Code::Statistics->new( %args, args => \%command_args );
}

1;
