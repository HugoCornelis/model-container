#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      '-R',
					      'channels/purkinje/nap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we identify the prototype of the channel ?",
						   read => 'value = 11
',
						   write => "printparameter /nap PROTOTYPE_IDENTIFIER",
						  },
						  {
						   description => "Can we identify the prototype of the channel gate ?",
						   read => 'value = 8
',
						   write => "printparameter /nap/nap PROTOTYPE_IDENTIFIER",
						  },
						  {
						   description => "Can we identify the prototype of the channel gate, forward kinetic (has no prototype) ?",
						   read => 'value = 2.14748e+09
',
						   write => "printparameter /nap/nap/A PROTOTYPE_IDENTIFIER",
						  },
						  {
						   description => "Can we identify the prototype of the channel gate, backward kinetic (has no prototype) ?",
						   read => 'value = 2.14748e+09
',
						   write => "printparameter /nap/nap/B PROTOTYPE_IDENTIFIER",
						  },
						 ],
				description => "prototype identifiers of a simple channel, its gate and its kinetics",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  (
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 2.14748e+09
',
						    write => "printparameter /Purkinje PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 2.14748e+09
',
						    write => "printparameter /Purkinje/segments PROTOTYPE_IDENTIFIER",
						   },
						  ),
						  (
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 320
',
						    write => "printparameter /Purkinje/segments/soma PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 328
',
						    write => "printparameter /Purkinje/segments/main[0] PROTOTYPE_IDENTIFIER",
						   },
						   {
						    comment => "I am not sure if this works correctly: I get different identifiers for br3[0], br3[1], br3[2], but for the much more important channels and gates I get equal identifiers.  Is that really correct ?",
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 380
',
						    write => "printparameter /Purkinje/segments/br3[0] PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 381
',
						    write => "printparameter /Purkinje/segments/br3[1] PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 382
',
						    write => "printparameter /Purkinje/segments/br3[2] PROTOTYPE_IDENTIFIER",
						   },
						  ),
						  (
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 56
',
						    write => "printparameter /Purkinje/segments/soma/cat PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 56
',
						    write => "printparameter /Purkinje/segments/br3[1]/cat PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => 'value = 56
',
						    write => "printparameter /Purkinje/segments/br3[2]/cat PROTOTYPE_IDENTIFIER",
						   },
						  ),
						  (
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => '/Purkinje/segments/soma/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[0]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[1]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[2]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[3]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[4]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[5]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[6]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[7]/kdr->PROTOTYPE_IDENTIFIER = 146
/Purkinje/segments/main[8]/kdr->PROTOTYPE_IDENTIFIER = 146
',
						    write => "printparameter /Purkinje/segments/**/kdr PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => '/Purkinje/segments/soma/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[0]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[1]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[2]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[3]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[4]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[5]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[6]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[7]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
/Purkinje/segments/main[8]/kdr/kdr_tau->PROTOTYPE_IDENTIFIER = 142
',
						    write => "printparameter /Purkinje/segments/**/kdr_tau PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => '/Purkinje/segments/soma/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[0]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[1]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[2]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[3]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[4]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[5]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[6]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[7]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[8]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
',
						    write => "printparameter /Purkinje/segments/**/kdr_steadystate PROTOTYPE_IDENTIFIER",
						   },
						   {
						    description => "Can we identify the prototype of the cell (has no prototype) ?",
						    read => '/Purkinje/segments/soma/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/soma/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/soma/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/soma/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/soma/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/soma/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/soma/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[0]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[0]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[0]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[0]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[0]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[0]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[0]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[1]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[1]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[1]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[1]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[1]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[1]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[1]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[2]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[2]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[2]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[2]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[2]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[2]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[2]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[3]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[3]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[3]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[3]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[3]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[3]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[3]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[4]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[4]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[4]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[4]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[4]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[4]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[4]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[5]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[5]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[5]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[5]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[5]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[5]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[5]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[6]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[6]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[6]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[6]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[6]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[6]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[6]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[7]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[7]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[7]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[7]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[7]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[7]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[7]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[8]/kdr/kdr_steadystate->PROTOTYPE_IDENTIFIER = 141
/Purkinje/segments/main[8]/kdr/kdr_steadystate/A->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[8]/kdr/kdr_steadystate/A/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[8]/kdr/kdr_steadystate/A/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[8]/kdr/kdr_steadystate/B->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[8]/kdr/kdr_steadystate/B/a->PROTOTYPE_IDENTIFIER = 2.14748e+09
/Purkinje/segments/main[8]/kdr/kdr_steadystate/B/b->PROTOTYPE_IDENTIFIER = 2.14748e+09
',
						    write => "printparameter /Purkinje/segments/**/kdr_steadystate/** PROTOTYPE_IDENTIFIER",
						   },
						  ),
						 ],
				description => "prototype identifiers of the purkinje cell model",
			       },
			      ],
       comment => 'This test needs to be enhanced with setting parameters of symbols and using parameter caches.  Doing so should change the value of the PROTOTYPE_IDENTIFIER automatically',
       description => "prototyping",
       name => 'prototyping.t',
      };


return $test;


