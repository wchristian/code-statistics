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

sub basic_collect : TestGroup {
    my ( $self ) = @_;

    local @ARGV = (
        @{$self->{basic_collect_args}},
        qw( --no_dump )
    );

    $self->check_codestat_shell_app_against( "data/json/basic_collect.json" );

    return;
}

sub check_codestat_shell_app_against {
    my ( $self, $file ) = @_;

    ok_regression(
        sub {
            my $result = Code::Statistics::App->run;
            return $result;
        },
        $file,
        'returned string matches expected output'
    );

    return;
}


1;
