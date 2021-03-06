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
					      'segments/purkinje_maind_passive.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_maind_passive.ndf.', ],
						  },
						  {
						   description => "Do we get sensible feedback after an unrecognized querymachine command ?",
						   read => "unrecognized command 'abcdefg'",
						   write => "abcdefg",
						  },
						 ],
				description => "unrecognized querymachine command",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'cannot be found',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ 'Could not find file (number 0, 0), path name (cannot be found)
Set one of the environment variables NEUROSPACES_NMC_USER_MODELS,
NEUROSPACES_NMC_PROJECT_MODELS, NEUROSPACES_NMC_SYSTEM_MODELS or NEUROSPACES_NMC_MODELS
to point to a library where the required model is located,
or use the -m switch to configure where neurospaces looks for models.
', ],
						  },
						  {
						   description => "A single symbol expansion, without a model loaded",
						   read => "no model loaded",
						   write => "expand /CerebellarCortex/Golgis/1/Golgi_soma/spikegen/**",
						  },
						 ],
				description => "model description file not found",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'segments/purkinje_maind_passive.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_maind_passive.ndf.', ],
						  },
						  {
						   description => "Wait for the command prompt.",
						   read => "neurospaces ",
						  },
						  {
						   description => "A single symbol expansion, but symbol not found",
						   read => "neurospaces ",
						   write => "expand /CerebellarCortex/Golgis/1/Golgi_soma/spikegen/**",
						  },
						 ],
				description => "wildcard expansion, but without any match",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'segments/purkinje_maind_passive.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/purkinje_maind_passive.ndf.', ],
						  },
						  {
						   description => "What happens if we try to scale a parameter that does not have all the necessary dependencies ?",
						   read => " = 1.79769e+308
",
						   write => "printparameter /Purk_maind SURFACE"
						  },
						 ],
				description => "parameters with unresolved dependencies",
			       },
			       {
				arguments => [
					      '-v',
					      '1',
					      '-q',
					      '-R',
					      'utilities/circle.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/utilities/circle.ndf', ],
						  },
						  {
						   description => "What happens if we try to resolve a parameter that has circular dependencies ?",
						   read => "ParameterResolveToPidinStack(): presumably unbound recursion for RM, this parameter value depends on other parameter values that depend back on this parameter value.
value = 1.79769e+308
",
						   write => "printparameter /segm RM"
						  },
						  {
						   description => "What happens if we try to resolve a parameter that has circular dependencies ?",
						   read => "ParameterResolveToPidinStack(): presumably unbound recursion for RM, this parameter value depends on other parameter values that depend back on this parameter value.
value = 1.79769e+308
",
						   write => "printparameter /segm RM"
						  },
						  {
						   description => "What happens if we try to resolve a parameter with a function with wrong parameters ?",
						   read => "value = 1.79769e+308
",
						   write => "printparameter /segm RA"
						  },
						  {
						   description => "What happens if we try to resolve a parameter with a function parameter dependent on an unresolvable parameter ?",
						   read => "value = 1.79769e+308
",
						   write => "printparameter /segm CM"
						  },
						  {
						   description => "What happens if we try to resolve a parameter that is dependent on a parameter with circular dependencies ?",
						   read => "ParameterResolveToPidinStack(): presumably unbound recursion for B, this parameter value depends on other parameter values that depend back on this parameter value.
value = 1.79769e+308
",
						   write => "printparameter /segm A"
						  },
						  {
						   description => "What happens if we try to resolve a parameter that is dependent on a parameter with circular dependencies ?",
						   read => "ParameterResolveToPidinStack(): presumably unbound recursion for A, this parameter value depends on other parameter values that depend back on this parameter value.
value = 1.79769e+308
",
						   write => "printparameter /segm B"
						  },
						 ],
				description => "parameters with circular dependencies",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'utilities/syntaxerror.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has neurospaces reported the syntax error ?",
						   read => [ 'syntax error', ],
						  },
						 ],
				description => "a simple syntax error",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'channels/purkinje/cap.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has neurospaces reported that the conductance cannot be resolved ?",
						   read => "scaled value = 1.79769e+308
