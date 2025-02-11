use strictures 2;

package Code::Statistics::App::Command::nop;

# ABSTRACT: does nothing

use Code::Statistics::App -command;

sub abstract { return 'do nothing' }

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat;
}

1;
