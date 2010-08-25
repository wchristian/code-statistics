use strict;
use warnings;

package Code::Statistics::Reporter;

# ABSTRACT: creates reports statistics and outputs them

use 5.004;

use Moose;
use MooseX::HasDefaults::RO;
use Code::Statistics::MooseTypes;

use Carp 'confess';
use JSON 'from_json';
use File::Slurp 'read_file';
use List::Util qw( reduce max sum );
use Data::Section -setup;
use Template;
use List::MoreUtils qw( uniq );

has quiet => ( isa => 'Bool' );

has file_ignore => (
    isa    => 'CS::InputList',
    coerce => 1,
    default => sub {[]},
);

has screen_width => ( isa => 'Int', default => 80 );
has min_path_width => ( isa => 'Int', default => 12 );
has table_length => ( isa => 'Int', default => 10 );

=head2 reports
    Creates a report on given code statistics and outputs it in some way.
=cut

sub report {
    my ( $self ) = @_;

    my $stats = from_json read_file('codestat.out');

    $stats->{files} = $self->_strip_ignored_files( @{ $stats->{files} } );
    $stats->{target_types} = $self->_prepare_target_types( $stats->{files} );

    $_->{metrics} = $self->_process_target_type( $_, $stats->{metrics} ) for @{$stats->{target_types}};

    my $output;
    my $tmpl = $self->section_data( 'dos_template' );
    my $tt = Template->new( STRICT => 1 );
    $tt->process(
        $tmpl,
        {
            targets => $stats->{target_types},
            truncate_front => sub {
                my ( $string, $length ) = @_;
                return $string if $length >= length $string;
                return substr $string, 0-$length, $length;
            },
        },
        \$output
    ) or confess $tt->error;

    print $output if !$self->quiet;

    return $output;
}

sub _strip_ignored_files {
    my ( $self, @files ) = @_;

    my @ignore_regexes = grep { $_ } @{ $self->file_ignore };

    for my $re ( @ignore_regexes ) {
        @files = grep { $_->{path} !~ $re } @files;
    }

    return \@files;
}

sub _sort_columns {
    my ( $self, %widths ) = @_;

    my @columns = uniq grep { $widths{$_} } qw( path line col ), keys %widths;

    @columns = map {{ name => $_, width => $widths{$_} }} @columns;

    my $used_width = sum( values %widths ) - $columns[0]{width};
    my $path_width = $self->screen_width - $used_width;
    $columns[0]{width} = max( $self->min_path_width, $path_width );

    for ( @columns ) {
        $_->{printname} = ucfirst "Code::Statistics::Metric::$_->{name}"->short_name;
        $_->{printname} = " $_->{printname}" if $_->{name} ne 'path';
    }

    return \@columns;
}

sub _prepare_target_types {
    my ( $self, $files ) = @_;

    my %target_types;

    for my $file ( @{$files} ) {
        for my $target_type ( keys %{$file->{measurements}} ) {
            for my $target ( @{$file->{measurements}{$target_type}} ) {
                $target->{path} = $file->{path};
                push @{ $target_types{$target_type}->{list} }, $target;
            }
        }
    }

    $target_types{$_}->{type} = $_ for keys %target_types;

    return [ values %target_types ];
}

sub _process_target_type {
    my ( $self, $target_type, $metrics ) = @_;

    my @metric = map $self->_process_metric( $target_type, $_ ), @{$metrics};

    return \@metric;
}

sub _process_metric {
    my ( $self, $target_type, $metric ) = @_;

    return if "Code::Statistics::Metric::$metric"->is_insignificant;
    return if !$target_type->{list}[0];
    return if !exists $target_type->{list}[0]{$metric};

    my @list = reverse sort { $a->{$metric} <=> $b->{$metric} } @{$target_type->{list}};
    my @top = grep { defined } @list[ 0 .. $self->table_length - 1 ];
    @list = grep { defined } @list; # the above autovivifies some entries, this reverses that

    my $metric_data = {
        top => \@top,
        type => $metric,
    };

    $metric_data->{bottom} = $self->_get_bottom( @list );
    $metric_data->{avg} = $self->_calc_average( $metric, @list );
    $metric_data->{widths} = $self->_calc_widths( @{$metric_data->{bottom}}, @top );
    $metric_data->{columns} = $self->_sort_columns( %{ $metric_data->{widths} } );

    return $metric_data;
}

sub _calc_widths {
    my ( $self, $bottom, @list ) = @_;

    my @columns = keys %{$list[0]};

    my %widths;
    for my $col ( @columns ) {
        my @lengths = map { length $_->{$col} } @list, { $col => $col };
        my $max = max @lengths;
        $widths{$col} = $max;
    }

    $_++ for values %widths;

    return \%widths;
}

sub _calc_average {
    my ( $self, $metric, @list ) = @_;

    my $sum = reduce { $a + $b->{$metric} } 0, @list;
    my $average = $sum / @list;

    return $average;
}

sub _get_bottom {
    my ( $self, @list ) = @_;

    return [] if @list < $self->table_length;

    @list = reverse @list;
    my @bottom = @list[ 0 .. $self->table_length - 1 ];
    @list = grep { defined } @list; # the above autovivifies some entries, this reverses that

    my $bottom_size = @list - $self->table_length;
    @bottom = splice @bottom, 0, $bottom_size if $bottom_size < $self->table_length;

    return \@bottom;
}

1;

__DATA__
__[ dos_template ]__

================================================================================
============================ Code Statistics Report ============================
================================================================================

[% FOR target IN targets %]
================================================================================

    [%- " " FILTER repeat( ( 80 - target.type.length ) / 2 ) %][% target.type %]
================================================================================


    [%- "averages" %]

    [%- FOR metric IN target.metrics %]
        [%- metric.type %]: [% metric.avg %]

    [%- END %]

    [%- FOR metric IN target.metrics %]
        [%- NEXT IF metric.avg == 1 or metric.avg == 0 %]

        [%- " " FILTER repeat( ( 80 - metric.type.length ) / 2 ) %][% metric.type %]

        [%- FOR table_mode IN [ 'top', 'bottom' ] %]
            [%- NEXT IF !metric.$table_mode.size -%]
            [%- table_mode %] ten

            [%- FOR column IN metric.columns -%]
                [%- column.printname FILTER format("%-${column.width}s") -%]
            [%- END %]
--------------------------------------------------------------------------------

            [%- FOR line IN metric.$table_mode -%]
                [%- FOR column IN metric.columns -%]
                    [%- IF column.name == 'path' # align to the left and truncate -%]
                        [%- truncate_front( line.${column.name}, column.width ) FILTER format("%-${column.width}s") -%]
                    [%- ELSE # align to the right -%]
                        [%- line.${column.name} FILTER format("%${column.width}s") -%]
                    [%- END -%]
                [%- END %]

            [%- END -%]
--------------------------------------------------------------------------------


        [%- END %]
    [%- END -%]
[%- END -%]
