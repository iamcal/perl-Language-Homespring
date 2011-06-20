#!/usr/bin/perl -w

use strict;

use Language::Homespring;
use Data::Dumper;

my $code = "bear hatchery Hello,. World ..\n powers";

######################################################

$code = <<END;
Universe of marshy force. Field sense
shallows the hatchery saying Hello,. World!.
 Hydro. Power spring  sometimes; snowmelt
      powers   snowmelt always.
END

######################################################

$code = <<END;
Universe marshy now. The marshy stuff evaporates downstream. Sense rapids
upstream. Killing. Device downstream. Sense shallows and say Hi,. 
   That powers the     force. Field sense shallows hatchery power.
Hi .. What's. your. name?. 
  Hydro. Power spring  when snowmelt then       powers
    insulated bear hatchery !.
 Powers felt;       powers feel     snowmelt themselves.
END

######################################################

my $hs = new Language::Homespring();
$hs->parse($code);

$hs->tick(); # for(1..100);

print Dumper($hs->{root_node}, $hs->{salmon}, $hs->{new_salmon});
