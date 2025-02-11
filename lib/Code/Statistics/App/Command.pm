use strictures 2;

package Code::Statistics::App::Command;

# ABSTRACT: base class for commands

use App::Cmd::Setup -command;

=head2 cstat
    Dispatches to the Code::Statistics object creation routine.
=cut

sub cstat {
    return shift->app->cstat( @_ );
}

1;
