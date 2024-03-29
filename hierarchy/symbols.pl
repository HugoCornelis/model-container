#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb
#
# $ProjectVersion: 0.1675 $
#

use strict;


my $class_hierarchy
    = {
       # base types

       (
	root => {
		 allows => {
			   },
		 description => 'root symbol, completely generic, allows nothing, has no parameters',
		 isa => undef,
		 name => 'CoreRoot',
		},
	base => {
		 allows => {
			   },
		 description => 'base symbol, for all components that should be accessible in the symbol table, possibly the identification numbers are external to this symbol',
		 isa => 'root',
		 name => 'symtab_Base',
		},
	symbol => {
		   allows => {
			      #! note: base symbol because of the
			      #! conflict between name 'symbol' for the
			      #! instrumentor, and 'symbol' in the
			      #! derivation hierarchy.

# 			      'invisible_serial_2_context' => 'symbol',
# 			      'principal_serial_2_context' => 'symbol',
# 			      'traverse_bio_levels' => 'symbol',
# 			      'traverse_wildcard' => 'symbol',
			      'all_successors_get' => 'base_symbol',
			      'all_successors_set' => 'base_symbol',
			      'all_serials_to_parent_get' => 'base_symbol',
			      'all_serials_to_parent_set' => 'base_symbol',
# 			      'get_i_d' => 'base_symbol',
			      'get_symbol' => 'base_symbol',
			     },
		   description => 'symbol that maintains its own identification numbers',
		   isa => 'base',
		   name => 'symtab_HSolveListElement',

		   #t should only be there for InstanceOfMovable().

		   parameters => {
				  "ROTATE_ANGLE" => 'relative coordinate transformation',
				  "ROTATE_AXIS_X" => 'relative coordinate transformation',
				  "ROTATE_AXIS_Y" => 'relative coordinate transformation',
				  "ROTATE_AXIS_Z" => 'relative coordinate transformation',
				  "ROTATE_CENTER_X" => 'relative coordinate transformation',
				  "ROTATE_CENTER_Y" => 'relative coordinate transformation',
				  "ROTATE_CENTER_Z" => 'relative coordinate transformation',
				  'X' => 'coordinate relative to parent',
				  'Y' => 'coordinate relative to parent',
				  'Z' => 'coordinate relative to parent',
				 },
		  },
       ),

       # abstract types, towards the biological/mathematical path

       (
	iol => {
		allows => {
			   'assign_inputs' => 'i_o_list',
			   'assign_bindable_i_o' => 'i_o_list',
			   'get_inputs' => 'i_o_list',
			   'has_bindable_i_o' => 'i_o_list',
			   'resolve_input' => 'i_o_list',
			  },
		description => 'a component with shared variables that can be bound',
		isa => 'symbol',
		name => 'symtab_IOList',
	       },
	iohier => {
		   allows => {
			      'add_child' => 'i_o_hierarchy',
			      'delete_child' => 'i_o_hierarchy',
			      'get_children' => 'i_o_hierarchy',
			      'lookup_hierarchical' => 'i_o_hierarchy',
			      'print' => 'i_o_hierarchy',
			      'traverse' => 'i_o_hierarchy',
			     },
		   description => 'a component with shared variables and children',
		   isa => 'iol',
		   name => 'symtab_IOHierarchy',
		  },
	bio_comp => {
		     allows => {
				'assign_parameters' => 'bio_component',
				'count_spike_generators' => 'bio_component',
				'count_spike_receivers' => 'bio_component',
				'create_alias' => 'bio_component',
				'get_child_from_input' => 'bio_component',
# 				'get_i_d' => 'bio_component',
				'get_modifiable_parameter' => 'bio_component',
				'get_name' => 'bio_component',
				'get_options' => 'bio_component',
				'get_parameter' => 'bio_component',
				'get_pidin' => 'bio_component',
				'get_prototype' => 'bio_component',
				'lookup_hierarchical' => 'bio_component',
				'lookup_serial_i_d' => 'bio_component',
				'parameter_link_at_end' => 'bio_component',
				'parameter_resolve_value' => 'bio_component',
				'print' => 'bio_component',
				'reduce' => 'bio_component',
				'resolve_input' => 'bio_component',
				'resolve_parameter_functional_input' => 'bio_component',
				'traverse_spike_generators' => 'bio_component',
				'traverse_spike_receivers' => 'bio_component',
				'set_at_x_y_z' => 'bio_component',
				'set_name' => 'bio_component',
				'set_namespace' => 'bio_component',
				'set_options' => 'bio_component',
				'set_parameter_context' => 'bio_component',
				'set_parameter_double' => 'bio_component',
				'set_parameter_may_be_copy_string' => 'bio_component',
				'set_parameter_string' => 'bio_component',
				'set_prototype' => 'bio_component',
				'traverse' => 'bio_component',
			       },
		     description => 'a component with children, shared variables and parameters',
		     isa => 'iohier',
		     name => 'symtab_BioComponent',
		    },
       ),

       # biological components

       (

	# biological without segments

	(
	 cached_connection => {
			       allows => {
					  'get_cached_delay' => 'cached_connection',
					  'get_cached_post' => 'cached_connection',
					  'get_cached_pre' => 'cached_connection',
					  'get_cached_weight' => 'cached_connection',
					 },
			       annotations => {
					       'piSymbolType2Biolevel' => 'BIOLEVEL_CELL',
					      },
			       description => 'a connection in a projection index, alien typed and with alien identification numbers',
			       isa => 'root',
# 			       name => 'symtab_ConnectionSymbol',
			       parameters => {
					      'DELAY' => {
							  description => 'connection delay',
							 },
					      'POST' => 'connection post synaptic serial identifier',
					      'PRE' => 'connection pre synaptic serial identifier',
					      'WEIGHT' => 'connection weight',
					     },
			      },
	 channel => {
		     allows => {
				'collect_mandatory_parameter_values' => 'channel',
				'create_alias' => 'channel',
				'get_parameter' => 'channel',
				'has_equation' => 'channel',
				'has_m_g_block_g_m_a_x' => 'channel',
				'has_nernst_erev' => 'channel',
				'parameter_scale_value' => 'channel',
				'reduce' => 'channel',
			       },
		     annotations => {
				     'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
				    },
		     description => 'a ion conductance through a cell membrane',
		     dimensions => [
				    'mechanism',
				   ],
		     grammar => {
				 components => [
						'Attachment',
						'EquationExponential',
						'HHGate',
					       ],
				 specific_allocator => 'ChannelCalloc',
				 specific_description => {
							  add => '		TOKEN_TABLEFILE
		TOKEN_STRING
		{
#line
		    //- remove ending \'"\' from string

		    $2->pcString[$2->iLength - 1] = \'\0\';

		    //- put channel description on stack

		    $$ = ParserContextGetActual((PARSERCONTEXT *)pacParserContext);

		    //- fill in table parameters

		    ChannelSetTableParameters
			($$,
			 (PARSERCONTEXT *)pacParserContext,
			 &$2->pcString[1]);

		    //- reset actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$$->bio.ioh.iol.hsle);

		    //! memory leak : $2
		}
',
							 },
				 specific_token => {
						    class => 'channel',
						    lexical => 'TOKEN_CHANNEL',
						    purpose => 'physical',
						   },
				 typing => {
					    base => 'phsle',
					    id => 'pidin',
					    spec => 'pchan',
					    to_base => '->bio.ioh.iol.hsle',
					   },
				},
		     isa => 'bio_comp',
		     name => 'symtab_Channel',
		     parameters => {
				    CHANNEL_TYPE => {
						     description => 'defines the channel type (ChannelActInact: channel with activation and inactivation gates, ChannelAct: channel with activation gate, ChannelActConc: channel with activation and concentration gates)',
						     translation_steps => {
									   modeling => 'derived',
									  },
						    },
				    Erev => {
					     description => 'channel reversal potential',
					     translation_steps => {
								   simulation => 'initial_value',
								  },
					    },
				    G_MAX => {
					      description => 'maximal conductance density when all channels are in the open state',
					      translation_steps => {
								    simulation => 'initial_value',
								   },
					     },
				    G => 'actual channel conductance, normally a solved variable',
				    I => 'actual channel current, normally a solved variable',
				   },
		    },
	 concentration_gate_kinetic => {
					allows => {
						   'create_alias' => 'concentration_gate_kinetic',
						   'get_parameter' => 'concentration_gate_kinetic',
						  },
					annotations => {
							'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
						       },
					description => 'a description of the kinetics of a channel gate that is concentration dependent',
					grammar => {
						    components => [
								  ],
						    specific_allocator => 'ConcentrationGateKineticCalloc',
						    specific_token =>  => {
									   class => 'concentration_gate_kinetic',
									   lexical => 'TOKEN_CONCENTRATION_GATE_KINETIC',
									   purpose => 'physical',
									  },
						    typing => {
							       base => 'phsle',
							       id => 'pidin',
							       spec => 'pcgatk',
							       to_base => '->bio.ioh.iol.hsle',
							      },
						   },
					isa => 'bio_comp',
					name => 'symtab_ConcentrationGateKinetic',
					parameters => {
						       'Base' => 'basal level, A in EDS1994',
						       'HH_NUMBER_OF_TABLE_ENTRIES' => 'number of table entries in the gate kinetic',
						       'Tau' => 'time constant, B in EDS1994',
						      },
				       },
	 gate_kinetic => {
			  allows => {
				     'create_alias' => 'gate_kinetic',
				     'get_parameter' => 'gate_kinetic',
				    },
			  annotations => {
					  'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
					 },
			  description => 'a description of the kinetics of a gate, A/B representation',
			  grammar => {
				      components => [
						    ],
				      specific_allocator => 'GateKineticCalloc',
				      specific_token =>  => {
							     class => 'gate_kinetic',
							     lexical => 'TOKEN_GATE_KINETIC',
							     purpose => 'physical',
							    },
				      typing => {
						 base => 'phsle',
						 id => 'pidin',
						 spec => 'pgatk',
						 to_base => '->bio.ioh.iol.hsle',
						},
				     },
			  isa => 'bio_comp',
			  name => 'symtab_GateKinetic',
			  parameters => {
					 'HH_AB_Factor_Flag' => '3: choose between nominator or denominator, 1 means nominator, -1',
					 'HH_AB_Mult' => '2: multiplier membrane dependence, 0.0 for no dependence',
					 'HH_AB_Offset' => '4: nominator or denominator offset',
					 'HH_AB_OffsetM' => '4: nominator or denominator offset',
					 'HH_AB_Offset_E' => '5: membrane offset',
					 'HH_AB_Add_Num' => '1: multiplier',
					 'HH_AB_Div_E' => '6: denormalized time constant',
					 'HH_NUMBER_OF_TABLE_ENTRIES' => 'number of table entries in the gate kinetic',
					 'table[0]' => 'First entry when a tabulated representation is available',
					},
			 },
# 	 gate_kinetic_tabulated => {
# 				    allows => {
# 					       'create_alias' => 'gate_kinetic_tabulated',

# 					       #! note that we overwrite the parameters we get from gate_kinetic,
# 					       #! because we don't want to see AB representations and such.

# 					       'get_parameter' => 'bio_comp',
# 					      },
# 				    annotations => {
# 						    'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
# 						   },
# 				    description => 'a tabulated description of the kinetics of a gate, A/B representation',
# 				    isa => 'gate_kinetic',
# 				    name => 'symtab_GateKineticTabulated',
# 				    parameters => {
# 						   entry => 'array with values',
# 						  },
# 				   },
	 h_h_gate => {
		      annotations => {
				      'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
				     },
		      allows => {
				 'create_alias' => 'h_h_gate',
				 'get_parameter' => 'h_h_gate',
				},
		      description => 'a channel gate with hodgkin huxley alike kinetics',
		      grammar => {
				  components => [
						 'ConcentrationGateKinetic',
						 'GateKinetic',
						 'GateKineticBackward',
						 'GateKineticForward',
						 'GateKineticPart',
						],
				  specific_allocator => 'HHGateCalloc',
				  specific_token => {
						     class => 'h_h_gate',
						     lexical => 'TOKEN_HH_GATE',
						     purpose => 'physical',
						    },
				  typing => {
					     base => 'phsle',
					     id => 'pidin',
					     spec => 'pgathh',
					     to_base => '->bio.ioh.iol.hsle',
					    },
				 },
		      isa => 'bio_comp',
		      name => 'symtab_HHGate',
		      parameters => {
				     'HH_NUMBER_OF_TABLE_ENTRIES' => 'number of table entries in each of the gates',
				     'POWER' => 'gate power',
				     'state' => 'current state, normally a solved variable',
				     'state_init' => 'initial value, commonly forward over backward steady states',
				    },
		     },
	 connection => {
			allows => {
				   'all_successors_get' => 'connection',
				   'all_successors_set' => 'connection',
				   'all_serials_to_parent_get' => 'connection',
				   'all_serials_to_parent_set' => 'connection',
# 				   'assign_parameters' => 'connection',
				   'get_delay' => 'connection',
				   'get_parameter' => 'connection',
# 				   'get_pidin' => 'connection',
				   'get_post' => 'connection',
				   'get_pre' => 'connection',
				   'get_weight' => 'connection',
				   'parameter_resolve_value' => 'connection',
# 				   'traverse' => 'connection',
				  },
			annotations => {
					'piSymbolType2Biolevel' => 'BIOLEVEL_CELL',
				       },
			description => 'a regular connection in the symbol table, alien typed and with alien identification numbers',
			isa => 'root',
			name => 'symtab_Connection',
			parameters => {
				       'DELAY' => 'connection delay',
				       'POST' => 'connection post synaptic serial identifier',
				       'PRE' => 'connection pre synaptic serial identifier',
				       'WEIGHT' => 'connection weight',
				      },
		       },
	 connection_symbol => {
			       allows => {
					  'get_delay' => 'connection_symbol',
					  'get_post' => 'connection_symbol',
					  'get_pre' => 'connection_symbol',
					  'get_weight' => 'connection_symbol',
					 },
			       annotations => {
					       'piSymbolType2Biolevel' => 'BIOLEVEL_CELL',
					      },
			       description => 'a regular connection in the symbol table, self typed and with its own identification numbers',

			       grammar => {
					   components => [],
					   specific_allocator => 'ConnectionSymbolCalloc',
					   specific_token =>  => {
								  class => 'connection_symbol',
								  lexical => 'TOKEN_CONNECTION',
								  purpose => 'physical',
								 },
					   typing => {
						      base => 'phsle',
						      id => 'pidin',
						      spec => 'pconsy',
						      to_base => '->bio.ioh.iol.hsle',
						     },
					  },
			       isa => 'bio_comp',
			       name => 'symtab_ConnectionSymbol',
			       parameters => {
					      'DELAY' => 'connection delay',
					      'POST' => 'connection post synaptic symbol',
					      'PRE' => 'connection pre synaptic symbol',
					      'WEIGHT' => 'connection weight',
					     },
			      },
	 projection => {
			annotations => {
					'piSymbolType2Biolevel' => 'BIOLEVEL_POPULATION',
				       },
			allows => {
				   'count_connections' => 'projection',
				   'create_alias' => 'projection',
				  },
			description => 'a projection, with source and target populations',
			grammar => {
				    components => [
						   'VConnectionSymbol',
						   'Projection',
						  ],
				    specific_allocator => 'ProjectionCalloc',
				    specific_token => {
						       class => 'projection',
						       lexical => 'TOKEN_PROJECTION',
						       purpose => 'physical',
						      },
				    typing => {
					       base => 'phsle',
					       id => 'pidin',
					       spec => 'pproj',
					       to_base => '->bio.ioh.iol.hsle',
					      },
				   },
			isa => 'bio_comp',
			name => 'symtab_Projection',
			parameters => {
				       SOURCE => 'source population',
				       TARGET => 'target population',
				      },
		       },
	 pool => {
		  allows => {
			     'create_alias' => 'pool',
			     'get_parameter' => 'pool',
			     'parameter_scale_value' => 'pool',
			     'reduce' => 'pool',
			    },
		  annotations => {
				  'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
				 },
		  description => 'a concentration pool, exponential decay',
		  dimensions => [
				 'mechanism',
				],
		  grammar => {
			      components => [],
			      specific_allocator => 'PoolCalloc',
			      specific_token => {
						 class => 'pool',
						 lexical => 'TOKEN_POOL',
						 purpose => 'physical',
						},
			      typing => {
					 base => 'phsle',
					 id => 'pidin',
					 spec => 'ppool',
					 to_base => '->bio.ioh.iol.hsle',
					},
			     },
		  isa => 'bio_comp',
		  name => 'symtab_Pool',
		  parameters => {
				 BASE => 'base concentration level',
				 BETA => 'fixed beta (use the FIXED function to avoid scaling)',
				 DIA => 'concentration pool diameter, normally the same as the segment diameter',
				 LENGTH => 'concentration pool length, normally the same as the segment length',
				 TAU => 'concentration pool time constant',
				 THICK => 'concentration pool thickness',
				 VAL => 'ion valency',
				 concen => 'actual concentration value, normally a solved variable',
				 concen_init => 'initial concentration level',
				},
		 },
         pulse_gen => {
		       allows => {
				  'create_alias' => 'pulse_gen',
				 },
		       annotations => {
				       'piSymbolType2Biolevel' => 'BIOLEVEL_MECHANISM',
				      },
		       description => 'an object that can generate a variety of pulse patterns',
		       dimensions => [
				      'signal',
				     ],
		       grammar => {
				   components => [],
				   specific_allocator => 'PulseGenCalloc',
				   specific_token => {
						      class => 'pulse_gen',
						      lexical => 'TOKEN_PULSE_GEN',
						      purpose => 'physical',
						     },
				   typing => {
					      base => 'phsle',
					      id => 'pidin',
					      spec => 'ppulsegen',
					      to_base => '->bio.ioh.iol.hsle',
					     },
				  },
		       isa => 'bio_comp',
		       name => 'symtab_PulseGen',
		       parameters => {
				      LEVEL1 => 'level of pulse1',
				      LEVEL2 => 'level of pulse2',
				      WIDTH1 => 'width of pulse1',
				      WIDTH2 => 'width of pulse2',
				      DELAY1 => 'delay of pulse1',
				      DELAY2 => 'delay of pulse2',
				      BASELEVEL => 'baseline level',
				      TRIGMODE => 'Trigger mode, 0 - free run, 1 - ext trig, 2 - ext gate',
				     },
		      },
	),

	# biological with segments

	(
	 # segment traversables

	 #t these ones should support the following getters:
	 #t volume
	 #t surface
	 #t total cumulative length
	 #t branches ?
	 #t average diameter == volume / surface / PI or something

	 (
	  # biological with segments, base symbol

	  segmenter => {
			allows => {
				   'count_segments' => 'segmenter',
				   'get_parameter' => 'segmenter',
				   'linearize' => 'segmenter',
				   'mesher_on_length' => 'segmenter',
				   'parameter_scale_value' => 'segmenter',
				   'traverse_segments' => 'segmenter',
				  },
			annotations => {
					'piSymbolType2Biolevel' => 'BIOLEVEL_SEGMENT',
				       },
			description => 'a cable based component that allows segmentation of self or/and its children',
			isa => 'bio_comp',
			name => 'symtab_Segmenter',
			parameters => {
				       DIA => 'segment diameter',
				       LENGTH => 'segment length (calculated automatically if not set)',
				       PARENT => 'parent segment, somatopetal',
				       SEGMENTER_BASE => 'base symbol of segmentation',
				       SURFACE => 'surface of the segment (calculated automatically if not set, you can set it to add spine surface)',
				       TOTALSURFACE => 'total surface of all segments in the segmenter (calculated automatically)',
				       rel_X => 'spatial extent of the segment in the X direction',
				       rel_Y => 'spatial extent of the segment in the Y direction',
				       rel_Z => 'spatial extent of the segment in the Z direction',
				      },
		       },
	 ),

	 (
	  axon_hillock => {
			   allows => {
				      'create_alias' => 'axon_hillock',
				     },
			   annotations => {
					   'piSymbolType2Biolevel' => 'BIOLEVEL_SEGMENT',
					  },
			   description => 'a axon hillock',
			   grammar => {
				       components => [
						      'Segment',
						      'VSegment',
						     ],
				       specific_allocator => 'AxonHillockCalloc',
				       specific_token =>  => {
							      class => 'axon_hillock',
							      lexical => 'TOKEN_AXON_HILLOCK',
							      purpose => 'physical',
							     },
				       typing => {
						  base => 'phsle',
						  id => 'pidin',
						  spec => 'paxhi',
						  to_base => '->segr.bio.ioh.iol.hsle',
						 },
				      },
			   isa => 'segmenter',
			   name => 'symtab_AxonHillock',
			   parameters => {
					 },
			  },
	  cell => {
		   allows => {
			      'create_alias' => 'cell',
			     },
		   annotations => {
				   'piSymbolType2Biolevel' => 'BIOLEVEL_CELL',
				  },
		   description => 'a cell, presumably a neuron',
		   dimensions => [
				  'movable',
				 ],
		   grammar => {
			       components => [
					      'AxonHillock',
					      'Segment',
					      'VSegment',
					     ],
			       specific_allocator => 'CellCalloc',
			       specific_token =>  => {
						      class => 'cell',
						      lexical => 'TOKEN_CELL',
						      purpose => 'physical',
						     },
			       typing => {
					  base => 'phsle',
					  id => 'pidin',
					  spec => 'pcell',
					  to_base => '->segr.bio.ioh.iol.hsle',
					 },
			      },
		   isa => 'segmenter',
		   name => 'symtab_Cell',
		   parameters => {
				 },
		  },
	  izhikevich => {
			 allows => {
				    'create_alias' => 'izhikevich',
				   },
			 annotations => {
					 'piSymbolType2Biolevel' => 'BIOLEVEL_CELL',
					},
			 description => 'implementation of the izhikevich simple neuron model',
			 grammar => {
				     components => [],
				     specific_allocator => 'IzhikevichCalloc',
				     specific_token => {
							class => 'izhikevich',
							lexical => 'TOKEN_IZHIKEVICH',
							purpose => 'physical',
						       },
				     typing => {
						base => 'phsle',
						id => 'pidin',
						spec => 'pizhi',
						to_base => '->segr.bio.ioh.iol.hsle',
					       },
				    },
			 isa => 'segmenter',
			 name => 'symtab_Izhikevich',
			 parameters => {
					IHZI_A => 'A izhikevich simple neuron model parameter',
					IHZI_B => 'B izhikevich simple neuron model parameter',
					IHZI_C => 'C izhikevich simple neuron model parameter',
					IHZI_D => 'D izhikevich simple neuron model parameter',
				       },
			},
	  fiber => {
		    allows => {
			       'create_alias' => 'fiber',
			      },
		    annotations => {
				    'piSymbolType2Biolevel' => 'BIOLEVEL_CELL',
				   },
		    description => 'an axonal fiber that fires action potentials',
		    grammar => {
				components => [],
				specific_allocator => 'FiberCalloc',
				specific_token => {
						   class => 'fiber',
						   lexical => 'TOKEN_FIBER',
						   purpose => 'physical',
						  },
				typing => {
					   base => 'phsle',
					   id => 'pidin',
					   spec => 'pfibr',
					   to_base => '->segr.bio.ioh.iol.hsle',
					  },
			       },
		    isa => 'segmenter',
		    name => 'symtab_Fiber',
		    parameters => {
				   RATE => 'average firing frequence, bind it to the threshold of a spikegenerator',
				   REFRACTORY => 'absolute refractory period',
				  },
		   },
	  network => {
		      allows => {
				 'count_cells' => 'network',
				 'count_connections' => 'network',
				 'create_alias' => 'network',
				},
		      annotations => {
				      'piSymbolType2Biolevel' => 'BIOLEVEL_NETWORK',
				     },
		      description => 'a set of populations connected with projections',
		      dimensions => [
				     'movable',
				    ],
		      grammar => {
				  components => [
						 'Cell',
						 'Population',
						 'Projection',
						 'Network',
						],
				  specific_allocator => 'NetworkCalloc',
				  specific_token => {
						     class => 'network',
						     lexical => 'TOKEN_NETWORK',
						     purpose => 'physical',
						    },
				  typing => {
					     base => 'phsle',
					     id => 'pidin',
					     spec => 'pnetw',
					     to_base => '->segr.bio.ioh.iol.hsle',
					    },
				 },
		      isa => 'segmenter',
		      name => 'symtab_Network',
		      parameters => {
				    },
		     },
	  population => {
			 allows => {
				    'count_cells' => 'population',
				    'create_alias' => 'population',
				    'get_parameter' => 'population',
				   },
			 annotations => {
					 'piSymbolType2Biolevel' => 'BIOLEVEL_POPULATION',
					},
			 description => 'a set of cells',
			 dimensions => [
					'movable',
				       ],
			 grammar => {
				     components => [
						    'Cell',
						    'Randomvalue',
						   ],
				     specific_allocator => 'PopulationCalloc',
				     specific_token => {
							class => 'population',
							lexical => 'TOKEN_POPULATION',
							purpose => 'physical',
						       },
				     typing => {
						base => 'phsle',
						id => 'pidin',
						spec => 'ppopu',
						to_base => '->segr.bio.ioh.iol.hsle',
					       },
				    },
			 isa => 'segmenter',
			 name => 'symtab_Population',
			 parameters => {
					EXTENT_X => 'coordinate of the last cell minus coordinate of the first cell',
					EXTENT_Y => 'coordinate of the last cell minus coordinate of the first cell',
					EXTENT_Z => 'coordinate of the last cell minus coordinate of the first cell',
				       },
			},
# 	  subpopulation => {
# 			    allows => {
# 				       'count_cells' => 'population',
# 				       'create_alias' => 'population',
# 				       'get_parameter' => 'population',
# 				      },
# 			    annotations => {
# 					    'piSymbolType2Biolevel' => 'BIOLEVEL_POPULATION',
# 					   },
# 			    description => 'a subset of cells',
# 			    dimensions => [
# 					   'movable',
# 					  ],
# 			    grammar => {
# 					components => [
# 						       'Cell',
# 						       'Randomvalue',
# 						      ],
# 					specific_allocator => 'PopulationCalloc',
# 					specific_token => {
# 							   class => 'population',
# 							   lexical => 'TOKEN_SUBPOPULATION',
# 							   purpose => 'physical',
# 							  },
# 					typing => {
# 						   base => 'phsle',
# 						   id => 'pidin',
# 						   spec => 'ppopu',
# 						   to_base => '->segr.bio.ioh.iol.hsle',
# 						  },
# 				       },
# 			    isa => 'segmenter',
# 			    name => 'symtab_Population',
# 			    parameters => {
# 					   EXTENT_X => 'coordinate of the last cell minus coordinate of the first cell',
# 					   EXTENT_Y => 'coordinate of the last cell minus coordinate of the first cell',
# 					   EXTENT_Z => 'coordinate of the last cell minus coordinate of the first cell',
# 					  },
# 			   },
	  segment => {
		      allows => {
				 'create_alias' => 'segment',
				 'get_parameter' => 'segment',
				 'reduce' => 'segment',
				},
		      annotations => {
				      'piSymbolType2Biolevel' => 'BIOLEVEL_SEGMENT',
				     },
		      description => 'a single linear cylindrical segment of a neuron',
		      grammar => {
				  components => [
						 'Attachment',
						 'Pool',
						 'Channel',
						],
				  specific_allocator => 'SegmentCalloc',
				  specific_token => {
						     class => 'segment',
						     lexical => 'TOKEN_SEGMENT',
						     purpose => 'physical',
						    },
				  typing => {
					     base => 'phsle',
					     id => 'pidin',
					     spec => 'psegment',
					     to_base => '->segr.bio.ioh.iol.hsle',
					    },
				 },
		      isa => 'segmenter',
		      name => 'symtab_Segment',
		      parameters => {
				     BRANCHPOINT => '1 if this is a branch point, 0 if not, DBL_MAX if unknown (a very high value)',
				     CM => 'specific capacitance of this segment',
				     RA => 'specific axial resistance of this segment',
				     RM => 'specific membrane resistance of this segment',
				     SOMATOPETAL_BRANCHPOINTS => 'number of branchpoints on the path toward the soma',
				     SOMATOPETAL_DISTANCE => 'somatopetal distance of the segment',
				     TAU => 'time constant of the segment, CM * RM',
				     Vm => 'membrane potential, normally a solved variable',
				     Vm_init => 'initial membrane potential',
				    },
		     },
	 ),
	),
       ),

       # enumeration types, homogeneous

       (
	vector => {
		   description => 'a homogeneous group of components (all children have the same type)',
		   isa => 'bio_comp',
		   name => 'symtab_Vector',

		   #t I think this should be abstract, not sure.
		   #t it does need an init function to init the structure

		   parameters => {
				 },
		  },
	v_contour => {
		      allows => {
				 'create_alias' => 'v_contour',
				},
		      description => 'a vector of spatial contours',
		      grammar => {
				  components => [
						 'EMContour',
						],
				  specific_allocator => 'VContourCalloc',
				  specific_token => {
						     class => 'v_contour',
						     lexical => 'TOKEN_CONTOUR_GROUP',
						     purpose => 'physical',
						    },
				  typing => {
					     base => 'phsle',
					     id => 'pidin',
					     spec => 'pvcont',
					     to_base => '->vect.bio.ioh.iol.hsle',
					    },
				 },
		      isa => 'vector',
		      name => 'symtab_VContour',
		      parameters => {
				    },
		     },
	v_connection => {
			 allows => {
# 				    'create_alias' => 'v_connection',
				    'traverse' => 'v_connection',
				   },
# 			 annotations => {
# 					 'piSymbolType2Biolevel' => 'BIOLEVEL_POPULATION',
# 					},
			 description => 'a vector of connections with alien typing',
			 isa => 'vector',
			 name => 'symtab_VConnection',
			 parameters => {
				       },
			},
	v_connection_symbol => {
				allows => {
					   'create_alias' => 'v_connection_symbol',
					  },
# 				annotations => {
# 						'piSymbolType2Biolevel' => 'BIOLEVEL_POPULATION',
# 					       },
				description => 'a vector of connections with their own type information',
			 grammar => {
				     components => [
						    'ConnectionSymbol',
						   ],

				     # not having an allocator
				     # overhere means the generated
				     # grammar will not have allocator
				     # code, and allocation must be
				     # done externally.

				     specific_allocator => 'VConnectionSymbolCalloc',
				     specific_token => {
							class => 'v_connection',
							lexical => 'TOKEN_CONNECTION_GROUP',
							purpose => 'physical',
						       },
				     typing => {
						base => 'phsle',
						id => 'pidin',
						spec => 'pvconsy',
						to_base => '->vect.bio.ioh.iol.hsle',
					       },
# 				     disabled => 'to complicated for the moment',
				    },
				isa => 'vector',
				name => 'symtab_VConnectionSymbol',
				parameters => {
					      },
			       },

	#t this one should be a segmenter, but need to use instrumentation for that.

	v_segment => {
		      allows => {
				 'count_segments' => 'v_segment',
				 'create_alias' => 'v_segment',
				 'traverse_segments' => 'v_segment',
				},
		      description => 'a vector of segments',
		      dimensions => [
				     'movable',
				    ],
		      grammar => {
				  components => [
						 'Segment',
						 'VSegment',
						],
				  specific_allocator => 'VSegmentCalloc',
				  specific_section => {
						       parts => [
								 'specific_front',
								 '	InputOutputRelations',
								 '	OptionalItemInputRelations',
								 '	specific_description',
								 '{
		    //- get current context

		    struct PidinStack *ppist
			= ParserContextGetPidinContext
			  ((PARSERCONTEXT *)pacParserContext);

		    //- recompute relative coordinates to absolute coordinates

		    VSegmentRelative2Absolute($4, ppist);
		}',
								 'specific_end',
								],
						       semantic => '#line
		    //- link input/output relations

		    SymbolAssignBindableIO(&$4specific_to_base, $2);

		    //- bind I/O relations

		    SymbolAssignInputs(&$4specific_to_base, $3);

		    //- put finished section info on stack

		    $$ = $4;
',
						      },
				  specific_token => {
						     class => 'v_segment',
						     lexical => 'TOKEN_SEGMENT_GROUP',
						     purpose => 'physical',
						    },
				  typing => {
					     base => 'phsle',
					     id => 'pidin',
					     spec => 'pvsegm',
					     to_base => '->vect.bio.ioh.iol.hsle',
					    },
				 },
		      isa => 'vector',
		      name => 'symtab_VSegment',
		      parameters => {
				    },
		     },
       ),

       # enumeration types, heterogeneous

       (
	group => {
		  allows => {
# 			     'count_spike_generators' => 'group',
			     'count_segments' => 'segmenter',
			     'create_alias' => 'group',
			     'traverse_segments' => 'segmenter',
			    },
		  description => 'a heterogeneous group of components',
		  dimensions => [
				 'movable',
				],
		  grammar => {
			      components => [
					     'Attachment',
					     'AxonHillock',
					     'Cell',
					     'Channel',
					     'ConcentrationGateKinetic',
					     'EquationExponential',
					     'Fiber',
					     'GateKinetic',
					     'GateKineticBackward',
					     'GateKineticForward',
					     'GateKineticPart',
					     'Group',
					     'HHGate',
					     'Izhikevich',
					     'Network',
					     'Pool',
					     'Population',
					     'Projection',
					     'Segment',
					     'VSegment',
					    ],
			      specific_allocator => 'GroupCalloc',
			      specific_token => {
						 class => 'group',
						 lexical => 'TOKEN_GROUP',
						 purpose => 'physical',
						},
			      typing => {
					 base => 'phsle',
					 id => 'pidin',
					 spec => 'pgrup',
					 to_base => '->bio.ioh.iol.hsle',
					},
			     },
		  isa => 'bio_comp',
		  name => 'symtab_Group',
		  parameters => {
				},
		 },
       ),

       # purely mathematical types

       (
	equation_exponential => {
				 allows => {
					    'collect_mandatory_parameter_values' => 'equation_exponential',
					    'create_alias' => 'equation_exponential',
					   },
				 description => 'an exponential equation (or an alpha function)',
				 grammar => {
					     components => [],
					     specific_allocator => 'EquationExponentialCalloc',
					     specific_token => {
								class => 'equation_exponential',
								lexical => 'TOKEN_EQUATION_EXPONENTIAL',
								purpose => 'physical',
							       },
					     typing => {
							base => 'phsle',
							id => 'pidin',
							spec => 'peqe',
							to_base => '->bio.ioh.iol.hsle',
						       },
					    },
				 isa => 'bio_comp',
				 name => 'symtab_EquationExponential',
				 parameters => {
						TAU1 => 'first time constant',
						TAU2 => 'second time constant',
					       },
				},
	randomvalue => {
			allows => {
				   'create_alias' => 'randomvalue',
				  },

			#! perhaps this annotation is related to visualization, not sure, but
			#! if a randomvalue is a purely mathematical type, it should not have biolevel.

# 			annotations => {
# 					'piSymbolType2Biolevel' => 'BIOLEVEL_SEGMENT',
# 				       },
			description => 'a component that produces a different random value each time it is consulted',
			grammar => {
				    components => [
						   'Attachment',
						  ],
				    specific_allocator => 'RandomvalueCalloc',
				    specific_token => {
						       class => 'randomvalue',
						       lexical => 'TOKEN_RANDOMVALUE',
						       purpose => 'physical',
						      },
				    typing => {
					       base => 'phsle',
					       id => 'pidin',
					       spec => 'pranv',
					       to_base => '->bio.ioh.iol.hsle',
					      },
				   },
			isa => 'bio_comp',
			name => 'symtab_Randomvalue',
			parameters => {
				       LENGTH => 'length, for visualization purposes only',
				       MAXIMUM => 'maximum value the random variable can take',
				       MINIMUM => 'minimum value the random variable can take',
				      },
		       },
       ),

       # geometrical types

       (
	e_m_contour => {
			allows => {
				   'count_points' => 'e_m_contour',
				   'create_alias' => 'e_m_contour',
				  },
			annotations => {
					'piSymbolType2Biolevel' => 'BIOLEVEL_ATOMIC',
				       },
			description => 'a spatial contour, presumably representing an EM trace',
			grammar => {
				    components => [
						   'ContourPoint',
						  ],
				    specific_allocator => 'EMContourCalloc',
				    specific_token => {
						       class => 'e_m_contour',
						       lexical => 'TOKEN_EM_CONTOUR',
						       purpose => 'physical',
						      },
				    typing => {
					       base => 'phsle',
					       id => 'pidin',
					       spec => 'pemc',
					       to_base => '->bio.ioh.iol.hsle',
					      },
				   },
			isa => 'bio_comp',
			name => 'symtab_EMContour',
			parameters => {
				      },
		       },
	contour_point => {
			  allows => {
				     'create_alias' => 'contour_point',
				     'get_parameter' => 'contour_point',
				    },
			  annotations => {
					  'piSymbolType2Biolevel' => 'BIOLEVEL_ATOMIC',
					 },
			  description => 'a single point in 3D space, presumably from an EM trace',
			  grammar => {
				      components => [
						    ],
				      specific_allocator => 'ContourPointCalloc',
				      specific_token => {
							 class => 'contour_point',
							 lexical => 'TOKEN_CONTOUR_POINT',
							 purpose => 'physical',
							},
				      typing => {
						 base => 'phsle',
						 id => 'pidin',
						 spec => 'pcpnt',
						 to_base => '->bio.ioh.iol.hsle',
						},
				     },
			  isa => 'bio_comp',
			  name => 'symtab_ContourPoint',
			  parameters => {
					 THICKNESS => 'thickness of the slice originating the contour',
					},
			 },
       ),

       # discrete & combinatorial types

       (
	algorithm_symbol => {
			     allows => {
					'create_alias' => 'algorithm_symbol',
					'get_name' => 'algorithm_symbol',
					'get_parameter' => 'algorithm_symbol',
					'get_pidin' => 'algorithm_symbol',
					'parameter_resolve_value' => 'algorithm_symbol',
					'traverse' => 'algorithm_symbol',
				       },
			     description => 'a symbol that represents the fact that an algorithm has modified or inspected the model in the symbol table',
			     isa => 'symbol',
			     name => 'symtab_AlgorithmSymbol',
			     parameters => {
					   },
			    },
	traversable_algorithm => {
				  allows => {
					     'traverse' => 'traversable_algorithm',
					    },
				  description => 'a symbol that represents an algorithm that generates components of the model',
				  isa => 'algorithm_symbol',
				  name => 'symtab_AlgorithmSymbol',
				  parameters => {
						},
				 },
       ),

       # data model related

       (
	attachment => {
		       allows => {
				  'collect_mandatory_parameter_values' => 'attachment',
				  'create_alias' => 'attachment',
				  'get_type' => 'attachment',
				  'set_type' => 'attachment',
				 },
		       description => 'a possible connection start or end point, without the connection',
		       grammar => {
				   components => [
						 ],
				   specific_allocator => 'AttachmentCalloc',
				   specific_token =>  => {
							  class => 'attachment',
							  lexical => 'TOKEN_ATTACHMENT',
							  purpose => 'physical',
							 },
				   typing => {
					      base => 'phsle',
					      id => 'pidin',
					      spec => 'patta',
					      to_base => '->bio.ioh.iol.hsle',
					     },
				   disabled => 'to complicated for the moment',
				  },

		       #t should not be a bio_comp at all, but the
		       #t implementation currently depends on this ...
		       #t I think this is one of the biggest abstract
		       #t problems with NS right now.

		       isa => 'bio_comp',
		       name => 'symtab_Attachment',
		       parameters => {
				     },
		      },

	#t specific functions can be derived, but shouldn't this be
	#t in its own hierarchy ?  Ah, no, for the SHA checking,
	#t everything must be accessible in a single traversal.

	#t for the purpose of addressing, most convenient is to have
	#t everything accessible in a single hierarchy, to simplify the
	#t interface of a findsolvefield function.  It will look the same,
	#t independent of fetching the value of a function, component, or
	#t something else.

# 	function => {
# 		     allows => {
# 				get_name => 'function',
# 				traverse => 'function',
# 			       },
# 		     isa => 'symbol',
# 		     name => 'symtab_Function',
# 		     parameters => {
# 				   },
# 		    },

	grouped_parameters => {
			       allows => {
					 },
			       description => 'a group of parameters',
			       grammar => {
					   components => [
							 ],
					   specific_allocator => 'GroupedParametersCalloc',
					   specific_token => {
							      class => 'grouped_parameters',
							      lexical => 'TOKEN_GROUPED_PARAMETERS',
							      purpose => 'physical',
							     },
					   typing => {
						      base => 'phsle',
						      id => 'pidin',
						      spec => 'pgrpp',
						      to_base => '->bio.ioh.iol.hsle',
						     },
					  },
			       isa => 'bio_comp',
			       name => 'symtab_GroupedParameters',
			       parameters => {
					     },
			      },
	invisible => {
		      description => 'an entry that has been inserted during memory optimization, and is generally invisible to the user',
		      isa => 'symbol',
		      name => 'symtab_Invisible',
		      parameters => {
				     #t ah, this is an interesting
				     #t one, as it can be anything
				     #t depending on what has been made
				     #t invisible, but it can never be
				     #t anything, because it is
				     #t invisible.
				     #t
				     #t at the moment, doesnot matter,
				     #t so I don't care.
				    },
		     },

	#t a parameter is supposed to always end the recursion of the traversal ?

	#t perhaps it allows to recurse traversals for cases where
	#t this is an explicit request, but not for 'biologically
	#t regular' traversals.

	#t then perhaps the same can be said about function ?

	#t I need to make drawings of this ...

# 	parameter => {
# 		      allows => {
# 				 get_name => 'parameter',
# 				 traverse => 'parameter',
# 				},
# 		      description => 'a parameter that belongs to a component',
# 		      isa => 'symbol',
# 		      name => 'symtab_Parameter',
# 		     },
	root_symbol => {
			allows => {
				   'add_child' => 'root_symbol',
				   'delete_child' => 'root_symbol',
				   'get_name' => 'root_symbol',
				   'get_pidin' => 'root_symbol',
				   'lookup_hierarchical' => 'root_symbol',
				   'traverse' => 'root_symbol',
				   'traverse_spike_generators' => 'root_symbol',
				   'traverse_spike_receivers' => 'root_symbol',
				  },
			annotations => {
					'piSymbolType2Biolevel' => 'BIOLEVEL_NERVOUS_SYSTEM',
				       },
			description => 'the root of a set of imported files, private or public models',
			isa => 'symbol',
			name => 'symtab_RootSymbol',
			parameters => {
				       #t could be useful to make the origin accessible, like filename etc.
				      },
		       },
       ),
      };


