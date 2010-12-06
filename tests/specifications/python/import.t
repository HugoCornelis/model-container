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
						   read => 'Importing nmc_base
Importing nmc
Done!
',
						  },
						 ],
				description => "a simple application that imports the built nmc python modules",
			       },
			      ],
       description => "Simple python functionality tests",
       name => 'python/import.t',
      };


return $test;


