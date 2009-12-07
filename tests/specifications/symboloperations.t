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
					      '-R',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/cells/golgi.ndf.', ],
						   write => undef,
						  },
						  {
						   description => "Do we find all the components in the golgi cell ?",
						   read => "/Golgi
- /Golgi/Golgi_soma
- /Golgi/Golgi_soma/spikegen
- /Golgi/Golgi_soma/Ca_pool
- /Golgi/Golgi_soma/CaHVA
- /Golgi/Golgi_soma/H
- /Golgi/Golgi_soma/InNa
- /Golgi/Golgi_soma/KA
- /Golgi/Golgi_soma/KDr
- /Golgi/Golgi_soma/Moczyd_KC
- /Golgi/Golgi_soma/mf_AMPA
- /Golgi/Golgi_soma/mf_AMPA/synapse
- /Golgi/Golgi_soma/mf_AMPA/exp2
- /Golgi/Golgi_soma/pf_AMPA
- /Golgi/Golgi_soma/pf_AMPA/synapse
- /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "expand /**",
						  },
						  {
						   description => "What is the serial mapping of the spikegen (1) ?",
						   read => "Traversal serial ID = 3
Principal serial ID = 3 of 16 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the reverse serial mapping of the spikegen (1) ?",
						   read => "serial id /,3 -> /Golgi/Golgi_soma/spikegen
",
						   write => "serial2context / 3",
						  },
						  {
						   description => "What is the serial mapping of the InNa channel (1) ?",
						   read => "Traversal serial ID = 7
Principal serial ID = 7 of 16 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/InNa",
						  },
						  {
						   description => "What is the reverse serial mapping of the InNa channel (1) ?",
						   read => "serial id /,7 -> /Golgi/Golgi_soma/InNa
",
						   write => "serial2context / 7",
						  },
						  {
						   description => "What is the serial mapping of the parallel fiber exponential equation (1) ?",
						   read => "Traversal serial ID = 16
Principal serial ID = 16 of 16 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/pf_AMPA/exp2",
						  },
						  {
						   description => "What is the reverse serial mapping of the parallel fiber exponential equation (1) ?",
						   read => "serial id /,16 -> /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "serial2context / 16",
						  },
						  {
						   description => "Can we delete a channel ?",
						   read => "neurospaces",
						   write => "delete /Golgi/Golgi_soma/H",
						  },
						  {
						   description => "Do we find all the remaining components in the golgi cell (1) ?",
						   read => "/Golgi
- /Golgi/Golgi_soma
- /Golgi/Golgi_soma/spikegen
- /Golgi/Golgi_soma/Ca_pool
- /Golgi/Golgi_soma/CaHVA
- /Golgi/Golgi_soma/InNa
- /Golgi/Golgi_soma/KA
- /Golgi/Golgi_soma/KDr
- /Golgi/Golgi_soma/Moczyd_KC
- /Golgi/Golgi_soma/mf_AMPA
- /Golgi/Golgi_soma/mf_AMPA/synapse
- /Golgi/Golgi_soma/mf_AMPA/exp2
- /Golgi/Golgi_soma/pf_AMPA
- /Golgi/Golgi_soma/pf_AMPA/synapse
- /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "expand /**",
						  },
						  {
						   description => "What is the serial mapping of the spikegen (2) ?",
						   read => "Traversal serial ID = 3
Principal serial ID = 3 of 15 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the reverse serial mapping of the spikegen (2) ?",
						   read => "serial id /,3 -> /Golgi/Golgi_soma/spikegen
",
						   write => "serial2context / 3",
						  },
						  {
						   description => "What is the serial mapping of the InNa channel (2) ?",
						   read => "Traversal serial ID = 6
Principal serial ID = 6 of 15 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/InNa",
						  },
						  {
						   description => "What is the reverse serial mapping of the InNa channel (2) ?",
						   read => "serial id /,6 -> /Golgi/Golgi_soma/InNa
",
						   write => "serial2context / 6",
						  },
						  {
						   description => "What is the serial mapping of the parallel fiber exponential equation (2) ?",
						   read => "Traversal serial ID = 15
Principal serial ID = 15 of 15 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/pf_AMPA/exp2",
						  },
						  {
						   description => "What is the reverse serial mapping of the parallel fiber exponential equation (2) ?",
						   read => "serial id /,15 -> /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "serial2context / 15",
						  },
						  {
						   comment => 'note that the deletions takes place at forestspace level, not treespace level',
						   description => "Can we delete a synapse  ?",
						   read => "neurospaces",
						   write => "delete /Golgi/Golgi_soma/pf_AMPA/synapse",
						  },
						  {
						   comment => 'note that the deletions takes place at forestspace level, not treespace level',
						   description => "Do we find all the remaining components in the golgi cell (2) ?",
						   read => "/Golgi
- /Golgi/Golgi_soma
- /Golgi/Golgi_soma/spikegen
- /Golgi/Golgi_soma/Ca_pool
- /Golgi/Golgi_soma/CaHVA
- /Golgi/Golgi_soma/InNa
- /Golgi/Golgi_soma/KA
- /Golgi/Golgi_soma/KDr
- /Golgi/Golgi_soma/Moczyd_KC
- /Golgi/Golgi_soma/mf_AMPA
- /Golgi/Golgi_soma/mf_AMPA/exp2
- /Golgi/Golgi_soma/pf_AMPA
- /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "expand /**",
						  },
						  {
						   description => "What is the serial mapping of the spikegen (3) ?",
						   read => "Traversal serial ID = 3
Principal serial ID = 3 of 13 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the reverse serial mapping of the spikegen (3) ?",
						   read => "serial id /,3 -> /Golgi/Golgi_soma/spikegen
",
						   write => "serial2context / 3",
						  },
						  {
						   description => "What is the serial mapping of the InNa channel (3) ?",
						   read => "Traversal serial ID = 6
Principal serial ID = 6 of 13 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/InNa",
						  },
						  {
						   description => "What is the reverse serial mapping of the InNa channel (3) ?",
						   read => "serial id /,6 -> /Golgi/Golgi_soma/InNa
",
						   write => "serial2context / 6",
						  },
						  {
						   description => "What is the serial mapping of the parallel fiber exponential equation (3) ?",
						   read => "Traversal serial ID = 13
Principal serial ID = 13 of 13 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/pf_AMPA/exp2",
						  },
						  {
						   description => "What is the reverse serial mapping of the parallel fiber exponential equation (3) ?",
						   read => "serial id /,13 -> /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "serial2context / 13",
						  },
						  {
						   comment => 'note that the deletions takes place at forestspace level, not treespace level',
						   description => "Can we delete a concentration pool ?",
						   read => "neurospaces",
						   write => "delete /Golgi/Golgi_soma/Ca_pool",
						  },
						  {
						   comment => 'note that the deletions takes place at forestspace level, not treespace level',
						   description => "Do we find all the remaining components in the golgi cell (3) ?",
						   read => "/Golgi
- /Golgi/Golgi_soma
- /Golgi/Golgi_soma/spikegen
- /Golgi/Golgi_soma/CaHVA
- /Golgi/Golgi_soma/InNa
- /Golgi/Golgi_soma/KA
- /Golgi/Golgi_soma/KDr
- /Golgi/Golgi_soma/Moczyd_KC
- /Golgi/Golgi_soma/mf_AMPA
- /Golgi/Golgi_soma/mf_AMPA/exp2
- /Golgi/Golgi_soma/pf_AMPA
- /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "expand /**",
						  },
						  {
						   description => "What is the serial mapping of the spikegen (4) ?",
						   read => "Traversal serial ID = 3
Principal serial ID = 3 of 12 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/spikegen",
						  },
						  {
						   description => "What is the reverse serial mapping of the spikegen (4) ?",
						   read => "serial id /,3 -> /Golgi/Golgi_soma/spikegen
",
						   write => "serial2context / 3",
						  },
						  {
						   description => "What is the serial mapping of the InNa channel (4) ?",
						   read => "Traversal serial ID = 5
Principal serial ID = 5 of 12 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/InNa",
						  },
						  {
						   description => "What is the reverse serial mapping of the InNa channel (4) ?",
						   read => "serial id /,5 -> /Golgi/Golgi_soma/InNa
",
						   write => "serial2context / 5",
						  },
						  {
						   description => "What is the serial mapping of the parallel fiber exponential equation (4) ?",
						   read => "Traversal serial ID = 12
Principal serial ID = 12 of 12 Principal successors
",
						   write => "serialMapping / /Golgi/Golgi_soma/pf_AMPA/exp2",
						  },
						  {
						   description => "What is the reverse serial mapping of the parallel fiber exponential equation (4) ?",
						   read => "serial id /,12 -> /Golgi/Golgi_soma/pf_AMPA/exp2
",
						   write => "serial2context / 12",
						  },
						  {
						   description => "Can we delete the soma ?",
						   read => "neurospaces",
						   write => "delete /Golgi/Golgi_soma",
						  },
						  {
						   description => "Do we find all the remaining components in the golgi cell (4) ?",
						   read => "/Golgi
",
						   write => "expand /**",
						  },
						  {
						   description => "Can we delete the cell ?",
# 						   disabled => 'root symbols cannot delete their children yet',
						   read => "neurospaces",
						   write => "delete /Golgi",
						  },
						  {
						   description => "Do we find an empty result ?",
# 						   disabled => 'root symbols cannot delete their children yet',
						   read => "neurospaces",
						   write => "expand /**",
						  },
						 ],
				description => "deletions of components of a simple neuron model",
				disabled => (`cat $::config->{core_directory}/neurospaces/config.h` =~ m/define DELETE_OPERATION\s*1/ ? 0 : 'use configure --with-delete-operation to enable these tests'),
			       },
			      ],
       comment => 'Because delete operations are only supported at the forestspace level, delete operations on nested data structures do not make much sense.  Not tested.',
       description => "operations on components in the symbol table",
       name => 'symboloperations.t',
      };


return $test;


