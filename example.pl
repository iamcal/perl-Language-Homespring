#!/usr/bin/perl -w

use strict;

use Language::Homespring;
use Data::Dumper;

my $hs = new Language::Homespring();
$hs->parse("bear hatchery Hello,. World ..\n powers");

print Dumper $hs;
