use Test::Simple tests => 2;

use Language::Homespring;
require "t/harness.inc";

#
# powers
# Generates electricity for everything downstream of the 'powers' node
#
 
ok(test_hs_return("bear hatchery foo  powers", ['','','','','','foo','foo']));
ok(test_hs_return("bear hatchery foo", ['','','','','','','']));

#
# hydro power
# Generates electricity only when supplied with water. This can be destroyed by snowmelt
#

