#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/python/test_purkinje_1.py',
				command_tests => [
						  {
						   description => "Can load the purkinje cell model via python ?",
						   read => "value = 18",

						   wait => 20,

						  },
						 ],
				description => "A simple script that will load the purkinje cell and set a few parameters",
			       },
			      ],
       description => "Simple python functionality tests",
       disabled => 'currently not maintaining the python interface',
       name => 'python/pybasic.t',
      };


return $test;


