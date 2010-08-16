use strict;
use warnings;

package Code::Statistics::ConfigTest;

use lib '../..';

use parent 'Test::Class::TestGroup';

use Test::More;
use Test::MockObject;

use Code::Statistics::Config;

sub make_fixtures : Test(setup) {
    my ( $self ) = @_;

    my $cstat = Test::MockObject->new;
    $cstat->set_isa('Code::Statistics');
    $cstat->set_always( 'global_conf_file', 'data/config/globalcodestatrc' );
    $cstat->set_always( 'conf_file', 'data/config/codestatrc' );
    $cstat->set_always( 'command', 'collect' );
    $cstat->set_always( 'profile', 'test' );
    $cstat->set_always( 'args', { overridden_by_args => 7 } );

    $self->{cstat} = $cstat;

    return;
}

sub overrides_basic : TestGroup(configuration overrides work if all config inputs are present and active) {
    my ( $self ) = @_;

    my $cstat = $self->{cstat};
    $cstat->set_always( 'profile', 'test' );

    my $config = Code::Statistics::Config->new( cstat => $cstat )->assemble;

    my %options = (
        global_setting => 1,
        overridden_by_command => 2,
        overridden_by_profile => 3,
        overridden_by_local => 4,
        overridden_by_local_command => 5,
        overridden_by_local_profile => 6,
        overridden_by_args => 7,
    );

    is( $config->{$_}, $options{$_}, "$_ works" ) for keys %options;

    return;
}

sub overrides_no_profile : TestGroup(configuration overrides work if all no profile is given) {
    my ( $self ) = @_;

    my $cstat = $self->{cstat};
    $cstat->set_always( 'profile', undef );

    my $config = Code::Statistics::Config->new( cstat => $cstat )->assemble;

    my %options = (
        global_setting => 1,
        overridden_by_command => 2,
        overridden_by_profile => 2,
        overridden_by_local => 4,
        overridden_by_local_command => 5,
        overridden_by_local_profile => 5,
        overridden_by_args => 7,
    );

    is( $config->{$_}, $options{$_}, "$_ works" ) for keys %options;

    return;
}

1;
