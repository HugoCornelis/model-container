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
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hardcoded_tables1.ndf.', ],
						   write => undef,
						  },

						  # first gate

						  (
						   {
						    description => "Is the number of table entries of the first gate, first gate kinetic correct ?",
						    read => 'value = 10
',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h1 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    description => "Is the number of table entries of the first gate, second gate kinetic correct ?",
						    read => 'value = 10
',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h2 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    description => "Is the number of table entries of the first gate derived correctly ?",
						    read => 'value = 10
',
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
						    read => 'value = 8
',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h2 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						   {
						    comment => "These semantics are ok for running simulations, for modeling not sure yet.",
						    description => "Is the number of table entries of the second gate derived correctly ?",
						    read => 'value = 1.79769e+308
',
						    write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2 HH_NUMBER_OF_TABLE_ENTRIES',
						   },
						  ),
						 ],
				description => "gate table entries",
			       },
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
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hardcoded_tables1.ndf.', ],
						   write => undef,
						  },
						  (
						   (
						    # first gate, first gate kinetic

						    {
						     description => "Is the start of the table of the first gate, first gate kinetic correct ?",
						     read => 'value = 10
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h1 HH_TABLE_START_Y',
						    },
						    {
						     description => "Is the end of the table of the first gate, first gate kinetic correct ?",
						     read => 'value = 19
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h1 HH_TABLE_END_Y',
						    },
						    {
						     description => "Is the step of the table of the first gate, first gate kinetic correct ?",
						     read => 'value = 1
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h1 HH_TABLE_STEP_Y',
						    },
						   ),

						   (
						    # first gate, second gate kinetic

						    {
						     description => "Is the start of the table of the first gate, second gate kinetic correct ?",
						     read => 'value = 21
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h2 HH_TABLE_START_Y',
						    },
						    {
						     description => "Is the end of the table of the first gate, second gate kinetic correct ?",
						     read => 'value = 30
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h2 HH_TABLE_END_Y',
						    },
						    {
						     description => "Is the step of the table of the first gate, second gate kinetic correct ?",
						     read => 'value = 1
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh/h2 HH_TABLE_STEP_Y',
						    },
						   ),

						   (
						    # first gate

						    {
						     description => "Is the start of the table of the first gate correct ?",
						     read => 'value = 1.79769e+308
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh HH_TABLE_START_Y',
						    },
						    {
						     description => "Is the end of the table of the first gate correct ?",
						     read => 'value = 1.79769e+308
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh HH_TABLE_END_Y',
						    },
						    {
						     description => "Is the step of the table of the first gate correct ?",
						     read => 'value = 1
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh HH_TABLE_STEP_Y',
						    },
						   ),
						  ),
						  (
						   (
						    # second gate, first gate kinetic

						    {
						     description => "Is the start of the table of the second gate, first gate kinetic correct ?",
						     read => 'parameter not found in symbol
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h1 HH_TABLE_START_Y',
						    },
						    {
						     comment => "If the start cannot be found, the model container does not know how to find the end either",
						     description => "Is the end of the table of the second gate, first gate kinetic correct ?",
						     read => 'parameter not found in symbol
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h1 HH_TABLE_END_Y',
						    },
						    {
						     comment => "If the start cannot be found, the model container does not know how to find the step either",
						     description => "Is the step of the table of the second gate, first gate kinetic correct ?",
						     read => 'parameter not found in symbol
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h1 HH_TABLE_STEP_Y',
						    },
						   ),

						   (
						    # second gate, second gate kinetic

						    {
						     description => "Is the start of the table of the second gate, second gate kinetic correct ?",
						     read => 'value = 42
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h2 HH_TABLE_START_Y',
						    },
						    {
						     description => "Is the end of the table of the second gate, second gate kinetic correct ?",
						     read => 'value = 49
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h2 HH_TABLE_END_Y',
						    },
						    {
						     description => "Is the step of the table of the second gate, second gate kinetic correct ?",
						     read => 'value = 1
',
						     write => 'printparameter /hardcoded_tables1/segments/soma/kh/kh2/h2 HH_TABLE_STEP_Y',
						    },
						   ),

						   (
						    # second gate

						   ),
						  ),
						 ],
				description => "gate table start, end and step parameters",
			       },
		      ],
       description => "parameters related to gates with tables",
       name => 'gatetables.t',
      };


return $test;


