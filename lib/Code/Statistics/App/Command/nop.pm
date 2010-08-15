use strict;
use warnings;

package Code::Statistics::App::Command::nop;
use Code::Statistics::App -command;

sub abstract { 'do nothing' }

sub opt_spec {
    [ 'dirs=s' => 'the directories in which to to search for perl code files', { default => '.' } ],;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat;
}

1;
