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
						    timeout => 5,
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
  GATE_KINETIC "A_4_4"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 35000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Div_E = -0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_4_4" "A_inserted_4"
  END CHILD
  GATE_KINETIC "B_5_5"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 7000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Div_E = 0.02 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_5_5" "B_inserted_5"
  END CHILD
  HH_GATE "naf_activation_3_3"
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
    CHILD "A_4_4" "A"
    END CHILD
    CHILD "B_5_5" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_activation_3_3" "naf_activation_inserted_3"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "naf_activation_3_3" "naf_activation"
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
  <GATE_KINETIC> <name>A_4_4</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>35000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.005</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>-0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>A_4_4</prototype> <name>A_inserted_4</name>
  </child>
  <GATE_KINETIC> <name>B_5_5</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>7000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.065</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>0.02</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>B_5_5</prototype> <name>B_inserted_5</name>
  </child>
  <HH_GATE> <name>naf_activation_3_3</name>
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
    <child> <prototype>A_4_4</prototype> <name>A</name>
    </child>
    <child> <prototype>B_5_5</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_activation_3_3</prototype> <name>naf_activation_inserted_3</name>
  </child>
</private_models>
<public_models>
  <child> <prototype>naf_activation_3_3</prototype> <name>naf_activation</name>
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
						    timeout => 5,
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
						    timeout => 5,
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
						    timeout => 5,
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
  GATE_KINETIC "A_6_6"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 35000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Div_E = -0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_6_6" "A_inserted_6"
  END CHILD
  GATE_KINETIC "B_7_7"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 7000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Div_E = 0.02 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_7_7" "B_inserted_7"
  END CHILD
  HH_GATE "naf_activation_5_5"
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
    CHILD "A_6_6" "A"
    END CHILD
    CHILD "B_7_7" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_activation_5_5" "naf_gate_activation_prototype_5_13"
  END CHILD
  CHILD "naf_gate_activation_prototype_5_13" "naf_gate_activation_5_16"
  END CHILD
  CHILD "naf_gate_activation_5_16" "naf_gate_activation_inserted_16"
  END CHILD
  GATE_KINETIC "A_11_11"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 225 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 1 ),
      PARAMETER ( HH_AB_Offset_E = 0.08 ),
      PARAMETER ( HH_AB_Div_E = 0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_11_11" "A_inserted_11"
  END CHILD
  GATE_KINETIC "B_12_12"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 7500 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = -0.003 ),
      PARAMETER ( HH_AB_Div_E = -0.018 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_12_12" "B_inserted_12"
  END CHILD
  HH_GATE "naf_inactivation_10_10"
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
    CHILD "A_11_11" "A"
    END CHILD
    CHILD "B_12_12" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_inactivation_10_10" "naf_gate_inactivation_prototype_10_14"
  END CHILD
  CHILD "naf_gate_inactivation_prototype_10_14" "naf_gate_inactivation_10_17"
  END CHILD
  CHILD "naf_gate_inactivation_10_17" "naf_gate_inactivation_inserted_17"
  END CHILD
  CHANNEL "NaF_prototype_15_15"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 75000 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "naf_gate_activation_inserted_16" "naf_gate_activation"
    END CHILD
    CHILD "naf_gate_inactivation_inserted_17" "naf_gate_inactivation"
    END CHILD
  END CHANNEL
  CHILD "NaF_prototype_15_15" "NaF_prototype_inserted_15"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "NaF_prototype_15_15" "NaF_prototype"
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
  <GATE_KINETIC> <name>A_6_6</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>35000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.005</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>-0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>A_6_6</prototype> <name>A_inserted_6</name>
  </child>
  <GATE_KINETIC> <name>B_7_7</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>7000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.065</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>0.02</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>B_7_7</prototype> <name>B_inserted_7</name>
  </child>
  <HH_GATE> <name>naf_activation_5_5</name>
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
    <child> <prototype>A_6_6</prototype> <name>A</name>
    </child>
    <child> <prototype>B_7_7</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_activation_5_5</prototype> <name>naf_gate_activation_prototype_5_13</name>
  </child>
  <child> <prototype>naf_gate_activation_prototype_5_13</prototype> <name>naf_gate_activation_5_16</name>
  </child>
  <child> <prototype>naf_gate_activation_5_16</prototype> <name>naf_gate_activation_inserted_16</name>
  </child>
  <GATE_KINETIC> <name>A_11_11</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>225</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>1</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.08</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>A_11_11</prototype> <name>A_inserted_11</name>
  </child>
  <GATE_KINETIC> <name>B_12_12</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>7500</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>-0.003</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>-0.018</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>B_12_12</prototype> <name>B_inserted_12</name>
  </child>
  <HH_GATE> <name>naf_inactivation_10_10</name>
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
    <child> <prototype>A_11_11</prototype> <name>A</name>
    </child>
    <child> <prototype>B_12_12</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_inactivation_10_10</prototype> <name>naf_gate_inactivation_prototype_10_14</name>
  </child>
  <child> <prototype>naf_gate_inactivation_prototype_10_14</prototype> <name>naf_gate_inactivation_10_17</name>
  </child>
  <child> <prototype>naf_gate_inactivation_10_17</prototype> <name>naf_gate_inactivation_inserted_17</name>
  </child>
  <CHANNEL> <name>NaF_prototype_15_15</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>G_MAX</name><value>75000</value> </parameter>
      <parameter> <name>Erev</name><value>0.045</value> </parameter>
    </parameters>
    <child> <prototype>naf_gate_activation_inserted_16</prototype> <name>naf_gate_activation</name>
    </child>
    <child> <prototype>naf_gate_inactivation_inserted_17</prototype> <name>naf_gate_inactivation</name>
    </child>
  </CHANNEL>
  <child> <prototype>NaF_prototype_15_15</prototype> <name>NaF_prototype_inserted_15</name>
  </child>
</private_models>
<public_models>
  <child> <prototype>NaF_prototype_15_15</prototype> <name>NaF_prototype</name>
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
						    timeout => 5,
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
						    timeout => 5,
						   },
						  ],
				 description => "parsing of the generated channel xml file",
				},
			       ),
			       (
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
						    timeout => 5,
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
  GATE_KINETIC "A_9_9"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 35000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Div_E = -0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_9_9" "A_inserted_9"
  END CHILD
  GATE_KINETIC "B_10_10"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 7000 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Div_E = 0.02 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_10_10" "B_inserted_10"
  END CHILD
  HH_GATE "naf_activation_8_8"
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
    CHILD "A_9_9" "A"
    END CHILD
    CHILD "B_10_10" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_activation_8_8" "naf_gate_activation_8_16"
  END CHILD
  CHILD "naf_gate_activation_8_16" "naf_gate_activation_8_19"
  END CHILD
  CHILD "naf_gate_activation_8_19" "naf_gate_activation_inserted_19"
  END CHILD
  GATE_KINETIC "A_14_14"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 225 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 1 ),
      PARAMETER ( HH_AB_Offset_E = 0.08 ),
      PARAMETER ( HH_AB_Div_E = 0.01 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_14_14" "A_inserted_14"
  END CHILD
  GATE_KINETIC "B_15_15"
    BINDABLES
      INPUT Vm,
      OUTPUT rate,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( HH_AB_Add_Num = 7500 ),
      PARAMETER ( HH_AB_Mult = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Add_Den = 0 ),
      PARAMETER ( HH_AB_Offset_E = -0.003 ),
      PARAMETER ( HH_AB_Div_E = -0.018 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_15_15" "B_inserted_15"
  END CHILD
  HH_GATE "naf_inactivation_13_13"
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
    CHILD "A_14_14" "A"
    END CHILD
    CHILD "B_15_15" "B"
    END CHILD
  END HH_GATE
  CHILD "naf_inactivation_13_13" "naf_gate_inactivation_13_17"
  END CHILD
  CHILD "naf_gate_inactivation_13_17" "naf_gate_inactivation_13_20"
  END CHILD
  CHILD "naf_gate_inactivation_13_20" "naf_gate_inactivation_inserted_20"
  END CHILD
  CHANNEL "NaF_prototype_18_18"
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
    CHILD "naf_gate_activation_inserted_19" "naf_gate_activation"
    END CHILD
    CHILD "naf_gate_inactivation_inserted_20" "naf_gate_inactivation"
    END CHILD
  END CHANNEL
  CHILD "NaF_prototype_18_18" "NaF_18_22"
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
  END CHILD
  CHILD "NaF_18_22" "NaF_inserted_22"
  END CHILD
  SEGMENT "soma_prototype_21_21"
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
    CHILD "NaF_inserted_22" "NaF"
    END CHILD
  END SEGMENT
  CHILD "soma_prototype_21_21" "soma_21_25"
    PARAMETERS
      PARAMETER ( rel_X = 0 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_Z = 0 ),
      PARAMETER ( DIA = 2.98e-05 ),
    END PARAMETERS
  END CHILD
  CHILD "soma_21_25" "soma_inserted_25"
  END CHILD
  SEGMENT_GROUP "segments_24_24"
    CHILD "soma_inserted_25" "soma"
    END CHILD
  END SEGMENT_GROUP
  CHILD "segments_24_24" "segments_inserted_24"
  END CHILD
  CELL "singlea_naf_23_23"
    CHILD "segments_24_24" "segments"
    END CHILD
  END CELL
  CHILD "singlea_naf_23_23" "singlea_naf_inserted_23"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "singlea_naf_23_23" "singlea_naf"
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
  <GATE_KINETIC> <name>A_9_9</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>35000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.005</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>-0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>A_9_9</prototype> <name>A_inserted_9</name>
  </child>
  <GATE_KINETIC> <name>B_10_10</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>7000</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.065</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>0.02</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>B_10_10</prototype> <name>B_inserted_10</name>
  </child>
  <HH_GATE> <name>naf_activation_8_8</name>
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
    <child> <prototype>A_9_9</prototype> <name>A</name>
    </child>
    <child> <prototype>B_10_10</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_activation_8_8</prototype> <name>naf_gate_activation_8_16</name>
  </child>
  <child> <prototype>naf_gate_activation_8_16</prototype> <name>naf_gate_activation_8_19</name>
  </child>
  <child> <prototype>naf_gate_activation_8_19</prototype> <name>naf_gate_activation_inserted_19</name>
  </child>
  <GATE_KINETIC> <name>A_14_14</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>225</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>1</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>0.08</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>0.01</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>A_14_14</prototype> <name>A_inserted_14</name>
  </child>
  <GATE_KINETIC> <name>B_15_15</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>rate</name> </output>
    </bindables>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>HH_AB_Add_Num</name><value>7500</value> </parameter>
      <parameter> <name>HH_AB_Mult</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Factor_Flag</name><value>-1</value> </parameter>
      <parameter> <name>HH_AB_Add_Den</name><value>0</value> </parameter>
      <parameter> <name>HH_AB_Offset_E</name><value>-0.003</value> </parameter>
      <parameter> <name>HH_AB_Div_E</name><value>-0.018</value> </parameter>
    </parameters>
  </GATE_KINETIC>
  <child> <prototype>B_15_15</prototype> <name>B_inserted_15</name>
  </child>
  <HH_GATE> <name>naf_inactivation_13_13</name>
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
    <child> <prototype>A_14_14</prototype> <name>A</name>
    </child>
    <child> <prototype>B_15_15</prototype> <name>B</name>
    </child>
  </HH_GATE>
  <child> <prototype>naf_inactivation_13_13</prototype> <name>naf_gate_inactivation_13_17</name>
  </child>
  <child> <prototype>naf_gate_inactivation_13_17</prototype> <name>naf_gate_inactivation_13_20</name>
  </child>
  <child> <prototype>naf_gate_inactivation_13_20</prototype> <name>naf_gate_inactivation_inserted_20</name>
  </child>
  <CHANNEL> <name>NaF_prototype_18_18</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>CHANNEL_TYPE</name><string>ChannelActInact</string> </parameter>
      <parameter> <name>G_MAX</name><value>75000</value> </parameter>
      <parameter> <name>Erev</name><value>0.045</value> </parameter>
    </parameters>
    <child> <prototype>naf_gate_activation_inserted_19</prototype> <name>naf_gate_activation</name>
    </child>
    <child> <prototype>naf_gate_inactivation_inserted_20</prototype> <name>naf_gate_inactivation</name>
    </child>
  </CHANNEL>
  <child> <prototype>NaF_prototype_18_18</prototype> <name>NaF_18_22</name>
    <bindings>
      <input> <name>..->Vm</name> </input>
    </bindings>
  </child>
  <child> <prototype>NaF_18_22</prototype> <name>NaF_inserted_22</name>
  </child>
  <SEGMENT> <name>soma_prototype_21_21</name>
    <bindables>
      <output> <name>Vm</name> </output>
    </bindables>
    <bindings>
      <input> <name>NaF->I</name> </input>
    </bindings>
    <parameters>
      <parameter> <name>Vm_init</name><value>-0.028</value> </parameter>
      <parameter> <name>RM</name><value>1</value> </parameter>
      <parameter> <name>RA</name><value>2.5</value> </parameter>
      <parameter> <name>CM</name><value>0.0164</value> </parameter>
      <parameter> <name>ELEAK</name><value>-0.08</value> </parameter>
    </parameters>
    <child> <prototype>NaF_inserted_22</prototype> <name>NaF</name>
    </child>
  </SEGMENT>
  <child> <prototype>soma_prototype_21_21</prototype> <name>soma_21_25</name>
    <parameters>
      <parameter> <name>rel_X</name><value>0</value> </parameter>
      <parameter> <name>rel_Y</name><value>0</value> </parameter>
      <parameter> <name>rel_Z</name><value>0</value> </parameter>
      <parameter> <name>DIA</name><value>2.98e-05</value> </parameter>
    </parameters>
  </child>
  <child> <prototype>soma_21_25</prototype> <name>soma_inserted_25</name>
  </child>
  <SEGMENT_GROUP> <name>segments_24_24</name>
    <child> <prototype>soma_inserted_25</prototype> <name>soma</name>
    </child>
  </SEGMENT_GROUP>
  <child> <prototype>segments_24_24</prototype> <name>segments_inserted_24</name>
  </child>
  <CELL> <name>singlea_naf_23_23</name>
    <child> <prototype>segments_24_24</prototype> <name>segments</name>
    </child>
  </CELL>
  <child> <prototype>singlea_naf_23_23</prototype> <name>singlea_naf_inserted_23</name>
  </child>
</private_models>
<public_models>
  <child> <prototype>singlea_naf_23_23</prototype> <name>singlea_naf</name>
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
						    timeout => 5,
						   },
						  ],
				 description => "parsing of the generated cell NDF file",
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
						    timeout => 5,
						   },
						  ],
				 description => "parsing of the generated cell xml file",
				},
			       ),
			       (
				map
				{
				    my ($key, $ndf) = %$_;

				    (
				     {
				      arguments => [
						    '-q',
						    '-v',
						    '1',
						    $ndf,
						   ],
				      command => './neurospacesparse',
				      command_tests => [
							{
							 description => "Is neurospaces startup successful ?",
							 read => [ '-re', "./neurospacesparse: No errors for .+?/$ndf.", ],
							 timeout => 5,
							},
							{
							 description => "Can we export the model as NDF ?",
							 wait => 1,
							 write => "export library ndf /tmp/1.ndf /**",
							},
							{
							 description => "Can we export the model as xml ?",
							 wait => 1,
							 write => "export library xml /tmp/1.xml /**",
							},
						       ],
				      description => "export of $ndf before reading it back",
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
							 read => "./neurospacesparse: No errors for /tmp/1.ndf.",
							 timeout => 5,
							},
						       ],
				      description => "reading of $ndf after exporting it",
				      disabled => ($ndf eq "networks/input.ndf" ? "export of $ndf does not work correctly, connection vectors and connection symbol vectors are messed up." : 0),
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
							 read => "./neurospacesparse: No errors for /tmp/1.xml.",
							 timeout => 5,
							},
						       ],
				      description => "reading of $ndf after exporting it",
				      disabled => ($ndf eq "networks/input.ndf" ? "export of $ndf does not work correctly, connection vectors and connection symbol vectors are messed up." : 0),
				     },
				    );
				}
				(
				 { gate => "gates/naf_activation.ndf", },
				 { channel => "tests/channels/naf.ndf", },
				 { cell => "tests/cells/singlea_naf.ndf", },
				),
			       ),
			      ],
       description => "exporting models in a variety of export formats",
       name => 'export_library.t',
      };


return $test;


