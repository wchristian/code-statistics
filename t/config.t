#!/usr/bin/perl
use strict;
use warnings;

BEGIN {
    chdir 't' if -d 't';
    use lib '../lib', '../blib/lib', 'lib';
}

use ShellTest;
use Code::Statistics::ConfigTest;

Test::Class->runtests;
