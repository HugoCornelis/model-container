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
					      'segments/micron2.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/segments/micron2.ndf.', ],
						   timeout => 3,
						   write => undef,
						  },
						  {
						   description => "What do the algorithm classes and instances report of what they have done ?",
						   read => [
							    "-re",
							    "---
number_of_algorithm_classes: 7
---
name: ConnectionCheckerClass
report:
    number_of_created_instances: 0
---
name: RandomizeClass
report:
    number_of_created_instances: 0
---
name: SpinesClass
report:
    number_of_created_instances: 0
---
name: ProjectionRandomizedClass
report:
    number_of_created_instances: 0
---
name: ProjectionVolumeClass
report:
    number_of_created_instances: 0
---
name: InserterClass
report:
    number_of_created_instances: 3
---
name: Grid3DClass
report:
    number_of_created_instances: 0
---
number_of_algorithm_instances: 3
---
name: InserterInstance spines
report:
    number_of_tries: 6
    number_of_failures_adding: 0
    InserterInstance heights file: algorithm_data/inserter_spines.heights
    InserterInstance insertion frequency: 1.000000
---
name: InserterInstance inhibition
report:
    number_of_tries: 6
    number_of_failures_adding: 0
    InserterInstance heights file: algorithm_data/inserter_inhibition.heights
    InserterInstance insertion frequency: 1.000000
---
name: InserterInstance excitation
report:
    number_of_tries: 6
    number_of_failures_adding: 0
    InserterInstance heights file: algorithm_data/inserter_excitation.heights
    InserterInstance insertion frequency: 1.000000
",
							   ],
						   write => "algorithmset",
						  },
						  {
						   description => "Do we find the inserted inhibitory channel ?",
#     channeAlgorithmInstance (excitation_inhibition)
						   read => "    Name, index (inserted_stellate_0,-1)
    Type (T_sym_channel)
    channeName, index (inserted_stellate_0,-1)
    channe{-- begin HIER sections ---
    channe}--  end  HIER sections ---
        channeName, index (Purk_GABA,-1)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (Purk_GABA,-1)
                PARA  Name (G_MAX)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.077000e+00)
                PARA  Name (Erev)
                PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
            channe{-- begin HIER sections ---
                Name, index (synapse,-1)
                Type (T_sym_attachment)
                attachName, index (synapse,-1)
                attach{-- begin HIER sections ---
                attach}--  end  HIER sections ---
                    attachName, index (Synapse,-1)
                    attach{-- begin HIER sections ---
                    attach}--  end  HIER sections ---
                        attachName, index (Synapse,-1)
                            PARA  Name (weight)
                            PARA  Type (TYPE_PARA_ATTRIBUTE), 
                            PARA  Name (delay)
                            PARA  Type (TYPE_PARA_ATTRIBUTE), 
                        attach{-- begin HIER sections ---
                        attach}--  end  HIER sections ---
                Name, index (exp2,-1)
                Type (T_sym_equation)
                equatiName, index (exp2,-1)
                    PARA  Name (TAU1)
                    PARA  Type (TYPE_PARA_NUMBER), Value(9.300000e-04)
                    PARA  Name (TAU2)
                    PARA  Type (TYPE_PARA_NUMBER), Value(2.650000e-02)
                equati{-- begin HIER sections ---
                equati}--  end  HIER sections ---
            channe}--  end  HIER sections ---
",
						   write => "printinfo /in12_1/mat_1/inserted_stellate_0",
						  },
						  {
						   description => "Do we find the inserted spine ?",
#     v_segmAlgorithmInstance (excitation_inhibition)
						   read => "    Name, index (inserted_spine_0,-1)
    Type (T_sym_v_segment)
    v_segmName, index (inserted_spine_0,-1)
    v_segm{-- begin HIER sections ---
    v_segm}--  end  HIER sections ---
        v_segmName, index (Purk_spine2,-1)
        v_segm{-- begin HIER sections ---
        v_segm}--  end  HIER sections ---
            v_segmName, index (Purk_spine2,-1)
            v_segm{-- begin HIER sections ---
                Name, index (neck,-1)
                Type (T_sym_segment)
                segmenName, index (neck,-1)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../..
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(6.600000e-07)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e-07)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
                    segmenName, index (spine_neck,-1)
                        PARA  Name (LENGTH)
                        PARA  Type (TYPE_PARA_NUMBER), Value(6.600000e-07)
                        PARA  Name (Vm_init)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
                        PARA  Name (RM)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e+00)
                        PARA  Name (RA)
                        PARA  Type (TYPE_PARA_NUMBER), Value(2.500000e+00)
                        PARA  Name (CM)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.640000e-02)
                        PARA  Name (ELEAK)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
                    segmen{-- begin HIER sections ---
                    segmen}--  end  HIER sections ---
                Name, index (head,-1)
                Type (T_sym_segment)
                segmenName, index (head,-1)
                    PARA  Name (Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.340360e-06)
                    PARA  Name (Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (PARENT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../neck
                    PARA  Name (rel_X)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Y)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (rel_Z)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.340360e-06)
                    PARA  Name (DIA)
                    PARA  Type (TYPE_PARA_NUMBER), Value(4.286000e-07)
                segmen{-- begin HIER sections ---
                segmen}--  end  HIER sections ---
                    segmenName, index (spine_head2,-1)
                        PARA  Name (LENGTH)
                        PARA  Type (TYPE_PARA_NUMBER), Value(6.803600e-07)
                        PARA  Name (Vm_init)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
                        PARA  Name (RM)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e+00)
                        PARA  Name (RA)
                        PARA  Type (TYPE_PARA_NUMBER), Value(2.500000e+00)
                        PARA  Name (CM)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.640000e-02)
                        PARA  Name (ELEAK)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
                    segmen{-- begin HIER sections ---
                    segmen}--  end  HIER sections ---
            v_segm}--  end  HIER sections ---
",
						   write => "printinfo /in12_1/mat_1/inserted_spine_0",
						  },
						  {
						   description => "Is the structure of the symbol table correct, start at root ?",
						   read => "Traversal serial ID = 37
Principal serial ID = 37 of 244 Principal successors
",
						   write => "serialMapping / /in12_1/mat_1/inserted_spine_0",
						  },
						  {
						   description => "Is the structure of the symbol table correct, somewhere in the middle (1) ?",
						   read => "Traversal serial ID = 1
Principal serial ID = 1 of 2 Principal successors
",
						   write => "serialMapping /in12_1/mat_1/inserted_spine_0 /in12_1/mat_1/inserted_spine_0/neck",
						  },
						  {
						   description => "Is the structure of the symbol table correct, somewhere in the middle (2) ?",
						   read => "Traversal serial ID = 1
Principal serial ID = 1 of 5 Principal successors
",
						   write => "serialMapping /in12_1/mat_1/inserted_excitation_0 /in12_1/mat_1/inserted_excitation_0/neck",
						  },
						  {
						   description => "Is the structure of the symbol table correct, somewhere in the middle (3) ?",
						   read => "Traversal serial ID = 2
Principal serial ID = 2 of 2 Principal successors
",
						   write => "serialMapping /in12_1/mat_1/inserted_stellate_0 /in12_1/mat_1/inserted_stellate_0/exp2",
						  },
						 ],
				description => "a reconstructed series",
# 				disabled => (!-e "$ENV{NEUROSPACES_NMC_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			      ],
       description => "inserter algorithm",
       name => 'inserter.t',
      };


return $test;


