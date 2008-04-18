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
						   description => "How many granule cells do we have ?",
						   read => 'Number of cells : 6240
',
						   write => "cellcount /CerebellarCortex/Granules",
						  },
						  {
						   description => "How many compartments do the granule cells have in total ?",
						   read => 'Number of segments : 6240
',
						   write => "segmentcount /CerebellarCortex/Granules",
						  },
						  {
						   description => "How does neurospaces react if we try to access parameters that are not defined ?",
						   read => "parameter not found in symbol
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Emax",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, ConnectionCheckerClass ?",
						   read => [
							    "-re",
							    "---
name: ConnectionCheckerClass
report:
    number_of_created_instances: 3
",
							   ],
						   write => "algorithmclass ConnectionChecker",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, RandomizeClass ?",
						   read => [
							    "-re",
							    "---
name: RandomizeClass
report:
    number_of_created_instances: 2
",
							   ],
						   write => "algorithmclass Randomize",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, SpinesClass ?",
						   read => [
							    "-re",
							    "---
name: SpinesClass
report:
    number_of_created_instances: 1
",
							   ],
						   write => "algorithmclass Spines",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, ProjectionRandomizedClass ?",
						   read => [
							    "-re",
							    "---
name: ProjectionRandomizedClass
report:
    number_of_created_instances: 0
",
							   ],
						   write => "algorithmclass ProjectionRandomized",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, ProjectionVolumeClass ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeClass
report:
    number_of_created_instances: 6
",
							   ],
						   write => "algorithmclass ProjectionVolume",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Grid3DClass ?",
						   read => [
							    "-re",
							    "---
name: Grid3DClass
report:
    number_of_created_instances: 4
",
							   ],
						   write => "algorithmclass Grid3D",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Golgis2Granules_GABAB ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeInstance Golgis2Granules_GABAB
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 6240
    number_of_tries_adding_connections: 6240
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: GABAB
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: GABAB
    ProjectionVolumeInstance_weight: 9.000000
",
							   ],
						   write => "algorithminstance Golgis2Granules_GABAB",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Golgis2Granules_GABAA ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeInstance Golgis2Granules_GABAA
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 6240
    number_of_tries_adding_connections: 6240
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: GABAA
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: GABAA
    ProjectionVolumeInstance_weight: 45.000000
",
							   ],
						   write => "algorithminstance Golgis2Granules_GABAA",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Granules2Golgis ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeInstance Granules2Golgis
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 98112
    number_of_tries_adding_connections: 98112
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: ForwardProjection
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: pf_AMPA
    ProjectionVolumeInstance_weight: 45.000000
",
							   ],
						   write => "algorithminstance Granules2Golgis",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Mossies2Granules_AMPA ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeInstance Mossies2Granules_AMPA
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 18734
    number_of_tries_adding_connections: 18734
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: AMPA
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 0.306100
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: mf_AMPA
    ProjectionVolumeInstance_weight: 6.000000
",
							   ],
						   write => "algorithminstance Mossies2Granules_AMPA",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Mossies2Granules_NMDA ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeInstance Mossies2Granules_NMDA
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 18734
    number_of_tries_adding_connections: 18734
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: NMDA
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 0.306100
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: mf_NMDA
    ProjectionVolumeInstance_weight: 4.000000
