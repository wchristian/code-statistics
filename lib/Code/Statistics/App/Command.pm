use strict;
use warnings;

package Code::Statistics::App::Command;
# ABSTRACT: base class for commands

use App::Cmd::Setup -command;

sub cstat {
    return shift->app->cstat( @_ );
}

1;