my $grammar_rules
    = {
       specific_description => {
				a_allocator_constructor => {
							    parts => [],
							    semantic => '#line

		    $$ = ParserContextGetActual((PARSERCONTEXT *)pacParserContext);
',
							   },
				b_reference_constructor => {
							    parts => [
								      'specific_description',
								      'ChildSectionOptionalInputOptionalParameters',
								     ],
							    semantic => '#line
		    //- link children

		    if ($2)
		    {
			SymbolAddChild(&$1specific_to_base, $2);
		    }

		    //- reset actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$1specific_to_base);

		    //- put symbol description on stack

		    $$ = $1;
',
							   },
				c_hardcoding_constructor => {
							     parts => [
								       'specific_description',
								       'specific_component',
								      ],
							     semantic => '#line
		    //- add component to current section list

		    SymbolAddChild(&$1specific_to_base, $2);

		    //- reset actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$1specific_to_base);

		    //- push current description on stack

		    $$ = $1;
',
							    },
				d_parameter_constructor => {
							    parts => [
								      'specific_description',
								      'Parameters',
								     ],
							    semantic => '#line
		    //- link parameters

		    SymbolParameterLinkAtEnd(&$1specific_to_base, $2);

		    //- reset actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$1specific_to_base);

		    //- put symbol on stack

		    $$ = $1;
',
							   },
				e_parametercache_constructor => {
								 parts => [
									   'specific_description',
									   'CachedParameters',
									  ],
								 semantic => '#line
		    //- link parameters

		    SymbolAddToForwardReferencers(&$1specific_to_base, $2);

		    //- reset actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$1specific_to_base);

		    //- put symbol on stack

		    $$ = $1;
',
							   },
			       },
       specific_end => {
			parts => [
				  'EndPushedPidin',
				  'specific_token',
				 ],
			semantic => '#line
',
		       },
       specific_front => {
			  parts => [
				    'specific_front1',
				    'specific_front2',
				   ],
			   semantic => '#line

		    //- prepare struct for symbol table

		    $$ = $1;

		    //- set actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$$specific_to_base);

		    //- assign name to symbol

		    SymbolSetName(&$$specific_to_base, $2);
',
			 },
       specific_front1 => {
			   parts => [
				     'specific_token',
				    ],
			   semantic => '#line

		    //- prepare struct for symbol table

		    $$ = specific_allocator();

		    //- set actual symbol

		    ParserContextSetActual
			((PARSERCONTEXT *)pacParserContext,
			 &$$specific_to_base);
',
			  },
       specific_front2 => {
			   parts => [
				     'IdentifierOptionIndexPushedPidin',
				    ],
			   semantic => '#line

		    //- put identifier on stack

		    $$ = $1;
',
			  },
       specific_section => {
			    parts => [
				      'specific_front',
				      '	InputOutputRelations',
				      '	OptionalItemInputRelations',
				      '	specific_description',
				      'specific_end',
				     ],
			    semantic => '#line
		    //- link input/output relations

		    SymbolAssignBindableIO(&$4specific_to_base, $2);

		    //- bind I/O relations

		    SymbolAssignInputs(&$4specific_to_base, $3);

		    //- put finished section info on stack

		    $$ = $4;
',
			   },
      };


