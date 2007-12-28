#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_test.pm',
				command_tests => [
						  {
						   description => "Can we run a simple application that binds to the perl interface ?",
						   read => [
							    "-re",
							    "No errors for .*/cells/purk2m9s.ndf.",
							   ],
						  },
						 ],
				description => "a simple application that binds to the perl interface",
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_test_traversal.pm',
				command_tests => [
						  {
						   comment => 'The traversal is assumed to report 46 biological components, only 10 are counted to avoid to costly re backtracking',
						   description => "Can we perform a traversal from the perl interface ?",
						   read => [
							    "-re",
							    '(processing \$VAR1 =(.|\\n)*?){10}',
							   ],
						   timeout => 10,
						  },
						 ],
				description => "performing a traversal from the perl interface",
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_test_algorithm.pm',
				command_tests => [
						  {
						   description => "Can we obtain algorithm instance information from the perl interface ?",
						   read => 'name: SpinesInstance SpinesNormal_13_1
report:
    number_of_added_spines: 1474
    number_of_virtual_spines: 142982.466417
    number_of_spiny_segments: 1474
    number_of_failures_adding_spines: 0
    SpinesInstance_prototype: Purkinje_spine
    SpinesInstance_surface: 1.33079e-12
',
						  },
						 ],
				description => "algorithm instance information from the perl interface",
			       },
			       {
				command => './glue/swig/perl/tests/neurospaces_test_neuromorpho.pm',
				command_tests => [
						  {
						   description => "Can we load morphologies from the neuromorpho database over the internet ?",
						   disabled => "due to the dynamic name of the converted neuron, it is difficult to extract information from the result, yet the overall loading and conversion works in -r 1509.  Also this test should first modify the PATH variable, such that neurospaces can find the morphology2ndf executable.",
						   read => "calling morphology2ndf",
						  },
						 ],
				comment => 'this test is disabled if no "default" route to the internet can be found, the "route" command must output a line with the text "default"',
				description => "morphology loading from the neuromorpho database using a URL",
				disabled => (`route` =~ /default/ ? '' : 'no default route to the internet found'),
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_load_command_options.pm',
				command_tests => [
						  {
						   description => "Can we add query machine commands for simple processing of a model ?",
						   read => (`cat $::config->{core_directory}/config.h` =~ /define DELETE_OPERATION 1/
							    ? "query: 'echo start'
 start
query: 'expand /**'
/Golgi
query: 'echo end'
 end
"
							    : "query: 'delete /Golgi/Golgi_soma'
the delete operation is not enabled by default, before compiling neurospaces, use 'configure --with-delete-operation' to enable the delete operation
query: 'echo start'
 start
query: 'expand /**'
/Golgi
/Golgi/Golgi_soma
/Golgi/Golgi_soma/spikegen
/Golgi/Golgi_soma/Ca_pool
/Golgi/Golgi_soma/CaHVA
/Golgi/Golgi_soma/H
/Golgi/Golgi_soma/InNa
/Golgi/Golgi_soma/KA
/Golgi/Golgi_soma/KDr
/Golgi/Golgi_soma/Moczyd_KC
/Golgi/Golgi_soma/mf_AMPA
/Golgi/Golgi_soma/mf_AMPA/synapse
/Golgi/Golgi_soma/mf_AMPA/exp2
/Golgi/Golgi_soma/pf_AMPA
/Golgi/Golgi_soma/pf_AMPA/synapse
/Golgi/Golgi_soma/pf_AMPA/exp2
query: 'echo end'
 end
" ),
						  },
						 ],
				description => "query machine commands for simple processing of a model",
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_add_component.pm',
				command_tests => [
						  {
						   description => "Can we add a component from the perl interface ?",
						   read => ' 1
/Purkinje/segments/soma
/Purkinje/segments/soma/spikegen
/Purkinje/segments/soma/NaF
/Purkinje/segments/soma/NaP
/Purkinje/segments/soma/CaT
/Purkinje/segments/soma/KA
/Purkinje/segments/soma/Kdr
/Purkinje/segments/soma/KM
/Purkinje/segments/soma/h1
/Purkinje/segments/soma/h2
/Purkinje/segments/soma/Ca_pool
/Purkinje/segments/soma/basket
/Purkinje/segments/soma/basket/synapse
/Purkinje/segments/soma/basket/exp2
 2
/Purkinje/segments/soma
/Purkinje/segments/soma/spikegen
/Purkinje/segments/soma/NaF
/Purkinje/segments/soma/NaP
/Purkinje/segments/soma/CaT
/Purkinje/segments/soma/KA
/Purkinje/segments/soma/Kdr
/Purkinje/segments/soma/KM
/Purkinje/segments/soma/h1
/Purkinje/segments/soma/h2
/Purkinje/segments/soma/Ca_pool
/Purkinje/segments/soma/basket
/Purkinje/segments/soma/basket/synapse
/Purkinje/segments/soma/basket/exp2
/Purkinje/segments/soma/synchan
/Purkinje/segments/soma/synchan/synapse
/Purkinje/segments/soma/synchan/exp2
 3
',
						  },
						 ],
				description => "adding components from the perl interface",
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_delete_component.pm',
				command_tests => [
						  {
						   description => "Can we delete a component from the perl interface ?",
						   read => ' 1
/Golgi/Golgi_soma
/Golgi/Golgi_soma/spikegen
/Golgi/Golgi_soma/Ca_pool
/Golgi/Golgi_soma/CaHVA
/Golgi/Golgi_soma/H
/Golgi/Golgi_soma/InNa
/Golgi/Golgi_soma/KA
/Golgi/Golgi_soma/KDr
/Golgi/Golgi_soma/Moczyd_KC
/Golgi/Golgi_soma/mf_AMPA
/Golgi/Golgi_soma/mf_AMPA/synapse
/Golgi/Golgi_soma/mf_AMPA/exp2
/Golgi/Golgi_soma/pf_AMPA
/Golgi/Golgi_soma/pf_AMPA/synapse
/Golgi/Golgi_soma/pf_AMPA/exp2
 2
/Golgi/Golgi_soma
/Golgi/Golgi_soma/Ca_pool
/Golgi/Golgi_soma/CaHVA
/Golgi/Golgi_soma/H
/Golgi/Golgi_soma/InNa
/Golgi/Golgi_soma/KA
/Golgi/Golgi_soma/KDr
/Golgi/Golgi_soma/Moczyd_KC
/Golgi/Golgi_soma/mf_AMPA
/Golgi/Golgi_soma/mf_AMPA/synapse
/Golgi/Golgi_soma/mf_AMPA/exp2
/Golgi/Golgi_soma/pf_AMPA
/Golgi/Golgi_soma/pf_AMPA/synapse
/Golgi/Golgi_soma/pf_AMPA/exp2
 3
',
						  },
						 ],
				description => "deleting components from the perl interface",
				disabled => (`cat $::config->{core_directory}/config.h` =~ /define DELETE_OPERATION 1/ ? '' : 'neurospaces was not configured to include the delete operation'),
			       },
			       {
				arguments => [
					     ],
				command => './glue/swig/perl/tests/neurospaces_with_configuration.pm',
				command_tests => [
						  {
						   description => "Can we specify a loader configuration ?",
						   read => "query: 'expand /C170897A_P3_CNG/segments/soma/**'
/C170897A_P3_CNG/segments/soma
/C170897A_P3_CNG/segments/soma/km
/C170897A_P3_CNG/segments/soma/km/km
/C170897A_P3_CNG/segments/soma/km/km/a
/C170897A_P3_CNG/segments/soma/km/km/b
/C170897A_P3_CNG/segments/soma/kdr
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate/forward
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate/forward/a
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate/forward/b
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate/backward
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate/backward/a
/C170897A_P3_CNG/segments/soma/kdr/kdr_steadystate/backward/b
/C170897A_P3_CNG/segments/soma/kdr/kdr_tau
/C170897A_P3_CNG/segments/soma/kdr/kdr_tau/a
/C170897A_P3_CNG/segments/soma/kdr/kdr_tau/b
/C170897A_P3_CNG/segments/soma/ka
/C170897A_P3_CNG/segments/soma/ka/ka_gate_activation
/C170897A_P3_CNG/segments/soma/ka/ka_gate_activation/forward
/C170897A_P3_CNG/segments/soma/ka/ka_gate_activation/backward
/C170897A_P3_CNG/segments/soma/ka/ka_gate_inactivation
/C170897A_P3_CNG/segments/soma/ka/ka_gate_inactivation/forward
/C170897A_P3_CNG/segments/soma/ka/ka_gate_inactivation/backward
/C170897A_P3_CNG/segments/soma/kh
/C170897A_P3_CNG/segments/soma/kh/kh
/C170897A_P3_CNG/segments/soma/kh/kh/tau1
/C170897A_P3_CNG/segments/soma/kh/kh/tau2
/C170897A_P3_CNG/segments/soma/nap
/C170897A_P3_CNG/segments/soma/nap/nap
/C170897A_P3_CNG/segments/soma/nap/nap/forward
/C170897A_P3_CNG/segments/soma/nap/nap/backward
/C170897A_P3_CNG/segments/soma/naf
/C170897A_P3_CNG/segments/soma/naf/naf_gate_activation
/C170897A_P3_CNG/segments/soma/naf/naf_gate_activation/forward
/C170897A_P3_CNG/segments/soma/naf/naf_gate_activation/backward
/C170897A_P3_CNG/segments/soma/naf/naf_gate_inactivation
/C170897A_P3_CNG/segments/soma/naf/naf_gate_inactivation/forward
/C170897A_P3_CNG/segments/soma/naf/naf_gate_inactivation/backward
/C170897A_P3_CNG/segments/soma/cat
/C170897A_P3_CNG/segments/soma/cat/cat_gate_activation
/C170897A_P3_CNG/segments/soma/cat/cat_gate_activation/forward
/C170897A_P3_CNG/segments/soma/cat/cat_gate_activation/backward
/C170897A_P3_CNG/segments/soma/cat/cat_gate_inactivation
/C170897A_P3_CNG/segments/soma/cat/cat_gate_inactivation/forward
/C170897A_P3_CNG/segments/soma/cat/cat_gate_inactivation/backward
/C170897A_P3_CNG/segments/soma/ca_pool
query: 'expand /C170897A_P3_CNG/segments/s_2/**'
/C170897A_P3_CNG/segments/s_2
/C170897A_P3_CNG/segments/s_2/cat
/C170897A_P3_CNG/segments/s_2/cat/cat_gate_activation
/C170897A_P3_CNG/segments/s_2/cat/cat_gate_activation/forward
/C170897A_P3_CNG/segments/s_2/cat/cat_gate_activation/backward
/C170897A_P3_CNG/segments/s_2/cat/cat_gate_inactivation
/C170897A_P3_CNG/segments/s_2/cat/cat_gate_inactivation/forward
/C170897A_P3_CNG/segments/s_2/cat/cat_gate_inactivation/backward
/C170897A_P3_CNG/segments/s_2/cap
/C170897A_P3_CNG/segments/s_2/cap/cap_gate_activation
/C170897A_P3_CNG/segments/s_2/cap/cap_gate_activation/forward
/C170897A_P3_CNG/segments/s_2/cap/cap_gate_activation/backward
/C170897A_P3_CNG/segments/s_2/cap/cap_gate_inactivation
/C170897A_P3_CNG/segments/s_2/cap/cap_gate_inactivation/forward
/C170897A_P3_CNG/segments/s_2/cap/cap_gate_inactivation/backward
/C170897A_P3_CNG/segments/s_2/kc
/C170897A_P3_CNG/segments/s_2/kc/kc_gate_activation
/C170897A_P3_CNG/segments/s_2/kc/kc_gate_activation/forward
/C170897A_P3_CNG/segments/s_2/kc/kc_gate_activation/backward
/C170897A_P3_CNG/segments/s_2/kc/kc_gate_concentration
/C170897A_P3_CNG/segments/s_2/kc/kc_gate_concentration/concentration_kinetic
/C170897A_P3_CNG/segments/s_2/k2
/C170897A_P3_CNG/segments/s_2/k2/k2_gate_activation
/C170897A_P3_CNG/segments/s_2/k2/k2_gate_activation/forward
/C170897A_P3_CNG/segments/s_2/k2/k2_gate_activation/backward
/C170897A_P3_CNG/segments/s_2/k2/k2_gate_concentration
/C170897A_P3_CNG/segments/s_2/k2/k2_gate_concentration/concentration_kinetic
/C170897A_P3_CNG/segments/s_2/km
/C170897A_P3_CNG/segments/s_2/km/km
/C170897A_P3_CNG/segments/s_2/km/km/a
/C170897A_P3_CNG/segments/s_2/km/km/b
/C170897A_P3_CNG/segments/s_2/ca_pool
/C170897A_P3_CNG/segments/s_2/stellate
/C170897A_P3_CNG/segments/s_2/stellate/synapse
/C170897A_P3_CNG/segments/s_2/stellate/exp2
query: 'expand /C170897A_P3_CNG/segments/s_1666/**'
/C170897A_P3_CNG/segments/s_1666
/C170897A_P3_CNG/segments/s_1666/cat
/C170897A_P3_CNG/segments/s_1666/cat/cat_gate_activation
/C170897A_P3_CNG/segments/s_1666/cat/cat_gate_activation/forward
/C170897A_P3_CNG/segments/s_1666/cat/cat_gate_activation/backward
/C170897A_P3_CNG/segments/s_1666/cat/cat_gate_inactivation
/C170897A_P3_CNG/segments/s_1666/cat/cat_gate_inactivation/forward
/C170897A_P3_CNG/segments/s_1666/cat/cat_gate_inactivation/backward
/C170897A_P3_CNG/segments/s_1666/cap
/C170897A_P3_CNG/segments/s_1666/cap/cap_gate_activation
/C170897A_P3_CNG/segments/s_1666/cap/cap_gate_activation/forward
/C170897A_P3_CNG/segments/s_1666/cap/cap_gate_activation/backward
/C170897A_P3_CNG/segments/s_1666/cap/cap_gate_inactivation
/C170897A_P3_CNG/segments/s_1666/cap/cap_gate_inactivation/forward
/C170897A_P3_CNG/segments/s_1666/cap/cap_gate_inactivation/backward
/C170897A_P3_CNG/segments/s_1666/kc
/C170897A_P3_CNG/segments/s_1666/kc/kc_gate_activation
/C170897A_P3_CNG/segments/s_1666/kc/kc_gate_activation/forward
/C170897A_P3_CNG/segments/s_1666/kc/kc_gate_activation/backward
/C170897A_P3_CNG/segments/s_1666/kc/kc_gate_concentration
/C170897A_P3_CNG/segments/s_1666/kc/kc_gate_concentration/concentration_kinetic
/C170897A_P3_CNG/segments/s_1666/k2
/C170897A_P3_CNG/segments/s_1666/k2/k2_gate_activation
/C170897A_P3_CNG/segments/s_1666/k2/k2_gate_activation/forward
/C170897A_P3_CNG/segments/s_1666/k2/k2_gate_activation/backward
/C170897A_P3_CNG/segments/s_1666/k2/k2_gate_concentration
/C170897A_P3_CNG/segments/s_1666/k2/k2_gate_concentration/concentration_kinetic
/C170897A_P3_CNG/segments/s_1666/km
/C170897A_P3_CNG/segments/s_1666/km/km
/C170897A_P3_CNG/segments/s_1666/km/km/a
/C170897A_P3_CNG/segments/s_1666/km/km/b
/C170897A_P3_CNG/segments/s_1666/ca_pool
/C170897A_P3_CNG/segments/s_1666/stellate
/C170897A_P3_CNG/segments/s_1666/stellate/synapse
/C170897A_P3_CNG/segments/s_1666/stellate/exp2
",
						  },
						 ],
				description => "specifying a loader configuration",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			      ],
       description => "various perl bindings tests",
       disabled => ((`perl -e '    push \@INC, "../glue/swig/perl";    push \@INC, "glue/swig/perl";    require Neurospaces;    print 1;'` eq 1)
		    ? ''
		    : 'Neurospaces.pm cannot be loaded, probably the swig glue has not been built yet'),
       name => 'basic.t',
      };


return $test;


