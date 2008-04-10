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
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
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
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/** Erev",
						  },
						  {
						   comment => 'this requires a full implementation of alien types, see developer TODOs',
						   description => "Can we find all the prototypes for the algorithms ?",
						   disabled => 'this requires a full implementation of alien types, see developer TODOs',
						   read => '/CerebellarCortex/MossyFibers/MossyGrid->PROTOTYPE = "MossyFiber"
/CerebellarCortex/Granules/GranuleGrid->PROTOTYPE = "Granule_cell"
/CerebellarCortex/Golgis/GolgiGrid->PROTOTYPE = "Golgi_cell"
',
						   write => "printparameter /** PROTOTYPE",
						  },
						  {
						   description => "Can we find the prototypes for the algorithms ?",
						   read => '/CerebellarCortex/Golgis/GolgiGrid->PROTOTYPE = "Golgi_cell"',
						   write => "printparameter /CerebellarCortex/**/GolgiGrid PROTOTYPE",
						  },
						 ],
				description => "wildcarded parameter query for various parameter types",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find a numeric parameter, segment CM ?",
						   read => 'value = 0.0164',
						   write => "printparameter /Purkinje/segments/soma CM",
						  },
						  {
						   description => "Can we scale a parameter, segment CM ?",
						   read => 'scaled value = 4.57537e-11',
						   write => "printparameterscaled /Purkinje/segments/soma CM",
						  },
						  {
						   description => "Can we resolve a symbolic parameter, pool LENGTH ?",
						   read => 'value = 1.44697e-05',
						   write => "printparameter /Purkinje/segments/main[0]/ca_pool LENGTH",
						  },
						  {
						   description => "Can we resolve a string parameter, spines instance PROTOTYPE ?",
						   read => 'value = "Purkinje_spine"',
						   write => "printparameter /Purkinje/SpinesNormal_13_1 PROTOTYPE",
						  },
						 ],
				description => "retrieving parameters of various types",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find the endogenous firing frequency for the stellate cells ?",
						   read => 'parameter not found in symbol',
						   write => "printparameter /Purkinje/segments/br1[7]/stellate1 FREQUENCY",
						  },
						  {
						   description => "Can we find the endogenous firing frequency for the stellate cells ?",
						   read => 'parameter not found in symbol',
						   write => "printparameter /Purkinje/segments/br1[7]/stellate2 FREQUENCY",
						  },
						  {
						   description => "Set the endogenous firing frequency at the most conceptual level.",
						   read => 'neurospaces',
						   write => "setparameterconcept thickd::gaba::/Purk_GABA FREQUENCY number 30",
						  },
						  {
						   description => "Is the conceptual setting propagated to the expanded representation ?",
						   read => '= 30',
						   write => "printparameter /Purkinje/segments/br1[7]/stellate1 FREQUENCY",
						  },
						  {
						   description => "Is the conceptual setting propagated to the expanded representation ?",
						   read => '= 30',
						   write => "printparameter /Purkinje/segments/br1[7]/stellate2 FREQUENCY",
						  },
						  {
						   description => "Is the conceptual setting propagated to the expanded representation ?",
						   read => '= 30',
						   write => "printparameter /Purkinje/segments/b0s02[17]/stellate FREQUENCY",
						  },
						  {
						   description => "Set the endogenous firing frequency at an intermediate conceptual level.",
						   read => 'neurospaces',
						   write => "setparameterconcept thickd::/thickd/stellate1 FREQUENCY number 40",
						  },
						  {
						   description => "Is the conceptual setting propagated to the expanded representation ?",
						   read => '= 40',
						   write => "printparameter /Purkinje/segments/br1[7]/stellate1 FREQUENCY",
						  },
						  {
						   description => "Is the conceptual setting propagated to the expanded representation (should not) ?",
						   read => '= 30',
						   write => "printparameter /Purkinje/segments/br1[7]/stellate2 FREQUENCY",
						  },
						  {
						   description => "Is the conceptual setting propagated to the expanded representation (should not) ?",
						   read => '= 30',
						   write => "printparameter /Purkinje/segments/b0s02[17]/stellate FREQUENCY",
						  },
						 ],
				description => "conceptual level parameter operations",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find all the parameters of the purkinje cell ?",
						   read => 'Parameter (BASE)
