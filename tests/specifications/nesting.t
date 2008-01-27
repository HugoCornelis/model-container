#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'legacy/networks/supernetwork.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/supernetwork.ndf.', ],
						   timeout => 100,
						   write => undef,
						  },
						  {
						   description => "What is the root namespace ?",
						   read => 'File (/tmp/neurospaces/test/models/legacy/networks/network.ndf) --> Namespace (Network_base::)
',
						   write => "namespaces",
						  },
						  {
						   description => "What are the nested namespaces ?",
						   read => 'File (/tmp/neurospaces/test/models/legacy/populations/purkinje.ndf) --> Namespace (Purkinje::)
File (/tmp/neurospaces/test/models/legacy/populations/granule.ndf) --> Namespace (Granule::)
File (/tmp/neurospaces/test/models/legacy/populations/golgi.ndf) --> Namespace (Golgi::)
File (/tmp/neurospaces/test/models/fibers/mossyfiber.ndf) --> Namespace (Fibers::)
',
						   write => "namespaces Network_base::",
						  },
						  {
						   description => "Do we find subnetworks and no inputs in the main network ?",
						   read => 'children (if any) :
Child 0 : 0,T_sym_network
Child 1 : 1,T_sym_network
Child 2 : 2,T_sym_network
Child 3 : 3,T_sym_network
Child 4 : 4,T_sym_network
Child 5 : 5,T_sym_network
Child 6 : 6,T_sym_network
Child 7 : 7,T_sym_network
Child 8 : 8,T_sym_network
Child 9 : NetworkGrid,T_sym_algorithm_symbol
inputs (if any) :
 neurospaces ',
						   timeout => 10,
						   write => "childreninfo /CerebellarCortex",
						  },
						  {
						   description => "How many cells do we have in total ?",
						   read => '56394',
						   write => "cellcount /CerebellarCortex",
						  },
						  {
						   description => "How many cells do we have in network 0 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/0",
						  },
						  {
						   description => "How many cells do we have in network 1 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/1",
						  },
						  {
						   description => "How many cells do we have in network 2 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/2",
						  },
						  {
						   description => "How many cells do we have in network 3 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/3",
						  },
						  {
						   description => "How many cells do we have in network 4 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/4",
						  },
						  {
						   description => "How many cells do we have in network 5 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/5",
						  },
						  {
						   description => "How many cells do we have in network 6 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/6",
						  },
						  {
						   description => "How many cells do we have in network 7 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/7",
						  },
						  {
						   description => "How many cells do we have in network 8 ?",
						   read => '6266',
						   write => "cellcount /CerebellarCortex/8",
						  },
						  {
						   description => "How many segments do we have in total ?",
						   read => '301932',
						   write => "segmentcount /CerebellarCortex",
						  },
						  {
						   description => "How many segments do we have in network 0 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/0",
						  },
						  {
						   description => "How many segments do we have in network 1 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/1",
						  },
						  {
						   description => "How many segments do we have in network 2 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/2",
						  },
						  {
						   description => "How many segments do we have in network 3 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/3",
						  },
						  {
						   description => "How many segments do we have in network 4 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/4",
						  },
						  {
						   description => "How many segments do we have in network 5 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/5",
						  },
						  {
						   description => "How many segments do we have in network 6 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/6",
						  },
						  {
						   description => "How many segments do we have in network 7 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/7",
						  },
						  {
						   description => "How many segments do we have in network 8 ?",
						   read => '33548',
						   write => "segmentcount /CerebellarCortex/8",
						  },
						  {
						   description => "Can we succesfully initialize a projectionquery that indexes all projections ?",
						   read => "caching = yes
",
						   timeout => 20,
						   write => "pqsetall c",
						  },
						  {
						   description => "Can we succesfully reinitialize a projectionquery that indexes all projections ?",
						   read => "caching = yes
",
						   timeout => 20,
						   write => "pqsetall c",
						  },
						  {
						   description => "Can we succesfully reinitialize a projectionquery that indexes all projections ?",
						   read => "caching = yes
",
						   timeout => 20,
						   write => "pqsetall c",
						  },
						  {
						   description => "How many connections do we have on the first subnetwork, second mossy fiber ?",
						   read => '#connections = 1060
',
#memory used by projection query = 21408584
#memory used by connection cache = 10703532
#memory used by ordered cache 1  = 5351780
#memory used by ordered cache 2  = 5351780
						   timeout => 20,
						   write => "pqcount c /CerebellarCortex/0/MossyFibers/1/spikegen",
						  },
						  {
						   description => "How many connections do we have on the first subnetwork, granule cell 5481, mossy fiber AMPA channel ?",
						   read => '#connections = 4
',
#memory used by projection query = 21408584
#memory used by connection cache = 10703532
#memory used by ordered cache 1  = 5351780
#memory used by ordered cache 2  = 5351780
						   timeout => 10,
						   write => "pqcount c /CerebellarCortex/0/Granules/5481/Granule_soma/mf_AMPA/synapse",
						  },
						  {
						   description => "How many connections do we have on the first subnetwork, granule cell 481, mossy fiber AMPA channel ?",
						   read => '#connections = 4
',
#memory used by projection query = 21408584
#memory used by connection cache = 10703532
#memory used by ordered cache 1  = 5351780
#memory used by ordered cache 2  = 5351780
						   write => "pqcount c /CerebellarCortex/0/Granules/481/Granule_soma/mf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 0 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/0/ForwardProjection /CerebellarCortex/0/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 1 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/1/ForwardProjection /CerebellarCortex/1/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 2 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/2/ForwardProjection /CerebellarCortex/2/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 3 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/3/ForwardProjection /CerebellarCortex/3/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 4 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/4/ForwardProjection /CerebellarCortex/4/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 5 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/5/ForwardProjection /CerebellarCortex/5/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 6 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/6/ForwardProjection /CerebellarCortex/6/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 7 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/7/ForwardProjection /CerebellarCortex/7/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell in network 8 ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/8/ForwardProjection /CerebellarCortex/8/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },

						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 0 and 1 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/0/ForwardProjection /CerebellarCortex/1/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 1 and 2 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/1/ForwardProjection /CerebellarCortex/2/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 2 and 3 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/2/ForwardProjection /CerebellarCortex/3/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 3 and 4 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/3/ForwardProjection /CerebellarCortex/4/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 4 and 5 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/4/ForwardProjection /CerebellarCortex/5/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 5 and 6 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/5/ForwardProjection /CerebellarCortex/6/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 6 and 7 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/6/ForwardProjection /CerebellarCortex/7/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 7 and 8 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/7/ForwardProjection /CerebellarCortex/8/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell if we cross network 8 and 0 ?",
						   read => 'Number of connections : 0
',
						   write => "spikereceivercount /CerebellarCortex/8/ForwardProjection /CerebellarCortex/0/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						 ],
				description => "population, cell count, projections and connections",
			       },
			      ],
       description => "nesting of networks",
       name => 'nesting.t',
      };


return $test;


