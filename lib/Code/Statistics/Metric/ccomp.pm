use strict;
use warnings;

package Code::Statistics::Metric::ccomp;

# ABSTRACT: measures the cyclomatic complexity of a target

use Moose;
extends 'Code::Statistics::Metric';

use Perl::Metrics::Simple::Analysis::File;

=head2 measure
    Returns the cyclomatic complexity of the given target.
=cut

sub measure {
    my ( $class, $target ) = @_;

    # not sure whether this is the right way to go, but sub-classing looks like
    # decidedly more work, to do the same exact thing
    my $s = bless {}, 'Perl::Metrics::Simple::Analysis::File';

    # setup default lists for keywords and operators
    %Perl::Metrics::Simple::Analysis::File::LOGIC_KEYWORDS = map { $_ => 1 } @Perl::Metrics::Simple::Analysis::File::DEFAULT_LOGIC_KEYWORDS;
    %Perl::Metrics::Simple::Analysis::File::LOGIC_OPERATORS = map { $_ => 1 } @Perl::Metrics::Simple::Analysis::File::DEFAULT_LOGIC_OPERATORS;

    my $complexity = $s->measure_complexity( $target );

    return $complexity;
}

1;
