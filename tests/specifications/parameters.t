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
						   description => "Does the soma of the purkinje cell have a diameter ?",
						   read => '= 2.98e-05',
						   write => "printparameter /Purkinje/segments/soma DIA",
						  },
						  {
						   description => "Does the soma of the purkinje cell not have a length ?",
						   read => '= 0
 neurospaces',
						   write => "printparameter /Purkinje/segments/soma LENGTH",
						  },
						  {
						   description => "Does the soma of the purkinje cell have a surface ?",
						   read => '= 2.78986e-09',
						   write => "printparameter /Purkinje/segments/soma SURFACE",
						  },
						  {
						   description => "Does the soma of the purkinje cell have a time constant ?",
						   read => '= 0.0164',
						   write => "printparameter /Purkinje/segments/soma TAU",
						  },
						  {
						   description => "Does the soma of the purkinje cell have a well-defined delayed rectifier potassium conductance ?",
						   read => '= 6000',
						   write => "printparameter /Purkinje/segments/soma/Kdr G_MAX",
						  },
						  {
						   description => "Has the conductance been scaled according to the surface ?",
						   read => '= 1.67392e-05',
						   write => "printparameterscaled /Purkinje/segments/soma/Kdr G_MAX",
						  },
						  {
						   description => "What is the diameter of one of the spiny dendrites ?",
						   read => '= 2.28e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] DIA",
						  },
						  {
						   description => "What is the length of one of the spiny dendrites ?",
						   read => '= 2.22e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						  },
						  {
						   description => "What is the time constant of one of the spiny dendrites ?",
						   read => '= 0.0492',
						   write => "printparameter /Purkinje/segments/b0s01[1] TAU",
						  },
						  {
						   description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						   read => '= 800',
						   write => "printparameter /Purkinje/segments/b0s01[1]/KC G_MAX",
						  },
						  {
						   description => "Is conductance scaling done correctly ?",
						   read => '= 1.27212e-08',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1]/KC G_MAX",
						  },
						 ],
				description => "parameter calculations on dendrites of the standard Purkinje cell model",
			       },
			       {
				arguments => [
					      '-q',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find spines attached to a spiny dendrite in the model purkinje cell ?",
						   read => '= 1141
',
						   write => "serialID /Purkinje Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par",
						  },
						  {
						   description => "What is the length of the spiny dendrite ?",
						   read => '= 2.22e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						  },
						  {
						   description => "What is the diameter of the spiny dendrite ?",
						   read => '= 2.28e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] DIA",
						  },
						  {
						   description => "What is the surface of the spiny dendrite (must be corrected for virtual spines) ?",
						   read => '= 5.29772e-11',
						   write => "printparameter /Purkinje/segments/b0s01[1] SURFACE",
						  },
						  {
						   description => "What is the length of the spine neck ?",
						   read => '= 6.6e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck LENGTH",
						  },
						  {
						   description => "What is the diameter of the spine neck ?",
						   read => '= 2e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck DIA",
						  },
						  {
						   description => "What is the surface of the spine neck ?",
						   read => '= 4.1469e-13',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck SURFACE",
						  },
						  {
						   description => "What is the length of the spine head ?",
						   read => '= 6.8036e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head LENGTH",
						  },
						  {
						   description => "What is the diameter of the spine head ?",
						   read => '= 4.286e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head DIA",
						  },
						  {
						   description => "What is the surface of the spine head ?",
						   read => '= 9.16096e-13', # joint is 1.330786e-12
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head SURFACE",
						  },
						  {
						   description => "What is the capacitance of the spiny dendrite ?",
						   read => '= 0.0164',
						   write => "printparameter /Purkinje/segments/b0s01[1] CM",
						  },
						  {
						   description => "What is the scaled capacitance of the spiny dendrite (includes spine surface for virtual spines) ?",
						   read => '= 8.68826e-13',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1] CM",
						  },
						  {
						   description => "What is the membrane resistance of the spiny dendrite ?",
						   read => '= 3
 neurospaces',
						   write => "printparameter /Purkinje/segments/b0s01[1] RM",
						  },
						  {
						   description => "What is the scaled membrane resistance of the spiny dendrite (includes spine surface for virtual spines) ?",
						   read => '= 5.66282e+10',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1] RM",
						  },
						  {
						   description => "What is the axial resistance of the spiny dendrite ?",
						   read => '= 2.5
 neurospaces',
						   write => "printparameter /Purkinje/segments/b0s01[1] RA",
						  },
						  {
						   description => "What is the scaled axial resistance of the spiny dendrite (does not includes spine parameters) ?",
						   read => '= 1.35936e+06',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1] RA",
						  },
						 ],
				description => "parameter calculations on spines of the standard Purkinje cell model",
			       },
			       {
				arguments => [
					      '-q',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find the input to a nernst function ?",
						   read => 'value = Ca_pool',
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT Erev Cin",
						  },
						 ],
				description => "parameter function correctness",
			       },

			       (
				{
				 arguments => [
					       '-v',
					       '1',
					       '-q',
					       'cells/purkinje/edsjb1994.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/cells/purkinje/edsjb1994.ndf.', ],
						    timeout => 3,
						    write => undef,
						   },
						   {
						    description => "Does the soma of the purkinje cell have a diameter ?",
						    read => '= 2.98e-05',
						    write => "printparameter /Purkinje/segments/soma DIA",
						   },
						   {
						    description => "Does the soma of the purkinje cell not have a length ?",
						    read => '= 0
',
						    write => "printparameter /Purkinje/segments/soma LENGTH",
						   },
						   {
						    description => "Does the soma of the purkinje cell have a surface ?",
						    read => '= 2.78986e-09',
						    write => "printparameter /Purkinje/segments/soma SURFACE",
						   },
						   {
						    description => "Does the soma of the purkinje cell have a time constant ?",
						    read => '= 0.0164',
						    write => "printparameter /Purkinje/segments/soma TAU",
						   },
						   {
						    description => "Does the soma of the purkinje cell have a well-defined delayed rectifier potassium conductance ?",
						    read => '= 6000
',
						    write => "printparameter /Purkinje/segments/soma/kdr G_MAX",
						   },
						   {
						    description => "Has the conductance been scaled according to the surface ?",
						    read => '= 1.67392e-05',
						    write => "printparameterscaled /Purkinje/segments/soma/kdr G_MAX",
						   },
						   {
						    description => "What is the diameter of one of the spiny dendrites ?",
						    read => '= 2.28e-06',
						    write => "printparameter /Purkinje/segments/b0s01[1] DIA",
						   },
						   {
						    description => "What is the length of one of the spiny dendrites ?",
						    read => '= 2.22e-06',
						    write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						   },
						   {
						    description => "What is the time constant of one of the spiny dendrites ?",
						    read => '= 0.0492',
						    write => "printparameter /Purkinje/segments/b0s01[1] TAU",
						   },
						   {
						    description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						    read => '= 800',
						    write => "printparameter /Purkinje/segments/b0s01[1]/kc G_MAX",
						   },
						   {
						    description => "Is conductance scaling done correctly ?",
						    read => '= 1.27212e-08',
						    write => "printparameterscaled /Purkinje/segments/b0s01[1]/kc G_MAX",
						   },
						  ],
				 description => "parameter calculations on dendrites of the standard Purkinje cell model (2)",
