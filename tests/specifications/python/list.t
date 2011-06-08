#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/python/children_tolist.py',
				command_tests => [
						  {
						   description => "Can we retrieve a python list of all elements in the Purkinje cell ?",
						   read => "Top level child is: Purkinje
Number of elements is 65623
Done!
",

						   timeout => 100,

						  },
						 ],
				description => "A simple script that will load the purkinje cell and return a python list",
			       },




			       {
				arguments => [
					     ],
				command => 'tests/python/coordinates_tolist.py',
				command_tests => [
						  {
						   description => "Can we retrieve a python list of all visible elements in the Purkinje cell ?",
						   read => "Top level child is: /Purkinje
Number of elements is 4549
Done!
",

						   timeout => 100,

						  },
						 ],
				description => "A simple script that will load the purkinje cell and return a python coordinate list",
			       },

			      ],
       description => "Python list tests",
       name => 'python/list.t',
      };


return $test;
