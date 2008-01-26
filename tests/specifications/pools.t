#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      '-R',
					      'pools/golgi_ca.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pools/golgi_ca.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "Has the beta parameter of the isolated pool been fixed ?",
						   read => 'scaled value = 2.02379e+10',
						   write => 'printparameterscaled /Ca_concen BETA',
						  },
						  {
						   description => "Has the beta parameter of the standalone pool been fixed ?",
						   read => 'scaled value = 2.02379e+10',
						   write => 'printparameterscaled /Ca_concen_standalone BETA',
						  },
						  {
						   description => "Has the beta parameter of the isolated pool been fixed ?",
						   read => 'value = 2.02379e+10',
						   write => 'printparameter /Ca_concen BETA',
						  },
						  {
						   description => "Has the beta parameter of the standalone pool been fixed ?",
						   read => 'value = 2.02379e+10',
						   write => 'printparameter /Ca_concen_standalone BETA',
						  },
						 ],
				description => "library golgi pool",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/golgi.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "Has the beta parameter of the isolated pool been fixed ?",
						   read => 'scaled value = 2.02379e+10',
						   write => 'printparameterscaled /Golgi/Golgi_soma/Ca_pool BETA',
						  },
						  {
						   description => "Has the beta parameter of the standalone pool been fixed ?",
						   read => 'scaled value = 2.02379e+10',
						   write => 'printparameterscaled ::concen::/Ca_concen BETA',
						  },
						  {
						   description => "Has the beta parameter of the standalone pool been fixed ?",
						   read => 'scaled value = 2.02379e+10',
						   write => 'printparameterscaled ::concen::/Ca_concen_standalone BETA',
						  },
						  {
						   description => "Has the beta parameter of the standalone pool been fixed ?",
						   read => 'value = 2.02379e+10',
						   write => 'printparameter ::concen::/Ca_concen BETA',
						  },
						  {
						   description => "Has the beta parameter of the standalone pool been fixed ?",
						   read => 'value = 2.02379e+10',
						   write => 'printparameter ::concen::/Ca_concen_standalone BETA',
						  },
						 ],
				description => "golgi cell pool",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'pools/purkinje_ca.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/pools/purkinje_ca.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "Is the beta parameter of the isolated pool not available ?",
						   read => 'scaled value = 3.40282e+38',
						   write => 'printparameterscaled /Ca_concen BETA',
						  },
						  {
						   description => "Is the beta parameter of the standalone pool available ?",
						   read => 'scaled value = 6.8724e+11',
						   write => 'printparameterscaled /Ca_concen_standalone BETA',
						  },
						  {
						   description => "Is the beta parameter of the isolated pool available (should be one) ?",
						   read => 'value = 1',
						   write => 'printparameter /Ca_concen BETA',
						  },
						  {
						   description => "Is the beta parameter of the standalone pool available (should be one) ?",
						   read => 'value = 1',
						   write => 'printparameter /Ca_concen_standalone BETA',
						  },
						 ],
				description => "library purkinje pool",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/cells/purk2m9s.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "What is the beta parameter purkinje cell soma pool ?",
						   read => 'scaled value = 9.41239e+09',
						   write => 'printparameterscaled /Purkinje/segments/soma/Ca_pool BETA',
						  },
						  {
						   description => "What is the beta parameter purkinje cell main[0] pool ?",
						   read => 'scaled value = 7.57902e+10',
						   write => 'printparameterscaled /Purkinje/segments/main[0]/Ca_pool BETA',
						  },
						  {
						   description => "What is the beta parameter purkinje cell soma pool (should be one) ?",
						   read => 'value = 1
',
						   write => 'printparameter /Purkinje/segments/soma/Ca_pool BETA',
						  },
						  {
						   description => "What is the beta parameter purkinje cell main[0] pool (should be one) ?",
						   read => 'value = 1
',
						   write => 'printparameter /Purkinje/segments/main[0]/Ca_pool BETA',
						  },
						 ],
				description => "purkinje cell pools",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'tests/cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purkinje/edsjb1994.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "What is the beta parameter purkinje cell soma pool ?",
						   read => 'scaled value = 9.41239e+09',
						   side_effects => 1,
						   write => 'printparameterscaled /Purkinje/segments/soma/ca_pool BETA',
						  },
						  {
						   description => "What is the beta parameter purkinje cell main[0] pool ?",
						   read => 'scaled value = 7.57902e+10',
						   write => 'printparameterscaled /Purkinje/segments/main[0]/ca_pool BETA',
						  },
						  {
						   description => "What is the beta parameter purkinje cell soma pool (should be one) ?",
						   read => 'value = 1
',
						   write => 'printparameter /Purkinje/segments/soma/ca_pool BETA',
						  },
						  {
						   description => "What is the beta parameter purkinje cell main[0] pool (should be one) ?",
						   read => 'value = 1
',
						   write => 'printparameter /Purkinje/segments/main[0]/ca_pool BETA',
						  },
						 ],
				description => "purkinje cell pools",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			      ],
       description => "generic pools, from multiple models",
       name => 'pools.t',
      };


return $test;