# 				 disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				},
				{
				 arguments => [
					       '-q',
					       'cells/purkinje/edsjb1994.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Can we find spines attached to a spiny dendrite in the model purkinje cell ?",
						    read => '= 3038
',
						    write => "serialID /Purkinje Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par",
						   },
						   {
						    description => "What is the length of the spiny dendrite ?",
						    read => '= 2.22e-06',
						    write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						   },
						   {
						    description => "What is the diameter of the spiny dendrite ?",
						    read => '= 2.28e-06',
						    write => "printparameter /Purkinje/segments/b0s01[1] DIA",
						   },
						   {
						    description => "What is the surface of the spiny dendrite (must be corrected for virtual spines) ?",
						    read => '= 5.29772e-11',
						    write => "printparameter /Purkinje/segments/b0s01[1] SURFACE",
						   },
						   {
						    description => "What is the length of the spine neck ?",
						    read => '= 6.6e-07',
						    write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck LENGTH",
						   },
						   {
						    description => "What is the diameter of the spine neck ?",
						    read => '= 2e-07',
						    write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck DIA",
						   },
						   {
						    description => "What is the surface of the spine neck ?",
						    read => '= 4.1469e-13',
						    write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck SURFACE",
						   },
						   {
						    description => "What is the length of the spine head ?",
						    read => '= 6.8036e-07',
						    write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head LENGTH",
						   },
						   {
						    description => "What is the diameter of the spine head ?",
						    read => '= 4.286e-07',
						    write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head DIA",
						   },
						   {
						    description => "What is the surface of the spine head ?",
						    read => '= 9.16096e-13', # joint is 1.330786e-12
						    write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head SURFACE",
						   },
						   {
						    description => "What is the capacitance of the spiny dendrite ?",
						    read => '= 0.0164',
						    write => "printparameter /Purkinje/segments/b0s01[1] CM",
						   },
						   {
						    description => "What is the scaled capacitance of the spiny dendrite (includes spine surface for virtual spines) ?",
						    read => '= 8.68826e-13',
						    write => "printparameterscaled /Purkinje/segments/b0s01[1] CM",
						   },
						   {
						    description => "What is the membrane resistance of the spiny dendrite ?",
						    read => '= 3
 neurospaces',
						    write => "printparameter /Purkinje/segments/b0s01[1] RM",
						   },
						   {
						    description => "What is the scaled membrane resistance of the spiny dendrite (includes spine surface for virtual spines) ?",
						    read => '= 5.66282e+10',
						    write => "printparameterscaled /Purkinje/segments/b0s01[1] RM",
						   },
						   {
						    description => "What is the axial resistance of the spiny dendrite ?",
						    read => '= 2.5
 neurospaces',
						    write => "printparameter /Purkinje/segments/b0s01[1] RA",
						   },
						   {
						    description => "What is the scaled axial resistance of the spiny dendrite (does not includes spine parameters) ?",
						    read => '= 1.35936e+06',
						    write => "printparameterscaled /Purkinje/segments/b0s01[1] RA",
						   },
						  ],
				 description => "parameter calculations on spines of the standard Purkinje cell model (2)",
