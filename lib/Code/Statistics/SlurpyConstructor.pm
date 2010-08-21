package Code::Statistics::SlurpyConstructor;

our $VERSION = '0.94';

use Moose;
use Moose::Exporter;
use Moose::Util::MetaRole;
use Code::Statistics::SlurpyConstructor::Role::Object;
use Code::Statistics::SlurpyConstructor::Role::Attribute;

Moose::Exporter->setup_import_methods;

sub init_meta {
    my ( undef, %args ) = @_;

    Moose->init_meta( %args );

    my $for_class = $args{ for_class };

    Moose::Util::MetaRole::apply_metaroles(
        for               => $for_class,
        class_metaroles   => {
            attribute => ['Code::Statistics::SlurpyConstructor::Role::Attribute'],
        },
    );

    Moose::Util::MetaRole::apply_base_class_roles(
        for               => $for_class,
        roles                   => ['Code::Statistics::SlurpyConstructor::Role::Object'],
    );
    return $for_class->meta;
}

no Moose;

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

Code::Statistics::SlurpyConstructor - L<MooseX::SlurpyConstructor> with a temporary deprecation fix

=head1 SEE ALSO

=over 4

=item L<MooseX::SlurpyConstructor>

=back

=cut
