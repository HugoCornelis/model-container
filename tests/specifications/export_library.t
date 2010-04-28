#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       (
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'gates/naf_activation.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/gates/naf_activation.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the gate model to an NDF file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export library ndf /tmp/1.ndf /**",
						   },
						   {
						    description => "Does the exported gate NDF file contain the correct model (1) ?",
						    read => {
							     application_output_file => '/tmp/1.ndf',
							     expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GATE_KINETIC "A_2"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Scale = 35000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Tau = -0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  GATE_KINETIC "B_3"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Scale = 7000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Tau = 0.02 ),
    END PARAMETERS
  END GATE_KINETIC
  HH_GATE "naf_activation_1"
    BINDABLES
      INPUT Vm,
      OUTPUT activation,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( state_init = 0.00784064 ),
      PARAMETER ( POWER = 3 ),
    END PARAMETERS
    CHILD "A_2" "A"
    END CHILD
    CHILD "B_3" "B"
    END CHILD
  END HH_GATE
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD naf_activation_1 naf_activation
  END CHILD
END PUBLIC_MODELS
',
							    },
						   },
						   {
						    description => "Can we export the gate model to an XML file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export library xml /tmp/1.xml /**",
						   },
						   {
						    comment => 'xml to html conversion fails when converting this test to html',
						    description => "Does the exported gate XML file contain the correct model ?",
						    read => {
							     application_output_file => '/tmp/1.xml',
							     expected_output => '<neurospaces type="ndf"/>

<private_models>
  <GATE_KINETIC> <name>A_2</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Scale</name><value>35000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.005</value> </parameter>
      <parameter> <name>HH_AB_Tau</name><value>-0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <GATE_KINETIC> <name>B_3</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Scale</name><value>7000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.065</value> </parameter>
      <parameter> <name>HH_AB_Tau</name><value>0.02</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <HH_GATE> <name>naf_activation_1</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>activation</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>state_init</name><value>0.00784064</value> </parameter>
      <parameter> <name>POWER</name><value>3</value> </parameter>
    </parameters>
    <child> <prototype>A_2</prototype> <name>A</name>
    </child>
    <child> <prototype>B_3</prototype> <name>B</name>
    </child>
  </HH_GATE>
</private_models>
<public_models>
  <child> <prototype>naf_activation_1</prototype> <name>naf_activation</name>
  </child>
</public_models>
',
							    },
						   },
						  ],
				 description => "export of a gate model",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       '/tmp/1.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for /tmp/1.ndf.', ],
						    timeout => 15,
						   },
						  ],
				 description => "parsing of the generated gate NDF file",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       '/tmp/1.xml',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for /tmp/1.xml.', ],
						    timeout => 15,
						   },
						  ],
				 description => "parsing of the generated gate xml file",
				},
			       ),
			       (
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/channels/naf.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/channels/naf.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the channel model to an NDF file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export library ndf /tmp/1.ndf /**",
						   },
						   {
						    description => "Does the exported channel NDF file contain the correct model (1) ?",
						    read => {
							     application_output_file => '/tmp/1.ndf',
							     expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GATE_KINETIC "A_3"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Scale = 35000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Tau = -0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  GATE_KINETIC "B_4"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Scale = 7000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Tau = 0.02 ),
    END PARAMETERS
  END GATE_KINETIC
  HH_GATE "naf_activation_2"
    BINDABLES
      INPUT Vm,
      OUTPUT activation,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( state_init = 0.00784064 ),
      PARAMETER ( POWER = 3 ),
    END PARAMETERS
    CHILD "A_3" "A"
    END CHILD
    CHILD "B_4" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_activation_2" "naf_gate_activation_2"
    PARAMETERS
      PARAMETER ( state_init = 0.00784064 ),
      PARAMETER ( POWER = 3 ),
    END PARAMETERS
  END CHILD
  CHILD "naf_gate_activation_2" "naf_gate_activation_proto_2"
  END CHILD
  GATE_KINETIC "A_6"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Scale = 225 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add = 1 ),
      PARAMETER ( HH_AB_Offset_E = 0.08 ),
      PARAMETER ( HH_AB_Tau = 0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  GATE_KINETIC "B_7"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Scale = 7500 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Offset_E = -0.003 ),
      PARAMETER ( HH_AB_Tau = -0.018 ),
    END PARAMETERS
  END GATE_KINETIC
  HH_GATE "naf_inactivation_5"
    BINDABLES
      INPUT Vm,
      OUTPUT activation,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( state_init = 0.263978 ),
      PARAMETER ( POWER = 1 ),
    END PARAMETERS
    CHILD "A_6" "A"
    END CHILD
    CHILD "B_7" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_inactivation_5" "naf_gate_inactivation_5"
    PARAMETERS
      PARAMETER ( state_init = 0.263978 ),
      PARAMETER ( POWER = 1 ),
    END PARAMETERS
  END CHILD
  CHILD "naf_gate_inactivation_5" "naf_gate_inactivation_proto_5"
  END CHILD
  CHANNEL "NaF_prototype_1"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 75000 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "naf_gate_activation_proto_2" "naf_gate_activation"
    END CHILD
    CHILD "naf_gate_inactivation_proto_5" "naf_gate_inactivation"
    END CHILD
  END CHANNEL
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD NaF_prototype_1 NaF_prototype
  END CHILD
END PUBLIC_MODELS
',
							    },
						   },
						   {
						    description => "Can we export the channel model to an XML file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export library xml /tmp/1.xml /**",
						   },
						   {
						    comment => 'xml to html conversion fails when converting this test to html',
						    description => "Does the exported channel XML file contain the correct model ?",
						    read => {
							     application_output_file => '/tmp/1.xml',
							     expected_output => '<neurospaces type="ndf"/>

<private_models>
  <GATE_KINETIC> <name>A_3</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Scale</name><value>35000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.005</value> </parameter>
      <parameter> <name>HH_AB_Tau</name><value>-0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <GATE_KINETIC> <name>B_4</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Scale</name><value>7000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.065</value> </parameter>
      <parameter> <name>HH_AB_Tau</name><value>0.02</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <HH_GATE> <name>naf_activation_2</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>activation</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>state_init</name><value>0.00784064</value> </parameter>
      <parameter> <name>POWER</name><value>3</value> </parameter>
    </parameters>
    <child> <prototype>A_3</prototype> <name>A</name>
    </child>
    <child> <prototype>B_4</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_activation_2</prototype> <name>naf_gate_activation_2</name>
    <parameters>
      <parameter> <name>state_init</name><value>0.00784064</value> </parameter>
      <parameter> <name>POWER</name><value>3</value> </parameter>
    </parameters>
  </child>
  <child> <prototype>naf_gate_activation_2</prototype> <name>naf_gate_activation_proto_2</name>
  </child>
  <GATE_KINETIC> <name>A_6</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Scale</name><value>225</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add</name><value>1</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.08</value> </parameter>
      <parameter> <name>HH_AB_Tau</name><value>0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <GATE_KINETIC> <name>B_7</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Scale</name><value>7500</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>-0.003</value> </parameter>
      <parameter> <name>HH_AB_Tau</name><value>-0.018</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <HH_GATE> <name>naf_inactivation_5</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>activation</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>state_init</name><value>0.263978</value> </parameter>
      <parameter> <name>POWER</name><value>1</value> </parameter>
    </parameters>
    <child> <prototype>A_6</prototype> <name>A</name>
    </child>
    <child> <prototype>B_7</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_inactivation_5</prototype> <name>naf_gate_inactivation_5</name>
    <parameters>
      <parameter> <name>state_init</name><value>0.263978</value> </parameter>
      <parameter> <name>POWER</name><value>1</value> </parameter>
    </parameters>
  </child>
  <child> <prototype>naf_gate_inactivation_5</prototype> <name>naf_gate_inactivation_proto_5</name>
  </child>
  <CHANNEL> <name>NaF_prototype_1</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>G_MAX</name><value>75000</value> </parameter>
      <parameter> <name>Erev</name><value>0.045</value> </parameter>
    </parameters>
    <child> <prototype>naf_gate_activation_proto_2</prototype> <name>naf_gate_activation</name>
    </child>
    <child> <prototype>naf_gate_inactivation_proto_5</prototype> <name>naf_gate_inactivation</name>
    </child>
  </CHANNEL>
</private_models>
<public_models>
  <child> <prototype>NaF_prototype_1</prototype> <name>NaF_prototype</name>
  </child>
</public_models>
',
							    },
						   },
						  ],
				 description => "export of a channel model",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       '/tmp/1.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for /tmp/1.ndf.', ],
						    timeout => 15,
						   },
						  ],
				 description => "parsing of the generated channel NDF file",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       '/tmp/1.xml',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for /tmp/1.xml.', ],
						    timeout => 15,
						   },
						  ],
				 description => "parsing of the generated channel xml file",
				},
			       ),
			      ],
       description => "exporting models in a variety of export formats",
       name => 'export_library.t',
      };


return $test;


