use strict;
use warnings;

package Code::Statistics::Collector;

# ABSTRACT: collects statistics and dumps them to json

use Moose;
use MooseX::HasDefaults::RO;
use Code::Statistics::MooseTypes;
use Code::Statistics::SlurpyConstructor;

use File::Find::Rule::Perl;
use Code::Statistics::File;
use JSON 'to_json';
use File::Slurp 'write_file';
use Term::ProgressBar::Simple;

has no_dump => ( isa => 'Bool' );

has dirs => (
    isa    => 'CS::InputList',
    coerce => 1,
);

has files => (
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {
        return $_[0]->_prepare_files;
    },
);

has targets => (
    isa     => 'CS::InputList',
    coerce  => 1,
);

has metrics => (
    isa     => 'CS::InputList',
    coerce  => 1,
);

has progress_bar => (
    isa     => 'Term::ProgressBar::Simple',
    lazy    => 1,
    default => sub {
        my $params = { name => 'Files', ETA => 'linear', max_update_rate => '0.1' };
        $params->{count} = @{ $_[0]->files };
        return Term::ProgressBar::Simple->new( $params );
    },
);

has command_args => (
    is      => 'ro',
    slurpy  => 1,
);

=head2 collect
    Locates files to collect statistics on, collects them and dumps them to
    JSON.
=cut

sub collect {
    my ( $self ) = @_;

    require "Code/Statistics/Target/$_.pm" for @{ $self->targets };    ## no critic qw( RequireBarewordIncludes )
    require "Code/Statistics/Metric/$_.pm" for @{ $self->metrics };    ## no critic qw( RequireBarewordIncludes )

    $_->analyze for @{ $self->files };

    my $json = $self->_measurements_as_json;
    $self->_dump_file_measurements( $json );

    return $json;
}

sub _find_files {
    my ( $self ) = @_;
    my @files = File::Find::Rule::Perl->perl_file->in( @{ $self->dirs } );
    return @files;
}

sub _prepare_files {
    my ( $self ) = @_;
    my @files = $self->_find_files;
    @files = map $self->_prepare_file( $_ ), @files;
    return \@files;
}

sub _prepare_file {
    my ( $self, $path ) = @_;

    my %params = (
        path      => $path,
        targets   => $self->targets,
        metrics   => $self->metrics,
        progress => sub { $self->progress_bar->increment },
    );

    return Code::Statistics::File->new( %params, %{$self->command_args} );
}

sub _dump_file_measurements {
    my ( $self, $text ) = @_;
    return if $self->no_dump;

    write_file( 'codestat.out', $text );

    return $self;
}

sub _measurements_as_json {
    my ( $self ) = @_;

    my @files = map $self->_strip_file( $_ ), @{ $self->files };

    my $json = to_json( \@files, { pretty => 1 } );

    return $json;
}

sub _strip_file {
    my ( $self, $file ) = @_;
    my %stripped_file = map { $_ => $file->{$_} } qw( path measurements );
    return \%stripped_file;
}

1;
