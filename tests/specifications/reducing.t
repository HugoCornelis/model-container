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
              PARAMETER ( HH_AB_Tau = -0.012 ),
              PARAMETER ( HH_AB_Offset_E = 0.027 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 1400 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.004 ),
              PARAMETER ( HH_AB_Offset_E = 0.03 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 490 ),
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
              PARAMETER ( HH_AB_Tau = 0.008 ),
              PARAMETER ( HH_AB_Offset_E = 0.05 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 17.5 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.013 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 1300 ),
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
              PARAMETER ( HH_AB_Tau = -0.012 ),
              PARAMETER ( HH_AB_Offset_E = 0.027 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 1400 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.004 ),
              PARAMETER ( HH_AB_Offset_E = 0.03 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 490 ),
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
              PARAMETER ( HH_AB_Tau = 0.008 ),
              PARAMETER ( HH_AB_Offset_E = 0.05 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 17.5 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.013 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 0 ),
              PARAMETER ( HH_AB_Scale = 1300 ),
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
			      ],
       description => "reducing model parameters",
       name => 'reducing.t',
      };


return $test;