",
							   ],
						   write => "algorithminstance Mossies2Granules_NMDA",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Mossies2Golgis ?",
						   read => [
							    "-re",
							    "---
name: ProjectionVolumeInstance Mossies2Golgis
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 600
    number_of_tries_adding_connections: 600
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: GolgiComponent
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: mf_AMPA
    ProjectionVolumeInstance_weight: 0.000000
",
							   ],
						   write => "algorithminstance Mossies2Golgis",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, ForwardProjection ?",
						   read => [
							    "-re",
							    "---
name: ConnectionCheckerInstance ForwardProjection
report:
    number_of_checked_connection_groups: 0
    number_of_checked_connections: 98112
    average_weight: 45.000000
    average_delay: 0.001967
    ConnectionCheckerInstance_network: CerebellarCortex
    ConnectionCheckerInstance_projection: ForwardProjection
",
							   ],
						   write => "algorithminstance ForwardProjection",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, BackwardProjectionB ?",
						   read => [
							    "-re",
							    "---
name: ConnectionCheckerInstance BackwardProjectionB
report:
    number_of_checked_connection_groups: 0
    number_of_checked_connections: 6240
    average_weight: 9.000000
    average_delay: 0.000000
    ConnectionCheckerInstance_network: CerebellarCortex
    ConnectionCheckerInstance_projection: GABAB
",
							   ],
						   write => "algorithminstance BackwardProjectionB",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, BackwardProjectionA ?",
						   read => [
							    "-re",
							    "---
name: ConnectionCheckerInstance BackwardProjectionA
report:
    number_of_checked_connection_groups: 0
    number_of_checked_connections: 6240
    average_weight: 45.000000
    average_delay: 0.000000
    ConnectionCheckerInstance_network: CerebellarCortex
    ConnectionCheckerInstance_projection: GABAA
",
							   ],
						   write => "algorithminstance BackwardProjectionA",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, PurkinjeGrid ?",
						   read => [
							    "-re",
							    "---
name: Grid3DInstance PurkinjeGrid
report:
    number_of_created_components: 6
    Grid3DInstance_prototype: Purkinje_cell
    Grid3DInstance_options: 3 0.000100 2 0.000200 1 0.900000
",
							   ],
						   write => "algorithminstance PurkinjeGrid",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, SpinesNormal_13_1 ?",
						   read => [
							    "-re",
							    "---
name: SpinesInstance SpinesNormal_13_1
report:
    number_of_added_spines: 1474
    number_of_virtual_spines: 142982.466417
    number_of_spiny_segments: 1474
    number_of_failures_adding_spines: 0
    SpinesInstance_prototype: Purkinje_spine
    SpinesInstance_surface: 1.33079e-12
",
							   ],
						   write => "algorithminstance SpinesNormal_13_1",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, GranuleGrid ?",
						   read => [
							    "-re",
							    "---
name: Grid3DInstance GranuleGrid
report:
    number_of_created_components: 6240
    Grid3DInstance_prototype: Granule_cell
    Grid3DInstance_options: 120 0.000025 26 0.000019 2 0.000020
",
							   ],
						   write => "algorithminstance GranuleGrid",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, GolgiGrid ?",
						   read => [
							    "-re",
							    "---
name: Grid3DInstance GolgiGrid
report:
    number_of_created_components: 20
    Grid3DInstance_prototype: Golgi_cell
    Grid3DInstance_options: 10 0.000300 2 0.000300 1 0.000040
",
							   ],
						   write => "algorithminstance GolgiGrid",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, Golgi_CaHVA ?",
						   read => [
							    "-re",
							    "---
name: RandomizeInstance Golgi_CaHVA
report:
    number_of_randomized_components: 20
    number_of_non-randomized_components_algorithm_symbols: 1
    number_of_non-randomized_components_unexpected: 0
    RandomizeInstance_prototype: CaHVA
    RandomizeInstance_options: Golgi_cell->G_MAX 213.000000 8.317569 9.317569
",
							   ],
						   write => "algorithminstance Golgi_CaHVA",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, GolgiLeak ?",
						   read => [
							    "-re",
							    "---
name: RandomizeInstance GolgiLeak
report:
    number_of_randomized_components: 20
    number_of_non-randomized_components_algorithm_symbols: 2
    number_of_non-randomized_components_unexpected: 0
    RandomizeInstance_prototype: Golgi_soma
    RandomizeInstance_options: Golgi_cell->ELEAK 213.000000 -0.060000 -0.050000
",
							   ],
						   write => "algorithminstance GolgiLeak",
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done, MossyGrid ?",
						   read => [
							    "-re",
							    "---
name: Grid3DInstance MossyGrid
report:
    number_of_created_components: 30
    Grid3DInstance_prototype: MossyFiber
    Grid3DInstance_options: 10 0.000360 3 0.000300 1 0.900000
",
							   ],
						   write => "algorithminstance MossyGrid",
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
    number_of_created_instances: 3
---
name: RandomizeClass
report:
    number_of_created_instances: 2
---
name: SpinesClass
report:
    number_of_created_instances: 1
---
name: ProjectionRandomizedClass
report:
    number_of_created_instances: 0
---
name: ProjectionVolumeClass
report:
    number_of_created_instances: 6
---
name: InserterClass
report:
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 4
---
number_of_algorithm_instances: 16
---
name: ProjectionVolumeInstance Golgis2Granules_GABAB
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 6240
    number_of_tries_adding_connections: 6240
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: GABAB
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: GABAB
    ProjectionVolumeInstance_weight: 9.000000
---
name: ProjectionVolumeInstance Golgis2Granules_GABAA
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 6240
    number_of_tries_adding_connections: 6240
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: GABAA
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: GABAA
    ProjectionVolumeInstance_weight: 45.000000
---
name: ProjectionVolumeInstance Granules2Golgis
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 98112
    number_of_tries_adding_connections: 98112
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: ForwardProjection
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: pf_AMPA
    ProjectionVolumeInstance_weight: 45.000000
