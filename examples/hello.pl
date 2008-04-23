#!/usr/bin/perl -w

use strict;

use Language::Homespring;
use Data::Dumper;

my $code = "bear hatchery Hello,. World ..\n powers";

my $hs = new Language::Homespring();
$hs->parse($code);

for (1..10){
	print "------------------------------------\n";
	print $hs->tick();
}

#print Dumper($hs->{root_node}, $hs->{salmon}, $hs->{new_salmon});
