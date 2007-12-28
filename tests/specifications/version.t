#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => 'neurospaces ',
						   timeout => 3,
						   write => undef,
						  },
						  {
						   # $Format: "description => \"Does the version information match with $ProjectVersion$ ?\","$
description => "Does the version information match with 0.1675 ?",
						   # $Format: "read => \"$ProjectVersion$\","$
read => "0.1675",
						   write => "version",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


