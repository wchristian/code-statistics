use strictures 2;

package Code::Statistics::App::Command::collect;

# ABSTRACT: the shell command handler for stat collection

use Code::Statistics::App -command;

sub abstract { return 'gather measurements on targets and write them to disk' }

sub opt_spec {
    my ( $self ) = @_;
    my @opts = (
        [ 'dirs=s' => 'the directories in which to to search for perl code files' ],
        [ 'no_dump' => 'prevents writing of measurements to disk' ],
        [ 'relative_paths' => 'switches file paths in dump from absolute to relative format' ],
        [ 'foreign_paths=s' => 'file paths in dump are printed in indicated system format; see File::Spec' ],
        [ 'targets=s' => 'specifies targets that will be looked for inside of files; see C::S::Target::*' ],
        [ 'metrics=s' => 'specifies metrics that be tried to be measured on targets; see C::S::Metric::*' ],
    );
    return @opts;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    return $self->cstat( %{$opt} )->collect;
}

1;
