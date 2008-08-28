#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'tests/cells/hardcoded_tables1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/hardcoded_tables1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hardcoded_tables1.ndf.', ],
						   write => undef,
						  },

						  # first gate

						  (
						   {
						    description => "Is the number of table entries of the first gate, first gate kinetic correct ?",
						    read => 'value = 10',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h1 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    description => "Is the number of table entries of the first gate, second gate kinetic correct ?",
						    read => 'value = 10',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h2 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    description => "Is the number of table entries of the first gate derived correctly ?",
						    read => 'value = 10',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						  ),

						  # second gate

						  (
						   {
						    description => "Is the number of table entries of the second gate, first gate kinetic correct (not found) ?",
						    read => 'parameter not found in symbol',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h1 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    description => "Is the number of table entries of the second gate, second gate kinetic correct ?",
						    read => 'value = 8',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h2 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    comment => "These semantics are ok for running simulations, for modeling not sure yet.",
						    description => "Is the number of table entries of the second gate derived correctly ?",
						    read => 'value = 3.40282e+38',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						  ),
						 ],
				description => "gate tables",
			       },
		      ],
       description => "parameters related to gates with tables",
       name => 'gatetables.t',
      };


return $test;