# special grammar symbols that are not directly related with symbol
# types (but perhaps they are indirectly)

my $grammar_symbols
    = {
       GateKineticBackward => {
			       components => [
					      'GateKineticPart',
					     ],
			       specific_allocator => 'GateKineticCalloc',
			       specific_token => {
						  lexical => 'TOKEN_GATE_KINETIC_B',
						 },
			       typing => {
					  base => 'phsle',
					  id => 'pidin',
					  spec => 'pgatk',
					  to_base => '->bio.ioh.iol.hsle',
					 },
			      },
       GateKineticForward => {
			      components => [
					     'GateKineticPart',
					    ],
			      specific_allocator => 'GateKineticCalloc',
			      specific_token => {
						 lexical => 'TOKEN_GATE_KINETIC_A',
						},
			      typing => {
					 base => 'phsle',
					 id => 'pidin',
					 spec => 'pgatk',
					 to_base => '->bio.ioh.iol.hsle',
					},
			     },
       GateKineticPart => {
			   components => [
					  #t this one is likely superfluous

					  'GateKineticPart',
					 ],
			   specific_allocator => 'GateKineticCalloc',
			   specific_token => {
					      lexical => 'TOKEN_GATE_KINETIC_PART',
					     },
			   typing => {
				      base => 'phsle',
				      id => 'pidin',
				      spec => 'pgatk',
				      to_base => '->bio.ioh.iol.hsle',
				     },
			  },
      };