Parameter (Base)
Parameter (CHANNEL_TYPE)
Parameter (CM)
Parameter (concen_init)
Parameter (dDeNominatorOffset)
Parameter (delay)
Parameter (DeNominatorOffset)
Parameter (dFirstInitActivation)
Parameter (dFirstSteadyState)
Parameter (DIA)
Parameter (dMembraneOffset)
Parameter (dMembraneOffset1)
Parameter (dMembraneOffset2)
Parameter (dMultiplier)
Parameter (dMultiplier1)
Parameter (dMultiplier2)
Parameter (dNominator)
Parameter (dSecondInitActivation)
Parameter (dSecondSteadyState)
Parameter (dTauDenormalizer)
Parameter (dTauDenormalizer1)
Parameter (dTauDenormalizer2)
Parameter (ELEAK)
Parameter (Erev)
Parameter (FREQUENCY)
Parameter (GMAX)
Parameter (HH_AB_Add)
Parameter (HH_AB_Factor_Flag)
Parameter (HH_AB_Mult)
Parameter (HH_AB_Offset_E)
Parameter (HH_AB_Scale)
Parameter (HH_AB_Tau)
Parameter (HighTarget)
Parameter (iFirstPower)
Parameter (iSecondPower)
Parameter (LENGTH)
Parameter (LowTarget)
Parameter (MembraneDependence)
Parameter (MembraneDependenceOffset)
Parameter (MembraneOffset)
Parameter (Multiplier)
Parameter (Nominator)
Parameter (PARENT)
Parameter (POWER)
Parameter (RA)
Parameter (rel_X)
Parameter (rel_Y)
Parameter (rel_Z)
Parameter (RM)
Parameter (state_init)
Parameter (STEADY_STATE_format)
Parameter (SURFACE)
Parameter (TAU)
Parameter (Tau)
Parameter (TAU1)
Parameter (TAU2)
Parameter (TAU_format)
Parameter (TauDenormalizer)
Parameter (THICK)
Parameter (Threshold)
Parameter (VAL)
Parameter (Vm_init)
Parameter (weight)
Parameter (X)
Parameter (Y)
Parameter (Z)
',
						   write => "printparameterset /Purkinje/**",
						  },
						 ],
				description => "finding parameter names, purkinje cell",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we find all the parameters in the network ?",
						   read => 'Parameter (BASE)
Parameter (BETA)
Parameter (CM)
Parameter (concen_init)
Parameter (delay)
Parameter (DIA)
Parameter (ELEAK)
Parameter (Erev)
Parameter (GMAX)
Parameter (LENGTH)
Parameter (MAXIMUM)
Parameter (MINIMUM)
Parameter (NORMALIZE)
Parameter (RA)
Parameter (RATE)
Parameter (REFRACTORY)
Parameter (RM)
Parameter (SOURCE)
Parameter (TARGET)
Parameter (TAU)
Parameter (TAU1)
Parameter (TAU2)
Parameter (THICK)
Parameter (THRESHOLD)
Parameter (VAL)
Parameter (Vm_init)
Parameter (weight)
Parameter (X)
Parameter (Xindex)
Parameter (Xpower)
Parameter (Y)
Parameter (Ypower)
Parameter (Z)
Parameter (Zpower)
',
						   write => "printparameterset /CerebellarCortex/**",
						  },
						  {
						   description => "Can we find the parameters of the mossy fibers ?",
						   read => 'Parameter (LENGTH)
Parameter (MAXIMUM)
Parameter (MINIMUM)
Parameter (RATE)
Parameter (REFRACTORY)
Parameter (THRESHOLD)
Parameter (X)
Parameter (Y)
Parameter (Z)
',
						   write => "printparameterset /CerebellarCortex/MossyFibers/**",
						  },
						  {
						   description => "Can we find the parameters of one mossy fibers ?",
						   read => 'Parameter (RATE)
Parameter (REFRACTORY)
Parameter (X)
Parameter (Y)
Parameter (Z)
',
						   write => "printparameterset /CerebellarCortex/MossyFibers/1",
						  },
						 ],
				description => "finding parameter names, small network",
			       },
			      ],
       description => "parameter operations",
       name => 'parameteroperations.t',
      };


return $test;


