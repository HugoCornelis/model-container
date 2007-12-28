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
					      '-q',
					      'networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/networksmall.ndf.', ],
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
						   read => "/CerebellarCortex/MossyFibers
/CerebellarCortex/MossyFibers/0
/CerebellarCortex/MossyFibers/0/value
/CerebellarCortex/MossyFibers/0/spikegen
/CerebellarCortex/MossyFibers/1
/CerebellarCortex/MossyFibers/1/value
/CerebellarCortex/MossyFibers/1/spikegen
/CerebellarCortex/MossyFibers/2
/CerebellarCortex/MossyFibers/2/value
/CerebellarCortex/MossyFibers/2/spikegen
/CerebellarCortex/MossyFibers/3
/CerebellarCortex/MossyFibers/3/value
/CerebellarCortex/MossyFibers/3/spikegen
",
						   write => "expand /CerebellarCortex/MossyFibers/**",
						  },
						  {
						   description => "A selective single population expansion on spike receivers",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/mf_AMPA/synapse
/CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse
/CerebellarCortex/Golgis/1/Golgi_soma/mf_AMPA/synapse
/CerebellarCortex/Golgis/1/Golgi_soma/pf_AMPA/synapse
",
						   write => "expand /CerebellarCortex/Golgis/**/synapse",
						  },
						  {
						   description => "A selective single population expansion on spike generators",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
/CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /CerebellarCortex/Golgis/**/spikegen",
						  },
						  {
						   description => "A selective single population expansion on spike generators, alternate form",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
/CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /**/Golgis/**/spikegen",
						  },
						  {
						   description => "A selective multiple population expansion on spike generators",
						   read => "/CerebellarCortex/MossyFibers/0/spikegen
/CerebellarCortex/MossyFibers/1/spikegen
/CerebellarCortex/MossyFibers/2/spikegen
/CerebellarCortex/MossyFibers/3/spikegen
/CerebellarCortex/Granules/0/Granule_soma/spikegen
/CerebellarCortex/Granules/1/Granule_soma/spikegen
/CerebellarCortex/Granules/2/Granule_soma/spikegen
/CerebellarCortex/Granules/3/Granule_soma/spikegen
/CerebellarCortex/Granules/4/Granule_soma/spikegen
/CerebellarCortex/Granules/5/Granule_soma/spikegen
/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
/CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /CerebellarCortex/**/spikegen",
						  },
						  {
						   description => "A selective single population expansion on spike generators using multiple wildcards",
						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
/CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /**/Golgis/**/spikegen",
						  },
						  {
						   description => "A selective multiple population expansion on spike generators using multiple wildcards",
						   read => "/CerebellarCortex/MossyFibers/0/spikegen
/CerebellarCortex/MossyFibers/1/spikegen
/CerebellarCortex/MossyFibers/2/spikegen
/CerebellarCortex/MossyFibers/3/spikegen
/CerebellarCortex/Granules/0/Granule_soma/spikegen
/CerebellarCortex/Granules/1/Granule_soma/spikegen
/CerebellarCortex/Granules/2/Granule_soma/spikegen
/CerebellarCortex/Granules/3/Granule_soma/spikegen
/CerebellarCortex/Granules/4/Granule_soma/spikegen
/CerebellarCortex/Granules/5/Granule_soma/spikegen
/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
/CerebellarCortex/Golgis/1/Golgi_soma/spikegen
",
						   write => "expand /**/**/spikegen",
						  },
# 						  {
# 						   description => "A selective single population expansion on spike generators using multiple wildcards, with a intermediate null match",
# 						   read => "/CerebellarCortex/Golgis/0/Golgi_soma/spikegen
# /CerebellarCortex/Golgis/1/Golgi_soma/spikegen
# ",
# 						   write => "expand /CerebellarCortex/**/Golgis/**/spikegen",
# 						  },
						  {
						   description => "Namespaces and wildcards cannot be combined (yet).",
						   disabled => "Namespaces and wildcards cannot be combined (yet).",
						   read => "wildcard expansion cannot be combined with namespaces.",
						   write => "expand ::Golgi::G::/Golgi/**/spikegen",
						  },
						 ],
				description => "wildcard expansions",
			       },
			      ],
       description => "wildcard matching and expansion",
       name => 'matching.t',
      };


return $test;