my $method_count = 2;

my $object_methods
    = {
       map
       {
	   $_ => $method_count++;
       }
       sort
       (
	'add_child',
	'all_serials_to_parent_get',
	'all_serials_to_parent_set',
	'all_successors_get',
	'all_successors_set',
	'assign_bindable_i_o',
	'assign_inputs',
	'assign_parameters',
	'collect_mandatory_parameter_values',
	'count_cells',
	'count_connections',
	'count_segments',
	'count_spike_generators',
	'count_spike_receivers',
	'create_alias',
	'delete_child',
	'get_cached_delay',
	'get_cached_post',
	'get_cached_pre',
	'get_cached_weight',
	'get_child_from_input',
	'get_children',
	'get_delay',
# 	'get_i_d',
	'get_inputs',
	'get_modifiable_parameter',
	'get_name',
	'get_options',
	'get_parameter',
	'get_pidin',
	'get_post',
	'get_pre',
	'get_prototype',
	'get_symbol',
	'get_type',
	'get_weight',
	'has_bindable_i_o',
	'has_equation',
	'has_m_g_block_g_m_a_x',
	'has_nernst_erev',
	'linearize',
	'lookup_hierarchical',
	'lookup_serial_i_d',
	'mesher_on_length',
	'parameter_link_at_end',
	'parameter_resolve_value',
	'parameter_scale_value',
#        'parameter_transform_value',
#        'principal_serial_2_context',
	'print',
	'reduce',
	'resolve_input',
	'resolve_parameter_functional_input',
	'set_at_x_y_z',
	'set_name',
	'set_namespace',
	'set_options',
	'set_parameter_context',
	'set_parameter_double',
	'set_parameter_may_be_copy_string',
	'set_parameter_string',
	'set_prototype',
	'set_type',
	'traverse',
#        'traverse_bio_levels',
	'traverse_segments',
	'traverse_spike_generators',
	'traverse_spike_receivers',
#        'traverse_wildcard',
       ),
      };


