use strict;
use warnings;

package Code::Statistics::Target::nop;

# ABSTRACT: represents nothing

use Moose;
extends 'Code::Statistics::Target';

=head2 find_targets
    Returns nothing.
=cut

sub find_targets {}

1;
