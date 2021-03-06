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
				timeout => 5,
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



			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_4.py',
				command_tests => [
						  {
						   disabled => "disabled this test due to a 'export failed' appearing in the output that was not previously there",
						   description => "Can we query the purkinje cell model for parameters ?",
						   read => 'value = 0.0164
scaled value = 4.57537e-11
value = 1.44697e-05
value = "Purkinje_spine"
---
\'parameter name\': Erev
type: function
\'function name\': NERNST
\'function parameters\':

  -
    \'parameter name\': Cin
    \'field name\': concen
    type: field
    value: ../ca_pool->concen
    \'resolved value\': /Purkinje/segments/soma/ca_pool->concen
  -
    \'parameter name\': Cout
    type: number
    value: 2.4
  -
    \'parameter name\': valency
    \'field name\': VAL
    type: field
    value: ../ca_pool->VAL
    \'resolved value\': /Purkinje/segments/soma/ca_pool->VAL
  -
    \'parameter name\': T
    type: number
    value: 37
---
show_parameters:
\'parameter name\': G_MAX
type: number
value: 5

\'parameter name\': Erev
type: function
\'function name\': NERNST
\'function parameters\':

  -
    \'parameter name\': Cin
    \'field name\': concen
    type: field
    value: ../ca_pool->concen
    \'resolved value\': /Purkinje/segments/soma/ca_pool->concen
  -
    \'parameter name\': Cout
    type: number
    value: 2.4
  -
    \'parameter name\': valency
    \'field name\': VAL
    type: field
    value: ../ca_pool->VAL
    \'resolved value\': /Purkinje/segments/soma/ca_pool->VAL
  -
    \'parameter name\': T
    type: number
    value: 37

  -
    \'parameter name\': LENGTH
    type: number
    value: 6.96028e-06
  -
    \'parameter name\': Z
    type: number
    value: 3.8022e-05
  -
    \'parameter name\': Y
    type: number
    value: 1.1682e-05
  -
    \'parameter name\': X
    type: number
    value: 1.5649e-05
  -
    \'parameter name\': PARENT
    type: symbolic
    value: ../main[1]
  -
    \'parameter name\': rel_X
    type: number
    value: 1.666e-06
  -
    \'parameter name\': rel_Y
    type: number
    value: 1.111e-06
  -
    \'parameter name\': rel_Z
    type: number
    value: 6.666e-06
  -
    \'parameter name\': DIA
    type: number
    value: 8.5e-06
  -
    \'parameter name\': Vm_init
    type: number
    value: -0.068
  -
    \'parameter name\': RM
    type: number
    value: 3
  -
    \'parameter name\': RA
    type: number
    value: 2.5
  -
    \'parameter name\': CM
    type: number
    value: 0.0164
  -
    \'parameter name\': ELEAK
    type: number
    value: -0.08
Done!
',


						  },



						 ],
				description => "parameter query 3",
			       },





			       {
				arguments => [
					     ],
				command => 'tests/python/get_parameter_1.py',
				command_tests => [
						  {
						   description => "Can we retrieve a parameter and set a parameter ?",
						   read => 'Soma CM is 0.016400 and EREV is 0.147021
Soma CM is 300.000000 and EREV is 0.147021
Done!
',


						  },
						 ],
				description => "A simple retrieval of a parameter and a set of that same parameter",
				timeout => 5,
			       },



			       {
				arguments => [
					     ],
				command => 'tests/python/symbols_1.py',
				command_tests => [
						  {
						   description => "Can we create a parameter via a call to model_container.symbols ?",
						   read => 'Value is 100.000000
Done!
',
						   timeout => 5,


						  },
						 ],
				description => "A simple retrieval of a parameter created via model_container.symbols",
			       },

			       {
				arguments => [
					     ],
				command => 'tests/python/symbols_2.py',
				command_tests => [
						  {
						   description => "Can we create a parameter via a call to model_container.symbols ?",
						   read => 'Value is 100.000000
Done!
',


						  },
						 ],
				description => "A simple retrieval of a parameter created via model_container.symbols",
			       },


			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_5.py',
				command_tests => [
						  {
						   description => "Can we set and change parameters in the model container ?",
						   read => 'Value of CM at the soma is 0.0164
Setting the value of CM to 0
Value of CM at the soma is 0.0
Setting the value of CM to 5000
Value of CM at the soma is 5000.0
Done!
',


						  },
						 ],
				description => "Loads a model and sets and gets the values to see if it's been updated",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_6.py',
				command_tests => [
						  {
						   description => "Can we set and change parameters in the model container ?",
						   read => 'Value of G_MAX at the soma is 1.79769313486e+308
Setting the value of G_MAX to 0
Value of G_MAX at the soma is 0.0
Setting the value of G_MAX to 5000
Value of G_MAX at the soma is 5000.0
Done!
',


						  },
						 ],
				description => "Loads a model and sets and gets the values to see if it's been updated",
			       },

			       {
				arguments => [
					     ],
				command => 'tests/python/component_type_1.py',
				command_tests => [
						  {
						   description => "Can we determine the symbol type for a symbol on the model container ?",
						   read => 'The component type for /Purkinje/segments/soma is \'SEGMENT\'
Done!
',


						  },
						 ],
				description => "Loads the purkinje cell and tells what type of symbol the soma is",
			       },

			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_7.py',
				command_tests => [
						  {
						   description => "Can we retrieve parameters for the soma ?",
						   read => 'Parameters for \'/Purkinje/segments/soma\' are:
	DIA: 2.98e-05
	LENGTH: 0.0
	rel_Y: 0.0
	rel_X: 0.0
	rel_Z: 0.0
Done!
',


						  },
						 ],
				description => "Returns all parameters from the soma in a python dict",
			       },



			       {
				arguments => [
					     ],
				command => 'tests/python/parameteroperations_8.py',
				command_tests => [
						  {
						   description => "Can we retrieve parameters from a segement ?",
						   read => 'Parameters for \'/Purkinje/segments/main[0]\' are:
	DIA: 7.72e-06
	LENGTH: 1.44696878681e-05
	Y: 9.447e-06
	X: 5.557e-06
	Z: 9.447e-06
	rel_Y: 9.447e-06
	rel_X: 5.557e-06
	rel_Z: 9.447e-06
Done!
',


						  },
						 ],
				description => "Returns all parameters from the soma in a python dict",
			       },

			      ],
       description => "parameter operations in python",
       name => 'python/pyparameteroperations.t',
      };


return $test;

