#!/usr/bin/perl
use strict;
use warnings;

BEGIN {
    chdir 't' if -d 't';
    use lib '../lib', '../blib/lib', 'lib';
}

use ShellTest;
use Code::Statistics::ConfigTest;

exit $ARGV[0]->runtests if $ARGV[0];

Test::Class->runtests;

exit;
