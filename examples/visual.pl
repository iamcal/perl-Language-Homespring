#!/usr/bin/perl -w

use strict;

use Language::Homespring;
use Language::Homespring::Visualise;

my $code = "bear hatchery Hello,. World ..\n powers";
$code = "Universe of marshy force. Field sense\nshallows the hatchery saying Hello,. World!.\n Hydro. Power spring  sometimes; snowmelt\n      powers   snowmelt always.";
#$code = "Universe bear hatchery Hello. World!.\n Powers   marshy mashsy snowmelt";

my $hs = new Language::Homespring();
$hs->parse($code);

my $vs = new Language::Homespring::Visualise({'interp' => $hs});
print $vs->do();
