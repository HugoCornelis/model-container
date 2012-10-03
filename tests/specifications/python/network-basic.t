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
				disabled => "Reads in the --- as an option",
			       },

			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/python/volumeconnect_1.py",
				command_tests => [
						  {
						   description => "Can we load network and namespace via volumeconnect ?",
						   read => "Done!
",

						   timeout => 5,
						  },
						 ],
				description => "constructs a network and mapping with volumeconnect",
			       },


			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/python/createprojection_1.py",
				command_tests => [
						  {
						   description => "Can we load network and namespace via createprojection ?",
						   read => "Done!
",

						   timeout => 5,
						  },
						 ],
				description => "constructs a network and mapping with createprojection",
			       },


			       {
				arguments => [
					     ],
				command => "$::config->{core_directory}/tests/python/createprojection_2.py",
				command_tests => [
						  {
						   description => "Can we load network and namespace via createprojection ?",
						   read => "Done!
",

						   timeout => 5,
						  },
						 ],
				description => "constructs a network and mapping with createprojection with tuples",
				disabled => "need to fix this",
			       },





			      ],
       description => "Python basic network tests",
       name => 'python/network-basic.t',
      };


return $test;
