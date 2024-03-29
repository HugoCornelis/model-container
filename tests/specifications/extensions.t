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
					      '-R',
					      'tests/populations/subpopulation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (1) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/populations/subpopulation.ndf.', ],
						   timeout => 5,
						  },

						  #t complete these tests:
						  #t find subpopulation symbol
						  #t check biolevels of subpopulation

						  {
						   description => "Can we find the subpopulations (1) ?",
						   read => "",
						   write => "",
						  },
						 ],
				description => "adding grammar extensions to the builtin grammar",
				preparation => {
						comment => 'preparation does a make clean because of incomplete makefile rules',
						description => "Creating a builtin grammar with subpopulations",
						preparer =>
						sub
						{
# 						    system "echo '#
# # old_revision [2dcc60aa77102d4faa24c47ead2dfcd99176b9f7]
# #
# # patch \"hierarchy/symbols\"
# #  from [91666dba4f0b7b3de1e6146bcda2317d42fad53c]
# #    to [d93b5e1c732b834d6d0d0f0a55a1b65336b31c2e]
# #
# ============================================================
# --- hierarchy/symbols	91666dba4f0b7b3de1e6146bcda2317d42fad53c
# +++ hierarchy/symbols	d93b5e1c732b834d6d0d0f0a55a1b65336b31c2e
# @@ -705,6 +705,45 @@ my \$class_hierarchy
#  					EXTENT_Z => \'coordinate of the last cell minus coordinate of the first cell\',
#  				       },
#  			},
# +	  subpopulation => {
# +			    allows => {
# +				       \'count_cells\' => \'population\',
# +				       \'create_alias\' => \'population\',
# +				       \'get_parameter\' => \'population\',
# +				      },
# +			    annotations => {
# +					    \'piSymbolType2Biolevel\' => \'BIOLEVEL_POPULATION\',
# +					   },
# +			    description => \'a subset of cells\',
# +			    dimensions => [
# +					   \'movable\',
# +					  ],
# +			    grammar => {
# +					components => [
# +						       \'Cell\',
# +						       \'Randomvalue\',
# +						      ],
# +					specific_allocator => \'PopulationCalloc\',
# +					specific_token => {
# +							   class => \'population\',
# +							   lexical => \'TOKEN_SUBPOPULATION\',
# +							   purpose => \'physical\',
# +							  },
# +					typing => {
# +						   base => \'phsle\',
# +						   id => \'pidin\',
# +						   spec => \'ppopu\',
# +						   to_base => \'-\>segr.bio.ioh.iol.hsle\',
# +						  },
# +				       },
# +			    isa => \'segmenter\',
# +			    name => \'symtab_Population\',
# +			    parameters => {
# +					   EXTENT_X => \'coordinate of the last cell minus coordinate of the first cell\',
# +					   EXTENT_Y => \'coordinate of the last cell minus coordinate of the first cell\',
# +					   EXTENT_Z => \'coordinate of the last cell minus coordinate of the first cell\',
# +					  },
# +			   },
#  	  segment => {
#  		      allows => {
#  				 \'create_alias\' => \'segment\',
# ' | patch -p0 ";

# 						    system "patch <subpopulation.patch -p0";

						    system "cp subpopulation.yml hierarchy/symbols";

						    print "subpopulation definition inserted into the builtin grammar\n";

						    system "make clean && make";
						},
					       },
				reparation => {
					       comment => 'reparation does a make clean because of incomplete makefile rules',
					       description => "Restoring the grammar without subpopulations",
					       reparer =>
					       sub
					       {
# 						   system "echo '#
# # old_revision [2dcc60aa77102d4faa24c47ead2dfcd99176b9f7]
# #
# # patch \"hierarchy/symbols\"
# #  from [91666dba4f0b7b3de1e6146bcda2317d42fad53c]
# #    to [d93b5e1c732b834d6d0d0f0a55a1b65336b31c2e]
# #
# ============================================================
# --- hierarchy/symbols	91666dba4f0b7b3de1e6146bcda2317d42fad53c
# +++ hierarchy/symbols	d93b5e1c732b834d6d0d0f0a55a1b65336b31c2e
# @@ -705,6 +705,45 @@ my \$class_hierarchy
#  					EXTENT_Z => \'coordinate of the last cell minus coordinate of the first cell\',
#  				       },
#  			},
# +	  subpopulation => {
# +			    allows => {
# +				       \'count_cells\' => \'population\',
# +				       \'create_alias\' => \'population\',
# +				       \'get_parameter\' => \'population\',
# +				      },
# +			    annotations => {
# +					    \'piSymbolType2Biolevel\' => \'BIOLEVEL_POPULATION\',
# +					   },
# +			    description => \'a subset of cells\',
# +			    dimensions => [
# +					   \'movable\',
# +					  ],
# +			    grammar => {
# +					components => [
# +						       \'Cell\',
# +						       \'Randomvalue\',
# +						      ],
# +					specific_allocator => \'PopulationCalloc\',
# +					specific_token => {
# +							   class => \'population\',
# +							   lexical => \'TOKEN_SUBPOPULATION\',
# +							   purpose => \'physical\',
# +							  },
# +					typing => {
# +						   base => \'phsle\',
# +						   id => \'pidin\',
# +						   spec => \'ppopu\',
# +						   to_base => \'-\>segr.bio.ioh.iol.hsle\',
# +						  },
# +				       },
# +			    isa => \'segmenter\',
# +			    name => \'symtab_Population\',
# +			    parameters => {
# +					   EXTENT_X => \'coordinate of the last cell minus coordinate of the first cell\',
# +					   EXTENT_Y => \'coordinate of the last cell minus coordinate of the first cell\',
# +					   EXTENT_Z => \'coordinate of the last cell minus coordinate of the first cell\',
# +					  },
# +			   },
#  	  segment => {
#  		      allows => {
#  				 \'create_alias\' => \'segment\',
# ' | patch -p0 -R ";

# 						   system "patch <subpopulation.patch -p0 -R";

						   system "rm hierarchy/symbols/subpopulation.yml";

						   print "subpopulations removed\n";

						   system "make clean && make";
					       },
					      },
				side_effects => 'complete rebuild required, the preparation / reparation system does the rebuild',
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-R',
					      'tests/populations/subpopulation.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful (2) ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/populations/subpopulation.ndf.', ],
						   timeout => 5,
						  },

						  #t complete these tests:
						  #t find subpopulation symbol
						  #t check biolevels of subpopulation

						  {
						   description => "Can we find the subpopulations (2) ?",
						   read => "",
						   write => "",
						  },
						 ],
				description => "adding grammar extensions via custom extensions",
				preparation => {
						comment => 'preparation does a make clean because of incomplete makefile rules',
						description => "Creating a grammar with subpopulations via the custom extensions directory",
						preparer =>
						sub
						{
						    system "sudo mkdir -p /etc/neurospaces/model-container/symbols";

						    system "sudo cp subpopulation.yml /etc/neurospaces/model-container/symbols";

						    print "subpopulation definition added to the custom extensions directory\n";

						    system "make clean && make";
						},
					       },
				reparation => {
					       comment => 'reparation does a make clean because of incomplete makefile rules',
					       description => "Restoring the grammar without subpopulations",
					       reparer =>
					       sub
					       {
						   system "sudo rm /etc/neurospaces/model-container/symbols/subpopulation.yml";

						   print "subpopulations removed\n";

						   system "make clean && make";
					       },
					      },
				side_effects => 'complete rebuild required, the preparation / reparation system does the rebuild',
			       },
			      ],
       description => "source code extensions",
       name => 'extensions.t',
      };


return $test;