my $object_methods_custom_code
    = {
       'add_child' => {
		       simple => 1,
		      },
       'all_serials_to_parent_get' => {
				       simple => 1,
				      },
       'all_serials_to_parent_set' => {
				       simple => 1,
				      },
       'all_successors_get' => {
				simple => 1,
			       },
       'all_successors_set' => {
				simple => 1,
			       },
       'assign_bindable_i_o' => {
				 simple => 1,
				},
       'assign_inputs' => {
			   simple => 1,
			  },
       'assign_parameters' => {
			       simple => 1,
			      },
       'collect_mandatory_parameter_values' => {
						simple => 1,
					       },
       'count_cells' => {
			 simple => 1,
			},
       'count_connections' => {
			       simple => 1,
			      },
       'count_segments' => {
			    simple => 1,
			   },
       'count_spike_generators' => {
				    simple => 1,
				   },
       'count_spike_receivers' => {
				   simple => 1,
				  },
       'create_alias' => {
			  simple => 1,
			 },
       'delete_child' => {
			  simple => 1,
			 },
       'get_cached_delay' => {
			      simple => 1,
			     },
       'get_cached_post' => {
			     simple => 1,
			    },
       'get_cached_pre' => {
			    simple => 1,
			   },
       'get_cached_weight' => {
			       simple => 1,
			      },
       'get_child_from_input' => {
				  simple => 1,
				 },
       'get_children' => {
			  simple => 1,
			 },
       'get_delay' => {
		       simple => 1,
		      },
#        'get_i_d' => {
# 		     simple => 1,
# 		    },
       'get_inputs' => {
			simple => 1,
		       },
       'get_name' => {
		      simple => 1,
		     },
       'get_options' => {
			 simple => 1,
			},
       'get_parameter' => {
			   simple => 1,
			  },
       'get_pidin' => {
		       simple => 1,
		      },
       'get_post' => {
		      simple => 1,
		     },
       'get_pre' => {
		     simple => 1,
		    },
       'get_prototype' => {
			   simple => 1,
			  },
       'get_symbol' => {
			simple => 1,
		       },
       'get_type' => {
		      simple => 1,
		     },
       'get_weight' => {
			simple => 1,
		       },
       'has_bindable_i_o' => {
			      simple => 1,
			     },
       'has_equation' => {
			  simple => 1,
			 },
       'has_m_g_block_g_m_a_x' => {
				   simple => 1,
				  },
       'has_nernst_erev' => {
			     simple => 1,
			    },
       'linearize' => {
		       simple => 1,
		      },
       'lookup_hierarchical' => {
				 pre => '

    //- if outrunning this context

    if (PidinStackNumberOfEntries(ppist) < iLevel)
    {
	//- cannot be, return failure

	return(NULL);
    }

    //- if no next name in pidin stack

    if (!PidinStackElementPidin(ppist,iLevel))
    {
	//- return given element

	return(phsle);
    }

',
				},
       'lookup_serial_i_d' => {
			       simple => 1,
			      },
       'mesher_on_length' => {
			      simple => 1,
			     },
       'parameter_link_at_end' => {
				   simple => 1,
				  },
       'parameter_resolve_value' => {
				     simple => 1,
				    },
       'parameter_scale_value' => {
				   simple => 1,
				  },
#        'parameter_transform_value' => {
# 				       fixed => 1,
# 				      },
#        'principal_serial_2_context' => {
# 					fixed => 1,
# 				       },
       'print' => {
		   pre => '

    //- print name of symbol

    PrintIndent(iIndent,pfile);
    fprintf
	(pfile,"Name, index (%s,%i)\n",SymbolName(phsle), -1);

    //- print type of symbol

    PrintIndent(iIndent,pfile);
    fprintf(pfile,"Type (%s)\n",SymbolHSLETypeDescribe(phsle->iType));

',
		   post_I_was_wong_here => {
					    print => '
	PrintIndent(iIndent,pfile);
',
			   },
		  },
       'reduce' => {
		    simple => 1,
		   },
       'resolve_input' => {
			   simple => 1,
			  },
       'resolve_parameter_functional_input' => {
						simple => 1,
					       },
       'set_at_x_y_z' => {
			  simple => 1,
			 },
       'set_name' => {
		      simple => 1,
		     },
       'set_namespace' => {
			   simple => 1,
			  },
       'set_options' => {
			 simple => 1,
			},
       'set_parameter_context' => {
				   simple => 1,
				  },
       'set_parameter_double' => {
				  simple => 1,
				 },
       'set_parameter_may_be_copy_string' => {
					      simple => 1,
					     },
       'set_parameter_string' => {
				  simple => 1,
				 },
       'set_prototype' => {
			   simple => 1,
			  },
       'set_type' => {
		      simple => 1,
		     },
       'traverse_segments' => {
			       simple => 1,
			      },
       'traverse_spike_generators' => {
				       simple => 1,
				      },
       'traverse_spike_receivers' => {
				      simple => 1,
				     },
       'get_modifiable_parameter' => {
				      simple => 1,
				     },
       'traverse' => {
		      simple => 1,
		     },
#        'traverse_bio_levels' => {
# 				 fixed => 1,
# 				},
#        'traverse_wildcard' => {
# 			       fixed => 1,
# 			      },
      };


