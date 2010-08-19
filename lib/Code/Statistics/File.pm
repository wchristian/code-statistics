use strict;
use warnings;

package Code::Statistics::File;

# ABSTRACT: loads a file, searches for targets in it and measures their metrics

use Moose;
use MooseX::HasDefaults::RO;

use PPI::Document;
use Path::Class qw(file);

has path => (
    isa      => 'Str',
    required => 1,
);

has collector => (
    isa      => 'Code::Statistics::Collector',
    required => 1,
);

has ppi => (
    isa     => 'PPI::Document',
    lazy    => 1,
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
    $self->_format_file_path;
    $self->collector->progress_bar->increment;

    return $self;
}

sub _format_file_path {
    my ( $self ) = @_;
    my $path = file( $self->path );
    my $collector = $self->collector;

    $path = $path->relative if $collector->relative_paths;
    $path = $path->absolute if !$collector->relative_paths;

    $path = $path->as_foreign( $collector->foreign_paths ) if $collector->foreign_paths;

    $self->{path} = $path->stringify;
    return $self;
}

sub _process_target_class {
    my ( $self, $target_type ) = @_;

    my @supported_metrics = grep $self->_are_compatible( $target_type, $_ ), @{ $self->collector->metrics };
    return if !@supported_metrics;

    my $targets = "Code::Statistics::Target::$target_type"->find_targets( $self );
    return if !$targets;

    my @measurements = map _measure_target( $_, @supported_metrics ), @{$targets};
    $self->{measurements}{$target_type} = \@measurements;

    return $self;
}

sub _are_compatible {
    my ( $self, $target, $metric ) = @_;
    return 1 if "Code::Statistics::Target::$target"->supports( $metric );
    return 1 if "Code::Statistics::Metric::$metric"->supports( $target );
    return 0;
}

sub _measure_target {
    my ( $target, @metrics ) = @_;

    my %measurement;
    $measurement{$_} = "Code::Statistics::Metric::$_"->measure( $target ) for @metrics;

    return \%measurement;
}

1;
