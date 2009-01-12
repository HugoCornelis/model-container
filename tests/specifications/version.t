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
						   # $Format: "description => \"Does the version information match with ${package}-${label} ?\","$
description => "Does the version information match with model-container-16e23f15d78f5309ea818389c3ceb50568e64313-0 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "model-container-16e23f15d78f5309ea818389c3ceb50568e64313-0",
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


