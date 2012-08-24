#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [


			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/python/load_network_1.py",
				command_tests => [
						  {
						   description => "Can we load a ndf library namespace, create a network and create a map ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/load_network_1.txt`),

						   wait => 3,
						  },
						 ],
				description => "constructs a basic network and map",
			       },

			      ],
       description => "Python basic network tests",
       name => 'python/network-basic.t',
      };


return $test;
