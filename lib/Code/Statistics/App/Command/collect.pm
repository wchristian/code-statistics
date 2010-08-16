use strict;
use warnings;

package Code::Statistics::App::Command::collect;
use Code::Statistics::App -command;

sub abstract { 'gather measurements on targets and write them to disk' }

sub opt_spec {
    return (
        [ 'dirs=s' => 'the directories in which to to search for perl code files', { default => '.' } ],
    );
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat( %{$opt} )->collect;
}

1;