my $object_methods_return_types
    = {
       'add_child' => {
		       default => 'FALSE',
		       selector => '.uSelector.iFunc',
		       type => 'int',
		      },
       'all_serials_to_parent_get' => {
				       default => 'TRUE',
				       selector => '.uSelector.iFunc',
				       type => 'int',
				      },
       'all_serials_to_parent_set' => {
				       default => 'TRUE',
				       selector => '.uSelector.iFunc',
				       type => 'int',
				      },
       'all_successors_get' => {
				default => 'TRUE',
				selector => '.uSelector.iFunc',
				type => 'int',
			       },
       'all_successors_set' => {
				default => 'TRUE',
				selector => '.uSelector.iFunc',
				type => 'int',
			       },
       'assign_bindable_i_o' => {
				 default => 'FALSE',
				 selector => '.uSelector.iFunc',
				 type => 'int',
				},
       'assign_inputs' => {
			   default => 'FALSE',
			   selector => '.uSelector.iFunc',
			   type => 'int',
			  },
       'assign_parameters' => {
			       default => 'FALSE',
			       selector => '.uSelector.iFunc',
			       type => 'int',
			      },
       'collect_mandatory_parameter_values' => {
						default => '-1',
						selector => '.uSelector.iFunc',
						type => 'int',
					       },
       'count_cells' => {
			 default => '-1',
			 selector => '.uSelector.iFunc',
			 type => 'int',
			},
       'count_connections' => {
			       default => '-1',
			       selector => '.uSelector.iFunc',
			       type => 'int',
			      },
       'count_segments' => {
			    default => '-1',
			    selector => '.uSelector.iFunc',
			    type => 'int',
			   },
       'count_spike_generators' => {
				    default => '-1',
				    selector => '.uSelector.iFunc',
				    type => 'int',
				   },
       'count_spike_receivers' => {
				   default => '-1',
				   selector => '.uSelector.iFunc',
				   type => 'int',
				  },
       'create_alias' => {
			  default => 'NULL',
			  selector => '.uSelector.phsleFunc',
			  type => 'struct symtab_HSolveListElement *',
			 },
       'delete_child' => {
			  default => 'FALSE',
			  selector => '.uSelector.iFunc',
			  type => 'int',
			 },
       'get_cached_delay' => {
			      default => 'DBL_MAX',
			      selector => '.uSelector.dFunc',
			      type => 'double',
			     },
       'get_cached_post' => {
			     default => '-1',
			     selector => '.uSelector.iFunc',
			     type => 'int',
			    },
       'get_cached_pre' => {
			    default => '-1',
			    selector => '.uSelector.iFunc',
			    type => 'int',
			   },
       'get_cached_weight' => {
			       default => 'DBL_MAX',
			       selector => '.uSelector.dFunc',
			       type => 'double',
			      },
       'get_child_from_input' => {
				  default => 'NULL',
				  selector => '.uSelector.phsleFunc',
				  type => 'struct symtab_HSolveListElement *',
				 },
       'get_children' => {
			  default => 'NULL',
			  selector => '.uSelector.piohcFunc',
			  type => 'IOHContainer *',
			 },
       'get_delay' => {
		       default => 'DBL_MAX',
		       selector => '.uSelector.dFunc',
		       type => 'double',
		      },
#        'get_i_d' => {
# 		     default => 'NULL',
# 		     selector => '.uSelector.pcFunc',
# 		     type => 'char *',
# 		    },
       'get_inputs' => {
			default => 'NULL',
			selector => '.uSelector.piocFunc',
			type => 'struct symtab_IOContainer *',
		       },
       'get_modifiable_parameter' => {
				      default => 'NULL',
				      selector => '.uSelector.pparFunc',
				      type => 'struct symtab_Parameters *',
				     },
       'get_name' => {
		      default => 'NULL',
		      selector => '.uSelector.pcFunc',
		      type => 'char *',
		     },
       'get_options' => {
			 default => 'FALSE',
			 selector => '.uSelector.iFunc',
			 type => 'int',
			},
       'get_parameter' => {
			   default => 'NULL',
			   selector => '.uSelector.pparFunc',
			   type => 'struct symtab_Parameters *',
			  },
       'get_pidin' => {
		       default => 'NULL',
		       selector => '.uSelector.pidinFunc',
		       type => 'struct symtab_IdentifierIndex *',
		      },
       'get_post' => {
		      default => '-1',
		      selector => '.uSelector.iFunc',
		      type => 'int',
		     },
       'get_pre' => {
		     default => '-1',
		     selector => '.uSelector.iFunc',
		     type => 'int',
		    },
       'get_prototype' => {
			   default => 'NULL',
			   selector => '.uSelector.phsleFunc',
			   type => 'struct symtab_HSolveListElement *',
			  },
       'get_symbol' => {
			default => 'NULL',
			selector => '.uSelector.phsleFunc',
			type => 'struct symtab_HSolveListElement *',
		       },
       'get_type' => {
		      default => '-1',
		      selector => '.uSelector.iFunc',
		      type => 'int',
		     },
       'get_weight' => {
			default => 'DBL_MAX',
			selector => '.uSelector.dFunc',
			type => 'double',
		       },
       'has_bindable_i_o' => {
			      default => '-1',
			      selector => '.uSelector.iFunc',
			      type => 'int',
			     },
       'has_equation' => {
			  default => '-1',
			  selector => '.uSelector.iFunc',
			  type => 'int',
			 },
       'has_m_g_block_g_m_a_x' => {
				   default => '-1',
				   selector => '.uSelector.iFunc',
				   type => 'int',
				  },
       'has_nernst_erev' => {
			     default => '-1',
			     selector => '.uSelector.iFunc',
			     type => 'int',
			    },
       'linearize' => {
		       default => '0',
		       selector => '.uSelector.iFunc',
		       type => 'int',
		      },
       'lookup_hierarchical' => {
				 default => 'NULL',
				 selector => '.uSelector.phsleFunc',
				 type => 'struct symtab_HSolveListElement *',
				},
       'lookup_serial_i_d' => {
			       default => '-1',
			       selector => '.uSelector.iFunc',
			       type => 'int',
			      },
       'mesher_on_length' => {
			      default => '-1',
			      selector => '.uSelector.iFunc',
			      type => 'int',
			     },
       'parameter_link_at_end' => {
				   default => 'FALSE',
				   selector => '.uSelector.iFunc',
				   type => 'int',
				  },
       'parameter_resolve_value' => {
				     default => 'DBL_MAX',
				     selector => '.uSelector.dFunc',
				     type => 'double',
				    },
       'parameter_scale_value' => {
				   default => 'DBL_MAX',
				   selector => '.uSelector.dFunc',
				   type => 'double',
				  },
#        'parameter_transform_value' => {
# 				       default => 'FALSE',
# 				       selector => '.uSelector.iFunc',
# 				       type => 'int',
# 				      },
#        'principal_serial_2_context' => {
# 					default => 'NULL',
# 					selector => '.uSelector.',
# 					type => 'struct PidinStack *',
# 				       },
       'print' => {
		   default => 'TRUE',
		   selector => '.uSelector.iFunc',
		   type => 'int',
		  },
       'reduce' => {
		    default => 'TRUE',
		    selector => '.uSelector.iFunc',
		    type => 'int',
		   },
       'resolve_input' => {
			   default => 'NULL',
			   selector => '.uSelector.ppistFunc',
			   type => 'struct PidinStack *',
			  },
       'resolve_parameter_functional_input' => {
						default => 'NULL',
						selector => '.uSelector.phsleFunc',
						type => 'struct symtab_HSolveListElement *',
					       },
       'set_at_x_y_z' => {
			  default => 'FALSE',
			  selector => '.uSelector.iFunc',
			  type => 'int',
			 },
       'set_name' => {
		      default => 'FALSE',
		      selector => '.uSelector.iFunc',
		      type => 'int',
		     },
       'set_namespace' => {
			   default => 'FALSE',
			   selector => '.uSelector.iFunc',
			   type => 'int',
			  },
       'set_options' => {
			 default => 'FALSE',
			 selector => '.uSelector.iFunc',
			 type => 'int',
			},
       'set_parameter_context' => {
				   default => 'NULL',
				   selector => '.uSelector.pparFunc',
				   type => 'struct symtab_Parameters *',
				  },
       'set_parameter_double' => {
				  default => 'NULL',
				  selector => '.uSelector.pparFunc',
				  type => 'struct symtab_Parameters *',
				 },
       'set_parameter_may_be_copy_string' => {
					      default => 'NULL',
					      selector => '.uSelector.pparFunc',
					      type => 'struct symtab_Parameters *',
					     },
       'set_parameter_string' => {
				  default => 'NULL',
				  selector => '.uSelector.pparFunc',
				  type => 'struct symtab_Parameters *',
				 },
       'set_prototype' => {
			   default => 'FALSE',
			   selector => '.uSelector.iFunc',
			   type => 'int',
			  },
       'set_type' => {
		      default => 'FALSE',
		      selector => '.uSelector.iFunc',
		      type => 'int',
		     },
       'traverse' => {
		      default => '1',
		      selector => '.uSelector.iFunc',
		      type => 'int',
		     },
#        'traverse_bio_levels' => {
# 				 default => '1',
# 				 selector => '.uSelector.iFunc',
# 				 type => 'int',
# 				},
       'traverse_segments' => {
			       default => '1',
			       selector => '.uSelector.iFunc',
			       type => 'int',
			      },
       'traverse_spike_generators' => {
				       default => '1',
				       selector => '.uSelector.iFunc',
				       type => 'int',
				      },
       'traverse_spike_receivers' => {
				      default => '1',
				      selector => '.uSelector.iFunc',
				      type => 'int',
				     },
#        'traverse_wildcard' => {
# 			       default => '1',
# 			       selector => '.uSelector.iFunc',
# 			       type => 'int',
# 			      },
      };


