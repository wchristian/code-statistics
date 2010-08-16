use strict;
use warnings;

package Code::Statistics::Collector;

use Moose;
use MooseX::HasDefaults::RO;
use Moose::Util::TypeConstraints;

use File::Find::Rule::Perl;
use Code::Statistics::File;
use JSON 'to_json';
use File::Slurp 'write_file';
use Path::Class qw(file);

subtype 'CS::InputList' => as 'ArrayRef';
coerce 'CS::InputList' => from 'Str' => via {
    my @list = split /;/, $_;
    return \@list;
};

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
    default => 'Block',
);

has metrics => (
    isa     => 'CS::InputList',
    coerce  => 1,
    default => 'size',
);

sub collect {
    my ( $self ) = @_;

    require "Code/Statistics/Target/$_.pm" for @{ $self->targets };
    require "Code/Statistics/Metric/$_.pm" for @{ $self->metrics };

    $_->analyze for @{ $self->files };
    $self->_dump_file_measurements;

    return $self;
}

sub _find_files {
    my ( $self ) = @_;
    my @files = File::Find::Rule::Perl->perl_file->in( @{ $self->dirs } );
    @files = map file( $_ )->absolute->stringify, @files;
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
        path    => $path,
        targets => $self->targets,
        metrics => $self->metrics,
    );

    return Code::Statistics::File->new( %params );
}

sub _dump_file_measurements {
    my ( $self ) = @_;

    my @files = map $self->strip_file( $_ ), @{ $self->files };

    write_file( 'codestat.out', to_json( \@files, { pretty => 1 } ) );

    return $self;
}

sub strip_file {
    my ( $self, $file ) = @_;
    my %stripped_file = map { $_ => $file->{$_} } qw( path measurements );
    return \%stripped_file;
}


1;
