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
						   disabled => "The tests in list.t take care of this now",
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
       disabled => 'currently not maintaining the python interface',
       name => 'python/traversal.t',
      };


return $test;