---
name: ProjectionVolumeInstance Mossies2Granules_AMPA
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 18734
    number_of_tries_adding_connections: 18734
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: AMPA
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 0.306100
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: mf_AMPA
    ProjectionVolumeInstance_weight: 6.000000
---
name: ProjectionVolumeInstance Mossies2Granules_NMDA
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 18734
    number_of_tries_adding_connections: 18734
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: NMDA
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 0.306100
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: mf_NMDA
    ProjectionVolumeInstance_weight: 4.000000
---
name: ProjectionVolumeInstance Mossies2Golgis
report:
    number_of_added_connection_groups: 1
    number_of_added_connections: 600
    number_of_tries_adding_connections: 600
    number_of_failures_adding_connections: 0
    number_of_failures_generator_coordinates: 0
    number_of_failures_receiver_coordinates: 0
    ProjectionVolumeInstance_network: CerebellarCortex
    ProjectionVolumeInstance_projection: GolgiComponent
    ProjectionVolumeInstance_randomseed: 1212.000000
    ProjectionVolumeInstance_probability: 1.000000
    ProjectionVolumeInstance_pre: spikegen
    ProjectionVolumeInstance_post: mf_AMPA
    ProjectionVolumeInstance_weight: 0.000000
---
name: ConnectionCheckerInstance ForwardProjection
report:
    number_of_checked_connection_groups: 0
    number_of_checked_connections: 98112
    average_weight: 45.000000
    average_delay: 0.001967
    ConnectionCheckerInstance_network: CerebellarCortex
    ConnectionCheckerInstance_projection: ForwardProjection
---
name: ConnectionCheckerInstance BackwardProjectionB
report:
    number_of_checked_connection_groups: 0
    number_of_checked_connections: 6240
    average_weight: 9.000000
    average_delay: 0.000000
    ConnectionCheckerInstance_network: CerebellarCortex
    ConnectionCheckerInstance_projection: GABAB
---
name: ConnectionCheckerInstance BackwardProjectionA
report:
    number_of_checked_connection_groups: 0
    number_of_checked_connections: 6240
    average_weight: 45.000000
    average_delay: 0.000000
    ConnectionCheckerInstance_network: CerebellarCortex
    ConnectionCheckerInstance_projection: GABAA
---
name: Grid3DInstance PurkinjeGrid
report:
    number_of_created_components: 6
    Grid3DInstance_prototype: Purkinje_cell
    Grid3DInstance_options: 3 0.000100 2 0.000200 1 0.900000
---
name: SpinesInstance SpinesNormal_13_1
report:
    number_of_added_spines: 1474
    number_of_virtual_spines: 142982.466417
    number_of_spiny_segments: 1474
    number_of_failures_adding_spines: 0
    SpinesInstance_prototype: Purkinje_spine
    SpinesInstance_surface: 1.33079e-12
---
name: Grid3DInstance GranuleGrid
report:
    number_of_created_components: 6240
    Grid3DInstance_prototype: Granule_cell
    Grid3DInstance_options: 120 0.000025 26 0.000019 2 0.000020
---
name: Grid3DInstance GolgiGrid
report:
    number_of_created_components: 20
    Grid3DInstance_prototype: Golgi_cell
    Grid3DInstance_options: 10 0.000300 2 0.000300 1 0.000040
---
name: RandomizeInstance Golgi_CaHVA
report:
    number_of_randomized_components: 20
    number_of_non-randomized_components_algorithm_symbols: 1
    number_of_non-randomized_components_unexpected: 0
    RandomizeInstance_prototype: CaHVA
    RandomizeInstance_options: Golgi_cell->G_MAX 213.000000 8.317569 9.317569
---
name: RandomizeInstance GolgiLeak
report:
    number_of_randomized_components: 20
    number_of_non-randomized_components_algorithm_symbols: 2
    number_of_non-randomized_components_unexpected: 0
    RandomizeInstance_prototype: Golgi_soma
    RandomizeInstance_options: Golgi_cell->ELEAK 213.000000 -0.060000 -0.050000
---
name: Grid3DInstance MossyGrid
report:
    number_of_created_components: 30
    Grid3DInstance_prototype: MossyFiber
    Grid3DInstance_options: 10 0.000360 3 0.000300 1 0.900000
",
							   ],
						   write => "algorithmset",
						  },
						 ],
				description => "network model : algorithm instantiation and reporting.",
			       },
			      ],
       description => "algorithms",
       name => 'algorithms.t',
      };


return $test;


