use strictures 2;

package Code::Statistics::Metric::ccomp;

# ABSTRACT: measures the cyclomatic complexity of a target

use Moose;
extends 'Code::Statistics::Metric';

use Perl::Critic::Utils::McCabe 'calculate_mccabe_of_sub';

=head2 measure
    Returns the cyclomatic complexity of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;

    my $complexity = calculate_mccabe_of_sub($target);

    return $complexity;
}

1;
