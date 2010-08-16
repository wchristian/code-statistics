use strict;
use warnings;

package Code::Statistics::App::Command::nop;
# ABSTRACT: does nothing

use Code::Statistics::App -command;

sub abstract { return 'do nothing' }

sub opt_spec {
    return (
        [ 'dirs=s' => 'the directories in which to to search for perl code files', { default => '.' } ],
    );
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat;
}

1;
