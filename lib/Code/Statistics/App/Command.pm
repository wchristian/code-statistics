use strict;
use warnings;

package Code::Statistics::App::Command;
use App::Cmd::Setup -command;

sub cstat {
    return shift->app->cstat( @_ );
}

1;
