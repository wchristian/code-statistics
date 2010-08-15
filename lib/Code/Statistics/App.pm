use strict;
use warnings;

package Code::Statistics::App;
use App::Cmd::Setup -app;

use Code::Statistics;

sub cstat {
    shift;
    return Code::Statistics->new( @_ );
}

1;
