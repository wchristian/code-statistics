use strict;
use warnings;

package Code::Statistics::MooseTypes;

# ABSTRACT: provides coercion types for Code::Statistics

use Moose::Util::TypeConstraints;

subtype 'CS::InputList' => as 'ArrayRef';
coerce 'CS::InputList' => from 'Str' => via {
    my @list = split /;/, $_;
    return \@list;
};

1;
