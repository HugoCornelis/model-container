#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_1.py',
				command_tests => [
						  {
						   description => "Can we find all the reversal potentials of the soma ?",
						   read => '/CerebellarCortex/Golgis/0/Golgi_soma/CaHVA->Erev = 0.138533
/CerebellarCortex/Golgis/0/Golgi_soma/H->Erev = -0.042
/CerebellarCortex/Golgis/0/Golgi_soma/InNa->Erev = 0.055
/CerebellarCortex/Golgis/0/Golgi_soma/KA->Erev = -0.09
/CerebellarCortex/Golgis/0/Golgi_soma/KDr->Erev = -0.09
/CerebellarCortex/Golgis/0/Golgi_soma/Moczyd_KC->Erev = -0.09
/CerebellarCortex/Golgis/0/Golgi_soma/mf_AMPA->Erev = 0
/CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA->Erev = 0
',


						  },
						 ],
				description => "A simple script that will load the purkinje cell and set a few parameters",
			       },



			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_2.py',
				command_tests => [
						  {
						   description => "Can we find all the prototypes for the algorithms ?",
						   disabled => 'this requires a full implementation of alien types, see developer TODOs',
						   read => '/CerebellarCortex/MossyFibers/MossyGrid->PROTOTYPE = "MossyFiber"
/CerebellarCortex/Granules/GranuleGrid->PROTOTYPE = "Granule_cell"
/CerebellarCortex/Golgis/GolgiGrid->PROTOTYPE = "Golgi_cell"
',


						  },
						 ],
				description => "wildcarded parameter query 2",
			       },

			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_3.py',
				command_tests => [
						  {
						   description => "Can we find the prototypes for the algorithms ?",
						   read => '/CerebellarCortex/Golgis/GolgiGrid->PROTOTYPE = "Golgi_cell',


						  },
						 ],
				description => "wildcarded parameter query 3",
			       },

			      ],
       description => "parameter operations in python",
       name => 'python/pyparameteroperations.t',
      };


return $test;

