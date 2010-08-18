use strict;
use warnings;

package Code::Statistics::App::Command::report;

# ABSTRACT: the shell command handler for stat reporting

use Code::Statistics::App -command;

sub abstract { return 'create reports on statistics and output them' }

sub opt_spec {
    my @opts = (
    );
    return @opts;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat( %{$opt} )->report;
}

1;
