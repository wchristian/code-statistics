use strict;
use warnings;

package Code::Statistics::Reporter;

# ABSTRACT: creates reports statistics and outputs them

use Moose;
use MooseX::HasDefaults::RO;
use Code::Statistics::MooseTypes;

=head2 reports
    Creates a report on given code statistics and outputs it in some way.
=cut

sub report {
    my ( $self ) = @_;

    return $self;
}

1;
