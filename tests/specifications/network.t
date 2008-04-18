#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/network-test.ndf.', ],
						   timeout => 100,
						   write => undef,
						  },
						  {
						   description => "What is the xpower of the delayed rectifier channel in the first Golgi cell ?",
						   read => "value = 4
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Xpower",
						  },
						  {
						   description => "What is the ypower of the delayed rectifier channel in the first Golgi cell ?",
						   read => "value = 1
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Ypower",
						  },
						  {
						   description => "What is the zpower of the delayed rectifier channel in the first Golgi cell ?",
						   read => "value = 0
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Zpower",
						  },
						  {
						   description => "What is the scaled conductance of the delayed rectifier channel in the first Golgi cell ?",
						   read => "scaled value = 1.91937e-07
",
						   write => "printparameterscaled /CerebellarCortex/Golgis/0/Golgi_soma/KDr G_MAX",
						  },
						  {
						   description => "What is the unscaled conductance of the delayed rectifier channel in the first Golgi cell ?",
						   read => "value = 67.8839
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr G_MAX",
						  },
						  {
						   description => "What is the reversal potential of the delayed rectifier channel in the first Golgi cell ?",
						   read => "value = -0.09
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Erev",
						  },
						  {
						   description => "How does neurospaces react if we try to access parameters that are not defined ?",
						   read => "parameter not found in symbol
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Emax",
						  },
						  {
						   description => "What is the diameter of the soma in the first Golgi cell ?",
						   read => "value = 3e-05
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma DIA",
						  },
						 ],
				description => "network model : basic sanity",
			       },
			      ],
       description => "network",
       name => 'network.t',
      };


return $test;


