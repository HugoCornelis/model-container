#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/python/asc_parse_1.py',
				command_tests => [
						  {
						   description => "Can we parse tokens in an asc file ?",
						   read => 'File e1cb4a1.asc has 25982 tokens
Done!',
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "simple token parsing",
			       },
			      ],
       description => "simple asc token parsing",
       name => 'asc_parse.t',
      };


return $test;


