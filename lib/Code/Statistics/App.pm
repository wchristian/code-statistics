use strict;
use warnings;

package Code::Statistics::App;

use App::Cmd::Setup -app;

use Code::Statistics;

sub cstat {
    my ( $self, %command_args ) = @_;

    return Code::Statistics->new( args => \%command_args );
}

1;
