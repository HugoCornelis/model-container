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
						   description => "What is the number of connections on the AMPA channel of the first Golgi cell ?",
						   read => 'Number of connections : 4452
',
						   write => "spikereceivercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections on the domain translator of the second granule cell ?",
						   read => 'Number of connections : 8
',
						   write => "spikesendercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Granules/1/Granule_soma/spikegen",
						  },
						  {
						   description => "Do we have already solver registrations ?",

						   #t this is not wright, should be corrected

						   read => undef,
						   write => "solverregistrations",
						  },
						  {
						   description => "How many connections has the first granule cell's GABAA channel in the feedback projection ?",
						   read => '#connections = 1
',
						   write => "projectionquerycount c /CerebellarCortex/Granules/0/Granule_soma/GABAA/synapse /CerebellarCortex/BackwardProjection/GABAA",
						  },
						  {
						   description => "How many connections has the first granule cell's GABAB channel in the feedback projection ?",
						   read => '#connections = 1
',
						   write => "projectionquerycount c /CerebellarCortex/Granules/0/Granule_soma/GABAB/synapse /CerebellarCortex/BackwardProjection/GABAB",
						  },
						  {
						   description => "How many compartments do the granule cells have in total ?",
						   read => 'Number of segments : 6240
',
						   write => "segmentcount /CerebellarCortex/Granules",
						  },
						  {
						   description => "What is the solver for the granule population ?",

						   #t this is not wright, should be corrected

						   read => undef,
						   write => "solverinfo /CerebellarCortex/Granules",
						  },
						  {
						   description => "What is the treespaces ID of a synaptic channel on a spine of the first Purkinje cell ?",
						   read => 'serial ID = 1140
',
						   write => "serialID /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par",
						  },
						  {
						   description => "What is the treespaces ID of a synaptic channel on a spine of the second Purkinje cell ?",
						   read => "serial ID = 25522
",
						   write => "serialID /CerebellarCortex/Purkinjes/1 /CerebellarCortex/Purkinjes/1/segments/b3s46[15]/Purkinje_spine_0/head/par",
						  },
						  {
						   description => "What is the treespaces ID of the feedforward projection if we accidently make a typo ?",
						   read => "Get neurospaces C implementation prior to -r 405 to see what happens here.
	That version has connections with hardcoded serial IDs per connection.
",
						   write => "serialID /CerebellarCortex/ForwardProjection /CerebellarCortex",
						  },
						  {
						   description => "What is the treespaces ID of the feedforward projection ?",
						   read => "serial ID = 328933
",
						   write => "serialID /CerebellarCortex /CerebellarCortex/ForwardProjection",
						  },
						  {
						   description => "How does neurospaces react if we try to access parameters that are not defined ?",
						   read => "parameter not found in symbol
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Emax",
						  },
						  {
						   description => "What is the number of connections in the feedforward projection",
						   read => "Number of connections : 98112
",
						   write => "connectioncount /CerebellarCortex/ForwardProjection",
						  },
						  {
						   description => "Can we assign a solver to the granule population ?",
						   read => undef,
						   write => "solverset /CerebellarCortex/Granules /Granules",
						  },
						  {
						   description => "Can we assign a solver to the Golgi population ?",
						   read => undef,
						   write => "solverset /CerebellarCortex/Golgis /Golgis",
						  },
						  {
						   description => "Can we assign a solver to the first Purkinje cell ?",
						   read => undef,
						   write => "solverset /CerebellarCortex/Purkinjes/0 /Purkinje[0]",
						  },
						  {
						   description => "Can we assign a solver to the second Purkinje cell ?",
						   read => undef,
						   write => "solverset /CerebellarCortex/Purkinjes/1 /Purkinje[1]",
						  },
						  {
						   description => "Have the solvers been registered right ?",
						   read => "Solver registration 0 :
/CerebellarCortex/Granules/**
		Solved by (/Granules)

Solver registration 1 :
/CerebellarCortex/Golgis/**
		Solved by (/Golgis)

Solver registration 2 :
/CerebellarCortex/Purkinjes/0/**
		Solved by (/Purkinje[0])

Solver registration 3 :
/CerebellarCortex/Purkinjes/1/**
		Solved by (/Purkinje[1])
",
						   write => "solverregistrations",
						  },
						  {
						   description => "Can the solver for a synaptic channel of the first Purkinje cell be found, is it the one we just assigned to it ?",
						   read => "Solver = /Purkinje[0], solver serial ID = 1140
Solver serial context for 1140 = 
	/CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par
",
						   write => "resolvesolver /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par",
						  },
						  {
						   description => "What are the connections in the feedforward and feedback projections for the first Golgi cell's soma ?",
						   read => "Connection (00000)
        CCONN  pre(137379.000000) -> post(112.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00001)
        CCONN  pre(137379.000000) -> post(134.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00002)
        CCONN  pre(137379.000000) -> post(156.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00003)
        CCONN  pre(137379.000000) -> post(178.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00004)
        CCONN  pre(137379.000000) -> post(200.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00005)
        CCONN  pre(137379.000000) -> post(222.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00006)
        CCONN  pre(137379.000000) -> post(244.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00007)
        CCONN  pre(137379.000000) -> post(266.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00008)
        CCONN  pre(137379.000000) -> post(288.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00009)
        CCONN  pre(137379.000000) -> post(310.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00010)
        CCONN  pre(137379.000000) -> post(332.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00011)
        CCONN  pre(137379.000000) -> post(354.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00012)
        CCONN  pre(137379.000000) -> post(2752.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00013)
        CCONN  pre(137379.000000) -> post(2774.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00014)
        CCONN  pre(137379.000000) -> post(2796.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00015)
        CCONN  pre(137379.000000) -> post(2818.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00016)
        CCONN  pre(137379.000000) -> post(2840.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00017)
        CCONN  pre(137379.000000) -> post(2862.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00018)
        CCONN  pre(137379.000000) -> post(2884.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00019)
        CCONN  pre(137379.000000) -> post(2906.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00020)
        CCONN  pre(137379.000000) -> post(2928.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00021)
        CCONN  pre(137379.000000) -> post(2950.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00022)
        CCONN  pre(137379.000000) -> post(2972.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00023)
        CCONN  pre(137379.000000) -> post(2994.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00024)
        CCONN  pre(137379.000000) -> post(5392.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00025)
        CCONN  pre(137379.000000) -> post(5414.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00026)
        CCONN  pre(137379.000000) -> post(5436.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00027)
        CCONN  pre(137379.000000) -> post(5458.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00028)
        CCONN  pre(137379.000000) -> post(5480.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00029)
        CCONN  pre(137379.000000) -> post(5502.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00030)
        CCONN  pre(137379.000000) -> post(5524.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00031)
        CCONN  pre(137379.000000) -> post(5546.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00032)
        CCONN  pre(137379.000000) -> post(5568.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00033)
        CCONN  pre(137379.000000) -> post(5590.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00034)
        CCONN  pre(137379.000000) -> post(5612.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00035)
        CCONN  pre(137379.000000) -> post(5634.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00036)
        CCONN  pre(137379.000000) -> post(8032.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00037)
        CCONN  pre(137379.000000) -> post(8054.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00038)
        CCONN  pre(137379.000000) -> post(8076.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00039)
        CCONN  pre(137379.000000) -> post(8098.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00040)
        CCONN  pre(137379.000000) -> post(8120.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00041)
        CCONN  pre(137379.000000) -> post(8142.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00042)
        CCONN  pre(137379.000000) -> post(8164.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00043)
        CCONN  pre(137379.000000) -> post(8186.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00044)
        CCONN  pre(137379.000000) -> post(8208.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00045)
        CCONN  pre(137379.000000) -> post(8230.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00046)
        CCONN  pre(137379.000000) -> post(8252.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00047)
        CCONN  pre(137379.000000) -> post(8274.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00048)
        CCONN  pre(137379.000000) -> post(10672.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00049)
        CCONN  pre(137379.000000) -> post(10694.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00050)
        CCONN  pre(137379.000000) -> post(10716.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00051)
        CCONN  pre(137379.000000) -> post(10738.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00052)
        CCONN  pre(137379.000000) -> post(10760.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00053)
        CCONN  pre(137379.000000) -> post(10782.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00054)
        CCONN  pre(137379.000000) -> post(10804.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00055)
        CCONN  pre(137379.000000) -> post(10826.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00056)
        CCONN  pre(137379.000000) -> post(10848.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00057)
        CCONN  pre(137379.000000) -> post(10870.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00058)
        CCONN  pre(137379.000000) -> post(10892.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00059)
        CCONN  pre(137379.000000) -> post(10914.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00060)
        CCONN  pre(137379.000000) -> post(13312.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00061)
        CCONN  pre(137379.000000) -> post(13334.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00062)
        CCONN  pre(137379.000000) -> post(13356.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00063)
        CCONN  pre(137379.000000) -> post(13378.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00064)
        CCONN  pre(137379.000000) -> post(13400.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00065)
        CCONN  pre(137379.000000) -> post(13422.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00066)
        CCONN  pre(137379.000000) -> post(13444.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00067)
        CCONN  pre(137379.000000) -> post(13466.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00068)
        CCONN  pre(137379.000000) -> post(13488.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00069)
        CCONN  pre(137379.000000) -> post(13510.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00070)
        CCONN  pre(137379.000000) -> post(13532.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00071)
        CCONN  pre(137379.000000) -> post(13554.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00072)
        CCONN  pre(137379.000000) -> post(15952.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00073)
        CCONN  pre(137379.000000) -> post(15974.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00074)
        CCONN  pre(137379.000000) -> post(15996.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00075)
        CCONN  pre(137379.000000) -> post(16018.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00076)
        CCONN  pre(137379.000000) -> post(16040.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00077)
        CCONN  pre(137379.000000) -> post(16062.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00078)
        CCONN  pre(137379.000000) -> post(16084.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00079)
        CCONN  pre(137379.000000) -> post(16106.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00080)
        CCONN  pre(137379.000000) -> post(16128.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00081)
        CCONN  pre(137379.000000) -> post(16150.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00082)
        CCONN  pre(137379.000000) -> post(16172.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00083)
        CCONN  pre(137379.000000) -> post(16194.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00084)
        CCONN  pre(137379.000000) -> post(18592.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00085)
        CCONN  pre(137379.000000) -> post(18614.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00086)
        CCONN  pre(137379.000000) -> post(18636.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00087)
        CCONN  pre(137379.000000) -> post(18658.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00088)
        CCONN  pre(137379.000000) -> post(18680.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00089)
        CCONN  pre(137379.000000) -> post(18702.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00090)
        CCONN  pre(137379.000000) -> post(18724.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00091)
        CCONN  pre(137379.000000) -> post(18746.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00092)
        CCONN  pre(137379.000000) -> post(18768.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00093)
        CCONN  pre(137379.000000) -> post(18790.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00094)
        CCONN  pre(137379.000000) -> post(18812.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00095)
        CCONN  pre(137379.000000) -> post(18834.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00096)
        CCONN  pre(137379.000000) -> post(21232.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00097)
        CCONN  pre(137379.000000) -> post(21254.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00098)
        CCONN  pre(137379.000000) -> post(21276.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00099)
        CCONN  pre(137379.000000) -> post(21298.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00100)
        CCONN  pre(137379.000000) -> post(21320.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00101)
        CCONN  pre(137379.000000) -> post(21342.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00102)
        CCONN  pre(137379.000000) -> post(21364.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00103)
        CCONN  pre(137379.000000) -> post(21386.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00104)
        CCONN  pre(137379.000000) -> post(21408.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00105)
        CCONN  pre(137379.000000) -> post(21430.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00106)
        CCONN  pre(137379.000000) -> post(21452.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00107)
        CCONN  pre(137379.000000) -> post(21474.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00108)
        CCONN  pre(137379.000000) -> post(23872.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00109)
        CCONN  pre(137379.000000) -> post(23894.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00110)
        CCONN  pre(137379.000000) -> post(23916.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00111)
        CCONN  pre(137379.000000) -> post(23938.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00112)
        CCONN  pre(137379.000000) -> post(23960.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00113)
        CCONN  pre(137379.000000) -> post(23982.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00114)
        CCONN  pre(137379.000000) -> post(24004.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00115)
        CCONN  pre(137379.000000) -> post(24026.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00116)
        CCONN  pre(137379.000000) -> post(24048.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00117)
        CCONN  pre(137379.000000) -> post(24070.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00118)
        CCONN  pre(137379.000000) -> post(24092.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00119)
        CCONN  pre(137379.000000) -> post(24114.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00120)
        CCONN  pre(137379.000000) -> post(26512.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00121)
        CCONN  pre(137379.000000) -> post(26534.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00122)
        CCONN  pre(137379.000000) -> post(26556.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00123)
        CCONN  pre(137379.000000) -> post(26578.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00124)
        CCONN  pre(137379.000000) -> post(26600.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00125)
        CCONN  pre(137379.000000) -> post(26622.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00126)
        CCONN  pre(137379.000000) -> post(26644.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00127)
        CCONN  pre(137379.000000) -> post(26666.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00128)
        CCONN  pre(137379.000000) -> post(26688.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00129)
        CCONN  pre(137379.000000) -> post(26710.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00130)
        CCONN  pre(137379.000000) -> post(26732.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00131)
        CCONN  pre(137379.000000) -> post(26754.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00132)
        CCONN  pre(137379.000000) -> post(29152.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00133)
        CCONN  pre(137379.000000) -> post(29174.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00134)
        CCONN  pre(137379.000000) -> post(29196.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00135)
        CCONN  pre(137379.000000) -> post(29218.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00136)
        CCONN  pre(137379.000000) -> post(29240.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00137)
        CCONN  pre(137379.000000) -> post(29262.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00138)
        CCONN  pre(137379.000000) -> post(29284.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00139)
        CCONN  pre(137379.000000) -> post(29306.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00140)
        CCONN  pre(137379.000000) -> post(29328.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00141)
        CCONN  pre(137379.000000) -> post(29350.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00142)
        CCONN  pre(137379.000000) -> post(29372.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00143)
        CCONN  pre(137379.000000) -> post(29394.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00144)
        CCONN  pre(137379.000000) -> post(31792.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00145)
        CCONN  pre(137379.000000) -> post(31814.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00146)
        CCONN  pre(137379.000000) -> post(31836.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00147)
        CCONN  pre(137379.000000) -> post(31858.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00148)
        CCONN  pre(137379.000000) -> post(31880.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00149)
        CCONN  pre(137379.000000) -> post(31902.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00150)
        CCONN  pre(137379.000000) -> post(31924.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00151)
        CCONN  pre(137379.000000) -> post(31946.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00152)
        CCONN  pre(137379.000000) -> post(31968.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00153)
        CCONN  pre(137379.000000) -> post(31990.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00154)
        CCONN  pre(137379.000000) -> post(32012.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00155)
        CCONN  pre(137379.000000) -> post(32034.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00156)
        CCONN  pre(137379.000000) -> post(68752.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00157)
        CCONN  pre(137379.000000) -> post(68774.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00158)
        CCONN  pre(137379.000000) -> post(68796.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00159)
        CCONN  pre(137379.000000) -> post(68818.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00160)
        CCONN  pre(137379.000000) -> post(68840.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00161)
        CCONN  pre(137379.000000) -> post(68862.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00162)
        CCONN  pre(137379.000000) -> post(68884.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00163)
        CCONN  pre(137379.000000) -> post(68906.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00164)
        CCONN  pre(137379.000000) -> post(68928.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00165)
        CCONN  pre(137379.000000) -> post(68950.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00166)
        CCONN  pre(137379.000000) -> post(68972.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00167)
        CCONN  pre(137379.000000) -> post(68994.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00168)
        CCONN  pre(137379.000000) -> post(71392.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00169)
        CCONN  pre(137379.000000) -> post(71414.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00170)
        CCONN  pre(137379.000000) -> post(71436.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00171)
        CCONN  pre(137379.000000) -> post(71458.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00172)
        CCONN  pre(137379.000000) -> post(71480.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00173)
        CCONN  pre(137379.000000) -> post(71502.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00174)
        CCONN  pre(137379.000000) -> post(71524.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00175)
        CCONN  pre(137379.000000) -> post(71546.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00176)
        CCONN  pre(137379.000000) -> post(71568.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00177)
        CCONN  pre(137379.000000) -> post(71590.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00178)
        CCONN  pre(137379.000000) -> post(71612.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00179)
        CCONN  pre(137379.000000) -> post(71634.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00180)
        CCONN  pre(137379.000000) -> post(74032.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00181)
        CCONN  pre(137379.000000) -> post(74054.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00182)
        CCONN  pre(137379.000000) -> post(74076.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00183)
        CCONN  pre(137379.000000) -> post(74098.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00184)
        CCONN  pre(137379.000000) -> post(74120.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00185)
        CCONN  pre(137379.000000) -> post(74142.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00186)
        CCONN  pre(137379.000000) -> post(74164.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00187)
        CCONN  pre(137379.000000) -> post(74186.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00188)
        CCONN  pre(137379.000000) -> post(74208.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00189)
        CCONN  pre(137379.000000) -> post(74230.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00190)
        CCONN  pre(137379.000000) -> post(74252.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00191)
        CCONN  pre(137379.000000) -> post(74274.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00192)
        CCONN  pre(137379.000000) -> post(76672.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00193)
        CCONN  pre(137379.000000) -> post(76694.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00194)
        CCONN  pre(137379.000000) -> post(76716.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00195)
        CCONN  pre(137379.000000) -> post(76738.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00196)
        CCONN  pre(137379.000000) -> post(76760.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00197)
        CCONN  pre(137379.000000) -> post(76782.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00198)
        CCONN  pre(137379.000000) -> post(76804.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00199)
        CCONN  pre(137379.000000) -> post(76826.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00200)
        CCONN  pre(137379.000000) -> post(76848.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00201)
        CCONN  pre(137379.000000) -> post(76870.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00202)
        CCONN  pre(137379.000000) -> post(76892.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00203)
        CCONN  pre(137379.000000) -> post(76914.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00204)
        CCONN  pre(137379.000000) -> post(79312.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00205)
        CCONN  pre(137379.000000) -> post(79334.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00206)
        CCONN  pre(137379.000000) -> post(79356.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00207)
        CCONN  pre(137379.000000) -> post(79378.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00208)
        CCONN  pre(137379.000000) -> post(79400.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00209)
        CCONN  pre(137379.000000) -> post(79422.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00210)
        CCONN  pre(137379.000000) -> post(79444.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00211)
        CCONN  pre(137379.000000) -> post(79466.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00212)
        CCONN  pre(137379.000000) -> post(79488.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00213)
        CCONN  pre(137379.000000) -> post(79510.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00214)
        CCONN  pre(137379.000000) -> post(79532.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00215)
        CCONN  pre(137379.000000) -> post(79554.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00216)
        CCONN  pre(137379.000000) -> post(81952.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00217)
        CCONN  pre(137379.000000) -> post(81974.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00218)
        CCONN  pre(137379.000000) -> post(81996.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00219)
        CCONN  pre(137379.000000) -> post(82018.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00220)
        CCONN  pre(137379.000000) -> post(82040.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00221)
        CCONN  pre(137379.000000) -> post(82062.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00222)
        CCONN  pre(137379.000000) -> post(82084.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00223)
        CCONN  pre(137379.000000) -> post(82106.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00224)
        CCONN  pre(137379.000000) -> post(82128.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00225)
        CCONN  pre(137379.000000) -> post(82150.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00226)
        CCONN  pre(137379.000000) -> post(82172.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00227)
        CCONN  pre(137379.000000) -> post(82194.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00228)
        CCONN  pre(137379.000000) -> post(84592.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00229)
        CCONN  pre(137379.000000) -> post(84614.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00230)
        CCONN  pre(137379.000000) -> post(84636.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00231)
        CCONN  pre(137379.000000) -> post(84658.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00232)
        CCONN  pre(137379.000000) -> post(84680.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00233)
        CCONN  pre(137379.000000) -> post(84702.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00234)
        CCONN  pre(137379.000000) -> post(84724.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00235)
        CCONN  pre(137379.000000) -> post(84746.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00236)
        CCONN  pre(137379.000000) -> post(84768.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00237)
        CCONN  pre(137379.000000) -> post(84790.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00238)
        CCONN  pre(137379.000000) -> post(84812.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00239)
        CCONN  pre(137379.000000) -> post(84834.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00240)
        CCONN  pre(137379.000000) -> post(87232.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00241)
        CCONN  pre(137379.000000) -> post(87254.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00242)
        CCONN  pre(137379.000000) -> post(87276.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00243)
        CCONN  pre(137379.000000) -> post(87298.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00244)
        CCONN  pre(137379.000000) -> post(87320.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00245)
        CCONN  pre(137379.000000) -> post(87342.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00246)
        CCONN  pre(137379.000000) -> post(87364.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00247)
        CCONN  pre(137379.000000) -> post(87386.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00248)
        CCONN  pre(137379.000000) -> post(87408.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00249)
        CCONN  pre(137379.000000) -> post(87430.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00250)
        CCONN  pre(137379.000000) -> post(87452.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00251)
        CCONN  pre(137379.000000) -> post(87474.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00252)
        CCONN  pre(137379.000000) -> post(89872.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00253)
        CCONN  pre(137379.000000) -> post(89894.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00254)
        CCONN  pre(137379.000000) -> post(89916.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00255)
        CCONN  pre(137379.000000) -> post(89938.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00256)
        CCONN  pre(137379.000000) -> post(89960.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00257)
        CCONN  pre(137379.000000) -> post(89982.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00258)
        CCONN  pre(137379.000000) -> post(90004.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00259)
        CCONN  pre(137379.000000) -> post(90026.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00260)
        CCONN  pre(137379.000000) -> post(90048.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00261)
        CCONN  pre(137379.000000) -> post(90070.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00262)
        CCONN  pre(137379.000000) -> post(90092.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00263)
        CCONN  pre(137379.000000) -> post(90114.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00264)
        CCONN  pre(137379.000000) -> post(92512.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00265)
        CCONN  pre(137379.000000) -> post(92534.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00266)
        CCONN  pre(137379.000000) -> post(92556.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00267)
        CCONN  pre(137379.000000) -> post(92578.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00268)
        CCONN  pre(137379.000000) -> post(92600.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00269)
        CCONN  pre(137379.000000) -> post(92622.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00270)
        CCONN  pre(137379.000000) -> post(92644.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00271)
        CCONN  pre(137379.000000) -> post(92666.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00272)
        CCONN  pre(137379.000000) -> post(92688.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00273)
        CCONN  pre(137379.000000) -> post(92710.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00274)
        CCONN  pre(137379.000000) -> post(92732.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00275)
        CCONN  pre(137379.000000) -> post(92754.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00276)
        CCONN  pre(137379.000000) -> post(95152.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00277)
        CCONN  pre(137379.000000) -> post(95174.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00278)
        CCONN  pre(137379.000000) -> post(95196.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00279)
        CCONN  pre(137379.000000) -> post(95218.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00280)
        CCONN  pre(137379.000000) -> post(95240.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00281)
        CCONN  pre(137379.000000) -> post(95262.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00282)
        CCONN  pre(137379.000000) -> post(95284.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00283)
        CCONN  pre(137379.000000) -> post(95306.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00284)
        CCONN  pre(137379.000000) -> post(95328.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00285)
        CCONN  pre(137379.000000) -> post(95350.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00286)
        CCONN  pre(137379.000000) -> post(95372.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00287)
        CCONN  pre(137379.000000) -> post(95394.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00288)
        CCONN  pre(137379.000000) -> post(97792.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00289)
        CCONN  pre(137379.000000) -> post(97814.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00290)
        CCONN  pre(137379.000000) -> post(97836.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00291)
        CCONN  pre(137379.000000) -> post(97858.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00292)
        CCONN  pre(137379.000000) -> post(97880.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00293)
        CCONN  pre(137379.000000) -> post(97902.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00294)
        CCONN  pre(137379.000000) -> post(97924.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00295)
        CCONN  pre(137379.000000) -> post(97946.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00296)
        CCONN  pre(137379.000000) -> post(97968.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00297)
        CCONN  pre(137379.000000) -> post(97990.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00298)
        CCONN  pre(137379.000000) -> post(98012.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00299)
        CCONN  pre(137379.000000) -> post(98034.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00300)
        CCONN  pre(137379.000000) -> post(100432.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00301)
        CCONN  pre(137379.000000) -> post(100454.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00302)
        CCONN  pre(137379.000000) -> post(100476.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00303)
        CCONN  pre(137379.000000) -> post(100498.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00304)
        CCONN  pre(137379.000000) -> post(100520.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00305)
        CCONN  pre(137379.000000) -> post(100542.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00306)
        CCONN  pre(137379.000000) -> post(100564.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00307)
        CCONN  pre(137379.000000) -> post(100586.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00308)
        CCONN  pre(137379.000000) -> post(100608.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00309)
        CCONN  pre(137379.000000) -> post(100630.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00310)
        CCONN  pre(137379.000000) -> post(100652.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00311)
        CCONN  pre(137379.000000) -> post(100674.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00312)
        CCONN  pre(137379.000000) -> post(115.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00313)
        CCONN  pre(137379.000000) -> post(137.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00314)
        CCONN  pre(137379.000000) -> post(159.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00315)
        CCONN  pre(137379.000000) -> post(181.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00316)
        CCONN  pre(137379.000000) -> post(203.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00317)
        CCONN  pre(137379.000000) -> post(225.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00318)
        CCONN  pre(137379.000000) -> post(247.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00319)
        CCONN  pre(137379.000000) -> post(269.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00320)
        CCONN  pre(137379.000000) -> post(291.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00321)
        CCONN  pre(137379.000000) -> post(313.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00322)
        CCONN  pre(137379.000000) -> post(335.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00323)
        CCONN  pre(137379.000000) -> post(357.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00324)
        CCONN  pre(137379.000000) -> post(2755.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00325)
        CCONN  pre(137379.000000) -> post(2777.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00326)
        CCONN  pre(137379.000000) -> post(2799.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00327)
        CCONN  pre(137379.000000) -> post(2821.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00328)
        CCONN  pre(137379.000000) -> post(2843.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00329)
        CCONN  pre(137379.000000) -> post(2865.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00330)
        CCONN  pre(137379.000000) -> post(2887.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00331)
        CCONN  pre(137379.000000) -> post(2909.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00332)
        CCONN  pre(137379.000000) -> post(2931.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00333)
        CCONN  pre(137379.000000) -> post(2953.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00334)
        CCONN  pre(137379.000000) -> post(2975.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00335)
        CCONN  pre(137379.000000) -> post(2997.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00336)
        CCONN  pre(137379.000000) -> post(5395.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00337)
        CCONN  pre(137379.000000) -> post(5417.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00338)
        CCONN  pre(137379.000000) -> post(5439.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00339)
        CCONN  pre(137379.000000) -> post(5461.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00340)
        CCONN  pre(137379.000000) -> post(5483.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00341)
        CCONN  pre(137379.000000) -> post(5505.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00342)
        CCONN  pre(137379.000000) -> post(5527.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00343)
        CCONN  pre(137379.000000) -> post(5549.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00344)
        CCONN  pre(137379.000000) -> post(5571.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00345)
        CCONN  pre(137379.000000) -> post(5593.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00346)
        CCONN  pre(137379.000000) -> post(5615.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00347)
        CCONN  pre(137379.000000) -> post(5637.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00348)
        CCONN  pre(137379.000000) -> post(8035.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00349)
        CCONN  pre(137379.000000) -> post(8057.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00350)
        CCONN  pre(137379.000000) -> post(8079.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00351)
        CCONN  pre(137379.000000) -> post(8101.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00352)
        CCONN  pre(137379.000000) -> post(8123.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00353)
        CCONN  pre(137379.000000) -> post(8145.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00354)
        CCONN  pre(137379.000000) -> post(8167.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00355)
        CCONN  pre(137379.000000) -> post(8189.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00356)
        CCONN  pre(137379.000000) -> post(8211.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00357)
        CCONN  pre(137379.000000) -> post(8233.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00358)
        CCONN  pre(137379.000000) -> post(8255.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00359)
        CCONN  pre(137379.000000) -> post(8277.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00360)
        CCONN  pre(137379.000000) -> post(10675.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00361)
        CCONN  pre(137379.000000) -> post(10697.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00362)
        CCONN  pre(137379.000000) -> post(10719.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00363)
        CCONN  pre(137379.000000) -> post(10741.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00364)
        CCONN  pre(137379.000000) -> post(10763.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00365)
        CCONN  pre(137379.000000) -> post(10785.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00366)
        CCONN  pre(137379.000000) -> post(10807.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00367)
        CCONN  pre(137379.000000) -> post(10829.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00368)
        CCONN  pre(137379.000000) -> post(10851.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00369)
        CCONN  pre(137379.000000) -> post(10873.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00370)
        CCONN  pre(137379.000000) -> post(10895.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00371)
        CCONN  pre(137379.000000) -> post(10917.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00372)
        CCONN  pre(137379.000000) -> post(13315.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00373)
        CCONN  pre(137379.000000) -> post(13337.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00374)
        CCONN  pre(137379.000000) -> post(13359.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00375)
        CCONN  pre(137379.000000) -> post(13381.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00376)
        CCONN  pre(137379.000000) -> post(13403.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00377)
        CCONN  pre(137379.000000) -> post(13425.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00378)
        CCONN  pre(137379.000000) -> post(13447.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00379)
        CCONN  pre(137379.000000) -> post(13469.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00380)
        CCONN  pre(137379.000000) -> post(13491.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00381)
        CCONN  pre(137379.000000) -> post(13513.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00382)
        CCONN  pre(137379.000000) -> post(13535.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00383)
        CCONN  pre(137379.000000) -> post(13557.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00384)
        CCONN  pre(137379.000000) -> post(15955.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00385)
        CCONN  pre(137379.000000) -> post(15977.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00386)
        CCONN  pre(137379.000000) -> post(15999.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00387)
        CCONN  pre(137379.000000) -> post(16021.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00388)
        CCONN  pre(137379.000000) -> post(16043.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00389)
        CCONN  pre(137379.000000) -> post(16065.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00390)
        CCONN  pre(137379.000000) -> post(16087.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00391)
        CCONN  pre(137379.000000) -> post(16109.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00392)
        CCONN  pre(137379.000000) -> post(16131.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00393)
        CCONN  pre(137379.000000) -> post(16153.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00394)
        CCONN  pre(137379.000000) -> post(16175.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00395)
        CCONN  pre(137379.000000) -> post(16197.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00396)
        CCONN  pre(137379.000000) -> post(18595.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00397)
        CCONN  pre(137379.000000) -> post(18617.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00398)
        CCONN  pre(137379.000000) -> post(18639.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00399)
        CCONN  pre(137379.000000) -> post(18661.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00400)
        CCONN  pre(137379.000000) -> post(18683.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00401)
        CCONN  pre(137379.000000) -> post(18705.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00402)
        CCONN  pre(137379.000000) -> post(18727.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00403)
        CCONN  pre(137379.000000) -> post(18749.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00404)
        CCONN  pre(137379.000000) -> post(18771.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00405)
        CCONN  pre(137379.000000) -> post(18793.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00406)
        CCONN  pre(137379.000000) -> post(18815.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00407)
        CCONN  pre(137379.000000) -> post(18837.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00408)
        CCONN  pre(137379.000000) -> post(21235.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00409)
        CCONN  pre(137379.000000) -> post(21257.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00410)
        CCONN  pre(137379.000000) -> post(21279.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00411)
        CCONN  pre(137379.000000) -> post(21301.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00412)
        CCONN  pre(137379.000000) -> post(21323.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00413)
        CCONN  pre(137379.000000) -> post(21345.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00414)
        CCONN  pre(137379.000000) -> post(21367.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00415)
        CCONN  pre(137379.000000) -> post(21389.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00416)
        CCONN  pre(137379.000000) -> post(21411.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00417)
        CCONN  pre(137379.000000) -> post(21433.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00418)
        CCONN  pre(137379.000000) -> post(21455.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00419)
        CCONN  pre(137379.000000) -> post(21477.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00420)
        CCONN  pre(137379.000000) -> post(23875.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00421)
        CCONN  pre(137379.000000) -> post(23897.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00422)
        CCONN  pre(137379.000000) -> post(23919.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00423)
        CCONN  pre(137379.000000) -> post(23941.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00424)
        CCONN  pre(137379.000000) -> post(23963.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00425)
        CCONN  pre(137379.000000) -> post(23985.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00426)
        CCONN  pre(137379.000000) -> post(24007.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00427)
        CCONN  pre(137379.000000) -> post(24029.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00428)
        CCONN  pre(137379.000000) -> post(24051.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00429)
        CCONN  pre(137379.000000) -> post(24073.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00430)
        CCONN  pre(137379.000000) -> post(24095.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00431)
        CCONN  pre(137379.000000) -> post(24117.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00432)
        CCONN  pre(137379.000000) -> post(26515.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00433)
        CCONN  pre(137379.000000) -> post(26537.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00434)
        CCONN  pre(137379.000000) -> post(26559.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00435)
        CCONN  pre(137379.000000) -> post(26581.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00436)
        CCONN  pre(137379.000000) -> post(26603.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00437)
        CCONN  pre(137379.000000) -> post(26625.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00438)
        CCONN  pre(137379.000000) -> post(26647.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00439)
        CCONN  pre(137379.000000) -> post(26669.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00440)
        CCONN  pre(137379.000000) -> post(26691.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00441)
        CCONN  pre(137379.000000) -> post(26713.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00442)
        CCONN  pre(137379.000000) -> post(26735.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00443)
        CCONN  pre(137379.000000) -> post(26757.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00444)
        CCONN  pre(137379.000000) -> post(29155.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00445)
        CCONN  pre(137379.000000) -> post(29177.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00446)
        CCONN  pre(137379.000000) -> post(29199.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00447)
        CCONN  pre(137379.000000) -> post(29221.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00448)
        CCONN  pre(137379.000000) -> post(29243.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00449)
        CCONN  pre(137379.000000) -> post(29265.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00450)
        CCONN  pre(137379.000000) -> post(29287.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00451)
        CCONN  pre(137379.000000) -> post(29309.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00452)
        CCONN  pre(137379.000000) -> post(29331.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00453)
        CCONN  pre(137379.000000) -> post(29353.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00454)
        CCONN  pre(137379.000000) -> post(29375.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00455)
        CCONN  pre(137379.000000) -> post(29397.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00456)
        CCONN  pre(137379.000000) -> post(31795.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00457)
        CCONN  pre(137379.000000) -> post(31817.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00458)
        CCONN  pre(137379.000000) -> post(31839.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00459)
        CCONN  pre(137379.000000) -> post(31861.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00460)
        CCONN  pre(137379.000000) -> post(31883.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00461)
        CCONN  pre(137379.000000) -> post(31905.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00462)
        CCONN  pre(137379.000000) -> post(31927.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00463)
        CCONN  pre(137379.000000) -> post(31949.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00464)
        CCONN  pre(137379.000000) -> post(31971.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00465)
        CCONN  pre(137379.000000) -> post(31993.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00466)
        CCONN  pre(137379.000000) -> post(32015.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00467)
        CCONN  pre(137379.000000) -> post(32037.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00468)
        CCONN  pre(137379.000000) -> post(68755.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00469)
        CCONN  pre(137379.000000) -> post(68777.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00470)
        CCONN  pre(137379.000000) -> post(68799.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00471)
        CCONN  pre(137379.000000) -> post(68821.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00472)
        CCONN  pre(137379.000000) -> post(68843.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00473)
        CCONN  pre(137379.000000) -> post(68865.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00474)
        CCONN  pre(137379.000000) -> post(68887.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00475)
        CCONN  pre(137379.000000) -> post(68909.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00476)
        CCONN  pre(137379.000000) -> post(68931.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00477)
        CCONN  pre(137379.000000) -> post(68953.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00478)
        CCONN  pre(137379.000000) -> post(68975.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00479)
        CCONN  pre(137379.000000) -> post(68997.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00480)
        CCONN  pre(137379.000000) -> post(71395.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00481)
        CCONN  pre(137379.000000) -> post(71417.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00482)
        CCONN  pre(137379.000000) -> post(71439.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00483)
        CCONN  pre(137379.000000) -> post(71461.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00484)
        CCONN  pre(137379.000000) -> post(71483.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00485)
        CCONN  pre(137379.000000) -> post(71505.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00486)
        CCONN  pre(137379.000000) -> post(71527.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00487)
        CCONN  pre(137379.000000) -> post(71549.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00488)
        CCONN  pre(137379.000000) -> post(71571.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00489)
        CCONN  pre(137379.000000) -> post(71593.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00490)
        CCONN  pre(137379.000000) -> post(71615.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00491)
        CCONN  pre(137379.000000) -> post(71637.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00492)
        CCONN  pre(137379.000000) -> post(74035.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00493)
        CCONN  pre(137379.000000) -> post(74057.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00494)
        CCONN  pre(137379.000000) -> post(74079.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00495)
        CCONN  pre(137379.000000) -> post(74101.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00496)
        CCONN  pre(137379.000000) -> post(74123.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00497)
        CCONN  pre(137379.000000) -> post(74145.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00498)
        CCONN  pre(137379.000000) -> post(74167.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00499)
        CCONN  pre(137379.000000) -> post(74189.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00500)
        CCONN  pre(137379.000000) -> post(74211.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00501)
        CCONN  pre(137379.000000) -> post(74233.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00502)
        CCONN  pre(137379.000000) -> post(74255.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00503)
        CCONN  pre(137379.000000) -> post(74277.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00504)
        CCONN  pre(137379.000000) -> post(76675.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00505)
        CCONN  pre(137379.000000) -> post(76697.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00506)
        CCONN  pre(137379.000000) -> post(76719.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00507)
        CCONN  pre(137379.000000) -> post(76741.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00508)
        CCONN  pre(137379.000000) -> post(76763.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00509)
        CCONN  pre(137379.000000) -> post(76785.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00510)
        CCONN  pre(137379.000000) -> post(76807.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00511)
        CCONN  pre(137379.000000) -> post(76829.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00512)
        CCONN  pre(137379.000000) -> post(76851.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00513)
        CCONN  pre(137379.000000) -> post(76873.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00514)
        CCONN  pre(137379.000000) -> post(76895.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00515)
        CCONN  pre(137379.000000) -> post(76917.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00516)
        CCONN  pre(137379.000000) -> post(79315.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00517)
        CCONN  pre(137379.000000) -> post(79337.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00518)
        CCONN  pre(137379.000000) -> post(79359.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00519)
        CCONN  pre(137379.000000) -> post(79381.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00520)
        CCONN  pre(137379.000000) -> post(79403.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00521)
        CCONN  pre(137379.000000) -> post(79425.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00522)
        CCONN  pre(137379.000000) -> post(79447.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00523)
        CCONN  pre(137379.000000) -> post(79469.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00524)
        CCONN  pre(137379.000000) -> post(79491.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00525)
        CCONN  pre(137379.000000) -> post(79513.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00526)
        CCONN  pre(137379.000000) -> post(79535.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00527)
        CCONN  pre(137379.000000) -> post(79557.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00528)
        CCONN  pre(137379.000000) -> post(81955.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00529)
        CCONN  pre(137379.000000) -> post(81977.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00530)
        CCONN  pre(137379.000000) -> post(81999.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00531)
        CCONN  pre(137379.000000) -> post(82021.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00532)
        CCONN  pre(137379.000000) -> post(82043.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00533)
        CCONN  pre(137379.000000) -> post(82065.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00534)
        CCONN  pre(137379.000000) -> post(82087.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00535)
        CCONN  pre(137379.000000) -> post(82109.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00536)
        CCONN  pre(137379.000000) -> post(82131.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00537)
        CCONN  pre(137379.000000) -> post(82153.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00538)
        CCONN  pre(137379.000000) -> post(82175.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00539)
        CCONN  pre(137379.000000) -> post(82197.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00540)
        CCONN  pre(137379.000000) -> post(84595.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00541)
        CCONN  pre(137379.000000) -> post(84617.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00542)
        CCONN  pre(137379.000000) -> post(84639.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00543)
        CCONN  pre(137379.000000) -> post(84661.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00544)
        CCONN  pre(137379.000000) -> post(84683.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00545)
        CCONN  pre(137379.000000) -> post(84705.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00546)
        CCONN  pre(137379.000000) -> post(84727.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00547)
        CCONN  pre(137379.000000) -> post(84749.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00548)
        CCONN  pre(137379.000000) -> post(84771.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00549)
        CCONN  pre(137379.000000) -> post(84793.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00550)
        CCONN  pre(137379.000000) -> post(84815.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00551)
        CCONN  pre(137379.000000) -> post(84837.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00552)
        CCONN  pre(137379.000000) -> post(87235.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00553)
        CCONN  pre(137379.000000) -> post(87257.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00554)
        CCONN  pre(137379.000000) -> post(87279.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00555)
        CCONN  pre(137379.000000) -> post(87301.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00556)
        CCONN  pre(137379.000000) -> post(87323.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00557)
        CCONN  pre(137379.000000) -> post(87345.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00558)
        CCONN  pre(137379.000000) -> post(87367.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00559)
        CCONN  pre(137379.000000) -> post(87389.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00560)
        CCONN  pre(137379.000000) -> post(87411.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00561)
        CCONN  pre(137379.000000) -> post(87433.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00562)
        CCONN  pre(137379.000000) -> post(87455.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00563)
        CCONN  pre(137379.000000) -> post(87477.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00564)
        CCONN  pre(137379.000000) -> post(89875.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00565)
        CCONN  pre(137379.000000) -> post(89897.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00566)
        CCONN  pre(137379.000000) -> post(89919.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00567)
        CCONN  pre(137379.000000) -> post(89941.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00568)
        CCONN  pre(137379.000000) -> post(89963.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00569)
        CCONN  pre(137379.000000) -> post(89985.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00570)
        CCONN  pre(137379.000000) -> post(90007.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00571)
        CCONN  pre(137379.000000) -> post(90029.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00572)
        CCONN  pre(137379.000000) -> post(90051.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00573)
        CCONN  pre(137379.000000) -> post(90073.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00574)
        CCONN  pre(137379.000000) -> post(90095.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00575)
        CCONN  pre(137379.000000) -> post(90117.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00576)
        CCONN  pre(137379.000000) -> post(92515.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00577)
        CCONN  pre(137379.000000) -> post(92537.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00578)
        CCONN  pre(137379.000000) -> post(92559.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00579)
        CCONN  pre(137379.000000) -> post(92581.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00580)
        CCONN  pre(137379.000000) -> post(92603.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00581)
        CCONN  pre(137379.000000) -> post(92625.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00582)
        CCONN  pre(137379.000000) -> post(92647.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00583)
        CCONN  pre(137379.000000) -> post(92669.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00584)
        CCONN  pre(137379.000000) -> post(92691.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00585)
        CCONN  pre(137379.000000) -> post(92713.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00586)
        CCONN  pre(137379.000000) -> post(92735.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00587)
        CCONN  pre(137379.000000) -> post(92757.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00588)
        CCONN  pre(137379.000000) -> post(95155.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00589)
        CCONN  pre(137379.000000) -> post(95177.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00590)
        CCONN  pre(137379.000000) -> post(95199.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00591)
        CCONN  pre(137379.000000) -> post(95221.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00592)
        CCONN  pre(137379.000000) -> post(95243.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00593)
        CCONN  pre(137379.000000) -> post(95265.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00594)
        CCONN  pre(137379.000000) -> post(95287.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00595)
        CCONN  pre(137379.000000) -> post(95309.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00596)
        CCONN  pre(137379.000000) -> post(95331.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00597)
        CCONN  pre(137379.000000) -> post(95353.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00598)
        CCONN  pre(137379.000000) -> post(95375.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00599)
        CCONN  pre(137379.000000) -> post(95397.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00600)
        CCONN  pre(137379.000000) -> post(97795.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00601)
        CCONN  pre(137379.000000) -> post(97817.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00602)
        CCONN  pre(137379.000000) -> post(97839.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00603)
        CCONN  pre(137379.000000) -> post(97861.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00604)
        CCONN  pre(137379.000000) -> post(97883.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00605)
        CCONN  pre(137379.000000) -> post(97905.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00606)
        CCONN  pre(137379.000000) -> post(97927.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00607)
        CCONN  pre(137379.000000) -> post(97949.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00608)
        CCONN  pre(137379.000000) -> post(97971.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00609)
        CCONN  pre(137379.000000) -> post(97993.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00610)
        CCONN  pre(137379.000000) -> post(98015.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00611)
        CCONN  pre(137379.000000) -> post(98037.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00612)
        CCONN  pre(137379.000000) -> post(100435.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00613)
        CCONN  pre(137379.000000) -> post(100457.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00614)
        CCONN  pre(137379.000000) -> post(100479.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00615)
        CCONN  pre(137379.000000) -> post(100501.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00616)
        CCONN  pre(137379.000000) -> post(100523.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00617)
        CCONN  pre(137379.000000) -> post(100545.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00618)
        CCONN  pre(137379.000000) -> post(100567.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00619)
        CCONN  pre(137379.000000) -> post(100589.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00620)
        CCONN  pre(137379.000000) -> post(100611.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00621)
        CCONN  pre(137379.000000) -> post(100633.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00622)
        CCONN  pre(137379.000000) -> post(100655.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00623)
        CCONN  pre(137379.000000) -> post(100677.000000)
        CCONN  Delay, Weight (0.000000,9.000000)
",
						   timeout => 50,
						   write => "projectionquery c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB",
						  },
						  {
						   description => "How many connections in the feedforward and feedback projections can be found for the first Golgi cell's soma ?",
						   read => "#connections = 624
",
						   write => "projectionquerycount c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB",
						  },
						  {
						   description => "How many connections in the feedforward and feedback projections can be found ?",
						   read => "first symbol is not attachment, will be used as part of projectionquery
#connections = 110592
",
						   write => "projectionquerycount c /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB",
						  },
# 						  {
# 						   description => "How many symbols, mechanism and segments have been defined ?",
# 						   read => "Traversal serial ID = 1
# Principal serial ID = 1 of 439521 Principal successors
# Mechanism serial ID = 0 of 146304 Mechanism successors
# Segment  serial  ID = 0 of 33548  Segment  successors
# ",
# 						   write => "serialMapping /CerebellarCortex",
# 						  },
						  {
						   description => "What are the forestspace IDs for the spine neck ?",
						   read => "Traversal serial ID = 1139
Principal serial ID = 1139 of 153157 Principal successors
",
# Mechanism serial ID = 656 of 77484 Mechanism successors
# Segment  serial  ID = 73 of 27288  Segment  successors
						   write => "serialMapping /CerebellarCortex/Purkinjes /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						  {
						   description => "Can the mossy fiber forestspace IDs be found ?",
						   read => "serial id /CerebellarCortex,12 -> /CerebellarCortex/MossyFibers/3/value
",
						   write => "serial2context /CerebellarCortex 12",
						  },
						  {
						   description => "Can we define a caching projection query for the feedforward, feedback and mossy fiber projections ?",
						   read => "caching = yes
",
						   write => "pqset c /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection/GABAA /CerebellarCortex/BackwardProjection/GABAB /CerebellarCortex/MossyFiberProjection/GranuleComponent/NMDA /CerebellarCortex/MossyFiberProjection/GranuleComponent/AMPA /CerebellarCortex/MossyFiberProjection/GolgiComponent",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery, caching mode ?",
						   read => "#connections = 148660
",
#memory used by projection query = 2378760
#memory used by connection cache = 1189292
#memory used by ordered cache 1  = 594660
#memory used by ordered cache 2  = 594660
						   write => "pqcount c",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery, non-caching mode ?",
						   read => "#connections = 148660
",
#memory used by projection query = 2378760
#memory used by connection cache = 1189292
#memory used by ordered cache 1  = 594660
#memory used by ordered cache 2  = 594660
						   write => "pqcount n",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's domain mapper, caching mode ?",
						   read => "#connections = 624
",
						   write => "pqcount c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's domain mapper, non-caching mode ?",
						   read => "#connections = 624
",
						   write => "pqcount n /CerebellarCortex/Golgis/0/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's parallel fiber synapse, caching mode ?",
						   read => "#connections = 4452
",
						   write => "pqcount c /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   description => "What is the number of connections in the defined projectionquery for the first Golgi cell's parallel fiber synapse, non-caching mode ?",
						   read => "#connections = 4452
",
						   write => "pqcount n /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse",
						  },
						 ],
				description => "network model - connections and solver registrations",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'networks/input.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/input.ndf.', ],
						   timeout => 10,
						   write => undef,
						  },
						  {
						   description => "Can we define a projection query for flexible connections ?",
						   read => "caching = yes
",
						   write => "pqset c /TestOfInputFibers/MossyFiberInputProjection",
						  },
						  {
						   description => "Can we find connections for the first mossy fiber, caching mode ?",
						   read => "connections = 1
",
						   write => "pqcount c /TestOfInputFibers/MossyFibers/Fiber[0]/spikegen",
						  },
						  {
						   description => "Can we find connections for the first mossy fiber, non-caching mode ?",
						   read => "connections = 1
",
						   write => "pqcount n /TestOfInputFibers/MossyFibers/Fiber[0]/spikegen",
						  },
						 ],
				description => "simplified input layer with simple connections",
				disabled => "individual connections are broken for the moment",
			       },
			      ],
       description => "connections and solvers",
       name => 'connections.t',
      };


return $test;