# 				 disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				},
				{
				 arguments => [
					       '-q',
					       'cells/purkinje/edsjb1994.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Can we find the input to a nernst function ?",
						    read => 'value = ca_pool',
						    write => "printparameterinput /Purkinje/segments/main[0]/cat Erev Cin",
						   },
						  ],
				 description => "parameter function correctness",
# 				 disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
				},
			       ),
			       {
				arguments => [
					      '-q',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find all the reversal potentials ?",
						   read => '/Golgi/Golgi_soma/CaHVA->Erev = 0.138533
/Golgi/Golgi_soma/H->Erev = -0.042
/Golgi/Golgi_soma/InNa->Erev = 0.055
/Golgi/Golgi_soma/KA->Erev = -0.09
/Golgi/Golgi_soma/KDr->Erev = -0.09
/Golgi/Golgi_soma/Moczyd_KC->Erev = -0.09
/Golgi/Golgi_soma/mf_AMPA->Erev = 0
/Golgi/Golgi_soma/pf_AMPA->Erev = 0
',
						   write => "printparameter /** Erev",
						  },
						 ],
				comment => 'this test is superseded by the same type of test in parameteroperations.t',
				description => "wildcarded parameter query",
			       },
			       {
				arguments => [
					      '-q',
					      'contours/section1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "What is the thickness of the first contour ?",
						   read => '= 7e-08
',
						   write => "printparameter /section1/e0 THICKNESS",
						  },
						  {
						   description => "Is the thickness inherited by the contour points ?",
						   read => '= 7e-08
',
						   write => "printparameter /section1/e0/e0_0 THICKNESS",
						  },
						  {
						   description => "Is the thickness inherited by the contour points (2) ?",
						   read => '= 7e-08
',
						   write => "printparameter /section1/e0/e0_1 THICKNESS",
						  },
						  {
						   description => "Is the thickness inherited by the contour points (3) ?",
						   read => '= 7e-08
',
						   write => "printparameter /section1/e0/e0_2 THICKNESS",
						  },
						 ],
				description => "thickness of EM contours and points",
				disabled => 'EM contours have been disabled with commit commit 7144a5da54a897473c0b32dbdf4b19246f3b33d1
Author: Hugo Cornelis <hugo.cornelis@gmail.com>
Date:   Sat Aug 17 08:47:08 2024 +0200

    Removed contour related symbols from the grammar.
',
			       },
			      ],
       description => "parameter calculations on existing models",
       name => 'parameters.t',
      };


return $test;


