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
					      'legacy/segments/purkinje_maind.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is the nernst function calculated correctly ?",
						   read => "= 0.147021",
						   write => "printparameter /Purk_maind/CaT Erev"
						  },
						 ],
				description => "nernst function",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'legacy/cells/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is the conductance with magnesium blocking calculated correctly ?",
						   read => "= 0.0164909",
						   write => "printparameter /Granule/Granule_soma/mf_NMDA GMAX"
						  },
						 ],
				description => "magnesium blocking function",
				disabled => "This value still needs to be checked",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'utilities/functions.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is the serial calculated correctly ?",
						   read => "= 1",
						   write => "printparameter /segm A"
						  },
						 ],
				description => "serial functions",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'utilities/functions.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is the minimum calculated correctly ?",
						   read => "= 0",
						   write => "printparameter /segm B"
						  },
						  {
						   description => "Is the maximum calculated correctly ?",
						   read => "= 1",
						   write => "printparameter /segm C"
						  },

						  {
						   description => "Is lower than calculated correctly, case 1 ?",
						   read => "= 5",
						   write => "printparameter /segm D1"
						  },
						  {
						   description => "Is lower than calculated correctly, case 2 ?",
						   read => "= 6",
						   write => "printparameter /segm D2"
						  },
						  {
						   description => "Is higher than calculated correctly, case 1 ?",
						   read => "= 6",
						   write => "printparameter /segm E1"
						  },
						  {
						   description => "Is higher than calculated correctly, case 2 ?",
						   read => "= 5",
						   write => "printparameter /segm E2"
						  },

						  {
						   description => "Is subtraction calculated correctly ?",
						   read => "= 2",
						   write => "printparameter /segm F"
						  },
						  {
						   description => "Is the negative calculated correctly ?",
						   read => "= -1",
						   write => "printparameter /segm G"
						  },
						  {
						   description => "Is division calculated correctly ?",
						   read => "= 0.4",
						   write => "printparameter /segm H"
						  },
						  {
						   description => "Is a step calculated correctly (low value) ?",
						   read => "= 0",
						   write => "printparameter /segm I1"
						  },
						  {
						   description => "Is a step calculated correctly (in range) ?",
						   read => "= 1",
						   write => "printparameter /segm I2"
						  },
						  {
						   description => "Is a step calculated correctly (high value) ?",
						   read => "= 0",
						   write => "printparameter /segm I3"
						  },
						 ],
				description => "arithmetic functions",
			       },
			      ],
       description => "parameter functions",
       name => 'functions.t',
      };


return $test;


