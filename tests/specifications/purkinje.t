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
						   description => "What is the length of the first main segment ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0] LENGTH",
						  },
						  {
						   description => "What is the length of the second main segment ?",
						   read => 'value = 2.35003e-05',
						   write => "printparameter /Purkinje/segments/main[1] LENGTH",
						  },
						  {
						   description => "What is the length of the first spiny dendrite ?",
						   read => 'value = 6.16021e-06',
						   write => "printparameter /Purkinje/segments/b0s01[0] LENGTH",
						  },
						  {
						   description => "What is the length of the second spiny dendrite ?",
						   read => 'value = 2.22e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						  },
						  {
						   description => "What is the length of one of the spinyd dendrites (the longest one) ?",
						   read => 'value = 3.09897e-05',
						   write => "printparameter /Purkinje/segments/b3s37[17] LENGTH",
						  },
						  {
						   description => "What is the length of the first spine neck ?",
						   read => 'value = 6.6e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck LENGTH",
						  },
						  {
						   description => "What is the length of the first spine head ?",
						   read => 'value = 6.8036e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head LENGTH",
						  },
						  {
						   description => "What is the somatopetal distance of the soma ?",
						   read => 'value = 0',
						   write => "printparameter /Purkinje/segments/soma SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the first main segment ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the second main segment ?",
						   read => 'value = 3.797e-05',
						   write => "printparameter /Purkinje/segments/main[1] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of a spiny dendrite ?",
						   read => 'value = 4.41302e-05',
						   write => "printparameter /Purkinje/segments/b0s01[0] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of a spiny dendrite ?",
						   read => 'value = 4.63502e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the spine neck for the previous dendritic segment ?",
						   read => 'value = 4.70102e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the spine head for the previous dendritic segment ?",
						   read => 'value = 4.76906e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head SOMATOPETAL_DISTANCE",
						  },
						  {
						   comment => "this value is close to the value in table 2 of the Rapp paper, when shrinkage correction is not applied and spines are not added, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total dendritic length of the purkinje cell ?",
						   read => 'value = 0.0140198',
						   write => "printparameter /Purkinje TOTALLENGTH",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total dendritic length of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 0.0140198',
						   write => "printparameter /Purkinje/segments TOTALLENGTH",
						  },
						  {
						   comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total surface of the purkinje cell ?",
						   read => 'value = 2.61206e-07',
						   write => "printparameter /Purkinje TOTALSURFACE",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total surface of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 2.61206e-07',
						   write => "printparameter /Purkinje/segments TOTALSURFACE",
						  },
						  {
						   comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total volume of the purkinje cell ?",
						   read => 'value = 5.39527e-14',
						   write => "printparameter /Purkinje TOTALVOLUME",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total volume of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 5.39527e-14',
						   write => "printparameter /Purkinje/segments TOTALVOLUME",
						  },
						  {
						   description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						   read => '800',
						   write => "printparameter /Purkinje/segments/b0s01[1]/KC G_MAX",
						  },
						  {
						   description => "Is conductance scaling done correctly ?",
						   read => '1.27212e-08',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1]/KC G_MAX",
						  },
						  {
						   description => "Can we find spines in the model purkinje cell ?",
						   read => '/Purkinje/segments/b0s01[1]/Purkinje_spine_0
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par/synapse
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par/exp2
',
						   write => "expand /Purkinje/segments/b0s01[1]/Purkinje_spine_0/**",
						  },
						  {
						   description => "What are the forestspace IDs for the spine neck ?",
						   read => 'Traversal serial ID = 1139
Principal serial ID = 1139 of 25525 Principal successors
',
# Mechanism serial ID = 656 of 12914 Mechanism successors
# Segment  serial  ID = 73 of 4548  Segment  successors
						   write => "serialMapping /Purkinje Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						  {
						   comment => 'note the differences when using G2 tabchans, G3 ns-sli and plain G3',
						   description => "What are the forestspace IDs for the segment b0s01[1] ?",
						   read => 'Traversal serial ID = 1128
Principal serial ID = 1128 of 25525 Principal successors
',
# Mechanism serial ID = 649 of 12914 Mechanism successors
# Segment  serial  ID = 72 of 4548  Segment  successors
						   write => "serialMapping /Purkinje Purkinje/segments/b0s01[1]",
						  },
						  {
						   description => "Can we assign a solver to the purkinje cell ?",
						   read => undef,
						   write => "solverset /Purkinje purk_solver",
						  },
						  {
						   description => "Can the solver for the spine neck be found, is it the one we just assigned to it ?",
						   read => 'Solver = purk_solver, solver serial ID = 1139
Solver serial context for 1139 = 
	/Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck
',
						   write => "resolvesolver /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						 ],
				description => "elementary tests for the purkinje cell model with genesis alike channels",
			       },
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
						   description => "What is the length of the first main segment ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0] LENGTH",
						  },
						  {
						   description => "What is the length of the second main segment ?",
						   read => 'value = 2.35003e-05',
						   write => "printparameter /Purkinje/segments/main[1] LENGTH",
						  },
						  {
						   description => "What is the length of the first spiny dendrite ?",
						   read => 'value = 6.16021e-06',
						   write => "printparameter /Purkinje/segments/b0s01[0] LENGTH",
						  },
						  {
						   description => "What is the length of the second spiny dendrite ?",
						   read => 'value = 2.22e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						  },
						  {
						   description => "What is the length of one of the spinyd dendrites (the longest one) ?",
						   read => 'value = 3.09897e-05',
						   write => "printparameter /Purkinje/segments/b3s37[17] LENGTH",
						  },
						  {
						   description => "What is the length of the first spine neck ?",
						   read => 'value = 6.6e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck LENGTH",
						  },
						  {
						   description => "What is the length of the first spine head ?",
						   read => 'value = 6.8036e-07',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head LENGTH",
						  },
						  {
						   description => "What is the somatopetal distance of the soma ?",
						   read => 'value = 0',
						   write => "printparameter /Purkinje/segments/soma SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the first main segment ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the second main segment ?",
						   read => 'value = 3.797e-05',
						   write => "printparameter /Purkinje/segments/main[1] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of a spiny dendrite ?",
						   read => 'value = 4.41302e-05',
						   write => "printparameter /Purkinje/segments/b0s01[0] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of a spiny dendrite ?",
						   read => 'value = 4.63502e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the spine neck for the previous dendritic segment ?",
						   read => 'value = 4.70102e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the spine head for the previous dendritic segment ?",
						   read => 'value = 4.76906e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head SOMATOPETAL_DISTANCE",
						  },
						  {
						   comment => "this value is close to the value in table 2 of the Rapp paper, when shrinkage correction is not applied and spines are not added, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total dendritic length of the purkinje cell ?",
						   read => 'value = 0.0140198',
						   write => "printparameter /Purkinje TOTALLENGTH",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total dendritic length of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 0.0140198',
						   write => "printparameter /Purkinje/segments TOTALLENGTH",
						  },
						  {
						   comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total surface of the purkinje cell ?",
						   read => 'value = 2.61206e-07',
						   write => "printparameter /Purkinje TOTALSURFACE",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total surface of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 2.61206e-07',
						   write => "printparameter /Purkinje/segments TOTALSURFACE",
						  },
						  {
						   comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total volume of the purkinje cell ?",
						   read => 'value = 5.39527e-14',
						   write => "printparameter /Purkinje TOTALVOLUME",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total volume of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 5.39527e-14',
						   write => "printparameter /Purkinje/segments TOTALVOLUME",
						  },
						  {
						   description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						   read => '800',
						   write => "printparameter /Purkinje/segments/b0s01[1]/kc G_MAX",
						  },
						  {
						   description => "Is conductance scaling done correctly ?",
						   read => '1.27212e-08',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1]/kc G_MAX",
						  },
						  {
						   description => "Can we find spines in the model purkinje cell ?",
						   read => '/Purkinje/segments/b0s01[1]/Purkinje_spine_0
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par/synapse
- /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head/par/exp2
',
						   write => "expand /Purkinje/segments/b0s01[1]/Purkinje_spine_0/**",
						  },
						  {
						   description => "What are the forestspace IDs for the spine neck ?",
						   read => 'Traversal serial ID = 3036
Principal serial ID = 3036 of 65622 Principal successors
',
						   write => "serialMapping /Purkinje Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						  {
						   comment => 'note the differences when using G2 tabchans, G3 ns-sli and plain G3',
						   description => "What are the forestspace IDs for the segment b0s01[1] ?",
						   read => 'Traversal serial ID = 3000
Principal serial ID = 3000 of 65622 Principal successors
',
						   write => "serialMapping /Purkinje Purkinje/segments/b0s01[1]",
						  },
						  {
						   description => "Can we assign a solver to the purkinje cell ?",
						   read => undef,
						   write => "solverset /Purkinje purk_solver",
						  },
						  {
						   description => "Can the solver for the spine neck be found, is it the one we just assigned to it ?",
						   read => 'Solver = purk_solver, solver serial ID = 3036
Solver serial context for 3036 = 
	/Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck
',
						   write => "resolvesolver /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						 ],
				description => "elementary tests for the purkinje cell model with parameterized channels",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'cells/purkinje/edsjb1994_spinesurface.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/purkinje/edsjb1994_spinesurface.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "What is the length of the first main segment ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0] LENGTH",
						  },
						  {
						   description => "What is the length of the second main segment ?",
						   read => 'value = 2.35003e-05',
						   write => "printparameter /Purkinje/segments/main[1] LENGTH",
						  },
						  {
						   description => "What is the length of the first spiny dendrite ?",
						   read => 'value = 6.16021e-06',
						   write => "printparameter /Purkinje/segments/b0s01[0] LENGTH",
						  },
						  {
						   description => "What is the length of the second spiny dendrite ?",
						   read => 'value = 2.22e-06',
						   write => "printparameter /Purkinje/segments/b0s01[1] LENGTH",
						  },
						  {
						   description => "What is the length of one of the spinyd dendrites (the longest one) ?",
						   read => 'value = 3.09897e-05',
						   write => "printparameter /Purkinje/segments/b3s37[17] LENGTH",
						  },
						  {
						   description => "What is the length of the first spine neck ?",
						   read => 'symbol not found',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck LENGTH",
						  },
						  {
						   description => "What is the length of the first spine head ?",
						   read => 'symbol not found',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head LENGTH",
						  },
						  {
						   description => "What is the somatopetal distance of the soma ?",
						   read => 'value = 0',
						   write => "printparameter /Purkinje/segments/soma SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the first main segment ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the second main segment ?",
						   read => 'value = 3.797e-05',
						   write => "printparameter /Purkinje/segments/main[1] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of a spiny dendrite ?",
						   read => 'value = 4.41302e-05',
						   write => "printparameter /Purkinje/segments/b0s01[0] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of a spiny dendrite ?",
						   read => 'value = 4.63502e-05',
						   write => "printparameter /Purkinje/segments/b0s01[1] SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the spine neck for the previous dendritic segment ?",
						   read => 'symbol not found',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck SOMATOPETAL_DISTANCE",
						  },
						  {
						   description => "What is the somatopetal distance of the spine head for the previous dendritic segment ?",
						   read => 'symbol not found',
						   write => "printparameter /Purkinje/segments/b0s01[1]/Purkinje_spine_0/head SOMATOPETAL_DISTANCE",
						  },
						  {
						   comment => "this value is close to the value in table 2 of the Rapp paper, when shrinkage correction is not applied and spines are not added, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total dendritic length of the purkinje cell ?",
						   read => 'value = 0.0120441',
						   write => "printparameter /Purkinje TOTALLENGTH",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total dendritic length of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 0.0120441',
						   write => "printparameter /Purkinje/segments TOTALLENGTH",
						  },
						  {
						   comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total surface of the purkinje cell ?",
						   read => 'value = 2.61092e-07',
						   write => "printparameter /Purkinje TOTALSURFACE",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total surface of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 2.61092e-07',
						   write => "printparameter /Purkinje/segments TOTALSURFACE",
						  },
						  {
						   comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						   description => "What is the total volume of the purkinje cell ?",
						   read => 'value = 5.37774e-14',
						   write => "printparameter /Purkinje TOTALVOLUME",
						  },
						  {
						   comment => "See developer TODOs",
						   description => "What is the total volume of all the segments the purkinje cell ?",
						   disabled => "See developer TODOs",
						   read => 'value = 5.37774e-14',
						   write => "printparameter /Purkinje/segments TOTALVOLUME",
						  },
						  {
						   description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						   read => '800',
						   write => "printparameter /Purkinje/segments/b0s01[1]/kc G_MAX",
						  },
						  {
						   description => "Is conductance scaling done correctly ?",
						   read => '1.27212e-08',
						   write => "printparameterscaled /Purkinje/segments/b0s01[1]/kc G_MAX",
						  },
						  {
						   description => "Can we find spines in the model purkinje cell ?",
						   read => '
',
						   write => "expand /Purkinje/segments/b0s01[1]/Purkinje_spine_0/**",
						  },
						  {
						   description => "What are the forestspace IDs for the spine neck ?",
						   read => 'symbol not found',
						   write => "serialMapping /Purkinje Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						  {
						   comment => 'note the differences when using G2 tabchans, G3 ns-sli and plain G3',
						   description => "What are the forestspace IDs for the segment b0s01[1] ?",
						   read => 'Traversal serial ID = 3000
Principal serial ID = 3000 of 56778 Principal successors
',
						   write => "serialMapping /Purkinje Purkinje/segments/b0s01[1]",
						  },
						  {
						   description => "Can we assign a solver to the purkinje cell ?",
						   write => "solverset /Purkinje purk_solver",
						  },
						  {
						   description => "Can the solver for the spine neck be found, is it the one we just assigned to it ?",
						   read => 'symbol not found',
						   write => "resolvesolver /Purkinje/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						 ],
				description => "elementary tests for the purkinje cell model with parameterized channels",
			       },
			      ],
       description => "EDS purkinje cell model",
       name => 'purkinje.t',
      };


return $test;


