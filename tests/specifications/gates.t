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
						   # standard parameters

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
						    description => "Do we find the HH_Scale parameter with a correct value in the forward gate kinetic ?",
						    read => '35000',
						    write => 'printparameter /naf_activation/forward HH_Scale',
						   },
						   {
						    description => "Do we find the HH_Mult parameter with a correct value in the forward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/forward HH_Mult',
						   },
						   {
						    description => "Do we find the HH_Factor_Flag parameter with a correct value in the forward gate kinetic ?",
						    read => '= -1',
						    write => 'printparameter /naf_activation/forward HH_Factor_Flag',
						   },
						   {
						    description => "Do we find the HH_Add parameter with a correct value in the forward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/forward HH_Add',
						   },
						   {
						    description => "Do we find the HH_Offset2 parameter with a correct value in the forward gate kinetic ?",
						    read => '0.005',
						    write => 'printparameter /naf_activation/forward HH_Offset2',
						   },
						   {
						    description => "Do we find the HH_Tau parameter with a correct value in the forward gate kinetic ?",
						    read => '= -0.01',
						    write => 'printparameter /naf_activation/forward HH_Tau',
						   },
						  ),
						  (
						   # additional tests

						   {
						    description => "Do we find the HH_Offset parameter with the same values as HH_Offset2 in the forward gate kinetic ?",
						    read => '0.005',
						    write => 'printparameter /naf_activation/forward HH_Offset',
						   },
						  ),
						  (
						   {
						    description => "Do we find the HH_Scale parameter with a correct value in the backward gate kinetic ?",
						    read => '7000',
						    write => 'printparameter /naf_activation/backward HH_Scale',
						   },
						   {
						    description => "Do we find the HH_Mult parameter with a correct value in the backward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/backward HH_Mult',
						   },
						   {
						    description => "Do we find the HH_Factor_Flag parameter with a correct value in the backward gate kinetic ?",
						    read => '= -1',
						    write => 'printparameter /naf_activation/backward HH_Factor_Flag',
						   },
						   {
						    description => "Do we find the HH_Add parameter with a correct value in the backward gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/backward HH_Add',
						   },
						   {
						    description => "Do we find the HH_Offset2 parameter with a correct value in the backward gate kinetic ?",
						    read => '0.065',
						    write => 'printparameter /naf_activation/backward HH_Offset2',
						   },
						   {
						    description => "Do we find the HH_Tau parameter with a correct value in the backward gate kinetic ?",
						    read => '0.02',
						    write => 'printparameter /naf_activation/backward HH_Tau',
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


