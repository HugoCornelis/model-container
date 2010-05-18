#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => 'neurospaces ',
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "A symbol must match with its entire subtree",
						   read => "Match",
						   write => "match /Purk /Purk/**",
						  },
						  {
						   description => "Different symbols must not match",
						   read => "No match",
						   write => "match /Purk1 /Purk",
						  },
						  {
						   description => "Symbols must not match with the subtree of a different symbol",
						   read => "No match",
						   write => "match /Purk1 /Purk/**",
						  },
						  {
						   description => "A nested symbol must match with a wildcard.",
						   read => "Match",
						   write => "match /Purk/soma/gaba/synapse /Purk/soma/**/synapse",
						  },
						  {
						   description => "A nested symbol must match with a wildcard over many levels.",
						   read => "Match",
						   write => "match /Purk/soma/channels/gaba/synapse /Purk/**/synapse",
						  },
						  {
						   description => "A nested symbol must match with a multiple wildcard over many levels.",
						   read => "Match",
						   write => "match /Purk/soma/channels/gaba/synapse /Purk/**/**/synapse",
						  },
						  {
						   description => "A symbol nested over two levels must match with a wildcard over two levels.",
						   read => "Match",
						   write => "match /Purk/soma/gaba/synapse /Purk/**/**/synapse",
						  },
						  {
						   description => "A symbol nested over one level must not match with a wildcard over two levels.",
						   read => "No match",
						   write => "match /Purk/soma/synapse /Purk/**/**/synapse",
						  },
						  {
						   description => "A nested symbol must not match with a wildcard over many levels if the names are different.",
						   read => "No match",
						   write => "match /Purk/soma/channels/gaba/syn /Purk/**/synapse",
						  },
						  {
						   description => "A symbol nested over one level must not match with a wildcard over two levels if the names differ.",
						   read => "No match",
						   write => "match /Purk/soma/synapse /Purk/**/**/syn",
						  },
						  {
						   description => "A deeply nested symbol must match with a wildcard, prefixed with the same context.",
						   read => "Match",
						   write => "match /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine/head/par /CerebellarCortex/Purkinjes/0/**",
						  },
						 ],
				description => "path selections",
			       },
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
						   description => "Can we get parse info on /CerebellarCortex/Purkinjes ?",
						   read => '
- parsed context: /CerebellarCortex/Purkinjes
- found using SymbolsLookupHierarchical()
- found using PidinStackLookupTopSymbol()
',
						   write => "context-info /CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "Can we get parse info on //CerebellarCortex/Purkinjes ?",
						   read => '
- parsed context: /CerebellarCortex/Purkinjes
- found using SymbolsLookupHierarchical()
- found using PidinStackLookupTopSymbol()
',
						   write => "context-info //CerebellarCortex/Purkinjes",
						  },
						  {
						   description => "Can we get parse info on /CerebellarCortex//Purkinjes ?",
						   read => '
- parsed context: /CerebellarCortex/Purkinjes
- found using SymbolsLookupHierarchical()
- found using PidinStackLookupTopSymbol()
',
						   write => "context-info /CerebellarCortex//Purkinjes",
						  },
						  {
						   description => "Can we get parse info on //CerebellarCortex//Purkinjes ?",
						   read => '
- parsed context: /CerebellarCortex/Purkinjes
- found using SymbolsLookupHierarchical()
- found using PidinStackLookupTopSymbol()
',
						   write => "context-info //CerebellarCortex//Purkinjes",
						  },
						  {
						   description => "Can we get parse info on //CerebellarCortex/./Purkinjes ?",
						   read => '
- parsed context: /CerebellarCortex/Purkinjes
- found using SymbolsLookupHierarchical()
- found using PidinStackLookupTopSymbol()
',
						   write => "context-info //CerebellarCortex/./Purkinjes",
						  },
						 ],
				description => "context parsing, no fields",
			       },
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
						   description => "Can we get input info on /CerebellarCortex/Purkinjes/0/segments/soma/CaT ?",
						   read => 'inputs:
CaT input 0: ../Vm, child not defined in this context
CaT input 1: ../Vm, child not defined in this context
CaT input 2: ../Vm, child not defined in this context
',
						   write => "input-info /CerebellarCortex/Purkinjes/0/segments/soma/CaT",
						  },
						  {
						   description => "Can we get input info on /CerebellarCortex/Purkinjes/0/segments/soma/CaT ?",
						   read => 'inputs:
Ca_pool input 0: ../CaT/I, child not defined in this context
Ca_pool input 1: ../CaT/I, child not defined in this context
Ca_concen input 2: ../CaT/I, child not defined in this context
Ca_concen input 3: ../CaT/I, child not defined in this context
',
						   write => "input-info /CerebellarCortex/Purkinjes/0/segments/soma/Ca_pool",
						  },
						 ],
				description => "context and field parsing",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/legacy/networks/networksmall.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "A single symbol expansion",
						   read => "/CerebellarCortex/Golgis/1/Golgi_soma/spikegen",
						   write => "expand /CerebellarCortex/Golgis/1/Golgi_soma/spikegen/**",
						  },
						  {
						   description => "A small population expansion",
						   read => "
- /CerebellarCortex/MossyFibers
- /CerebellarCortex/MossyFibers/MossyGrid
- /CerebellarCortex/MossyFibers/0
- /CerebellarCortex/MossyFibers/0/value
- /CerebellarCortex/MossyFibers/0/spikegen
- /CerebellarCortex/MossyFibers/1
- /CerebellarCortex/MossyFibers/1/value
- /CerebellarCortex/MossyFibers/1/spikegen
- /CerebellarCortex/MossyFibers/2
- /CerebellarCortex/MossyFibers/2/value
- /CerebellarCortex/MossyFibers/2/spikegen
- /CerebellarCortex/MossyFibers/3
- /CerebellarCortex/MossyFibers/3/value
- /CerebellarCortex/MossyFibers/3/spikegen
",
						   write => "expand /CerebellarCortex/MossyFibers/**",
						  },
						  {
						   description => "A selective single population expansion on spike receivers",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/mf_AMPA/synapse
- /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse
- /CerebellarCortex/Golgis/1/Golgi_soma/mf_AMPA/synapse
- /CerebellarCortex/Golgis/1/Golgi_soma/pf_AMPA/synapse
",
						   write => "expand /CerebellarCortex/Golgis/**/synapse",
						  },
						  {
						   description => "A selective single population expansion on spike generators",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
- /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /CerebellarCortex/Golgis/**/spikegen",
						  },
						  {
						   description => "A selective single population expansion on spike generators, alternate form",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
- /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /**/Golgis/**/spikegen",
						  },
						  {
						   description => "A selective multiple population expansion on spike generators",
						   read => "/CerebellarCortex/MossyFibers/0/spikegen
- /CerebellarCortex/MossyFibers/1/spikegen
- /CerebellarCortex/MossyFibers/2/spikegen
- /CerebellarCortex/MossyFibers/3/spikegen
- /CerebellarCortex/Granules/0/Granule_soma/spikegen
- /CerebellarCortex/Granules/1/Granule_soma/spikegen
- /CerebellarCortex/Granules/2/Granule_soma/spikegen
- /CerebellarCortex/Granules/3/Granule_soma/spikegen
- /CerebellarCortex/Granules/4/Granule_soma/spikegen
- /CerebellarCortex/Granules/5/Granule_soma/spikegen
- /CerebellarCortex/Golgis/0/Golgi_soma/spikegen
- /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /CerebellarCortex/**/spikegen",
						  },
						  {
						   description => "A selective single population expansion on spike generators using multiple wildcards",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
- /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /**/Golgis/**/spikegen",
						  },
						  {
						   description => "A selective multiple population expansion on spike generators using multiple wildcards",
						   read => "/CerebellarCortex/MossyFibers/0/spikegen
- /CerebellarCortex/MossyFibers/1/spikegen
- /CerebellarCortex/MossyFibers/2/spikegen
- /CerebellarCortex/MossyFibers/3/spikegen
- /CerebellarCortex/Granules/0/Granule_soma/spikegen
- /CerebellarCortex/Granules/1/Granule_soma/spikegen
- /CerebellarCortex/Granules/2/Granule_soma/spikegen
- /CerebellarCortex/Granules/3/Granule_soma/spikegen
- /CerebellarCortex/Granules/4/Granule_soma/spikegen
- /CerebellarCortex/Granules/5/Granule_soma/spikegen
- /CerebellarCortex/Golgis/0/Golgi_soma/spikegen
- /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /**/**/spikegen",
						  },
						  {
						   description => "A selective single population expansion on spike generators using multiple wildcards, with a intermediate null match",
						   read => "
- /CerebellarCortex/Golgis/0/Golgi_soma/spikegen
- /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /CerebellarCortex/Golgis/**/spikegen",
						  },
						  {
						   description => "Can we find the spikegenerator in the Golgi namespace ?",
						   read => "
- ::/Golgi::/G::/Golgi/Golgi_soma/spikegen
",
						   write => "expand ::Golgi::G::/Golgi/**/spikegen",
						  },
						  {
						   description => "Can we find the soma in the Golgi namespace ?",
						   read => "
- ::/Golgi::/G::/Golgi/Golgi_soma",
						   write => "expand ::Golgi::G::/Golgi/*",
						  },
						  {
						   description => "Can we find the channels in the Golgi namespace ?",
						   read => "
- ::/Golgi::/G::/Golgi/Golgi_soma/spikegen
- ::/Golgi::/G::/Golgi/Golgi_soma/Ca_pool
- ::/Golgi::/G::/Golgi/Golgi_soma/CaHVA
- ::/Golgi::/G::/Golgi/Golgi_soma/H
- ::/Golgi::/G::/Golgi/Golgi_soma/InNa
- ::/Golgi::/G::/Golgi/Golgi_soma/KA
- ::/Golgi::/G::/Golgi/Golgi_soma/KDr
- ::/Golgi::/G::/Golgi/Golgi_soma/Moczyd_KC
- ::/Golgi::/G::/Golgi/Golgi_soma/mf_AMPA
- ::/Golgi::/G::/Golgi/Golgi_soma/pf_AMPA
",
						   write => "expand ::Golgi::G::/Golgi/Golgi_soma/*",
						  }
						 ],
				description => "wildcard expansions",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'tests/cells/pool1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   comment => "for conversion of a genesis SLI CHANNEL message",
						   description => "Can we do a context subraction, from channel to segment ?",
						   read => '