my $object_methods_signatures
    = {
       'add_child' => {
		       calling => '(phsle, phsleChild)',
		       prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_HSolveListElement *phsleChild)',
		      },
       'all_serials_to_parent_get' => {
				       calling => '(phsle
	 , piInvisible
	 , piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , piSegment
#endif
	    )
',
				       prototype => '(struct symtab_HSolveListElement *phsle,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
)',
				      },
       'all_serials_to_parent_set' => {
				       calling => '(phsle
	 , iInvisible
	 , iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , iSegment
#endif
	    )
',
				       prototype => '(struct symtab_HSolveListElement *phsle,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
)',
				      },
       'all_successors_get' => {
				calling => '(phsle
	 , piInvisible
	 , piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , piSegment
#endif
	    )
',
				prototype => '(struct symtab_HSolveListElement *phsle,
 int *piInvisible,
 int *piPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int *piMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int *piSegment
#endif
)',
			       },
       'all_successors_set' => {
				calling => '(phsle
	 , iInvisible
	 , iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
	 , iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
	 , iSegment
#endif
	    )
',
				prototype => '(struct symtab_HSolveListElement *phsle,
 int iInvisible,
 int iPrincipal
#ifdef TREESPACES_SUBSET_MECHANISM
 , int iMechanism
#endif
#ifdef TREESPACES_SUBSET_SEGMENT
 , int iSegment
#endif
)',
			       },
       'assign_bindable_i_o' => {
				 calling => '(phsle, pioc)',
				 prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_IOContainer *pioc)',
				},
       'assign_inputs' => {
			   calling => '(phsle, pio)',
			   prototype => '(struct symtab_HSolveListElement * phsle, struct symtab_InputOutput *pio)',
			  },
       'assign_parameters' => {
			       calling => '(phsle, ppar)',
			       prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_Parameters *ppar)',
			      },
       'collect_mandatory_parameter_values' => {
						calling => '(phsle, ppist)',
						prototype => '(struct symtab_HSolveListElement *phsle,struct PidinStack *ppist)',
					       },
       'count_cells' => {
			 calling => '(phsle, ppist)',
			 prototype => '(struct symtab_HSolveListElement *phsle,struct PidinStack *ppist)',
			},
       'count_connections' => {
			       calling => '(phsle, ppist)',
			       prototype => '(struct symtab_HSolveListElement *phsle,struct PidinStack *ppist)',
			      },
       'count_segments' => {
			    calling => '(phsle, ppist)',
			    prototype => '(struct symtab_HSolveListElement *phsle,struct PidinStack *ppist)',
			   },
       'count_spike_generators' => {
				    calling => '(phsle, ppist)',
				    prototype => '(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)',
				   },
       'count_spike_receivers' => {
				   calling => '(phsle, ppist)',
				   prototype => '(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)',
				  },
       'create_alias' => {
			  calling => '(phsle, pcNamespace, pidin)',
			  prototype => '(struct symtab_HSolveListElement *phsle, char *pcNamespace, struct symtab_IdentifierIndex *pidin)',
			 },
       'delete_child' => {
			  calling => '(phsle, phsleChild)',
			  prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_HSolveListElement *phsleChild)',
		      },
       'get_cached_delay' => {
			      calling => '(phsle)',
			      prototype => '(struct symtab_HSolveListElement * phsle)',
			     },
       'get_cached_post' => {
			     calling => '(phsle)',
			     prototype => '(struct symtab_HSolveListElement * phsle)',
			    },
       'get_cached_pre' => {
			    calling => '(phsle)',
			    prototype => '(struct symtab_HSolveListElement * phsle)',
			   },
       'get_cached_weight' => {
			       calling => '(phsle)',
			       prototype => '(struct symtab_HSolveListElement * phsle)',
			      },
       'get_child_from_input' => {
				  calling => '(phsle, pio)',
				  prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_InputOutput *pio)',
				 },
       'get_children' => {
			  calling => '(pioh)',
			  prototype => '(struct symtab_IOHierarchy *pioh)',
			  typer => {
				    name => '&pioh->iol.hsle',
				   },
			 },
       'get_delay' => {
		       calling => '(phsle, ppist)',
		       prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist)',
		      },
#        'get_i_d' => {
# 		     calling => '(phsle, ppist)',
# 		     prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist)',
# 		    },
       'get_inputs' => {
			calling => '(phsle)',
			prototype => '(struct symtab_HSolveListElement *phsle)',
		       },
       'get_modifiable_parameter' => {
				      calling => '(phsle, pcName, ppist)',
				      prototype => '(struct symtab_HSolveListElement *phsle, char *pcName, struct PidinStack *ppist)',
				     },
       'get_name' => {
		      calling => '(phsle)',
		      prototype => '(struct symtab_HSolveListElement *phsle)',
		     },
       'get_options' => {
			 calling => '(phsle)',
			 prototype => '(struct symtab_HSolveListElement *phsle)',
			},
       'get_parameter' => {
			   calling => '(phsle, ppist, pcName)',
			   prototype => '(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, char *pcName)',
			  },
       'get_pidin' => {
		       calling => '(phsle)',
		       prototype => '(struct symtab_HSolveListElement *phsle)',
		      },
       'get_post' => {
		      calling => '(phsle, iTarget)',
		      prototype => '(struct symtab_HSolveListElement * phsle, int iTarget)',
		     },
       'get_pre' => {
		     calling => '(phsle, iSource)',
		     prototype => '(struct symtab_HSolveListElement * phsle, int iSource)',
		    },
       'get_prototype' => {
			   calling => '(phsle)',
			   prototype => '(struct symtab_HSolveListElement *phsle)',
			  },
       'get_symbol' => {
			calling => '(phsle)',
			prototype => '(struct symtab_HSolveListElement *phsle)',
		       },
       'get_type' => {
		      calling => '(phsle)',
		      prototype => '(struct symtab_HSolveListElement *phsle)',
		     },
       'get_weight' => {
			calling => '(phsle, ppist)',
			prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist)',
		       },
       'has_bindable_i_o' => {
			      calling => '(phsle, pc, i)',
			      prototype => '(struct symtab_HSolveListElement * phsle, char *pc, int i)',
			     },
       'has_equation' => {
			  calling => '(phsle, ppist)',
			  prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist)',
			 },
       'has_m_g_block_g_m_a_x' => {
				   calling => '(phsle, ppist)',
				   prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist)',
				  },
       'has_nernst_erev' => {
			     calling => '(phsle, ppist)',
			     prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist)',
			    },
       'linearize' => {
		       calling => '(phsle, ppist)',
		       prototype => '(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)',
		      },
       'lookup_hierarchical' => {
				 calling => '(phsle, ppist, iLevel, bAll)',
				 prototype => '(struct symtab_HSolveListElement * phsle, struct PidinStack *ppist, int iLevel, int bAll)',
				},
       'lookup_serial_i_d' => {
			       calling => '(phsle, ppist, phsleSerial, ppistSerial)',
			       prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsleSerial,
 struct PidinStack *ppistSerial)',
			      },
       'mesher_on_length' => {
			      calling => '(phsle, ppist, dLength)',
			      prototype => '(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, double dLength)',
			     },
       'parameter_link_at_end' => {
				   calling => '(phsle, ppar)',
				   prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_Parameters *ppar)',
				  },
       'parameter_resolve_value' => {
				     calling => '(phsle, ppist, pcName)',
				     prototype => '(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, char *pcName)',
				    },
       'parameter_scale_value' => {
				   calling => '(phsle, ppist, dValue, ppar)',
				   prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar)',
				  },
