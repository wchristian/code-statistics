use strict;
use warnings;

package Code::Statistics::App::Command::collect;

# ABSTRACT: the shell command handler for stat collection

use Code::Statistics::App -command;

sub abstract { return 'gather measurements on targets and write them to disk' }

sub opt_spec {
    my @opts = (
        [ 'dirs=s' => 'the directories in which to to search for perl code files', { default => '.' } ],
        [ 'no_dump' => 'prevents writing of measurements to disk' ],
        [ 'relative_paths' => 'switches file paths in dump from absolute to relative format' ],
        [ 'foreign_paths=s' => 'switches file paths in dump from native to indicated system format; see File::Spec for options', { default => '' } ],
        [ 'targets=s' => 'specifies targets that will be looked for inside of files; see C::S::Target::*', { default => 'Block' } ],
        [ 'metrics=s' => 'specifies metrics that be tried to be measured on targets; see C::S::Metric::*', { default => 'size' } ],
    );
    return @opts;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat( %{$opt} )->collect;
}

1;