first-second: ./cat
second-first: ..
',
						   write => 'context-subtract /pool1/segments/soma/cat /pool1/segments/soma',
						  },
						  {
						   comment => "for conversion of a genesis SLI VOLTAGE message",
						   description => "Can we do a context subraction, from segment to channel ?",
						   read => '
first-second: ..
second-first: ./cat
',
						   write => 'context-subtract /pool1/segments/soma /pool1/segments/soma/cat',
						  },
						  {
						   description => "Can we do a context subraction, identical elements ?",
						   read => '
first-second: .
second-first: .
',
						   write => 'context-subtract /pool1/segments/soma/cat /pool1/segments/soma/cat',
						  },
						  {
						   description => "Can we do a context subraction, 2 symbols ?",
						   read => '
first-second: ../..
second-first: ./soma/cat
',
						   write => 'context-subtract /pool1/segments /pool1/segments/soma/cat',
						  },
						  {
						   description => "Can we do a context subraction, 3 symbols ?",
						   read => '
first-second: ../../..
second-first: ./segments/soma/cat
',
						   write => 'context-subtract /pool1 /pool1/segments/soma/cat',
						  },
						  {
						   description => "Can we do a context subraction, 3 symbols, siblings involved (1) ?",
						   read => '
first-second: .././cat/cat_gate_inactivation/B
second-first: ../../.././ca_pool
',
						   write => 'context-subtract /pool1/segments/soma/cat/cat_gate_inactivation/B /pool1/segments/soma/ca_pool',
						  },
						  {
						   description => "Can we do a context subraction, 3 symbols, siblings involved (2)  ?",
						   read => '
first-second: .././cat/cat_gate_inactivation/A
second-first: ../../.././ca_pool
',
						   write => 'context-subtract /pool1/segments/soma/cat/cat_gate_inactivation/A /pool1/segments/soma/ca_pool',
						  },
						  {
						   description => "Can we do a context subraction, 2 symbols, siblings involved ?",
						   read => '
first-second: .././cat/cat_gate_inactivation
second-first: ../.././ca_pool
',
						   write => 'context-subtract /pool1/segments/soma/cat/cat_gate_inactivation /pool1/segments/soma/ca_pool',
						  },
						 ],
				description => "relative context subtraction",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      'tests/cells/pool1.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "Can we do a context subraction, edge case last descendant, child - parent ?",
						   read => '
first-second: ./ca_pool
second-first: ..
',
						   write => 'context-subtract /pool1/segments/soma/ca_pool /pool1/segments/soma',
						  },
						  {
						   description => "Can we do a context subraction, edge case last descendant, siblings ?",
						   read => '
first-second: .././ca_pool
second-first: .././cat
',
						   write => 'context-subtract /pool1/segments/soma/ca_pool /pool1/segments/soma/cat',
						  },
						 ],
				description => "relative context subtraction, edge cases",
			       },
			      ],
       description => "context operations, wildcard matching and expansion",
       name => 'contextoperations.t',
      };


return $test;


