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
					      '-q',
					      '-R',
					      'gates/naf_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
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
						  (
						   # standard gate parameters

						   {
						    description => "Do we find the HH_AB_Add_Num parameter with a correct value in the A gate kinetic ?",
						    read => '35000',
						    write => 'printparameter /naf_activation/A HH_AB_Add_Num',
						   },
						   {
						    description => "Do we find the HH_AB_Mult parameter with a correct value in the A gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/A HH_AB_Mult',
						   },
						   {
						    description => "Do we find the HH_AB_Factor_Flag parameter with a correct value in the A gate kinetic ?",
						    read => '= -1',
						    write => 'printparameter /naf_activation/A HH_AB_Factor_Flag',
						   },
						   {
						    description => "Do we find the HH_AB_Add_Den parameter with a correct value in the A gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/A HH_AB_Add_Den',
						   },
						   {
						    description => "Do we find the HH_AB_Offset_E parameter with a correct value in the A gate kinetic ?",
						    read => '0.005',
						    write => 'printparameter /naf_activation/A HH_AB_Offset_E',
						   },
						   {
						    description => "Do we find the HH_AB_Div_E parameter with a correct value in the A gate kinetic ?",
						    read => '= -0.01',
						    write => 'printparameter /naf_activation/A HH_AB_Div_E',
						   },
						  ),
						  (
						   # additional tests

						   {
						    description => "Do we find the HH_AB_Offset parameter with the same values as HH_OffsetE in the A gate kinetic ?",
						    disabled => "The HH_AB_Offset parameter has been removed.",
						    read => '0.005',
						    write => 'printparameter /naf_activation/A HH_AB_Offset',
						   },
						  ),
						  (
						   # standard gate parameters

						   {
						    description => "Do we find the HH_AB_Add_Num parameter with a correct value in the B gate kinetic ?",
						    read => '7000',
						    write => 'printparameter /naf_activation/B HH_AB_Add_Num',
						   },
						   {
						    description => "Do we find the HH_AB_Mult parameter with a correct value in the B gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/B HH_AB_Mult',
						   },
						   {
						    description => "Do we find the HH_AB_Factor_Flag parameter with a correct value in the B gate kinetic ?",
						    read => '= -1',
						    write => 'printparameter /naf_activation/B HH_AB_Factor_Flag',
						   },
						   {
						    description => "Do we find the HH_AB_Add_Den parameter with a correct value in the B gate kinetic ?",
						    read => '= 0',
						    write => 'printparameter /naf_activation/B HH_AB_Add_Den',
						   },
						   {
						    description => "Do we find the HH_AB_Offset_E parameter with a correct value in the B gate kinetic ?",
						    read => '0.065',
						    write => 'printparameter /naf_activation/B HH_AB_Offset_E',
						   },
						   {
						    description => "Do we find the HH_AB_Div_E parameter with a correct value in the B gate kinetic ?",
						    read => '0.02',
						    write => 'printparameter /naf_activation/B HH_AB_Div_E',
						   },
						  ),
						  (
						   # additional tests

						   {
						    description => "Do we find the HH_AB_Offset parameter with the same values as HH_OffsetE in the A gate kinetic ?",
						    disabled => "The HH_AB_Offset parameter has been removed.",
						    read => '0.065',
						    write => 'printparameter /naf_activation/B HH_AB_Offset',
						   },
						  ),
						 ],
				description => "sodium activation gate parameters",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'gates/naf_activation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/gates/naf_activation.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "Is the tabulation flag set (should not) ?",
						   read => '= 0
',
						   write => "printparameter /naf_activation/A HH_Has_Table",
						  },
						 ],
				description => "tabulation tests",
			       },
			      ],
       description => "generic gates, from multiple models",
       name => 'gates.t',
      };


return $test;


