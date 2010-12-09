#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      '-v',
					      '1',
					      'tests/cells/reducing.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/reducing.ndf.', ],
						  },
						  {
						   description => 'Do we find reducable items in the model (such as GENESIS2 and undefined parameters) ?',
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "hardcoded_neutral"
    SEGMENT "c"
      BINDINGS
        INPUT ka->I,
      END BINDINGS
      PARAMETERS
        PARAMETER ( LENGTH = 0 ),
        PARAMETER ( DIA = 2.98e-05 ),
        PARAMETER ( RM = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.58441e+08 ),
            ), ),
        PARAMETER ( RA = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 360502 ),
            ), ),
        PARAMETER ( Vm_init = -0.068 ),
        PARAMETER ( ELEAK = -0.08 ),
        PARAMETER ( CM = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 4.57537e-11 ),
            ), ),
        PARAMETER ( SURFACE = 2.78986e-09 ),
      END PARAMETERS
      CHANNEL "ka"
        BINDABLES
          INPUT Vm,
          OUTPUT G,
          OUTPUT I,
        END BINDABLES
        BINDINGS
          INPUT ..->Vm,
        END BINDINGS
        PARAMETERS
          PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
          PARAMETER ( G_MAX = 150 ),
          PARAMETER ( Erev = -0.085 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 1.79769e+308 ),
            PARAMETER ( state_init = 0.0837136 ),
            PARAMETER ( POWER = 4 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = -0.012 ),
              PARAMETER ( HH_AB_Offset_E = 0.027 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 1400 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = 0.004 ),
              PARAMETER ( HH_AB_Offset_E = 0.03 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 490 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 1.79769e+308 ),
            PARAMETER ( state_init = 0.747485 ),
            PARAMETER ( POWER = 1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = 0.008 ),
              PARAMETER ( HH_AB_Offset_E = 0.05 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 17.5 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.013 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 1300 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
    END SEGMENT
  END CELL
END PUBLIC_MODELS
',
						   write => 'export no ndf STDOUT /**',
						  },
						  {
						   description => 'Can we reduce the model ?',
						   write => 'reduce',
						  },
						  {
						   description => 'Do we find the reduced items in the model (removed GENESIS2 and undefined parameters) ?',
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "hardcoded_neutral"
    SEGMENT "c"
      BINDINGS
        INPUT ka->I,
      END BINDINGS
      PARAMETERS
        PARAMETER ( RA = 2.5 ),
        PARAMETER ( RM = 1 ),
        PARAMETER ( CM = 0.0164 ),
        PARAMETER ( DIA = 2.98e-05 ),
        PARAMETER ( Vm_init = -0.068 ),
        PARAMETER ( ELEAK = -0.08 ),
      END PARAMETERS
      CHANNEL "ka"
        BINDABLES
          INPUT Vm,
          OUTPUT G,
          OUTPUT I,
        END BINDABLES
        BINDINGS
          INPUT ..->Vm,
        END BINDINGS
        PARAMETERS
          PARAMETER ( G_MAX = 150 ),
          PARAMETER ( Erev = -0.085 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( state_init = 0.0837136 ),
            PARAMETER ( POWER = 4 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = -0.012 ),
              PARAMETER ( HH_AB_Offset_E = 0.027 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 1400 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = 0.004 ),
              PARAMETER ( HH_AB_Offset_E = 0.03 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 490 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( state_init = 0.747485 ),
            PARAMETER ( POWER = 1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = 0.008 ),
              PARAMETER ( HH_AB_Offset_E = 0.05 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 17.5 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Div_E = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.013 ),
              PARAMETER ( HH_AB_Add_Den = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Add_Num = 1300 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
    END SEGMENT
  END CELL
END PUBLIC_MODELS
',
						   write => 'export no ndf STDOUT /**',
						  },
						 ],
				description => 'reducing model parameters in a simple cell model',
			       },
			       {
				arguments => [
					      '-q',
					      '-v',
					      '1',
					      'tests/cells/singlea_naf.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/singlea_naf.ndf.', ],
						  },
						  {
						   description => 'Do we find reducable items in the model (such as CHANNEL_TYPE) ?',
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "soma" "tests/segments/soma.ndf"
    FILE "gate1" "gates/naf_activation.ndf"
    FILE "gate2" "gates/naf_inactivation.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "gate1::/naf_activation" "naf_gate_activation"
  END ALIAS
  ALIAS "gate2::/naf_inactivation" "naf_gate_inactivation"
  END ALIAS
  CHANNEL "NaF"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
      PARAMETER ( G_MAX = 75000 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "naf_gate_activation" "naf_gate_activation"
    END CHILD
    CHILD "naf_gate_inactivation" "naf_gate_inactivation"
    END CHILD
  END CHANNEL
  SEGMENT "soma2"
    BINDABLES
      OUTPUT Vm,
    END BINDABLES
    BINDINGS
      INPUT NaF->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Vm_init = -0.028 ),
      PARAMETER ( RM = 1 ),
      PARAMETER ( RA = 2.5 ),
      PARAMETER ( CM = 0.0164 ),
      PARAMETER ( ELEAK = -0.08 ),
    END PARAMETERS
    CHILD "NaF" "NaF"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "singlea_naf"
    SEGMENT_GROUP "segments"
      CHILD "soma2" "soma"
        PARAMETERS
          PARAMETER ( rel_X = 0 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 2.98e-05 ),
        END PARAMETERS
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						   write => 'export no ndf STDOUT /**',
						  },
						  {
						   description => 'Can we reduce the model (2) ?',
						   write => 'reduce',
						  },
						  {
						   description => 'Do we find the reduced items in the model (removed CHANNEL_TYPE and correct parameter structure) ?',
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "soma" "tests/segments/soma.ndf"
    FILE "gate1" "gates/naf_activation.ndf"
    FILE "gate2" "gates/naf_inactivation.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "gate1::/naf_activation" "naf_gate_activation"
  END ALIAS
  ALIAS "gate2::/naf_inactivation" "naf_gate_inactivation"
  END ALIAS
  CHANNEL "NaF"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 75000 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "naf_gate_activation" "naf_gate_activation"
    END CHILD
    CHILD "naf_gate_inactivation" "naf_gate_inactivation"
    END CHILD
  END CHANNEL
  SEGMENT "soma2"
    BINDABLES
      OUTPUT Vm,
    END BINDABLES
    BINDINGS
      INPUT NaF->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Vm_init = -0.028 ),
      PARAMETER ( RM = 1 ),
      PARAMETER ( RA = 2.5 ),
      PARAMETER ( CM = 0.0164 ),
      PARAMETER ( ELEAK = -0.08 ),
    END PARAMETERS
    CHILD "NaF" "NaF"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "singlea_naf"
    SEGMENT_GROUP "segments"
      CHILD "soma2" "soma"
        PARAMETERS
          PARAMETER ( rel_X = 0 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 2.98e-05 ),
        END PARAMETERS
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						   write => 'export no ndf STDOUT /**',
						  },
						 ],
				description => 'reducing model parameters in a single compartment model with one channel',
				disabled => 'todo',
			       },
			      ],
       description => "reducing model parameters",
       name => 'reducing.t',
      };


return $test;


