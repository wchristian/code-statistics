use strict;
use warnings;

package Code::Statistics::Reporter;

# ABSTRACT: creates reports statistics and outputs them

use Moose;
use MooseX::HasDefaults::RO;
use Code::Statistics::MooseTypes;

use JSON 'from_json';
use File::Slurp 'read_file';
use List::Util qw( reduce max sum );
use Data::Section -setup;
use Template;

=head2 reports
    Creates a report on given code statistics and outputs it in some way.
=cut

sub report {
    my ( $self ) = @_;

    my $stats = from_json read_file('codestat.out');

    $stats->{target_types} = $self->prepare_target_types( $stats->{files} );

    $_->{metrics} = $self->process_target_type( $_, $stats->{metrics} ) for @{$stats->{target_types}};

    my @columns = $self->build_template( $stats );

    my $output;
    my $tmpl = $self->section_data( 'dos_template' );
    my $tt = Template->new;
    $tt->process(
        $tmpl,
        {
            columns => \@columns,
            targets => $stats->{target_types},
            truncate_front => sub {
                return $_[0] if length($_[0]) <= $_[1];
                return substr( $_[0], -1 * $_[1], $_[1] )
            },
        },
        \$output
    ) or die $tt->error;

    print $output;

    return $self;
}

sub build_template {
    my ( $self, $stats ) = @_;

    my %metrics = map { $_ => 1 } 'path', @{$stats->{metrics}};

    my @columns = grep { $metrics{$_} } qw( path line );
    delete $metrics{$_} for @columns;

    @columns = ( @columns, keys %metrics );

    @columns = map {{ name => $_, width => 10 }} @columns;

    for ( @columns ) {
        $_->{printname} = ucfirst $_->{name};
        $_->{printname} = " $_->{printname}" if $_->{name} ne 'path';
    }

    return @columns;
}

sub prepare_target_types {
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

sub process_target_type {
    my ( $self, $target_type, $metrics ) = @_;

    my @metric = map $self->process_metric( $target_type, $_ ), @{$metrics};

    return \@metric;
}

sub process_metric {
    my ( $self, $target_type, $metric ) = @_;

    return if $self->is_only_loc_metric( $metric );
    return if !$target_type->{list}[0];
    return if !$target_type->{list}[0]{$metric};

    my @list = sort { $b->{$metric} <=> $a->{$metric} } @{$target_type->{list}};
    my @top = grep { defined } @list[0 .. 9];
    @list = grep { defined } @list; # the above autovivifies some entries, this reverses that

    my $metric_data = {
        top => \@top,
        type => $metric,
    };

    $metric_data->{bottom} = $self->get_bottom( @list ) if @list > 10;
    $metric_data->{avg} = $self->calc_average( $metric, @list );

    $metric_data->{widths} = $self->calc_widths( $metric_data->{bottom}, @top );

    return $metric_data;
}

sub calc_widths {
    my ( $self, $bottom, @list ) = @_;

    @list = ( @list, @{$bottom} ) if $bottom;

    my @columns = keys %{$list[0]};

    my %widths;
    for my $col ( @columns ) {
        my @lengths = map { length $_->{$col} } @list, { $col => $col };
        my $max = max @lengths;
        $widths{$col} = $max;
    }

    $_++ for values %widths;
    my $used_width = sum( values %widths ) - $widths{path};
    my $path_width = 80-$used_width;
    $widths{path} = max( 12, $path_width );

    return \%widths;
}

sub is_only_loc_metric {
    my ( $self, $metric ) = @_;
    return 1 if $metric eq 'line';
    return 0;
}

sub calc_average {
    my ( $self, $metric, @list ) = @_;

    my $sum = reduce { $a + $b->{$metric} } 0, @list;
    my $average = $sum / @list;

    return $average;
}

sub get_bottom {
    my ( $self, @list ) = @_;

    @list = reverse @list;
    my @bottom = @list[ 0 .. 9 ];
    @list = grep { defined } @list; # the above autovivifies some entries, this reverses that

    my $bottom_size = @list - 10;
    @bottom = splice( @bottom, 0, $bottom_size ) if $bottom_size < 10;

    return \@bottom;
}

1;

__DATA__
__[ dos_template ]__

[% FOR target IN targets %]

    [%- target.type %]

    [%- "averages" %]

    [%- FOR metric IN target.metrics %]
        [%- metric.type %]: [% metric.avg %]

    [%- END %]

    [%- FOR table_mode IN [ 'top', 'bottom' ] %]
        [%- FOR metric IN target.metrics %]
            [%- table_mode %] ten

            [%- FOR column IN columns -%]
                [%- width = metric.widths.${column.name} -%]
                [%- column.printname FILTER format("%-${width}s") -%]
            [%- END %]

            [%- FOR line IN metric.$table_mode -%]
                [%- FOR column IN columns -%]
                    [%- width = metric.widths.${column.name} -%]
                    [%- IF column.name == 'path' -%]
                        [%- truncate_front( line.${column.name}, width ) FILTER format("%-${width}s") -%]
                    [%- ELSE -%]
                        [%- line.${column.name} FILTER format("%${width}s") -%]
                    [%- END -%]
                [%- END %]

            [%- END %]

        [%- END %]
    [%- END -%]

[%- END -%]
