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
						   description => "biogroup identification of BIOLEVEL_NERVOUS_SYSTEM",
						   read => "biolevel BIOLEVEL_NERVOUS_SYSTEM has BIOLEVELGROUP_NERVOUS_SYSTEM as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_NERVOUS_SYSTEM",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_BRAIN",
						   read => "biolevel BIOLEVEL_BRAIN has BIOLEVELGROUP_BRAIN_STRUCTURE as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_BRAIN",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_BRAIN_STRUCTURE",
						   read => "biolevel BIOLEVEL_BRAIN_STRUCTURE has BIOLEVELGROUP_BRAIN_STRUCTURE as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_BRAIN_STRUCTURE",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_BRAIN_REGION",
						   read => "biolevel BIOLEVEL_BRAIN_REGION has BIOLEVELGROUP_BRAIN_STRUCTURE as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_BRAIN_REGION",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_NETWORK",
						   read => "biolevel BIOLEVEL_NETWORK has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_NETWORK",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_POPULATION",
						   read => "biolevel BIOLEVEL_POPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_POPULATION",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_SUBPOPULATION",
						   read => "biolevel BIOLEVEL_SUBPOPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_SUBPOPULATION",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_CELL",
						   read => "biolevel BIOLEVEL_CELL has BIOLEVELGROUP_CELL as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_CELL",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_SEGMENT",
						   read => "biolevel BIOLEVEL_SEGMENT has BIOLEVELGROUP_SEGMENT as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_SEGMENT",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_MECHANISM",
						   read => "biolevel BIOLEVEL_MECHANISM has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_MECHANISM",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_CHEMICAL_PATHWAY",
						   read => "biolevel BIOLEVEL_CHEMICAL_PATHWAY has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_CHEMICAL_PATHWAY",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_MOLECULAR",
						   read => "biolevel BIOLEVEL_MOLECULAR has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_MOLECULAR",
						  },
						  {
						   description => "biogroup identification of BIOLEVEL_ATOMIC",
						   read => "biolevel BIOLEVEL_ATOMIC has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup BIOLEVEL_ATOMIC",
						  },
						 ],
				description => "symbolic biogroup identifications",
			       },
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
						   description => "biogroup identification of number 10",
						   read => "biolevel BIOLEVEL_NERVOUS_SYSTEM has BIOLEVELGROUP_NERVOUS_SYSTEM as biogroup",
						   write => "biolevel2biogroup 10",
						  },
						  {
						   description => "biogroup identification of number 20",
						   read => "biolevel BIOLEVEL_BRAIN has BIOLEVELGROUP_BRAIN_STRUCTURE as biogroup",
						   write => "biolevel2biogroup 20",
						  },
						  {
						   description => "biogroup identification of number 30",
						   read => "biolevel BIOLEVEL_BRAIN_STRUCTURE has BIOLEVELGROUP_BRAIN_STRUCTURE as biogroup",
						   write => "biolevel2biogroup 30",
						  },
						  {
						   description => "biogroup identification of number 40",
						   read => "biolevel BIOLEVEL_BRAIN_REGION has BIOLEVELGROUP_BRAIN_STRUCTURE as biogroup",
						   write => "biolevel2biogroup 40",
						  },
						  {
						   description => "biogroup identification of number 50",
						   read => "biolevel BIOLEVEL_NETWORK has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup 50",
						  },
						  {
						   description => "biogroup identification of number 60",
						   read => "biolevel BIOLEVEL_POPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup 60",
						  },
						  {
						   description => "biogroup identification of number 70",
						   read => "biolevel BIOLEVEL_SUBPOPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup 70",
						  },
						  {
						   description => "biogroup identification of number 80",
						   read => "biolevel BIOLEVEL_CELL has BIOLEVELGROUP_CELL as biogroup",
						   write => "biolevel2biogroup 80",
						  },
						  {
						   description => "biogroup identification of number 90",
						   read => "biolevel BIOLEVEL_SEGMENT has BIOLEVELGROUP_SEGMENT as biogroup",
						   write => "biolevel2biogroup 90",
						  },
						  {
						   description => "biogroup identification of number 100",
						   read => "biolevel BIOLEVEL_MECHANISM has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup 100",
						  },
						  {
						   description => "biogroup identification of number 110",
						   read => "biolevel BIOLEVEL_CHEMICAL_PATHWAY has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup 110",
						  },
						  {
						   description => "biogroup identification of number 120",
						   read => "biolevel BIOLEVEL_MOLECULAR has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup 120",
						  },
						  {
						   description => "biogroup identification of number 130",
						   read => "biolevel BIOLEVEL_ATOMIC has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup 130",
						  },
						 ],
				description => "numeric biogroup identifications",
			       },
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
						   description => "biolevelgroup conversion of BIOLEVELGROUP_NERVOUS_SYSTEM (100000)",
						   read => "biogroup BIOLEVELGROUP_NERVOUS_SYSTEM has BIOLEVEL_NERVOUS_SYSTEM as lowest component",
						   write => "biogroup2biolevel BIOLEVELGROUP_NERVOUS_SYSTEM",
						  },
						  {
						   description => "biolevelgroup conversion of BIOLEVELGROUP_BRAIN_STRUCTURE (200000)",
						   read => "biogroup BIOLEVELGROUP_BRAIN_STRUCTURE has BIOLEVEL_BRAIN_REGION as lowest component",
						   write => "biogroup2biolevel BIOLEVELGROUP_BRAIN_STRUCTURE",
						  },
						  {
						   description => "biolevelgroup conversion of BIOLEVELGROUP_NETWORK (300000)",
						   read => "biogroup BIOLEVELGROUP_NETWORK has BIOLEVEL_SUBPOPULATION as lowest component",
						   write => "biogroup2biolevel BIOLEVELGROUP_NETWORK",
						  },
						  {
						   description => "biolevelgroup conversion of BIOLEVELGROUP_CELL (400000)",
						   read => "biogroup BIOLEVELGROUP_CELL has BIOLEVEL_CELL as lowest component",
						   write => "biogroup2biolevel BIOLEVELGROUP_CELL",
						  },
						  {
						   description => "biolevelgroup conversion of BIOLEVELGROUP_SEGMENT (500000)",
						   read => "biogroup BIOLEVELGROUP_SEGMENT has BIOLEVEL_SEGMENT as lowest component",
						   write => "biogroup2biolevel BIOLEVELGROUP_SEGMENT",
						  },
						  {
						   description => "biolevelgroup conversion of BIOLEVELGROUP_MECHANISM (600000)",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup2biolevel BIOLEVELGROUP_MECHANISM",
						  },
						 ],
				description => "symbolic biolevel identifications",
			       },
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
						   description => "biolevelgroup conversion 100000 (BIOLEVELGROUP_NERVOUS_SYSTEM)",
						   read => "biogroup BIOLEVELGROUP_NERVOUS_SYSTEM has BIOLEVEL_NERVOUS_SYSTEM as lowest component",
						   write => "biogroup2biolevel 100000",
						  },
						  {
						   description => "biolevelgroup conversion 200000 (BIOLEVELGROUP_BRAIN_STRUCTURE)",
						   read => "biogroup BIOLEVELGROUP_BRAIN_STRUCTURE has BIOLEVEL_BRAIN_REGION as lowest component",
						   write => "biogroup2biolevel 200000",
						  },
						  {
						   description => "biolevelgroup conversion 300000 (BIOLEVELGROUP_NETWORK)",
						   read => "biogroup BIOLEVELGROUP_NETWORK has BIOLEVEL_SUBPOPULATION as lowest component",
						   write => "biogroup2biolevel 300000",
						  },
						  {
						   description => "biolevelgroup conversion 400000 (BIOLEVELGROUP_CELL)",
						   read => "biogroup BIOLEVELGROUP_CELL has BIOLEVEL_CELL as lowest component",
						   write => "biogroup2biolevel 400000",
						  },
						  {
						   description => "biolevelgroup conversion 500000 (BIOLEVELGROUP_SEGMENT)",
						   read => "biogroup BIOLEVELGROUP_SEGMENT has BIOLEVEL_SEGMENT as lowest component",
						   write => "biogroup2biolevel 500000",
						  },
						  {
						   description => "biolevelgroup conversion 600000 (BIOLEVELGROUP_MECHANISM)",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup2biolevel 600000",
						  },
						 ],
				description => "numeric biolevel identifications",
			       },
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
						   description => "biolevel and biogroup identification of /",
						   read => "biolevel BIOLEVEL_NERVOUS_SYSTEM has BIOLEVELGROUP_NERVOUS_SYSTEM as biogroup",
						   write => "biolevel2biogroup /",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex",
						   read => "biolevel BIOLEVEL_NETWORK has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/MossyFibers",
						   read => "biolevel BIOLEVEL_POPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/MossyFibers",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/MossyFibers/0",
						   read => "biolevel BIOLEVEL_CELL has BIOLEVELGROUP_CELL as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/MossyFibers/0",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/MossyFibers/0/value",
						   read => "Unable to resolve biolevel -1", # biolevel BIOLEVEL_SEGMENT has BIOLEVELGROUP_SEGMENT as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/MossyFibers/0/value",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/MossyFibers/0/spikegen",
						   read => "Unable to resolve biolevel -1",
						   write => "biolevel2biogroup /CerebellarCortex/MossyFibers/0/spikegen",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes",
						   read => "biolevel BIOLEVEL_POPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0",
						   read => "biolevel BIOLEVEL_CELL has BIOLEVELGROUP_CELL as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments",
						   read => "Unable to resolve biolevel -1",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments/soma",
						   read => "biolevel BIOLEVEL_SEGMENT has BIOLEVELGROUP_SEGMENT as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments/soma",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments/soma/Kdr",
						   read => "biolevel BIOLEVEL_MECHANISM has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments/soma/Kdr",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments/soma/pf_AMPA",
						   read => "symbol not found",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments/soma/pf_AMPA",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments/soma/basket",
						   read => "biolevel BIOLEVEL_MECHANISM has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments/soma/basket",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments/soma/basket/exp2",
						   read => "Unable to resolve biolevel -1",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments/soma/basket/exp2",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/Purkinjes/0/segments/soma/basket/synapse",
						   read => "Unable to resolve biolevel -1",
						   write => "biolevel2biogroup /CerebellarCortex/Purkinjes/0/segments/soma/basket/synapse",
						  },
						  {
						   description => "biolevel and biogroup identification of /CerebellarCortex/ForwardProjection",
						   read => "biolevel BIOLEVEL_POPULATION has BIOLEVELGROUP_NETWORK as biogroup",
						   write => "biolevel /CerebellarCortex/ForwardProjection",
						  },
						 ],
				description => "biolevel and biogroup identification of model components",
			       },
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
						   description => "biogroup and biolevel conversion of /",
						   read => "biogroup BIOLEVELGROUP_NERVOUS_SYSTEM has BIOLEVEL_NERVOUS_SYSTEM as lowest component",
						   write => "biogroup /",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex",
						   read => "biogroup BIOLEVELGROUP_NETWORK has BIOLEVEL_SUBPOPULATION as lowest component",
						   write => "biogroup /CerebellarCortex",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/MossyFibers",
						   read => "biogroup BIOLEVELGROUP_NETWORK has BIOLEVEL_SUBPOPULATION as lowest component",
						   write => "biogroup /CerebellarCortex/MossyFibers",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/MossyFibers/0",
						   read => "biogroup BIOLEVELGROUP_CELL has BIOLEVEL_CELL as lowest component",
						   write => "biogroup /CerebellarCortex/MossyFibers/0",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/MossyFibers/0/value",
						   read => "Unable to resolve biogroup -1", # biogroup BIOLEVELGROUP_SEGMENT has BIOLEVEL_SEGMENT as lowest component",
						   write => "biogroup /CerebellarCortex/MossyFibers/0/value",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/MossyFibers/0/spikegen",
						   read => "Unable to resolve biogroup -1",
						   write => "biogroup /CerebellarCortex/MossyFibers/0/spikegen",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes",
						   read => "biogroup BIOLEVELGROUP_NETWORK has BIOLEVEL_SUBPOPULATION as lowest component",
						   write => "biogroup /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes/0",
						   read => "biogroup BIOLEVELGROUP_CELL has BIOLEVEL_CELL as lowest component",
						   write => "biogroup /CerebellarCortex/Purkinjes/0",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes/0/library",
						   read => "symbol not found",
						   write => "biogroup /CerebellarCortex/Purkinjes/0/library",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes/0/segments",
						   read => "Unable to resolve biogroup -1",
						   write => "biogroup /CerebellarCortex/Purkinjes/0/segments",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes/0/segments/soma",
						   read => "biogroup BIOLEVELGROUP_SEGMENT has BIOLEVEL_SEGMENT as lowest component",
						   write => "biogroup /CerebellarCortex/Purkinjes/0/segments/soma",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes/0/segments/soma/basket",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /CerebellarCortex/Purkinjes/0/segments/soma/basket",
						  },
						  {
						   description => "biogroup and biolevel conversion of /CerebellarCortex/Purkinjes/0/segments/soma/basket/synapse",
						   read => "Unable to resolve biogroup -1",
						   write => "biogroup /CerebellarCortex/Purkinjes/0/segments/soma/basket/synapse",
						  },
						  {
						   description => "biogroup and biolevel identification of /CerebellarCortex/Purkinjes/0/segments/soma/basket/synapse",
						   read => "biogroup BIOLEVELGROUP_NETWORK has BIOLEVEL_SUBPOPULATION as lowest component",
						   write => "biogroup /CerebellarCortex/ForwardProjection",
						  },
						 ],
				description => "biogroup and biolevel identification of model components",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'tests/cells/pool1_feedback1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (tests/cells/pool1_feedback1.ndf) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1_feedback1.ndf.', ],
						   timeout => 5,
						   write => undef,
						  },
						  {
						   description => "biogroup and biolevel conversion of /",
						   read => "biogroup BIOLEVELGROUP_NERVOUS_SYSTEM has BIOLEVEL_NERVOUS_SYSTEM as lowest component",
						   write => "biogroup /",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1",
						   read => "biogroup BIOLEVELGROUP_CELL has BIOLEVEL_CELL as lowest component",
						   write => "biogroup /pool1_feedback1",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1/segments/main[0]",
						   read => "biogroup BIOLEVELGROUP_SEGMENT has BIOLEVEL_SEGMENT as lowest component",
						   write => "biogroup /pool1_feedback1/segments/main[0]",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1/segments/main[0]/kc",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /pool1_feedback1/segments/main[0]/kc",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1/segments/main[0]/kc/kc_gate_activation",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /pool1_feedback1/segments/main[0]/kc/kc_gate_activation",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1/segments/main[0]/kc/kc_gate_activation/A",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /pool1_feedback1/segments/main[0]/kc/kc_gate_activation/A",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1/segments/main[0]/kc/kc_gate_concentration",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /pool1_feedback1/segments/main[0]/kc/kc_gate_concentration",
						  },
						  {
						   description => "biogroup and biolevel conversion of /pool1_feedback1/segments/main[0]/kc/kc_gate_concentration/concentration_kinetic",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /pool1_feedback1/segments/main[0]/kc/kc_gate_concentration/concentration_kinetic",
						  },
						 ],
				description => "biogroup and biolevel identification of model components, gates and related",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'contours/section1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "biogroup and biolevel conversion of /",
						   read => "biolevel BIOLEVEL_NERVOUS_SYSTEM has BIOLEVELGROUP_NERVOUS_SYSTEM as biogroup",
						   write => "biolevel /",
						  },
						  {
						   description => "biogroup and biolevel conversion of /",
						   read => "biogroup BIOLEVELGROUP_NERVOUS_SYSTEM has BIOLEVEL_NERVOUS_SYSTEM as lowest component",
						   write => "biogroup /",
						  },
						  {
						   description => "biogroup and biolevel conversion of /section1",
						   read => "Unable to resolve biolevel -1",
						   write => "biolevel /section1",
						  },
						  {
						   description => "biogroup and biolevel conversion of /section1",
						   read => "Unable to resolve biogroup -1",
						   write => "biogroup /section1",
						  },
						  {
						   description => "biogroup and biolevel conversion of /section1/e1",
						   read => "biolevel BIOLEVEL_ATOMIC has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel /section1/e1",
						  },
						  {
						   description => "biogroup and biolevel conversion of /section1/e1",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /section1/e1",
						  },
						  {
						   description => "biogroup and biolevel conversion of /section1/e1/e1_1",
						   read => "biolevel BIOLEVEL_ATOMIC has BIOLEVELGROUP_MECHANISM as biogroup",
						   write => "biolevel /section1/e1/e1_1",
						  },
						  {
						   description => "biogroup and biolevel conversion of /section1/e1/e1_1",
						   read => "biogroup BIOLEVELGROUP_MECHANISM has BIOLEVEL_ATOMIC as lowest component",
						   write => "biogroup /section1/e1/e1_1",
						  },
						 ],
				description => "biogroup and biolevel identification of model components, EM contours and related",
			       },
			      ],
       description => "biolevels and biogroups definitions",
       name => 'biolevels.t',
      };


return $test;


