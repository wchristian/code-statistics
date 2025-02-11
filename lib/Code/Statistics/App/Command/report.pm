use strictures 2;

package Code::Statistics::App::Command::report;

# ABSTRACT: the shell command handler for stat reporting

use Code::Statistics::App -command;

sub abstract { return 'create reports on statistics and output them' }

sub opt_spec {
    my @opts = (
        [ 'quiet' => 'prevents writing of report to screen' ],
        [ 'file_ignore=s' => 'list of regexes matching files that should be ignored in reporting ' ],
    );
    return @opts;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat( %{$opt} )->report;
}

1;
