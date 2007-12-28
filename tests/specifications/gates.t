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
					      'gates/naf_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  (
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/gates/naf_activation.ndf.', ],
						    timeout => 3,
						    write => undef,
						   },
						   {
						    description => "Do we find a power for the Hodgkin Huxley gate ?",
						    read => '3',
						    write => "printparameter /naf_activation POWER",
						   },
						   {
						    description => "Do we find the Multiplier parameter with a correct value in the forward gate kinetic ?",
						    read => '35000',
						    write => 'printparameter /naf_activation/forward Multiplier',
						   },
						   {
						    description => "Do we find the MembraneDependence parameter with a correct value in the forward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/forward MembraneDependence',
						   },
						   {
						    description => "Do we find the Nominator parameter with a correct value in the forward gate kinetic ?",
						    read => '= -1',
						    write => 'printparameter /naf_activation/forward Nominator',
						   },
						   {
						    description => "Do we find the DeNominatorOffset parameter with a correct value in the forward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/forward DeNominatorOffset',
						   },
						   {
						    description => "Do we find the MembraneOffset parameter with a correct value in the forward gate kinetic ?",
						    read => '0.005',
						    write => 'printparameter /naf_activation/forward MembraneOffset',
						   },
						   {
						    description => "Do we find the TauDenormalizer parameter with a correct value in the forward gate kinetic ?",
						    read => '= -0.01',
						    write => 'printparameter /naf_activation/forward TauDenormalizer',
						   },
						  ),
						  (
						   {
						    description => "Do we find the Multiplier parameter with a correct value in the backward gate kinetic ?",
						    read => '7000',
						    write => 'printparameter /naf_activation/backward Multiplier',
						   },
						   {
						    description => "Do we find the MembraneDependence parameter with a correct value in the backward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/backward MembraneDependence',
						   },
						   {
						    description => "Do we find the Nominator parameter with a correct value in the backward gate kinetic ?",
						    read => '= -1',
						    write => 'printparameter /naf_activation/backward Nominator',
						   },
						   {
						    description => "Do we find the DeNominatorOffset parameter with a correct value in the backward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/backward DeNominatorOffset',
						   },
						   {
						    description => "Do we find the MembraneOffset parameter with a correct value in the backward gate kinetic ?",
						    read => '0.065',
						    write => 'printparameter /naf_activation/backward MembraneOffset',
						   },
						   {
						    description => "Do we find the TauDenormalizer parameter with a correct value in the backward gate kinetic ?",
						    read => '0.02',
						    write => 'printparameter /naf_activation/backward TauDenormalizer',
						   },
						  ),
						 ],
				description => "sodium activation gate",
			       },
			      ],
       description => "generic gates, from multiple models",
       name => 'gates.t',
      };


return $test;


