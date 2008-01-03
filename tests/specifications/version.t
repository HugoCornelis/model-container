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
						   # $Format: "description => \"Does the version information match with ${package}-${label}-${email} ?\","$
description => "Does the version information match with neurospacesread-0.1675-hugo.cornelis@gmail.com ?",
						   # $Format: "read => \"${package}-${label}-${email}\","$
read => "neurospacesread-0.1675-hugo.cornelis@gmail.com",
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


