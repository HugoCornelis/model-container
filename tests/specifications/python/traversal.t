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
						   description => "Can we traverse a model in python ?",
						   read => "Top level child is: Purkinje
Done!",
						   timeout => 3,

						  },
						 ],
				description => "Traverses the model and returns a pure python list",
			       },
			      ],
       description => "Python traversal tests",
       name => 'python/traversal.t',
      };


return $test;
