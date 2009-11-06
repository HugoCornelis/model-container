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
					      'pulse/pulse1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pulse/pulse1.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },


						  {
						   description => "Has the parameter level1 been set ?",
						   read => 'value = 50',
						   write => 'printparameter /Pulse_gen LEVEL1',
						  },

						  {
						   description => "Has the parameter width1 been set ?",
						   read => 'value = 3',
						   write => 'printparameter /Pulse_gen WIDTH1',
						  },



						  {
						   description => "Has the parameter delay1 been set ?",
						   read => 'value = 5',
						   write => 'printparameter /Pulse_gen DELAY1',
						  },


						  {
						   description => "Has the parameter level2 been set ?",
						   read => 'value = -20',
						   write => 'printparameter /Pulse_gen LEVEL2',
						  },

						  {
						   description => "Has the parameter width2 been set ?",
						   read => 'value = 5',
						   write => 'printparameter /Pulse_gen WIDTH2',
						  },


						  {
						   description => "Has the parameter delay2 been set ?",
						   read => 'value = 8',
						   write => 'printparameter /Pulse_gen DELAY2',
						  },




						  {
						   description => "Has the parameter baselevel been set ?",
						   read => 'value = 10',
						   write => 'printparameter /Pulse_gen BASELEVEL',
						  },


						  {
						   description => "Has the trigger mode parameter been set ?",
						   read => 'value = 0',
						   write => 'printparameter /Pulse_gen TRIGMODE',
						  },


						 ],
				description => "library pulse generators",
			       },

			      ],
       description => "generic pulse objects",
       name => 'pulse.t',
      };


return $test;


