#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'populations/granule.ndf',
					     ],
				command => './neurospacesparse',
				description => "force a reload of the network",
			       },
			       {
				arguments => [
					      '-q',
					      'populations/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						  {
						   description => "How many granule cells do we have ?",
						   read => 'Number of cells : 14400
',
						   write => "cellcount /GranulePopulation",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done ?",
						   read => [
							    "-re",
							    "---
number_of_algorithm_classes: 7
---
name: ConnectionCheckerClass
report:
    number_of_created_instances: 0
---
name: RandomizeClass
report:
    number_of_created_instances: 0
---
name: SpinesClass
report:
    number_of_created_instances: 0
---
name: ProjectionRandomizedClass
report:
    number_of_created_instances: 0
---
name: ProjectionVolumeClass
report:
    number_of_created_instances: 0
---
name: InserterClass
report:
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 1
---
number_of_algorithm_instances: 1
---
name: Grid3DInstance GranuleGrid
report:
    number_of_created_components: 14400
    Grid3DInstance_prototype: Granule_cell
    Grid3DInstance_options: 160 0.000050 18 0.000038 5 0.900000
",
							   ],
						   write => "algorithmset",
						  },
						 ],
				description => "increase number of references (cells)",
				preparation => {
						description => "Creating a population with 14400 cells",
						preparer =>
						sub
						{
						    `perl -pi -e "s/X_COUNT = 120.0/X_COUNT = 160.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/X_DISTANCE = 2.5e-05/X_DISTANCE = 5e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_COUNT = 26.0/Y_COUNT = 18.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_DISTANCE = 1.875e-05/Y_DISTANCE = 3.75e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_COUNT = 2.0/Z_COUNT = 5.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_DISTANCE = 2e-5/Z_DISTANCE = 0.9/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						},
					       },
				reparation => {
					       description => "Restoring old population",
					       reparer =>
					       sub
					       {
						    `perl -pi -e "s/X_COUNT = 160.0/X_COUNT = 120.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/X_DISTANCE = 5e-05/X_DISTANCE = 2.5e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_COUNT = 18.0/Y_COUNT = 26.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_DISTANCE = 3.75e-05/Y_DISTANCE = 1.875e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_COUNT = 5.0/Z_COUNT = 2.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_DISTANCE = 0.9/Z_DISTANCE = 2e-5/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
					       },
					      },
				side_effects => 1,
			       },
			       {
				arguments => [
					      '-q',
					      'populations/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						  {
						   description => "How many granule cells do we have ?",
						   read => 'Number of cells : 1
',
						   write => "cellcount /GranulePopulation",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done ?",
						   read => [
							    "-re",
							    "---
number_of_algorithm_classes: 7
---
name: ConnectionCheckerClass
report:
    number_of_created_instances: 0
---
name: RandomizeClass
report:
    number_of_created_instances: 0
---
name: SpinesClass
report:
    number_of_created_instances: 0
---
name: ProjectionRandomizedClass
report:
    number_of_created_instances: 0
---
name: ProjectionVolumeClass
report:
    number_of_created_instances: 0
---
name: InserterClass
report:
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 1
---
number_of_algorithm_instances: 1
---
name: Grid3DInstance GranuleGrid
report:
    number_of_created_components: 1
    Grid3DInstance_prototype: Granule_cell
    Grid3DInstance_options: 1 0.000050 1 0.000038 1 0.900000
",

							   ],
						   write => "algorithmset",
						  },
						 ],
				description => "boundary condition : one reference",
				preparation => {
						description => "Creating a population with one cell",
						preparer =>
						sub
						{
						    `perl -pi -e "s/X_COUNT = 120.0/X_COUNT = 1.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/X_DISTANCE = 2.5e-05/X_DISTANCE = 5e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_COUNT = 26.0/Y_COUNT = 1.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_DISTANCE = 1.875e-05/Y_DISTANCE = 3.75e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_COUNT = 2.0/Z_COUNT = 1.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_DISTANCE = 2e-5/Z_DISTANCE = 0.9/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						},
					       },
				reparation => {
					       description => "Restoring old population",
					       reparer =>
					       sub
					       {
						    `perl -pi -e "s/X_COUNT = 1.0/X_COUNT = 120.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/X_DISTANCE = 5e-05/X_DISTANCE = 2.5e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_COUNT = 1.0/Y_COUNT = 26.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_DISTANCE = 3.75e-05/Y_DISTANCE = 1.875e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_COUNT = 1.0/Z_COUNT = 2.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_DISTANCE = 0.9/Z_DISTANCE = 2e-5/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
					       },
					      },
				side_effects => 1,
			       },
			       {
				arguments => [
					      '-q',
					      'populations/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/populations/granule.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						  {
						   description => "How many granule cells do we have ?",
						   read => 'Number of cells : 0
',
						   write => "cellcount /GranulePopulation",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done ?",
						   read => [
							    "-re",
							    "---
number_of_algorithm_classes: 7
---
name: ConnectionCheckerClass
report:
    number_of_created_instances: 0
---
name: RandomizeClass
report:
    number_of_created_instances: 0
---
name: SpinesClass
report:
    number_of_created_instances: 0
---
name: ProjectionRandomizedClass
report:
    number_of_created_instances: 0
---
name: ProjectionVolumeClass
report:
    number_of_created_instances: 0
---
name: InserterClass
report:
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 1
---
number_of_algorithm_instances: 1
---
name: Grid3DInstance GranuleGrid
report:
    number_of_created_components: 0
    Grid3DInstance_prototype: Granule_cell
    Grid3DInstance_options: 0 0.000050 8 0.000038 1 0.900000
",
							   ],
						   write => "algorithmset",
						  },
						 ],
				description => "boundary condition : no references",
				preparation => {
						description => "Creating a population without cells",
						preparer =>
						sub
						{
						    `perl -pi -e "s/X_COUNT = 120.0/X_COUNT = 0.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/X_DISTANCE = 2.5e-05/X_DISTANCE = 5e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_COUNT = 26.0/Y_COUNT = 8.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_DISTANCE = 1.875e-05/Y_DISTANCE = 3.75e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_COUNT = 2.0/Z_COUNT = 1.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_DISTANCE = 2e-5/Z_DISTANCE = 0.9/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						},
					       },
				reparation => {
					       description => "Restoring old population",
					       reparer =>
					       sub
					       {
						    `perl -pi -e "s/X_COUNT = 0.0/X_COUNT = 120.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/X_DISTANCE = 5e-05/X_DISTANCE = 2.5e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_COUNT = 8.0/Y_COUNT = 26.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Y_DISTANCE = 3.75e-05/Y_DISTANCE = 1.875e-05/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_COUNT = 1.0/Z_COUNT = 2.0/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
						    `perl -pi -e "s/Z_DISTANCE = 0.9/Z_DISTANCE = 2e-5/;" /tmp/neurospaces/test/models/populations/granule.ndf `;
					       },
					      },
				side_effects => 1,
			       },
			      ],
       description => "grid algorithm",
       name => 'grid.t',
      };


return $test;


