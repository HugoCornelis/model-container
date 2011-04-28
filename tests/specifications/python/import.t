#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/python/import_test.py',
				command_tests => [
						  {
						   description => "Can we import the nmc module and it's base class ?",
						   read => 'Importing model_container_base
Importing model container
Done!
',
						  },
						 ],
				description => "a simple application that imports the built nmc python modules",
			       },

			       {
				arguments => [
					     ],
				command => 'tests/python/import_test_1.py',
				disabled => 'Disabling this until the standard location installation is done.',
				command_tests => [
						  {
						   description => "Can we import the nmc module and it's base class from the installed location ?",
						   read => 'Importing nmc_base
Importing nmc
Done!
',
						  },
						 ],
				description => "A simple application that imports the built nmc python modules from /usr/local/glue/swig/python",
			       },

			      ],
       description => "Simple python functionality tests",
       name => 'python/import.t',
      };


return $test;


