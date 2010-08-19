use strict;
use warnings;

package Code::Statistics::Target::RootDocument;

# ABSTRACT: represents the root PPI document of a perl file

=head2 find_targets
    Returns the root PPI document of the given perl file.
=cut

sub find_targets {
    my ( $class, $file ) = @_;
    return [ $file->ppi ];
}

=head2 supports
    Returns the metrics this target supports.
=cut

sub supports {
    my ( $class, $metric ) = @_;
    my %metrics = ( size => 1, line => 1 );
    return $metrics{$metric};
}

1;
