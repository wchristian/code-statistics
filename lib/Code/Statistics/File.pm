use strict;
use warnings;

package Code::Statistics::File;
# ABSTRACT: loads a file, searches for targets in it and measures their metrics

use Moose;
use MooseX::HasDefaults::RO;

use PPI::Document;

has path => (
    isa      => 'Str',
    required => 1,
);

has collector => (
    isa => 'Code::Statistics::Collector',
    required => 1,
);

has ppi => (
    isa => 'PPI::Document',
    lazy => 1,
    default => sub {
        PPI::Document->new( $_[0]->path );
    },
);

=head2 analyze
    Finds targets in the given file and collects the metrics on those.
=cut
sub analyze {
    my ( $self ) = @_;

    $self->_process_target_class( $_ ) for @{ $self->collector->targets };
    $self->collector->progress_bar->increment;

    return $self;
}

sub _process_target_class {
    my ( $self, $target_type ) = @_;

    my ( $ppi_class, @supported_metrics ) = $self->_get_target_class_data( $target_type );
    return if !@supported_metrics;

    my $targets = $self->ppi->find( $ppi_class );
    return if !$targets;

    my @measurements = map _measure_target( $_, @supported_metrics ), @{$targets};
    $self->{measurements}{$target_type} = \@measurements;

    return $self;
}

sub _get_target_class_data {
    my ( $self, $target_type ) = @_;

    my $package           = "Code::Statistics::Target::$target_type";
    my @supported_metrics = grep { $package->supports( $_ ) } @{ $self->collector->metrics };
    my $ppi_class         = $package->class;

    return ( $ppi_class, @supported_metrics );
}

sub _measure_target {
    my ( $target, @metrics ) = @_;

    my %measurement;
    $measurement{$_} = "Code::Statistics::Metric::$_"->measure( $target ) for @metrics;

    return \%measurement;
}

1;
