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
					      'pulsegen/pulsegen1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pulsegen/pulsegen1.ndf.', ],
						   timeout => 3,
						  },
						  {
						   description => "Has the parameter level1 been set ?",
						   read => 'value = 50',
						   write => 'printparameter /PulseGen_1 LEVEL1',
						  },
						  {
						   description => "Has the parameter width1 been set ?",
						   read => 'value = 3',
						   write => 'printparameter /PulseGen_1 WIDTH1',
						  },
						  {
						   description => "Has the parameter delay1 been set ?",
						   read => 'value = 5',
						   write => 'printparameter /PulseGen_1 DELAY1',
						  },
						  {
						   description => "Has the parameter level2 been set ?",
						   read => 'value = -20',
						   write => 'printparameter /PulseGen_1 LEVEL2',
						  },
						  {
						   description => "Has the parameter width2 been set ?",
						   read => 'value = 5',
						   write => 'printparameter /PulseGen_1 WIDTH2',
						  },
						  {
						   description => "Has the parameter delay2 been set ?",
						   read => 'value = 8',
						   write => 'printparameter /PulseGen_1 DELAY2',
						  },
						  {
						   description => "Has the parameter baselevel been set ?",
						   read => 'value = 10',
						   write => 'printparameter /PulseGen_1 BASELEVEL',
						  },
						  {
						   description => "Has the trigger mode parameter been set ?",
						   read => 'value = 0',
						   write => 'printparameter /PulseGen_1 TRIGMODE',
						  },
						 ],
				description => "library pulsegen generators",
			       },
			      ],
       description => "the generic pulsegen object",
       name => 'pulsegen.t',
      };


return $test;


