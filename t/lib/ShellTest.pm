use strict;
use warnings;

package ShellTest;

use parent 'Test::Class::TestGroup';

use Test::More;
use Test::Regression;

use Code::Statistics::App;

sub basic_collect : Test {
    local @ARGV = qw( collect --no_dump --relative_paths --foreign_paths=Unix );

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
