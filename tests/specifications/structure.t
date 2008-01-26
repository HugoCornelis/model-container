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
						   description => "Describe the children of the soma of the first granule cell.",
						   read => "children (if any) :
Child 0 : spikegen,T_sym_attachment
Child 1 : InNa,T_sym_channel
Child 2 : Ca_pool,T_sym_pool
Child 3 : CaHVA,T_sym_channel
Child 4 : H,T_sym_channel
Child 5 : KA,T_sym_channel
Child 6 : KDr,T_sym_channel
Child 7 : Moczyd_KC,T_sym_channel
Child 8 : mf_AMPA,T_sym_channel
Child 9 : mf_NMDA,T_sym_channel
Child 10 : GABAA,T_sym_channel
Child 11 : GABAB,T_sym_channel
inputs (if any) :
Input 0 : CaHVA/I,T_sym_channel
Input 1 : H/I,T_sym_channel
Input 2 : InNa/I,T_sym_channel
Input 3 : KA/I,T_sym_channel
Input 4 : KDr/I,T_sym_channel
Input 5 : mf_NMDA/I,T_sym_channel
Input 6 : mf_AMPA/I,T_sym_channel
Input 7 : GABAA/I,T_sym_channel
Input 8 : GABAB/I,T_sym_channel
",
						   write => "childreninfo /CerebellarCortex/Granules/0/Granule_soma",
						  },
						  {
						   description => "Describe the children of the soma of the first Purkinje cell.",
						   read => "children (if any) :
inputs (if any) :
",
						   write => "childreninfo /CerebellarCortex/Purkinjes/0/segments/soma"
						  },
						  {
						   description => "Describe the children of the cerebellar cortex network.",
						   read => "children (if any) :
Child 0 : MossyFibers,T_sym_population
Child 1 : Granules,T_sym_population
Child 2 : Golgis,T_sym_population
Child 3 : Purkinjes,T_sym_population
Child 4 : MossyFiberProjection,T_sym_projection
Child 5 : ForwardProjection,T_sym_projection
Child 6 : BackwardProjection,T_sym_projection
Child 7 : ParallelFiberProjection,T_sym_projection
Child 8 : Golgis2Granules_GABAB,T_sym_algorithm_symbol
Child 9 : Golgis2Granules_GABAA,T_sym_algorithm_symbol
Child 10 : Granules2Golgis,T_sym_algorithm_symbol
Child 11 : Mossies2Granules_AMPA,T_sym_algorithm_symbol
Child 12 : Mossies2Granules_NMDA,T_sym_algorithm_symbol
Child 13 : Mossies2Golgis,T_sym_algorithm_symbol
Child 14 : ForwardProjection,T_sym_algorithm_symbol
Child 15 : BackwardProjectionB,T_sym_algorithm_symbol
Child 16 : BackwardProjectionA,T_sym_algorithm_symbol
inputs (if any) :
",
						   write => "childreninfo /CerebellarCortex"
						  },
						  {
						   description => "Describe the root namespaces, default arguments.",
						   read => "File (/tmp/neurospaces/test/models/populations/purkinje.ndf) --> Namespace (Purkinje::)
File (/tmp/neurospaces/test/models/populations/granule.ndf) --> Namespace (Granule::)
File (/tmp/neurospaces/test/models/populations/golgi.ndf) --> Namespace (Golgi::)
File (/tmp/neurospaces/test/models/fibers/mossyfiber.ndf) --> Namespace (Fibers::)
",
						   write => "namespaces"
						  },
						  {
						   description => "Describe the root namespaces, namespace explicitly given.",
						   read => "File (/tmp/neurospaces/test/models/populations/purkinje.ndf) --> Namespace (Purkinje::)
File (/tmp/neurospaces/test/models/populations/granule.ndf) --> Namespace (Granule::)
File (/tmp/neurospaces/test/models/populations/golgi.ndf) --> Namespace (Golgi::)
File (/tmp/neurospaces/test/models/fibers/mossyfiber.ndf) --> Namespace (Fibers::)
",
						   write => "namespaces ::"
						  },
						  {
						   description => "Describe the root namespaces, root explicitly given.",
						   read => "File (/tmp/neurospaces/test/models/populations/purkinje.ndf) --> Namespace (Purkinje::)
File (/tmp/neurospaces/test/models/populations/granule.ndf) --> Namespace (Granule::)
File (/tmp/neurospaces/test/models/populations/golgi.ndf) --> Namespace (Golgi::)
File (/tmp/neurospaces/test/models/fibers/mossyfiber.ndf) --> Namespace (Fibers::)
",
						   write => "namespaces ::/"
						  },
						  {
						   description => "What are the forestspace IDs for the spine neck ?",
						   read => "Traversal serial ID = 1139
Principal serial ID = 1139 of 153157 Principal successors
",
# Mechanism serial ID = 656 of 77484 Mechanism successors
# Segment  serial  ID = 73 of 27288  Segment  successors
						   write => "serialMapping /CerebellarCortex/Purkinjes /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						 ],
				description => "IO and treemodel structure correctness",
			       },
			      ],
       description => "internal data structures",
       name => 'structure.t',
      };


return $test;


