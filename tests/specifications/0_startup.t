#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-v',
					      '1',
					      'channels/nmda.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/nmda.ndf.', ],
						   timeout => 15,
						   write => undef,
						  },
						 ],
				description => "simple startup",
			       },
			      ],
       description => "simple startup, simple model",
       name => '0_startup.t',
      };


return $test;