#        'parameter_transform_value' => {
# 				       calling => '(phsle, ppist, ppar, pD3)',
# 				       prototype => '(struct symtab_HSolveListElement *phsle,
#  struct PidinStack *ppist,
#  struct symtab_Parameters *ppar,
#  struct D3Position *pD3)',
# 				      },
#        'principal_serial_2_context' => {
# 					calling => 'does not get used ?',
# 					prototype => 'does not get used ?',
# 				       },
       'print' => {
		   calling => '(phsle, TRUE, iIndent, pfile)',
		   prototype => '(struct symtab_HSolveListElement *phsle,int iIndent,FILE *pfile)',
		  },
       'reduce' => {
		    calling => '(phsle, ppist)',
		    prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)',
		   },
       'resolve_input' => {
			   calling => '(phsle, ppist, pcName, iPosition)',
			   prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcName,
 int iPosition)',
			  },
       'resolve_parameter_functional_input' => {
						calling => '(phsle, ppist, pcParameter, pcInput, iPosition)',
						prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcParameter,
 char *pcInput,
 int iPosition)',
					       },
       'set_at_x_y_z' => {
			  calling => '(phsle, x, y, z)',
			  prototype => '(struct symtab_HSolveListElement *phsle,double x,double y,double z)',
			 },
       'set_name' => {
		      calling => '(phsle, pidin)',
		      prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_IdentifierIndex *pidin)',
		     },
       'set_namespace' => {
			   calling => '(phsle, pc)',
			   prototype => '(struct symtab_HSolveListElement *phsle, char *pc)',
			  },
       'set_options' => {
			 calling => '(phsle, iOptions)',
			 prototype => '(struct symtab_HSolveListElement *phsle, int iOptions)',
			},
       'set_parameter_context' => {
				   calling => '(phsle, pcName, ppistValue/* , ppist */)',
				   prototype => '(struct symtab_HSolveListElement *phsle,
 char *pcName,
 struct PidinStack *ppistValue)',
				 },
       'set_parameter_double' => {
				  calling => '(phsle, pcName, dNumber/* , ppist */)',
				  prototype => '(struct symtab_HSolveListElement *phsle,
 char *pcName,
 double dNumber)',
				 },
       'set_parameter_may_be_copy_string' => {
					      calling => '(phsle, pcName, pcValue/* , ppist */)',
					      prototype => '(struct symtab_HSolveListElement *phsle,
 char *pcName,
 char *pcValue,
 int iFlags)',
				 },
       'set_parameter_string' => {
				  calling => '(phsle, pcName, pcValue/* , ppist */)',
				  prototype => '(struct symtab_HSolveListElement *phsle,
 char *pcName,
 char *pcValue)',
				 },
       'set_prototype' => {
			   calling => '(phsle, phsleProto)',
			   prototype => '(struct symtab_HSolveListElement *phsle, struct symtab_HSolveListElement *phsleProto)',
			  },
       'set_type' => {
		      calling => '(phsle, iType)',
		      prototype => '(struct symtab_HSolveListElement *phsle, int iType)',
		     },
       'traverse' => {
		      calling => '(ptstr, phsle)',
		      prototype => '(struct TreespaceTraversal *ptstr, struct symtab_HSolveListElement *phsle)',
		     },
#        'traverse_bio_levels' => {
# 				 calling => '(phsle, ppist, pbls, pfProcesor, pfFinalizer, pvUserdata)',
# 				 prototype => '(struct symtab_HSolveListElement *phsle,
#  struct PidinStack *ppist,
#  struct BiolevelSelection *pbls,
#  TreespaceTraversalProcessor *pfProcesor,
#  TreespaceTraversalProcessor *pfFinalizer,
#  void *pvUserdata)',
# 				},
       'traverse_segments' => {
			       calling => '(phsle, ppist, pfProcesor, pfFinalizer, pvUserdata)',
			       prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)',
			      },
       'traverse_spike_generators' => {
				       calling => '(phsle, ppist, pfProcesor, pfFinalizer, pvUserdata)',
				       prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)',
				      },
       'traverse_spike_receivers' => {
				      calling => '(phsle, ppist, pfProcesor, pfFinalizer, pvUserdata)',
				      prototype => '(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)',
				     },
#        'traverse_wildcard' => {
# 			       calling => '(phsle, ppist, pbls, pfProcesor, pfFinalizer, pvUserdata)',
# 			       prototype => '(struct symtab_HSolveListElement *phsle,
#  struct PidinStack *ppist,
#  struct PidinStack *ppistWildcard,
#  TreespaceTraversalProcessor *pfProcesor,
#  TreespaceTraversalProcessor *pfFinalizer,
#  void *pvUserdata)',
# 				},
      };


# tokens that are not associated with symbols, e.g. because they are
# purely structural.

my $tokens
    = {
       absolute => {
		    lexical => 'TOKEN_ABSOLUTE',
		   },
       alias => {
		 lexical => 'TOKEN_ALIAS',
		 purpose => 'structure',
		},
       alpha_equation => {
			  lexical => 'TOKEN_ALPHA_EQUATION',
			 },
       attributes => {
		      lexical => 'TOKEN_ATTRIBUTES',
		     },
       bindables => {
		     lexical => 'TOKEN_BINDABLES',
		     purpose => 'structure',
		    },
       bindings => {
		    lexical => 'TOKEN_BINDINGS',
		    purpose => 'structure',
		   },
       child => {
		 lexical => 'TOKEN_CHILD',
		 purpose => 'structure',
		},
#        children => {
# 		    lexical => 'TOKEN_CHILDREN',
# 		   },
       cylindrical => {
		       lexical => 'TOKEN_CYLINDRICAL',
		      },
       current_symbol => {
			  lexical => 'TOKEN_CURRENT_SYMBOL',
			  text => '.',
			 },
#        define => {
# 		  lexical => 'TOKEN_DEFINE',
# 		 },
       dereference => {
		       lexical => 'TOKEN_DEREFERENCE',
		       text => '->',
		      },
       end => {
	       lexical => 'TOKEN_END',
	      },
       events => {
		  lexical => 'TOKEN_EVENTS',
		 },
       file => {
		lexical => 'TOKEN_FILE',
	       },
       forwardparameters => {
			     lexical => 'TOKEN_FORWARDPARAMETERS',
			     purpose => 'structure',
			    },
       generates => {
		     lexical => 'TOKEN_GENERATES',
		    },
       has => {
	       lexical => 'TOKEN_HAS',
	      },
       hierarchicalseperator => {
				 lexical => 'TOKEN_HIERARCHICALSEPERATOR',
				 text => '/',
				},
       identifier => {
		      lexical => 'TOKEN_IDENTIFIER',
		      text => '',
		      type => 'pcIdentifier',
		     },
       import => {
		  lexical => 'TOKEN_IMPORT',
		  purpose => 'file_structure',
		 },
       input => {
		 lexical => 'TOKEN_INPUT',
		},
#        integer => {
# 		   lexical => 'TOKEN_INTEGER',
# 		   type => 'iInteger',
# 		  },
       ioselect => {
		    lexical => 'TOKEN_IOSELECT',
		    text => '@',
		   },
       meters => {
		  lexical => 'TOKEN_METERS',
		 },
       algorithm => {
		     class => 'algorithm_symbol',
		     lexical => 'TOKEN_ALGORITHM',
		     purpose => 'physical',
		    },
       namespaceseperator => {
			      lexical => 'TOKEN_NAMESPACESEPERATOR',
			      text => '::',
			     },
       ncd => {
	       lexical => 'TOKEN_NCD',
	      },
       ndf => {
	       lexical => 'TOKEN_NDF',
	      },
       ned => {
	       lexical => 'TOKEN_NED',
	      },
       neuron => {
		  lexical => 'TOKEN_NEURON',
		  purpose => 'physical',
		 },
       neurospaces => {
		       lexical => 'TOKEN_NEUROSPACES',
		      },
       nmd => {
	       lexical => 'TOKEN_NMD',
	      },
       nnd => {
	       lexical => 'TOKEN_NND',
	      },
       number => {
		  lexical => 'TOKEN_NUMBER',
		  text => '',
		  type => 'dNumber',
		 },
       options => {
		   lexical => 'TOKEN_OPTIONS',
		  },
       origin => {
		  lexical => 'TOKEN_ORIGIN',
		  text => '',
		 },
       output => {
		  lexical => 'TOKEN_OUTPUT',
		 },
       parameter => {
		     lexical => 'TOKEN_PARAMETER',
		     purpose => 'structure',
		    },
       parameters => {
		      lexical => 'TOKEN_PARAMETERS',
		      purpose => 'structure',
		     },
       parent_symbol => {
			 lexical => 'TOKEN_PARENT_SYMBOL',
			 text => [
				  '..',
				  '^',
				 ],
			},
       private_models => {
			  lexical => 'TOKEN_PRIVATE_MODELS',
			  purpose => 'file_structure',
			 },
       public_models => {
			 lexical => 'TOKEN_PUBLIC_MODELS',
			 purpose => 'file_structure',
			},
       receives => {
		    lexical => 'TOKEN_RECEIVES',
		   },
       relative => {
		    lexical => 'TOKEN_RELATIVE',
		   },
       seconds => {
		   lexical => 'TOKEN_SECONDS',
		  },
       shebanger => {
		     lexical => 'TOKEN_SHEBANGER',
		     text => '',
		    },
       siemens => {
		   lexical => 'TOKEN_SIEMENS',
		  },
       spherical => {
		     lexical => 'TOKEN_SPHERICAL',
		    },
       string => {
		  lexical => 'TOKEN_STRING',
		  text => '',
		  type => 'pstring',
		 },
       tablefile => {
		     lexical => 'TOKEN_TABLEFILE',
		     text => '',
		    },
       units => {
		 lexical => 'TOKEN_UNITS',
		},
       version => {
		   lexical => 'TOKEN_VERSION',
		  },
#        versionnumber => {
# 			 lexical => 'TOKEN_VERSIONNUMBER',
# 			},
       voltage => {
		   lexical => 'TOKEN_VOLTAGE',
		  },
      };


my $definitions
    = {
       annotations => {
		       'piSymbolType2Biolevel' => {
						     default => -1,
						     order => 'type_number',
						     type => 'plain',
						    },
		      },

       class_hierarchy => $class_hierarchy,
       grammar_rules => $grammar_rules,
       grammar_symbols => $grammar_symbols,
       name => 'symbols',
       object_methods => $object_methods,
       object_methods_custom_code => $object_methods_custom_code,
       object_methods_prefix => 'symbol',
       object_methods_return_types => $object_methods_return_types,
       object_methods_signatures => $object_methods_signatures,
       tokens => $tokens,

       typing => {
		  typer => {
			    member => 'iType',
			    name => 'phsle',
			    type => 'struct symtab_HSolveListElement *',
			   },
		 },
      };


return $definitions;


