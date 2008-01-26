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
						   description => "Load the projectionquery cache.",
						   read => "neurospaces ",
						   write => "pqload c projectionqueries/complete",
						  },
						  {
						   description => "Are the projectionquery flags ok, have ordered caches been built ?",
						   read => "bCaching(TRUE)
pcc(available)
pcc->iConnections(424161)
poccPre(available)
poccPost(available)
iCloned(0)
iCursor(100000)
",
						   #! uh ?!?, large timeout needed, but only during tests.

						   timeout => 10,
						   write => "pqget",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery cache, caching mode ?",
						   read => "#connections = 424161
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount c",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery cache, non-cache mode ?",
						   read => "#connections = 0
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount n",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's domain mapper, caching mode ?",
						   read => "#connections = 624
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's domain mapper, non-caching mode ?",
						   read => "#connections = 0
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount n /CerebellarCortex/Golgis/0/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's parallel fiber synapse, caching mode ?",
						   read => "#connections = 4452
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount c /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's parallel fiber synapse, non-caching mode ?",
						   read => "#connections = 0
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount n /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for a synapse in the fifth purkinje cell, caching mode ?",
						   read => "#connections = 32
",
#memory used by projection query = 6786680
#memory used by connection cache = 3393300
#memory used by ordered cache 1  = 1696664
#memory used by ordered cache 2  = 1696664
						   write => "pqcount c /CerebellarCortex/Purkinjes/5/segments/b0s03[24]/Purkinje_spine_0/head/par/synapse",
						  },
						  {
						   description => "Are the connections in the defined projectionquery for a synapse in the fifth purkinje cell properly defined, caching mode ?",
						   read => "Connection (00000)
        CCONN  pre(4123.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000723,2.000000)

Connection (00001)
        CCONN  pre(7533.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002088,2.000000)

Connection (00002)
        CCONN  pre(9711.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001117,2.000000)

Connection (00003)
        CCONN  pre(12813.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002067,2.000000)

Connection (00004)
        CCONN  pre(15937.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002957,2.000000)

Connection (00005)
        CCONN  pre(19765.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000512,2.000000)

Connection (00006)
        CCONN  pre(23967.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002693,2.000000)

Connection (00007)
        CCONN  pre(25045.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000448,2.000000)

Connection (00008)
        CCONN  pre(25881.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001731,2.000000)

Connection (00009)
        CCONN  pre(30039.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000923,2.000000)

Connection (00010)
        CCONN  pre(32481.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001346,2.000000)

Connection (00011)
        CCONN  pre(41061.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000273,2.000000)

Connection (00012)
        CCONN  pre(42359.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002869,2.000000)

Connection (00013)
        CCONN  pre(48981.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000234,2.000000)

Connection (00014)
        CCONN  pre(50015.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002540,2.000000)

Connection (00015)
        CCONN  pre(53623.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001272,2.000000)

Connection (00016)
        CCONN  pre(56285.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001225,2.000000)

Connection (00017)
        CCONN  pre(59057.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000932,2.000000)

Connection (00018)
        CCONN  pre(66031.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002945,2.000000)

Connection (00019)
        CCONN  pre(68759.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002952,2.000000)

Connection (00020)
        CCONN  pre(70035.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000714,2.000000)

Connection (00021)
        CCONN  pre(73709.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002480,2.000000)

Connection (00022)
        CCONN  pre(74171.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002643,2.000000)

Connection (00023)
        CCONN  pre(78021.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000630,2.000000)

Connection (00024)
        CCONN  pre(94939.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002663,2.000000)

Connection (00025)
        CCONN  pre(96193.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000620,2.000000)

Connection (00026)
        CCONN  pre(118787.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002838,2.000000)

Connection (00027)
        CCONN  pre(121053.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001988,2.000000)

Connection (00028)
        CCONN  pre(133967.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001353,2.000000)

Connection (00029)
        CCONN  pre(136409.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.000921,2.000000)

Connection (00030)
        CCONN  pre(136629.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.001408,2.000000)

Connection (00031)
        CCONN  pre(137113.000000) -> post(270536.000000)
        CCONN  Delay, Weight (0.002498,2.000000)

",
						   write => "pqtraverse c /CerebellarCortex/Purkinjes/5/segments/b0s03[24]/Purkinje_spine_0/head/par/synapse",
						  },
						 ],
				description => "projection query caches : saving, loading and examination of projection queries",
			       },
			      ],
       description => "projection query caching",
       name => 'projectionquery.t',
      };


return $test;


