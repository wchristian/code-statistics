use strict;
use warnings;

package Code::Statistics::File;

use Moose;

use PPI::Document;

has path => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has targets => (
    is  => 'ro',
    isa => 'ArrayRef',
);

has metrics => (
    is  => 'ro',
    isa => 'ArrayRef',
);

sub ppi {
    return PPI::Document->new( $_[0]->path );
}

sub analyze {
    my ( $self ) = @_;

    my $ppi = $self->ppi;
    $self->_process_target_class( $ppi, $_ ) for @{ $self->targets };

    return $self;
}

sub _process_target_class {
    my ( $self, $ppi, $target_type ) = @_;

    my ( $ppi_class, @supported_metrics ) = $self->_get_target_class_data( $target_type );
    return if !@supported_metrics;

    my $targets = $ppi->find( $ppi_class );
    return if !$targets;

    my @measurements = map _measure_target( $_, @supported_metrics ), @{$targets};
    $self->{measurements}{$target_type} = \@measurements;

    return $self;
}

sub _get_target_class_data {
    my ( $self, $target_type ) = @_;

    my $package           = "Code::Statistics::Target::$target_type";
    my @supported_metrics = grep { $package->supports( $_ ) } @{ $self->metrics };
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
