package Code::Statistics::SlurpyConstructor::Role::Object;

use Moose::Role;

around new => sub {
    my ( $orig, $class, @incoming ) = @_;

    my $args;
    if ( scalar @incoming == 1 and ref $incoming[ 0 ] eq 'HASH' ) {
        $args = shift @incoming;
    } else {
        $args = { @incoming };
    }

    my @init_args =
      grep { defined }
      map { $_->init_arg }
      $class->meta->get_all_attributes;

    # all args initially
    my %slurpy_args = %$args;

    # remove any that are defined as init_args for any attributes
    delete @slurpy_args{ @init_args };

    my $slurpy_attr = find_slurpy_attr( $class );
    my $init_arg = $slurpy_attr->init_arg;
    my %init_args = map filter_final_init_arg( $args, $init_arg, $_ ), @init_args;

    if ( defined $init_arg and defined $init_args{ $init_arg } ) {
        my $name = $slurpy_attr->name;
        die( "Can't assign to '$init_arg', as it's slurpy init_arg for attribute '$name'" );
    }

    my $self = $class->$orig({
        %init_args
    });

    # go behind the scenes to set the value, in case the slurpy attr
    # is marked read-only.
    $slurpy_attr->set_value( $self, \%slurpy_args );

    return $self;
};

sub filter_final_init_arg {
    my ( $args, $slurpy_name, $arg_name ) = @_;

    return if !exists $args->{$arg_name} and $slurpy_name ne $arg_name;

    return ( $arg_name => $args->{$arg_name} );
}

sub find_slurpy_attr {
    my ( $class ) = @_;

    # find all attributes marked slurpy
    my @slurpy_attrs =
        grep { $_->slurpy }
        $class->meta->get_all_attributes;

    # and ensure that we have one
    my $slurpy_attr = shift @slurpy_attrs;

    Moose->throw_error( "No parameters marked 'slurpy', do you need this module?" ) if !defined $slurpy_attr;
    die "Something strange here - There should never be more than a single slurpy argument, please report a bug, with test case" if @slurpy_attrs;

    return $slurpy_attr;
}

no Moose::Role;

1;

__END__

=pod

=head1 NAME

Code::Statistics::SlurpyConstructor::Role::Object - Internal class for
L<Code::Statistics::SlurpyConstructor>.

=cut
