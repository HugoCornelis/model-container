#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => './glue/swig/python/tests/neurospaces_test.py',
				command_tests => [
						  {
						   description => "Can we run a simple application that binds to the python interface ?",
						   read => 'simulation finished',
						  },
						 ],
				description => "a simple application that binds to the python interface",
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/python/tests/neurospaces_test_purkinje.py',
				command_tests => [
						  {
						   comment => 'Tests many functions, should be split in many tests',
						   description => "Can we examine and run the purkinje cell from the python interface ?",
						   read => [
							    '-re',
							    'value = 18
simulation finished
',
],
						   timeout => 100,
						  },
						 ],
				description => "examination and running the purkinje cell from the python interface",
			       },
			      ],
       description => "various python bindings tests",
       disabled => ((`python -c 'import Neurospaces ; print 1'` eq 1)
		    ? ''
		    : 'Neurospaces.py cannot be loaded, probably the swig glue has not been built yet'),
       name => 'basic.t',
      };


return $test;


