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
						   read => 'serial ID = 1141
',
						   write => "serialID /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par",
						  },
						  {
						   description => "What is the treespaces ID of a synaptic channel on a spine of the second Purkinje cell ?",
						   read => "serial ID = 25523
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
						   read => "serial ID = 328942
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
						   read => "Solver = /Purkinje[0], solver serial ID = 1141
Solver serial context for 1141 = 
	/CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par
",
						   write => "resolvesolver /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/head/par",
						  },
						  {
						   description => "What are the connections in the feedforward and feedback projections for the first Golgi cell's soma ?",
						   read => "Connection (00000)
        CCONN  pre(137391.000000) -> post(122.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00001)
        CCONN  pre(137391.000000) -> post(144.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00002)
        CCONN  pre(137391.000000) -> post(166.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00003)
        CCONN  pre(137391.000000) -> post(188.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00004)
        CCONN  pre(137391.000000) -> post(210.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00005)
        CCONN  pre(137391.000000) -> post(232.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00006)
        CCONN  pre(137391.000000) -> post(254.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00007)
        CCONN  pre(137391.000000) -> post(276.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00008)
        CCONN  pre(137391.000000) -> post(298.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00009)
        CCONN  pre(137391.000000) -> post(320.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00010)
        CCONN  pre(137391.000000) -> post(342.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00011)
        CCONN  pre(137391.000000) -> post(364.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00012)
        CCONN  pre(137391.000000) -> post(2762.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00013)
        CCONN  pre(137391.000000) -> post(2784.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00014)
        CCONN  pre(137391.000000) -> post(2806.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00015)
        CCONN  pre(137391.000000) -> post(2828.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00016)
        CCONN  pre(137391.000000) -> post(2850.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00017)
        CCONN  pre(137391.000000) -> post(2872.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00018)
        CCONN  pre(137391.000000) -> post(2894.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00019)
        CCONN  pre(137391.000000) -> post(2916.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00020)
        CCONN  pre(137391.000000) -> post(2938.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00021)
        CCONN  pre(137391.000000) -> post(2960.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00022)
        CCONN  pre(137391.000000) -> post(2982.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00023)
        CCONN  pre(137391.000000) -> post(3004.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00024)
        CCONN  pre(137391.000000) -> post(5402.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00025)
        CCONN  pre(137391.000000) -> post(5424.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00026)
        CCONN  pre(137391.000000) -> post(5446.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00027)
        CCONN  pre(137391.000000) -> post(5468.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00028)
        CCONN  pre(137391.000000) -> post(5490.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00029)
        CCONN  pre(137391.000000) -> post(5512.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00030)
        CCONN  pre(137391.000000) -> post(5534.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00031)
        CCONN  pre(137391.000000) -> post(5556.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00032)
        CCONN  pre(137391.000000) -> post(5578.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00033)
        CCONN  pre(137391.000000) -> post(5600.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00034)
        CCONN  pre(137391.000000) -> post(5622.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00035)
        CCONN  pre(137391.000000) -> post(5644.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00036)
        CCONN  pre(137391.000000) -> post(8042.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00037)
        CCONN  pre(137391.000000) -> post(8064.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00038)
        CCONN  pre(137391.000000) -> post(8086.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00039)
        CCONN  pre(137391.000000) -> post(8108.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00040)
        CCONN  pre(137391.000000) -> post(8130.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00041)
        CCONN  pre(137391.000000) -> post(8152.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00042)
        CCONN  pre(137391.000000) -> post(8174.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00043)
        CCONN  pre(137391.000000) -> post(8196.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00044)
        CCONN  pre(137391.000000) -> post(8218.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00045)
        CCONN  pre(137391.000000) -> post(8240.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00046)
        CCONN  pre(137391.000000) -> post(8262.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00047)
        CCONN  pre(137391.000000) -> post(8284.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00048)
        CCONN  pre(137391.000000) -> post(10682.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00049)
        CCONN  pre(137391.000000) -> post(10704.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00050)
        CCONN  pre(137391.000000) -> post(10726.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00051)
        CCONN  pre(137391.000000) -> post(10748.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00052)
        CCONN  pre(137391.000000) -> post(10770.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00053)
        CCONN  pre(137391.000000) -> post(10792.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00054)
        CCONN  pre(137391.000000) -> post(10814.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00055)
        CCONN  pre(137391.000000) -> post(10836.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00056)
        CCONN  pre(137391.000000) -> post(10858.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00057)
        CCONN  pre(137391.000000) -> post(10880.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00058)
        CCONN  pre(137391.000000) -> post(10902.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00059)
        CCONN  pre(137391.000000) -> post(10924.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00060)
        CCONN  pre(137391.000000) -> post(13322.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00061)
        CCONN  pre(137391.000000) -> post(13344.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00062)
        CCONN  pre(137391.000000) -> post(13366.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00063)
        CCONN  pre(137391.000000) -> post(13388.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00064)
        CCONN  pre(137391.000000) -> post(13410.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00065)
        CCONN  pre(137391.000000) -> post(13432.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00066)
        CCONN  pre(137391.000000) -> post(13454.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00067)
        CCONN  pre(137391.000000) -> post(13476.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00068)
        CCONN  pre(137391.000000) -> post(13498.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00069)
        CCONN  pre(137391.000000) -> post(13520.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00070)
        CCONN  pre(137391.000000) -> post(13542.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00071)
        CCONN  pre(137391.000000) -> post(13564.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00072)
        CCONN  pre(137391.000000) -> post(15962.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00073)
        CCONN  pre(137391.000000) -> post(15984.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00074)
        CCONN  pre(137391.000000) -> post(16006.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00075)
        CCONN  pre(137391.000000) -> post(16028.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00076)
        CCONN  pre(137391.000000) -> post(16050.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00077)
        CCONN  pre(137391.000000) -> post(16072.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00078)
        CCONN  pre(137391.000000) -> post(16094.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00079)
        CCONN  pre(137391.000000) -> post(16116.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00080)
        CCONN  pre(137391.000000) -> post(16138.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00081)
        CCONN  pre(137391.000000) -> post(16160.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00082)
        CCONN  pre(137391.000000) -> post(16182.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00083)
        CCONN  pre(137391.000000) -> post(16204.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00084)
        CCONN  pre(137391.000000) -> post(18602.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00085)
        CCONN  pre(137391.000000) -> post(18624.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00086)
        CCONN  pre(137391.000000) -> post(18646.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00087)
        CCONN  pre(137391.000000) -> post(18668.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00088)
        CCONN  pre(137391.000000) -> post(18690.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00089)
        CCONN  pre(137391.000000) -> post(18712.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00090)
        CCONN  pre(137391.000000) -> post(18734.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00091)
        CCONN  pre(137391.000000) -> post(18756.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00092)
        CCONN  pre(137391.000000) -> post(18778.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00093)
        CCONN  pre(137391.000000) -> post(18800.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00094)
        CCONN  pre(137391.000000) -> post(18822.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00095)
        CCONN  pre(137391.000000) -> post(18844.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00096)
        CCONN  pre(137391.000000) -> post(21242.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00097)
        CCONN  pre(137391.000000) -> post(21264.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00098)
        CCONN  pre(137391.000000) -> post(21286.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00099)
        CCONN  pre(137391.000000) -> post(21308.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00100)
        CCONN  pre(137391.000000) -> post(21330.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00101)
        CCONN  pre(137391.000000) -> post(21352.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00102)
        CCONN  pre(137391.000000) -> post(21374.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00103)
        CCONN  pre(137391.000000) -> post(21396.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00104)
        CCONN  pre(137391.000000) -> post(21418.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00105)
        CCONN  pre(137391.000000) -> post(21440.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00106)
        CCONN  pre(137391.000000) -> post(21462.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00107)
        CCONN  pre(137391.000000) -> post(21484.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00108)
        CCONN  pre(137391.000000) -> post(23882.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00109)
        CCONN  pre(137391.000000) -> post(23904.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00110)
        CCONN  pre(137391.000000) -> post(23926.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00111)
        CCONN  pre(137391.000000) -> post(23948.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00112)
        CCONN  pre(137391.000000) -> post(23970.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00113)
        CCONN  pre(137391.000000) -> post(23992.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00114)
        CCONN  pre(137391.000000) -> post(24014.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00115)
        CCONN  pre(137391.000000) -> post(24036.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00116)
        CCONN  pre(137391.000000) -> post(24058.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00117)
        CCONN  pre(137391.000000) -> post(24080.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00118)
        CCONN  pre(137391.000000) -> post(24102.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00119)
        CCONN  pre(137391.000000) -> post(24124.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00120)
        CCONN  pre(137391.000000) -> post(26522.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00121)
        CCONN  pre(137391.000000) -> post(26544.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00122)
        CCONN  pre(137391.000000) -> post(26566.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00123)
        CCONN  pre(137391.000000) -> post(26588.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00124)
        CCONN  pre(137391.000000) -> post(26610.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00125)
        CCONN  pre(137391.000000) -> post(26632.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00126)
        CCONN  pre(137391.000000) -> post(26654.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00127)
        CCONN  pre(137391.000000) -> post(26676.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00128)
        CCONN  pre(137391.000000) -> post(26698.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00129)
        CCONN  pre(137391.000000) -> post(26720.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00130)
        CCONN  pre(137391.000000) -> post(26742.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00131)
        CCONN  pre(137391.000000) -> post(26764.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00132)
        CCONN  pre(137391.000000) -> post(29162.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00133)
        CCONN  pre(137391.000000) -> post(29184.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00134)
        CCONN  pre(137391.000000) -> post(29206.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00135)
        CCONN  pre(137391.000000) -> post(29228.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00136)
        CCONN  pre(137391.000000) -> post(29250.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00137)
        CCONN  pre(137391.000000) -> post(29272.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00138)
        CCONN  pre(137391.000000) -> post(29294.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00139)
        CCONN  pre(137391.000000) -> post(29316.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00140)
        CCONN  pre(137391.000000) -> post(29338.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00141)
        CCONN  pre(137391.000000) -> post(29360.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00142)
        CCONN  pre(137391.000000) -> post(29382.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00143)
        CCONN  pre(137391.000000) -> post(29404.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00144)
        CCONN  pre(137391.000000) -> post(31802.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00145)
        CCONN  pre(137391.000000) -> post(31824.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00146)
        CCONN  pre(137391.000000) -> post(31846.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00147)
        CCONN  pre(137391.000000) -> post(31868.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00148)
        CCONN  pre(137391.000000) -> post(31890.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00149)
        CCONN  pre(137391.000000) -> post(31912.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00150)
        CCONN  pre(137391.000000) -> post(31934.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00151)
        CCONN  pre(137391.000000) -> post(31956.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00152)
        CCONN  pre(137391.000000) -> post(31978.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00153)
        CCONN  pre(137391.000000) -> post(32000.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00154)
        CCONN  pre(137391.000000) -> post(32022.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00155)
        CCONN  pre(137391.000000) -> post(32044.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00156)
        CCONN  pre(137391.000000) -> post(68762.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00157)
        CCONN  pre(137391.000000) -> post(68784.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00158)
        CCONN  pre(137391.000000) -> post(68806.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00159)
        CCONN  pre(137391.000000) -> post(68828.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00160)
        CCONN  pre(137391.000000) -> post(68850.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00161)
        CCONN  pre(137391.000000) -> post(68872.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00162)
        CCONN  pre(137391.000000) -> post(68894.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00163)
        CCONN  pre(137391.000000) -> post(68916.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00164)
        CCONN  pre(137391.000000) -> post(68938.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00165)
        CCONN  pre(137391.000000) -> post(68960.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00166)
        CCONN  pre(137391.000000) -> post(68982.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00167)
        CCONN  pre(137391.000000) -> post(69004.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00168)
        CCONN  pre(137391.000000) -> post(71402.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00169)
        CCONN  pre(137391.000000) -> post(71424.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00170)
        CCONN  pre(137391.000000) -> post(71446.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00171)
        CCONN  pre(137391.000000) -> post(71468.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00172)
        CCONN  pre(137391.000000) -> post(71490.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00173)
        CCONN  pre(137391.000000) -> post(71512.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00174)
        CCONN  pre(137391.000000) -> post(71534.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00175)
        CCONN  pre(137391.000000) -> post(71556.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00176)
        CCONN  pre(137391.000000) -> post(71578.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00177)
        CCONN  pre(137391.000000) -> post(71600.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00178)
        CCONN  pre(137391.000000) -> post(71622.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00179)
        CCONN  pre(137391.000000) -> post(71644.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00180)
        CCONN  pre(137391.000000) -> post(74042.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00181)
        CCONN  pre(137391.000000) -> post(74064.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00182)
        CCONN  pre(137391.000000) -> post(74086.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00183)
        CCONN  pre(137391.000000) -> post(74108.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00184)
        CCONN  pre(137391.000000) -> post(74130.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00185)
        CCONN  pre(137391.000000) -> post(74152.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00186)
        CCONN  pre(137391.000000) -> post(74174.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00187)
        CCONN  pre(137391.000000) -> post(74196.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00188)
        CCONN  pre(137391.000000) -> post(74218.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00189)
        CCONN  pre(137391.000000) -> post(74240.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00190)
        CCONN  pre(137391.000000) -> post(74262.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00191)
        CCONN  pre(137391.000000) -> post(74284.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00192)
        CCONN  pre(137391.000000) -> post(76682.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00193)
        CCONN  pre(137391.000000) -> post(76704.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00194)
        CCONN  pre(137391.000000) -> post(76726.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00195)
        CCONN  pre(137391.000000) -> post(76748.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00196)
        CCONN  pre(137391.000000) -> post(76770.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00197)
        CCONN  pre(137391.000000) -> post(76792.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00198)
        CCONN  pre(137391.000000) -> post(76814.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00199)
        CCONN  pre(137391.000000) -> post(76836.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00200)
        CCONN  pre(137391.000000) -> post(76858.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00201)
        CCONN  pre(137391.000000) -> post(76880.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00202)
        CCONN  pre(137391.000000) -> post(76902.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00203)
        CCONN  pre(137391.000000) -> post(76924.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00204)
        CCONN  pre(137391.000000) -> post(79322.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00205)
        CCONN  pre(137391.000000) -> post(79344.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00206)
        CCONN  pre(137391.000000) -> post(79366.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00207)
        CCONN  pre(137391.000000) -> post(79388.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00208)
        CCONN  pre(137391.000000) -> post(79410.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00209)
        CCONN  pre(137391.000000) -> post(79432.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00210)
        CCONN  pre(137391.000000) -> post(79454.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00211)
        CCONN  pre(137391.000000) -> post(79476.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00212)
        CCONN  pre(137391.000000) -> post(79498.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00213)
        CCONN  pre(137391.000000) -> post(79520.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00214)
        CCONN  pre(137391.000000) -> post(79542.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00215)
        CCONN  pre(137391.000000) -> post(79564.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00216)
        CCONN  pre(137391.000000) -> post(81962.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00217)
        CCONN  pre(137391.000000) -> post(81984.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00218)
        CCONN  pre(137391.000000) -> post(82006.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00219)
        CCONN  pre(137391.000000) -> post(82028.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00220)
        CCONN  pre(137391.000000) -> post(82050.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00221)
        CCONN  pre(137391.000000) -> post(82072.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00222)
        CCONN  pre(137391.000000) -> post(82094.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00223)
        CCONN  pre(137391.000000) -> post(82116.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00224)
        CCONN  pre(137391.000000) -> post(82138.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00225)
        CCONN  pre(137391.000000) -> post(82160.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00226)
        CCONN  pre(137391.000000) -> post(82182.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00227)
        CCONN  pre(137391.000000) -> post(82204.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00228)
        CCONN  pre(137391.000000) -> post(84602.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00229)
        CCONN  pre(137391.000000) -> post(84624.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00230)
        CCONN  pre(137391.000000) -> post(84646.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00231)
        CCONN  pre(137391.000000) -> post(84668.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00232)
        CCONN  pre(137391.000000) -> post(84690.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00233)
        CCONN  pre(137391.000000) -> post(84712.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00234)
        CCONN  pre(137391.000000) -> post(84734.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00235)
        CCONN  pre(137391.000000) -> post(84756.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00236)
        CCONN  pre(137391.000000) -> post(84778.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00237)
        CCONN  pre(137391.000000) -> post(84800.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00238)
        CCONN  pre(137391.000000) -> post(84822.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00239)
        CCONN  pre(137391.000000) -> post(84844.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00240)
        CCONN  pre(137391.000000) -> post(87242.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00241)
        CCONN  pre(137391.000000) -> post(87264.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00242)
        CCONN  pre(137391.000000) -> post(87286.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00243)
        CCONN  pre(137391.000000) -> post(87308.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00244)
        CCONN  pre(137391.000000) -> post(87330.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00245)
        CCONN  pre(137391.000000) -> post(87352.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00246)
        CCONN  pre(137391.000000) -> post(87374.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00247)
        CCONN  pre(137391.000000) -> post(87396.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00248)
        CCONN  pre(137391.000000) -> post(87418.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00249)
        CCONN  pre(137391.000000) -> post(87440.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00250)
        CCONN  pre(137391.000000) -> post(87462.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00251)
        CCONN  pre(137391.000000) -> post(87484.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00252)
        CCONN  pre(137391.000000) -> post(89882.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00253)
        CCONN  pre(137391.000000) -> post(89904.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00254)
        CCONN  pre(137391.000000) -> post(89926.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00255)
        CCONN  pre(137391.000000) -> post(89948.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00256)
        CCONN  pre(137391.000000) -> post(89970.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00257)
        CCONN  pre(137391.000000) -> post(89992.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00258)
        CCONN  pre(137391.000000) -> post(90014.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00259)
        CCONN  pre(137391.000000) -> post(90036.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00260)
        CCONN  pre(137391.000000) -> post(90058.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00261)
        CCONN  pre(137391.000000) -> post(90080.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00262)
        CCONN  pre(137391.000000) -> post(90102.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00263)
        CCONN  pre(137391.000000) -> post(90124.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00264)
        CCONN  pre(137391.000000) -> post(92522.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00265)
        CCONN  pre(137391.000000) -> post(92544.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00266)
        CCONN  pre(137391.000000) -> post(92566.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00267)
        CCONN  pre(137391.000000) -> post(92588.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00268)
        CCONN  pre(137391.000000) -> post(92610.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00269)
        CCONN  pre(137391.000000) -> post(92632.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00270)
        CCONN  pre(137391.000000) -> post(92654.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00271)
        CCONN  pre(137391.000000) -> post(92676.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00272)
        CCONN  pre(137391.000000) -> post(92698.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00273)
        CCONN  pre(137391.000000) -> post(92720.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00274)
        CCONN  pre(137391.000000) -> post(92742.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00275)
        CCONN  pre(137391.000000) -> post(92764.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00276)
        CCONN  pre(137391.000000) -> post(95162.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00277)
        CCONN  pre(137391.000000) -> post(95184.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00278)
        CCONN  pre(137391.000000) -> post(95206.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00279)
        CCONN  pre(137391.000000) -> post(95228.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00280)
        CCONN  pre(137391.000000) -> post(95250.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00281)
        CCONN  pre(137391.000000) -> post(95272.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00282)
        CCONN  pre(137391.000000) -> post(95294.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00283)
        CCONN  pre(137391.000000) -> post(95316.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00284)
        CCONN  pre(137391.000000) -> post(95338.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00285)
        CCONN  pre(137391.000000) -> post(95360.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00286)
        CCONN  pre(137391.000000) -> post(95382.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00287)
        CCONN  pre(137391.000000) -> post(95404.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00288)
        CCONN  pre(137391.000000) -> post(97802.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00289)
        CCONN  pre(137391.000000) -> post(97824.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00290)
        CCONN  pre(137391.000000) -> post(97846.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00291)
        CCONN  pre(137391.000000) -> post(97868.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00292)
        CCONN  pre(137391.000000) -> post(97890.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00293)
        CCONN  pre(137391.000000) -> post(97912.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00294)
        CCONN  pre(137391.000000) -> post(97934.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00295)
        CCONN  pre(137391.000000) -> post(97956.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00296)
        CCONN  pre(137391.000000) -> post(97978.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00297)
        CCONN  pre(137391.000000) -> post(98000.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00298)
        CCONN  pre(137391.000000) -> post(98022.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00299)
        CCONN  pre(137391.000000) -> post(98044.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00300)
        CCONN  pre(137391.000000) -> post(100442.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00301)
        CCONN  pre(137391.000000) -> post(100464.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00302)
        CCONN  pre(137391.000000) -> post(100486.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00303)
        CCONN  pre(137391.000000) -> post(100508.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00304)
        CCONN  pre(137391.000000) -> post(100530.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00305)
        CCONN  pre(137391.000000) -> post(100552.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00306)
        CCONN  pre(137391.000000) -> post(100574.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00307)
        CCONN  pre(137391.000000) -> post(100596.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00308)
        CCONN  pre(137391.000000) -> post(100618.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00309)
        CCONN  pre(137391.000000) -> post(100640.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00310)
        CCONN  pre(137391.000000) -> post(100662.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00311)
        CCONN  pre(137391.000000) -> post(100684.000000)
        CCONN  Delay, Weight (0.000000,45.000000)

Connection (00312)
        CCONN  pre(137391.000000) -> post(125.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00313)
        CCONN  pre(137391.000000) -> post(147.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00314)
        CCONN  pre(137391.000000) -> post(169.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00315)
        CCONN  pre(137391.000000) -> post(191.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00316)
        CCONN  pre(137391.000000) -> post(213.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00317)
        CCONN  pre(137391.000000) -> post(235.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00318)
        CCONN  pre(137391.000000) -> post(257.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00319)
        CCONN  pre(137391.000000) -> post(279.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00320)
        CCONN  pre(137391.000000) -> post(301.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00321)
        CCONN  pre(137391.000000) -> post(323.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00322)
        CCONN  pre(137391.000000) -> post(345.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00323)
        CCONN  pre(137391.000000) -> post(367.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00324)
        CCONN  pre(137391.000000) -> post(2765.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00325)
        CCONN  pre(137391.000000) -> post(2787.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00326)
        CCONN  pre(137391.000000) -> post(2809.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00327)
        CCONN  pre(137391.000000) -> post(2831.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00328)
        CCONN  pre(137391.000000) -> post(2853.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00329)
        CCONN  pre(137391.000000) -> post(2875.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00330)
        CCONN  pre(137391.000000) -> post(2897.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00331)
        CCONN  pre(137391.000000) -> post(2919.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00332)
        CCONN  pre(137391.000000) -> post(2941.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00333)
        CCONN  pre(137391.000000) -> post(2963.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00334)
        CCONN  pre(137391.000000) -> post(2985.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00335)
        CCONN  pre(137391.000000) -> post(3007.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00336)
        CCONN  pre(137391.000000) -> post(5405.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00337)
        CCONN  pre(137391.000000) -> post(5427.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00338)
        CCONN  pre(137391.000000) -> post(5449.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00339)
        CCONN  pre(137391.000000) -> post(5471.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00340)
        CCONN  pre(137391.000000) -> post(5493.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00341)
        CCONN  pre(137391.000000) -> post(5515.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00342)
        CCONN  pre(137391.000000) -> post(5537.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00343)
        CCONN  pre(137391.000000) -> post(5559.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00344)
        CCONN  pre(137391.000000) -> post(5581.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00345)
        CCONN  pre(137391.000000) -> post(5603.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00346)
        CCONN  pre(137391.000000) -> post(5625.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00347)
        CCONN  pre(137391.000000) -> post(5647.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00348)
        CCONN  pre(137391.000000) -> post(8045.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00349)
        CCONN  pre(137391.000000) -> post(8067.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00350)
        CCONN  pre(137391.000000) -> post(8089.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00351)
        CCONN  pre(137391.000000) -> post(8111.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00352)
        CCONN  pre(137391.000000) -> post(8133.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00353)
        CCONN  pre(137391.000000) -> post(8155.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00354)
        CCONN  pre(137391.000000) -> post(8177.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00355)
        CCONN  pre(137391.000000) -> post(8199.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00356)
        CCONN  pre(137391.000000) -> post(8221.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00357)
        CCONN  pre(137391.000000) -> post(8243.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00358)
        CCONN  pre(137391.000000) -> post(8265.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00359)
        CCONN  pre(137391.000000) -> post(8287.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00360)
        CCONN  pre(137391.000000) -> post(10685.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00361)
        CCONN  pre(137391.000000) -> post(10707.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00362)
        CCONN  pre(137391.000000) -> post(10729.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00363)
        CCONN  pre(137391.000000) -> post(10751.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00364)
        CCONN  pre(137391.000000) -> post(10773.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00365)
        CCONN  pre(137391.000000) -> post(10795.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00366)
        CCONN  pre(137391.000000) -> post(10817.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00367)
        CCONN  pre(137391.000000) -> post(10839.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00368)
        CCONN  pre(137391.000000) -> post(10861.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00369)
        CCONN  pre(137391.000000) -> post(10883.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00370)
        CCONN  pre(137391.000000) -> post(10905.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00371)
        CCONN  pre(137391.000000) -> post(10927.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00372)
        CCONN  pre(137391.000000) -> post(13325.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00373)
        CCONN  pre(137391.000000) -> post(13347.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00374)
        CCONN  pre(137391.000000) -> post(13369.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00375)
        CCONN  pre(137391.000000) -> post(13391.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00376)
        CCONN  pre(137391.000000) -> post(13413.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00377)
        CCONN  pre(137391.000000) -> post(13435.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00378)
        CCONN  pre(137391.000000) -> post(13457.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00379)
        CCONN  pre(137391.000000) -> post(13479.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00380)
        CCONN  pre(137391.000000) -> post(13501.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00381)
        CCONN  pre(137391.000000) -> post(13523.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00382)
        CCONN  pre(137391.000000) -> post(13545.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00383)
        CCONN  pre(137391.000000) -> post(13567.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00384)
        CCONN  pre(137391.000000) -> post(15965.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00385)
        CCONN  pre(137391.000000) -> post(15987.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00386)
        CCONN  pre(137391.000000) -> post(16009.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00387)
        CCONN  pre(137391.000000) -> post(16031.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00388)
        CCONN  pre(137391.000000) -> post(16053.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00389)
        CCONN  pre(137391.000000) -> post(16075.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00390)
        CCONN  pre(137391.000000) -> post(16097.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00391)
        CCONN  pre(137391.000000) -> post(16119.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00392)
        CCONN  pre(137391.000000) -> post(16141.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00393)
        CCONN  pre(137391.000000) -> post(16163.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00394)
        CCONN  pre(137391.000000) -> post(16185.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00395)
        CCONN  pre(137391.000000) -> post(16207.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00396)
        CCONN  pre(137391.000000) -> post(18605.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00397)
        CCONN  pre(137391.000000) -> post(18627.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00398)
        CCONN  pre(137391.000000) -> post(18649.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00399)
        CCONN  pre(137391.000000) -> post(18671.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00400)
        CCONN  pre(137391.000000) -> post(18693.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00401)
        CCONN  pre(137391.000000) -> post(18715.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00402)
        CCONN  pre(137391.000000) -> post(18737.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00403)
        CCONN  pre(137391.000000) -> post(18759.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00404)
        CCONN  pre(137391.000000) -> post(18781.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00405)
        CCONN  pre(137391.000000) -> post(18803.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00406)
        CCONN  pre(137391.000000) -> post(18825.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00407)
        CCONN  pre(137391.000000) -> post(18847.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00408)
        CCONN  pre(137391.000000) -> post(21245.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00409)
        CCONN  pre(137391.000000) -> post(21267.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00410)
        CCONN  pre(137391.000000) -> post(21289.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00411)
        CCONN  pre(137391.000000) -> post(21311.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00412)
        CCONN  pre(137391.000000) -> post(21333.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00413)
        CCONN  pre(137391.000000) -> post(21355.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00414)
        CCONN  pre(137391.000000) -> post(21377.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00415)
        CCONN  pre(137391.000000) -> post(21399.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00416)
        CCONN  pre(137391.000000) -> post(21421.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00417)
        CCONN  pre(137391.000000) -> post(21443.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00418)
        CCONN  pre(137391.000000) -> post(21465.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00419)
        CCONN  pre(137391.000000) -> post(21487.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00420)
        CCONN  pre(137391.000000) -> post(23885.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00421)
        CCONN  pre(137391.000000) -> post(23907.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00422)
        CCONN  pre(137391.000000) -> post(23929.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00423)
        CCONN  pre(137391.000000) -> post(23951.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00424)
        CCONN  pre(137391.000000) -> post(23973.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00425)
        CCONN  pre(137391.000000) -> post(23995.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00426)
        CCONN  pre(137391.000000) -> post(24017.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00427)
        CCONN  pre(137391.000000) -> post(24039.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00428)
        CCONN  pre(137391.000000) -> post(24061.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00429)
        CCONN  pre(137391.000000) -> post(24083.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00430)
        CCONN  pre(137391.000000) -> post(24105.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00431)
        CCONN  pre(137391.000000) -> post(24127.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00432)
        CCONN  pre(137391.000000) -> post(26525.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00433)
        CCONN  pre(137391.000000) -> post(26547.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00434)
        CCONN  pre(137391.000000) -> post(26569.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00435)
        CCONN  pre(137391.000000) -> post(26591.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00436)
        CCONN  pre(137391.000000) -> post(26613.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00437)
        CCONN  pre(137391.000000) -> post(26635.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00438)
        CCONN  pre(137391.000000) -> post(26657.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00439)
        CCONN  pre(137391.000000) -> post(26679.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00440)
        CCONN  pre(137391.000000) -> post(26701.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00441)
        CCONN  pre(137391.000000) -> post(26723.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00442)
        CCONN  pre(137391.000000) -> post(26745.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00443)
        CCONN  pre(137391.000000) -> post(26767.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00444)
        CCONN  pre(137391.000000) -> post(29165.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00445)
        CCONN  pre(137391.000000) -> post(29187.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00446)
        CCONN  pre(137391.000000) -> post(29209.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00447)
        CCONN  pre(137391.000000) -> post(29231.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00448)
        CCONN  pre(137391.000000) -> post(29253.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00449)
        CCONN  pre(137391.000000) -> post(29275.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00450)
        CCONN  pre(137391.000000) -> post(29297.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00451)
        CCONN  pre(137391.000000) -> post(29319.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00452)
        CCONN  pre(137391.000000) -> post(29341.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00453)
        CCONN  pre(137391.000000) -> post(29363.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00454)
        CCONN  pre(137391.000000) -> post(29385.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00455)
        CCONN  pre(137391.000000) -> post(29407.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00456)
        CCONN  pre(137391.000000) -> post(31805.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00457)
        CCONN  pre(137391.000000) -> post(31827.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00458)
        CCONN  pre(137391.000000) -> post(31849.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00459)
        CCONN  pre(137391.000000) -> post(31871.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00460)
        CCONN  pre(137391.000000) -> post(31893.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00461)
        CCONN  pre(137391.000000) -> post(31915.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00462)
        CCONN  pre(137391.000000) -> post(31937.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00463)
        CCONN  pre(137391.000000) -> post(31959.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00464)
        CCONN  pre(137391.000000) -> post(31981.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00465)
        CCONN  pre(137391.000000) -> post(32003.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00466)
        CCONN  pre(137391.000000) -> post(32025.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00467)
        CCONN  pre(137391.000000) -> post(32047.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00468)
        CCONN  pre(137391.000000) -> post(68765.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00469)
        CCONN  pre(137391.000000) -> post(68787.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00470)
        CCONN  pre(137391.000000) -> post(68809.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00471)
        CCONN  pre(137391.000000) -> post(68831.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00472)
        CCONN  pre(137391.000000) -> post(68853.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00473)
        CCONN  pre(137391.000000) -> post(68875.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00474)
        CCONN  pre(137391.000000) -> post(68897.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00475)
        CCONN  pre(137391.000000) -> post(68919.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00476)
        CCONN  pre(137391.000000) -> post(68941.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00477)
        CCONN  pre(137391.000000) -> post(68963.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00478)
        CCONN  pre(137391.000000) -> post(68985.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00479)
        CCONN  pre(137391.000000) -> post(69007.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00480)
        CCONN  pre(137391.000000) -> post(71405.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00481)
        CCONN  pre(137391.000000) -> post(71427.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00482)
        CCONN  pre(137391.000000) -> post(71449.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00483)
        CCONN  pre(137391.000000) -> post(71471.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00484)
        CCONN  pre(137391.000000) -> post(71493.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00485)
        CCONN  pre(137391.000000) -> post(71515.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00486)
        CCONN  pre(137391.000000) -> post(71537.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00487)
        CCONN  pre(137391.000000) -> post(71559.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00488)
        CCONN  pre(137391.000000) -> post(71581.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00489)
        CCONN  pre(137391.000000) -> post(71603.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00490)
        CCONN  pre(137391.000000) -> post(71625.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00491)
        CCONN  pre(137391.000000) -> post(71647.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00492)
        CCONN  pre(137391.000000) -> post(74045.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00493)
        CCONN  pre(137391.000000) -> post(74067.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00494)
        CCONN  pre(137391.000000) -> post(74089.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00495)
        CCONN  pre(137391.000000) -> post(74111.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00496)
        CCONN  pre(137391.000000) -> post(74133.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00497)
        CCONN  pre(137391.000000) -> post(74155.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00498)
        CCONN  pre(137391.000000) -> post(74177.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00499)
        CCONN  pre(137391.000000) -> post(74199.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00500)
        CCONN  pre(137391.000000) -> post(74221.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00501)
        CCONN  pre(137391.000000) -> post(74243.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00502)
        CCONN  pre(137391.000000) -> post(74265.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00503)
        CCONN  pre(137391.000000) -> post(74287.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00504)
        CCONN  pre(137391.000000) -> post(76685.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00505)
        CCONN  pre(137391.000000) -> post(76707.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00506)
        CCONN  pre(137391.000000) -> post(76729.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00507)
        CCONN  pre(137391.000000) -> post(76751.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00508)
        CCONN  pre(137391.000000) -> post(76773.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00509)
        CCONN  pre(137391.000000) -> post(76795.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00510)
        CCONN  pre(137391.000000) -> post(76817.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00511)
        CCONN  pre(137391.000000) -> post(76839.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00512)
        CCONN  pre(137391.000000) -> post(76861.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00513)
        CCONN  pre(137391.000000) -> post(76883.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00514)
        CCONN  pre(137391.000000) -> post(76905.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00515)
        CCONN  pre(137391.000000) -> post(76927.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00516)
        CCONN  pre(137391.000000) -> post(79325.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00517)
        CCONN  pre(137391.000000) -> post(79347.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00518)
        CCONN  pre(137391.000000) -> post(79369.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00519)
        CCONN  pre(137391.000000) -> post(79391.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00520)
        CCONN  pre(137391.000000) -> post(79413.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00521)
        CCONN  pre(137391.000000) -> post(79435.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00522)
        CCONN  pre(137391.000000) -> post(79457.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00523)
        CCONN  pre(137391.000000) -> post(79479.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00524)
        CCONN  pre(137391.000000) -> post(79501.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00525)
        CCONN  pre(137391.000000) -> post(79523.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00526)
        CCONN  pre(137391.000000) -> post(79545.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00527)
        CCONN  pre(137391.000000) -> post(79567.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00528)
        CCONN  pre(137391.000000) -> post(81965.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00529)
        CCONN  pre(137391.000000) -> post(81987.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00530)
        CCONN  pre(137391.000000) -> post(82009.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00531)
        CCONN  pre(137391.000000) -> post(82031.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00532)
        CCONN  pre(137391.000000) -> post(82053.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00533)
        CCONN  pre(137391.000000) -> post(82075.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00534)
        CCONN  pre(137391.000000) -> post(82097.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00535)
        CCONN  pre(137391.000000) -> post(82119.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00536)
        CCONN  pre(137391.000000) -> post(82141.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00537)
        CCONN  pre(137391.000000) -> post(82163.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00538)
        CCONN  pre(137391.000000) -> post(82185.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00539)
        CCONN  pre(137391.000000) -> post(82207.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00540)
        CCONN  pre(137391.000000) -> post(84605.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00541)
        CCONN  pre(137391.000000) -> post(84627.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00542)
        CCONN  pre(137391.000000) -> post(84649.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00543)
        CCONN  pre(137391.000000) -> post(84671.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00544)
        CCONN  pre(137391.000000) -> post(84693.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00545)
        CCONN  pre(137391.000000) -> post(84715.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00546)
        CCONN  pre(137391.000000) -> post(84737.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00547)
        CCONN  pre(137391.000000) -> post(84759.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00548)
        CCONN  pre(137391.000000) -> post(84781.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00549)
        CCONN  pre(137391.000000) -> post(84803.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00550)
        CCONN  pre(137391.000000) -> post(84825.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00551)
        CCONN  pre(137391.000000) -> post(84847.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00552)
        CCONN  pre(137391.000000) -> post(87245.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00553)
        CCONN  pre(137391.000000) -> post(87267.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00554)
        CCONN  pre(137391.000000) -> post(87289.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00555)
        CCONN  pre(137391.000000) -> post(87311.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00556)
        CCONN  pre(137391.000000) -> post(87333.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00557)
        CCONN  pre(137391.000000) -> post(87355.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00558)
        CCONN  pre(137391.000000) -> post(87377.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00559)
        CCONN  pre(137391.000000) -> post(87399.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00560)
        CCONN  pre(137391.000000) -> post(87421.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00561)
        CCONN  pre(137391.000000) -> post(87443.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00562)
        CCONN  pre(137391.000000) -> post(87465.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00563)
        CCONN  pre(137391.000000) -> post(87487.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00564)
        CCONN  pre(137391.000000) -> post(89885.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00565)
        CCONN  pre(137391.000000) -> post(89907.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00566)
        CCONN  pre(137391.000000) -> post(89929.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00567)
        CCONN  pre(137391.000000) -> post(89951.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00568)
        CCONN  pre(137391.000000) -> post(89973.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00569)
        CCONN  pre(137391.000000) -> post(89995.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00570)
        CCONN  pre(137391.000000) -> post(90017.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00571)
        CCONN  pre(137391.000000) -> post(90039.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00572)
        CCONN  pre(137391.000000) -> post(90061.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00573)
        CCONN  pre(137391.000000) -> post(90083.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00574)
        CCONN  pre(137391.000000) -> post(90105.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00575)
        CCONN  pre(137391.000000) -> post(90127.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00576)
        CCONN  pre(137391.000000) -> post(92525.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00577)
        CCONN  pre(137391.000000) -> post(92547.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00578)
        CCONN  pre(137391.000000) -> post(92569.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00579)
        CCONN  pre(137391.000000) -> post(92591.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00580)
        CCONN  pre(137391.000000) -> post(92613.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00581)
        CCONN  pre(137391.000000) -> post(92635.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00582)
        CCONN  pre(137391.000000) -> post(92657.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00583)
        CCONN  pre(137391.000000) -> post(92679.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00584)
        CCONN  pre(137391.000000) -> post(92701.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00585)
        CCONN  pre(137391.000000) -> post(92723.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00586)
        CCONN  pre(137391.000000) -> post(92745.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00587)
        CCONN  pre(137391.000000) -> post(92767.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00588)
        CCONN  pre(137391.000000) -> post(95165.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00589)
        CCONN  pre(137391.000000) -> post(95187.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00590)
        CCONN  pre(137391.000000) -> post(95209.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00591)
        CCONN  pre(137391.000000) -> post(95231.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00592)
        CCONN  pre(137391.000000) -> post(95253.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00593)
        CCONN  pre(137391.000000) -> post(95275.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00594)
        CCONN  pre(137391.000000) -> post(95297.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00595)
        CCONN  pre(137391.000000) -> post(95319.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00596)
        CCONN  pre(137391.000000) -> post(95341.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00597)
        CCONN  pre(137391.000000) -> post(95363.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00598)
        CCONN  pre(137391.000000) -> post(95385.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00599)
        CCONN  pre(137391.000000) -> post(95407.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00600)
        CCONN  pre(137391.000000) -> post(97805.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00601)
        CCONN  pre(137391.000000) -> post(97827.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00602)
        CCONN  pre(137391.000000) -> post(97849.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00603)
        CCONN  pre(137391.000000) -> post(97871.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00604)
        CCONN  pre(137391.000000) -> post(97893.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00605)
        CCONN  pre(137391.000000) -> post(97915.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00606)
        CCONN  pre(137391.000000) -> post(97937.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00607)
        CCONN  pre(137391.000000) -> post(97959.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00608)
        CCONN  pre(137391.000000) -> post(97981.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00609)
        CCONN  pre(137391.000000) -> post(98003.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00610)
        CCONN  pre(137391.000000) -> post(98025.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00611)
        CCONN  pre(137391.000000) -> post(98047.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00612)
        CCONN  pre(137391.000000) -> post(100445.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00613)
        CCONN  pre(137391.000000) -> post(100467.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00614)
        CCONN  pre(137391.000000) -> post(100489.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00615)
        CCONN  pre(137391.000000) -> post(100511.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00616)
        CCONN  pre(137391.000000) -> post(100533.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00617)
        CCONN  pre(137391.000000) -> post(100555.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00618)
        CCONN  pre(137391.000000) -> post(100577.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00619)
        CCONN  pre(137391.000000) -> post(100599.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00620)
        CCONN  pre(137391.000000) -> post(100621.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00621)
        CCONN  pre(137391.000000) -> post(100643.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00622)
        CCONN  pre(137391.000000) -> post(100665.000000)
        CCONN  Delay, Weight (0.000000,9.000000)

Connection (00623)
        CCONN  pre(137391.000000) -> post(100687.000000)
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
						   read => "Traversal serial ID = 1141
Principal serial ID = 1141 of 153157 Principal successors
",
# Mechanism serial ID = 656 of 77484 Mechanism successors
# Segment  serial  ID = 73 of 27288  Segment  successors
						   write => "serialMapping /CerebellarCortex/Purkinjes /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine_0/neck",
						  },
						  {
						   description => "Can the mossy fiber forestspace IDs be found ?",
						   read => "serial id /CerebellarCortex,22 -> /CerebellarCortex/MossyFibers/3/value
",
						   write => "serial2context /CerebellarCortex 22",
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