",
						   write => "printparameterscaled /cap G_MAX",
						  },
						 ],
				description => "resolving the conductance of an isolated channel",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'pools/purkinje_ca.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has neurospaces reported that beta cannot be resolved ?",
						   read => "scaled value = 1.79769e+308
",
						   write => "printparameterscaled /Ca_concen BETA",
						  },
						 ],
				description => "resolving beta for an isolated pool",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has neurospaces reported that we need two parameters for this command (1) ?",
						   read => "please specify a context and two parameters on the command line",
						   write => "printparameterinput",
						  },
						  {
						   description => "Has neurospaces reported that we need two parameters for this command (2) ?",
						   read => "please specify a context and two parameters on the command line",
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT",
						  },
						  {
						   description => "Has neurospaces reported that we need two parameters for this command (3) ?",
						   read => "please specify a context and two parameters on the command line",
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT Erev",
						  },
						  {
						   description => "Has neurospaces reported that we need two parameters for this command (4) ?",
						   read => "input not found",
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT Erev Cin ",
						  },
						  {
						   description => "Has neurospaces reported that the symbol cannot be found ?",
						   read => "symbol not found",
						   write => "printparameterinput /Purkinje/segments/CaT Erev concen ",
						  },
						  {
						   description => "Has neurospaces reported that the parameter cannot be found ?",

						   #t would be better if said 'parameter not found'

						   read => "input not found",
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT a Erev",
						  },
						  {
						   description => "Has neurospaces reported that the input cannot be found ?",
						   read => "input not found",
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT Erev a",
						  },
						  {
						   description => "Has neurospaces reported that the input cannot be found ?",
						   read => "input not found",
						   write => "printparameterinput /Purkinje/segments/main[0]/CaT Erev concen",
						  },
						 ],
				description => "function parameters",
			       },
			       {
				arguments => [
					      '-q',
					      'segments/micron2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can neurospaces handle an invalid query of the symbol table structure ?",
						   read => "symbol is not an ancestor",
						   write => "serialMapping /in12_1/mat_1/inserted_spine_0/neck /in12_1/mat_1/inserted_spine_0",
						  },
						 ],
				description => "invalid queries over symbol table structure",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'utilities/incomplete_inserter.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup not successful ?",
						   read => [
							    '-re',
							    'InserterInstance: \*\*\* Error: Inserter instance excitation cannot resolve NAME_SELECTOR parameter

\[.+?/utilities/incomplete_inserter.ndf line 38, near ALGORITHM\]

InserterInstance: \*\*\* Error: Inserter instance inhibition cannot resolve NAME_SELECTOR parameter

\[.+?/utilities/incomplete_inserter.ndf line 46, near ALGORITHM\]

InserterInstance: \*\*\* Error: Inserter instance spines cannot resolve NAME_SELECTOR parameter

\[.+?/utilities/incomplete_inserter.ndf line 54, near ALGORITHM\]

Inserter instance spines
Inserter instance inhibition
Inserter instance excitation
.+?/neurospacesparse: Parse of .*?utilities/incomplete_inserter.ndf failed with 3 \(cumulative\) errors.
',
							   ],
						  },
						 ],
				description => "incomplete parameters for the inserter algorithm",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'utilities/parents.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   todo => "This test should not be used as reference for how this command works",
						   description => "Do we find invalid parent segment parameter specifications ?",
						   read => "not found using SymbolLookupHierarchical() for /in12_1/mat_2: /mat_1
not found using PidinStackLookupTopSymbol() for /in12_1/mat_2: /mat_1
not found using SymbolLookupHierarchical() for /in12_1/mat_3: /in12_1/mat_3/mat_2
not found using PidinStackLookupTopSymbol() for /in12_1/mat_3: /in12_1/mat_3/mat_2
",
# circular reference for /in12_1/mat_4: /in12_1/mat_4
						   write => "validatesegmentgroup /in12_1",
						  },
						 ],
				description => "invalid parent segment parameter specifications",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      'utilities/some_segments.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we expand symbols without a selector ?",
						   read => "no symbols selector found
",
						   write => "expand /",
						  },
						 ],
				description => "error message when attempt to expand symbols without a selector",
			       },
			      ],
       description => "various error conditions",
       name => 'errors.t',
      };


return $test;


