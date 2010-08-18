use strict;
use warnings;

package Code::Statistics::MooseTypes;

use Moose::Util::TypeConstraints;

subtype 'CS::InputList' => as 'ArrayRef';
coerce 'CS::InputList' => from 'Str' => via {
    my @list = split /;/, $_;
    return \@list;
};

1;
