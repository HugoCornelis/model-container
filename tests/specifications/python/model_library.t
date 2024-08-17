#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "library/channels/hodgkin-huxley/k.npy",
					     ],
				command => '/usr/bin/python',
				command_tests => [
						  {
						   description => "Can we run a simple application that binds to the python interface ?",
						   read => 'import

initialize

construct
',
						  },
						 ],
				description => "a simple application that binds to the python interface",
			       },
			      ],
       description => "various python bindings tests",
       disabled_old => ((`python -c 'import Neurospaces ; print 1'` =~ /^1$/)
		    ? ''
		    : 'Neurospaces.py cannot be loaded, probably the swig glue has not been built yet'),
       disabled => 'currently not maintaining the python interface',
       name => 'python/model_library.t',
      };


return $test;


