#!/usr/bin/perl
use strict;
use warnings;

BEGIN {
    chdir 't' if -d 't';
    use lib '../lib', '../blib/lib', 'lib';
}

use Code::Statistics::ConfigTest;
Code::Statistics::ConfigTest->runtests;
