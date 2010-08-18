use strict;
use warnings;

package ShellTest;

use parent 'Test::Class::TestGroup';

use Test::More;
use Test::Regression;

use Code::Statistics::App;

sub make_fixture : Test(setup) {
    my ( $self ) = @_;

    $self->{basic_collect_args} = [ qw(
        collect
        --relative_paths
        --foreign_paths=Unix
    ) ];

    return;
}

sub basic_collect : Test {
    my ( $self ) = @_;

    local @ARGV = (
        @{$self->{basic_collect_args}},
        qw( --no_dump )
    );

    ok_regression(
        sub { $self->run_codestat_shell_app },
        "data/json/basic_collect.json",
        'returned string matches expected output'
    );

    return;
}

sub run_codestat_shell_app {
    my $result = Code::Statistics::App->run;
    return $result;
}

1;
