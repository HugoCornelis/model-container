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
					       'channels/nmda.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/channels/nmda.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model to an NDF file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export no ndf /tmp/1.ndf /**",
						   },
						   {
						    description => "Does the exported NDF file contain the correct model (1) ?",
						    read => {
							     application_output_file => '/tmp/1.ndf',
							     expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "mapper" "mappers/spikereceiver.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "mapper::/Synapse" "Synapse"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL "NMDA_fixed_conductance"
    BINDABLES
      INPUT Vm,
      OUTPUT exp2->G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( Erev = 0 ),
      PARAMETER ( G_MAX = 
        FIXED
          (
              PARAMETER ( value = 6.87066e-10 ),
              PARAMETER ( scale = 1 ),
          ), ),
    END PARAMETERS
    CHILD "Synapse" "synapse"
    END CHILD
    EQUATION_EXPONENTIAL "exp2"
      BINDABLES
        INPUT activation,
        OUTPUT G,
      END BINDABLES
      BINDINGS
        INPUT ../synapse->activation,
      END BINDINGS
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
  CHANNEL "NMDA"
    BINDABLES
      INPUT Vm,
      OUTPUT exp2->G,
      OUTPUT I,
    END BINDABLES
    CHILD "Synapse" "synapse"
    END CHILD
    EQUATION_EXPONENTIAL "exp2"
      BINDABLES
        INPUT activation,
        OUTPUT G,
      END BINDABLES
      BINDINGS
        INPUT ../synapse->activation,
      END BINDINGS
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
END PUBLIC_MODELS
',
							    },
						   },
						   {
						    description => "Can we export the model to an XML file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export no xml /tmp/1.xml /**",
						   },
						   {
						    comment => 'xml to html conversion fails when converting this test to html',
						    description => "Does the exported XML file contain the correct model ?",
						    read => {
							     application_output_file => '/tmp/1.xml',
							     expected_output => '<neurospaces type="ndf"/>

<import>
    <file> <namespace>mapper</namespace> <filename>mappers/spikereceiver.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>mapper::</namespace><prototype>/Synapse</prototype> <name>Synapse</name>
  </alias>
</private_models>

<public_models>
  <CHANNEL> <name>NMDA_fixed_conductance</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>exp2->G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>Erev</name><value>0</value> </parameter>
      <parameter> <name>G_MAX</name>
        <function> <name>FIXED</name>
                        <parameter> <name>value</name><value>6.87066e-10</value> </parameter>
              <parameter> <name>scale</name><value>1</value> </parameter>
          </function> </parameter>
    </parameters>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <bindables>
        <input> <name>activation</name> </input>
        <output> <name>G</name> </output>
      </bindables>
      <bindings>
        <input> <name>../synapse->activation</name> </input>
      </bindings>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
  <CHANNEL> <name>NMDA</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>exp2->G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <bindables>
        <input> <name>activation</name> </input>
        <output> <name>G</name> </output>
      </bindables>
      <bindings>
        <input> <name>../synapse->activation</name> </input>
      </bindings>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
</public_models>
',
							    },
						   },
						  ],
				 description => "export of a simple model",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'channels/hodgkin-huxley.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/channels/hodgkin-huxley.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model to an NDF file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export no ndf /tmp/1.ndf /**",
						   },
						   {
						    description => "Does the exported NDF file contain the correct model (2) ?",
						    read => {
							     application_output_file => '/tmp/1.ndf',
							     expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "k" "channels/hodgkin-huxley/potassium.ndf"
    FILE "na" "channels/hodgkin-huxley/sodium.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "k::/k" "k"
  END ALIAS
  ALIAS "na::/na" "na"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  ALIAS "k" "k"
  END ALIAS
  ALIAS "na" "na"
  END ALIAS
END PUBLIC_MODELS
',
							    },
						   },
						   {
						    description => "Can we export the model to an XML file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export no xml /tmp/1.xml /**",
						   },
						   {
						    comment => 'xml to html conversion fails when converting this test to html',
						    description => "Does the exported XML file contain the correct model ?",
						    read => {
							     application_output_file => '/tmp/1.xml',
							     expected_output => '<neurospaces type="ndf"/>

<import>
    <file> <namespace>k</namespace> <filename>channels/hodgkin-huxley/potassium.ndf</filename> </file>
    <file> <namespace>na</namespace> <filename>channels/hodgkin-huxley/sodium.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>k::</namespace><prototype>/k</prototype> <name>k</name>
  </alias>
  <alias> <namespace>na::</namespace><prototype>/na</prototype> <name>na</name>
  </alias>
</private_models>

<public_models>
  <alias> <prototype>k</prototype> <name>k</name>
  </alias>
  <alias> <prototype>na</prototype> <name>na</name>
  </alias>
</public_models>
',
							    },
						   },
						  ],
				 description => "export of a HH alike channel model in different ways",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'channels/nmda.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/channels/nmda.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model to an NDF file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export no ndf /tmp/1.ndf /**",
						   },
						   {
						    comment => 'exported text only differs in bindings of the original',
						    description => "Does the exported NDF file contain the correct model (3) ?",
						    read => {
							     application_output_file => '/tmp/1.ndf',
							     expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "mapper" "mappers/spikereceiver.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "mapper::/Synapse" "Synapse"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL "NMDA_fixed_conductance"
    BINDABLES
      INPUT Vm,
      OUTPUT exp2->G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( Erev = 0 ),
      PARAMETER ( G_MAX = 
        FIXED
          (
              PARAMETER ( value = 6.87066e-10 ),
              PARAMETER ( scale = 1 ),
          ), ),
    END PARAMETERS
    CHILD "Synapse" "synapse"
    END CHILD
    EQUATION_EXPONENTIAL "exp2"
      BINDABLES
        INPUT activation,
        OUTPUT G,
      END BINDABLES
      BINDINGS
        INPUT ../synapse->activation,
      END BINDINGS
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
  CHANNEL "NMDA"
    BINDABLES
      INPUT Vm,
      OUTPUT exp2->G,
      OUTPUT I,
    END BINDABLES
    CHILD "Synapse" "synapse"
    END CHILD
    EQUATION_EXPONENTIAL "exp2"
      BINDABLES
        INPUT activation,
        OUTPUT G,
      END BINDABLES
      BINDINGS
        INPUT ../synapse->activation,
      END BINDINGS
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
END PUBLIC_MODELS
',
							    },
						   },
						   {
						    description => "Can we export the model to an XML file ?",
						    read => 'neurospaces',
						    wait => 1,
						    write => "export no xml /tmp/1.xml /**",
						   },
						   {
						    comment => 'xml to html conversion fails when converting this test to html',
						    description => "Does the exported XML file contain the correct model ?",
						    read => {
							     application_output_file => '/tmp/1.xml',
							     expected_output => '<neurospaces type="ndf"/>

<import>
    <file> <namespace>mapper</namespace> <filename>mappers/spikereceiver.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>mapper::</namespace><prototype>/Synapse</prototype> <name>Synapse</name>
  </alias>
</private_models>

<public_models>
  <CHANNEL> <name>NMDA_fixed_conductance</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>exp2->G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>Erev</name><value>0</value> </parameter>
      <parameter> <name>G_MAX</name>
        <function> <name>FIXED</name>
                        <parameter> <name>value</name><value>6.87066e-10</value> </parameter>
              <parameter> <name>scale</name><value>1</value> </parameter>
          </function> </parameter>
    </parameters>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <bindables>
        <input> <name>activation</name> </input>
        <output> <name>G</name> </output>
      </bindables>
      <bindings>
        <input> <name>../synapse->activation</name> </input>
      </bindings>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
  <CHANNEL> <name>NMDA</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>exp2->G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <bindables>
        <input> <name>activation</name> </input>
        <output> <name>G</name> </output>
      </bindables>
      <bindings>
        <input> <name>../synapse->activation</name> </input>
      </bindings>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
</public_models>
',
							    },
						   },
						   {
						    description => 'Can we import a gaba channel ?',
						    write => 'importfile channels/gaba.ndf gaba',
						   },
						   {
						    description => 'Can we import a basket type synaptic channel ?',
						    write => 'importfile channels/purkinje_basket.ndf basket',
						   },
						   {
						    description => 'Are the imported namespaces present in the ndf export ?',
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "mapper" "mappers/spikereceiver.ndf"
    FILE "gaba" "channels/gaba.ndf"
    FILE "basket" "channels/purkinje_basket.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "mapper::/Synapse" "Synapse"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL "NMDA_fixed_conductance"
    BINDABLES
      INPUT Vm,
      OUTPUT exp2->G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( Erev = 0 ),
      PARAMETER ( G_MAX = 
        FIXED
          (
              PARAMETER ( value = 6.87066e-10 ),
              PARAMETER ( scale = 1 ),
          ), ),
    END PARAMETERS
    CHILD "Synapse" "synapse"
    END CHILD
    EQUATION_EXPONENTIAL "exp2"
      BINDABLES
        INPUT activation,
        OUTPUT G,
      END BINDABLES
      BINDINGS
        INPUT ../synapse->activation,
      END BINDINGS
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
  CHANNEL "NMDA"
    BINDABLES
      INPUT Vm,
      OUTPUT exp2->G,
      OUTPUT I,
    END BINDABLES
    CHILD "Synapse" "synapse"
    END CHILD
    EQUATION_EXPONENTIAL "exp2"
      BINDABLES
        INPUT activation,
        OUTPUT G,
      END BINDABLES
      BINDINGS
        INPUT ../synapse->activation,
      END BINDINGS
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
END PUBLIC_MODELS
',
						    write => 'export no ndf STDOUT /**',
						   },
						   {
						    description => 'Are the imported namespaces present in the xml export ?',
						    read => '<neurospaces type="ndf"/>

<import>
    <file> <namespace>mapper</namespace> <filename>mappers/spikereceiver.ndf</filename> </file>
    <file> <namespace>gaba</namespace> <filename>channels/gaba.ndf</filename> </file>
    <file> <namespace>basket</namespace> <filename>channels/purkinje_basket.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>mapper::</namespace><prototype>/Synapse</prototype> <name>Synapse</name>
  </alias>
</private_models>

<public_models>
  <CHANNEL> <name>NMDA_fixed_conductance</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>exp2->G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>Erev</name><value>0</value> </parameter>
      <parameter> <name>G_MAX</name>
        <function> <name>FIXED</name>
                        <parameter> <name>value</name><value>6.87066e-10</value> </parameter>
              <parameter> <name>scale</name><value>1</value> </parameter>
          </function> </parameter>
    </parameters>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <bindables>
        <input> <name>activation</name> </input>
        <output> <name>G</name> </output>
      </bindables>
      <bindings>
        <input> <name>../synapse->activation</name> </input>
      </bindings>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
  <CHANNEL> <name>NMDA</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>exp2->G</name> </output>
      <output> <name>I</name> </output>
    </bindables>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <bindables>
        <input> <name>activation</name> </input>
        <output> <name>G</name> </output>
      </bindables>
      <bindings>
        <input> <name>../synapse->activation</name> </input>
      </bindings>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
</public_models>
',
						    write => 'export no xml STDOUT /**',
						   },
						  ],
				 description => "export of a simple model and manually importing files",
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
						    timeout => 15,
						   },
						   {
						    comment => 'exported text differs with the original in the bindings of the channel inside the segment',
						    description => "Can we export the model as NDF ?",
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
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as XML ?",
						    read => '<neurospaces type="ndf"/>

<import>
    <file> <namespace>soma</namespace> <filename>tests/segments/soma.ndf</filename> </file>
    <file> <namespace>gate1</namespace> <filename>gates/naf_activation.ndf</filename> </file>
    <file> <namespace>gate2</namespace> <filename>gates/naf_inactivation.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>gate1::</namespace><prototype>/naf_activation</prototype> <name>naf_gate_activation</name>
  </alias>
  <alias> <namespace>gate2::</namespace><prototype>/naf_inactivation</prototype> <name>naf_gate_inactivation</name>
  </alias>
  <CHANNEL> <name>NaF</name>
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
    <child> <prototype>naf_gate_activation</prototype> <name>naf_gate_activation</name>
    </child>
    <child> <prototype>naf_gate_inactivation</prototype> <name>naf_gate_inactivation</name>
    </child>
  </CHANNEL>
  <SEGMENT> <name>soma2</name>
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
    <child> <prototype>NaF</prototype> <name>NaF</name>
      <bindings>
        <input> <name>..->Vm</name> </input>
      </bindings>
    </child>
  </SEGMENT>
</private_models>

<public_models>
  <CELL> <name>singlea_naf</name>
    <SEGMENT_GROUP> <name>segments</name>
      <child> <prototype>soma2</prototype> <name>soma</name>
        <parameters>
          <parameter> <name>rel_X</name><value>0</value> </parameter>
          <parameter> <name>rel_Y</name><value>0</value> </parameter>
          <parameter> <name>rel_Z</name><value>0</value> </parameter>
          <parameter> <name>DIA</name><value>2.98e-05</value> </parameter>
        </parameters>
      </child>
    </SEGMENT_GROUP>
  </CELL>
</public_models>
',
						    write => "export no xml STDOUT /**",
						   },
						  ],
				 description => "export of a model with an active channel",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/cells/hh1.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/hh1.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "hh" "segments/hodgkin_huxley.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "hh::/hh_segment" "hh"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "hh1"
    SEGMENT_GROUP "segments"
      CHILD "hh" "soma"
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "hh" "segments/hodgkin_huxley.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "hh::/hh_segment" "hh"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "hh1"
    SEGMENT_GROUP "segments"
      CHILD "hh" "soma"
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of a single HH compartment model",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/cells/singlep.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/singlep.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "soma" "tests/segments/soma.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "soma::/soma" "soma"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "singlep"
    SEGMENT_GROUP "segments"
      CHILD "soma" "soma"
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
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "soma" "tests/segments/soma.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "soma::/soma" "soma"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "singlep"
    SEGMENT_GROUP "segments"
      CHILD "soma" "soma"
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
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of a single passive compartment model",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/cells/addressing_aggregator1.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/addressing_aggregator1.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "cat" "channels/purkinje/cat.ndf"
    FILE "kdr" "channels/purkinje/kdr.ndf"
    FILE "naf" "channels/purkinje/naf.ndf"
    FILE "nap" "channels/purkinje/nap.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "cat::/cat" "cat"
  END ALIAS
  ALIAS "kdr::/kdr" "kdr"
  END ALIAS
  ALIAS "naf::/naf" "naf"
  END ALIAS
  ALIAS "nap::/nap" "nap"
  END ALIAS
  SEGMENT "something"
    BINDABLES
      OUTPUT Vm,
    END BINDABLES
    BINDINGS
      INPUT cat->I,
      INPUT naf->I,
      INPUT nap->I,
      INPUT kdr->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Vm_init = -0.068 ),
      PARAMETER ( RM = 1 ),
      PARAMETER ( RA = 2.5 ),
      PARAMETER ( CM = 0.0164 ),
      PARAMETER ( ELEAK = -0.08 ),
    END PARAMETERS
    CHILD "cat" "cat"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( Erev = 0.137526 ),
      END PARAMETERS
    END CHILD
    CHILD "kdr" "kdr"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
    CHILD "nap" "nap"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
    CHILD "naf" "naf"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "addressing_aggregator1"
    SEGMENT_GROUP "segments"
      CHILD "something" "c1"
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
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "cat" "channels/purkinje/cat.ndf"
    FILE "kdr" "channels/purkinje/kdr.ndf"
    FILE "naf" "channels/purkinje/naf.ndf"
    FILE "nap" "channels/purkinje/nap.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "cat::/cat" "cat"
  END ALIAS
  ALIAS "kdr::/kdr" "kdr"
  END ALIAS
  ALIAS "naf::/naf" "naf"
  END ALIAS
  ALIAS "nap::/nap" "nap"
  END ALIAS
  SEGMENT "something"
    BINDABLES
      OUTPUT Vm,
    END BINDABLES
    BINDINGS
      INPUT cat->I,
      INPUT naf->I,
      INPUT nap->I,
      INPUT kdr->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Vm_init = -0.068 ),
      PARAMETER ( RM = 1 ),
      PARAMETER ( RA = 2.5 ),
      PARAMETER ( CM = 0.0164 ),
      PARAMETER ( ELEAK = -0.08 ),
    END PARAMETERS
    CHILD "cat" "cat"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( Erev = 0.137526 ),
      END PARAMETERS
    END CHILD
    CHILD "kdr" "kdr"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
    CHILD "nap" "nap"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
    CHILD "naf" "naf"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "addressing_aggregator1"
    SEGMENT_GROUP "segments"
      CHILD "something" "c1"
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
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of a model with many channels in one compartment",
				},
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
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model as NDF ?",
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
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 3.40282e+38 ),
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
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 3.40282e+38 ),
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
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
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
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 3.40282e+38 ),
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
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 3.40282e+38 ),
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
						    write => "export names ndf STDOUT /**",
						   },
						   {
						    description => "Can we reduce the model?",
						    write => 'reduce',
						   },
						   {
						    description => "Can we export the model as NDF after reducing ?",
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
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support after reducing ?",
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
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of a model with many parameters that can be reduced",
				},
			       ),

			       # pools and pool bindings related

			       (
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/cells/pool1.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/pool1.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "gate1" "gates/cat_activation.ndf"
    FILE "gate2" "gates/cat_inactivation.ndf"
    FILE "ca_pool" "pools/purkinje_ca.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "gate1::/cat_activation" "cat_gate_activation"
  END ALIAS
  ALIAS "gate2::/cat_inactivation" "cat_gate_inactivation"
  END ALIAS
  ALIAS "ca_pool::/Ca_concen" "ca_pool"
  END ALIAS
  CHANNEL "cat"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
    END PARAMETERS
    CHILD "cat_gate_activation" "cat_gate_activation"
    END CHILD
    CHILD "cat_gate_inactivation" "cat_gate_inactivation"
    END CHILD
  END CHANNEL
  SEGMENT "soma2"
    BINDABLES
      OUTPUT Vm,
    END BINDABLES
    BINDINGS
      INPUT cat->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Vm_init = -0.028 ),
      PARAMETER ( RM = 1 ),
      PARAMETER ( RA = 2.5 ),
      PARAMETER ( CM = 0.0164 ),
      PARAMETER ( ELEAK = -0.08 ),
    END PARAMETERS
    CHILD "cat" "cat"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( G_MAX = 5 ),
        PARAMETER ( Erev = 0.137526 ),
      END PARAMETERS
    END CHILD
    CHILD "ca_pool" "ca_pool"
      BINDINGS
        INPUT ../cat->I,
      END BINDINGS
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "pool1"
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
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "gate1" "gates/cat_activation.ndf"
    FILE "gate2" "gates/cat_inactivation.ndf"
    FILE "ca_pool" "pools/purkinje_ca.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "gate1::/cat_activation" "cat_gate_activation"
  END ALIAS
  ALIAS "gate2::/cat_inactivation" "cat_gate_inactivation"
  END ALIAS
  ALIAS "ca_pool::/Ca_concen" "ca_pool"
  END ALIAS
  CHANNEL "cat"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
    END PARAMETERS
    CHILD "cat_gate_activation" "cat_gate_activation"
    END CHILD
    CHILD "cat_gate_inactivation" "cat_gate_inactivation"
    END CHILD
  END CHANNEL
  SEGMENT "soma2"
    BINDABLES
      OUTPUT Vm,
    END BINDABLES
    BINDINGS
      INPUT cat->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Vm_init = -0.028 ),
      PARAMETER ( RM = 1 ),
      PARAMETER ( RA = 2.5 ),
      PARAMETER ( CM = 0.0164 ),
      PARAMETER ( ELEAK = -0.08 ),
    END PARAMETERS
    CHILD "cat" "cat"
      BINDINGS
        INPUT ..->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( G_MAX = 5 ),
        PARAMETER ( Erev = 0.137526 ),
      END PARAMETERS
    END CHILD
    CHILD "ca_pool" "ca_pool"
      BINDINGS
        INPUT ../cat->I,
      END BINDINGS
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "pool1"
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
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of an pool model and a channel",
				},
			       ),

			       # morphology related

			       (
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/cells/tensizesp.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/tensizesp.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "soma" "tests/segments/soma.ndf"
    FILE "maind" "tests/segments/maind.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "soma::/soma" "soma"
  END ALIAS
  ALIAS "maind::/maind" "maind"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "tensizesp"
    SEGMENT_GROUP "segments"
      CHILD "soma" "soma"
        PARAMETERS
          PARAMETER ( INJECT = 1e-08 ),
          PARAMETER ( rel_X = 0 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 2.98e-05 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[0]"
        PARAMETERS
          PARAMETER ( Z = 9.447e-06 ),
          PARAMETER ( Y = 9.447e-06 ),
          PARAMETER ( X = 5.557e-06 ),
          PARAMETER ( PARENT = ../soma ),
          PARAMETER ( rel_X = 5.557e-06 ),
          PARAMETER ( rel_Y = 9.447e-06 ),
          PARAMETER ( rel_Z = 9.447e-06 ),
          PARAMETER ( DIA = 7.72e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[1]"
        PARAMETERS
          PARAMETER ( Z = 3.1356e-05 ),
          PARAMETER ( Y = 1.0571e-05 ),
          PARAMETER ( X = 1.3983e-05 ),
          PARAMETER ( PARENT = ../main[0] ),
          PARAMETER ( rel_X = 8.426e-06 ),
          PARAMETER ( rel_Y = 1.124e-06 ),
          PARAMETER ( rel_Z = 2.1909e-05 ),
          PARAMETER ( DIA = 8.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[2]"
        PARAMETERS
          PARAMETER ( Z = 3.8022e-05 ),
          PARAMETER ( Y = 1.1682e-05 ),
          PARAMETER ( X = 1.5649e-05 ),
          PARAMETER ( PARENT = ../main[1] ),
          PARAMETER ( rel_X = 1.666e-06 ),
          PARAMETER ( rel_Y = 1.111e-06 ),
          PARAMETER ( rel_Z = 6.666e-06 ),
          PARAMETER ( DIA = 8.5e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[3]"
        PARAMETERS
          PARAMETER ( Z = 3.9689e-05 ),
          PARAMETER ( Y = 1.3905e-05 ),
          PARAMETER ( X = 1.287e-05 ),
          PARAMETER ( PARENT = ../main[2] ),
          PARAMETER ( rel_X = -2.779e-06 ),
          PARAMETER ( rel_Y = 2.223e-06 ),
          PARAMETER ( rel_Z = 1.667e-06 ),
          PARAMETER ( DIA = 9.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[4]"
        PARAMETERS
          PARAMETER ( Z = 4.5242e-05 ),
          PARAMETER ( Y = 2.0014e-05 ),
          PARAMETER ( X = 1.1759e-05 ),
          PARAMETER ( PARENT = ../main[3] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = 6.109e-06 ),
          PARAMETER ( rel_Z = 5.553e-06 ),
          PARAMETER ( DIA = 8.89e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[5]"
        PARAMETERS
          PARAMETER ( Z = 5.024e-05 ),
          PARAMETER ( Y = 1.9459e-05 ),
          PARAMETER ( X = 1.0648e-05 ),
          PARAMETER ( PARENT = ../main[4] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 4.998e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[6]"
        PARAMETERS
          PARAMETER ( Z = 5.3738e-05 ),
          PARAMETER ( Y = 2.0042e-05 ),
          PARAMETER ( X = 8.899e-06 ),
          PARAMETER ( PARENT = ../main[5] ),
          PARAMETER ( rel_X = -1.749e-06 ),
          PARAMETER ( rel_Y = 5.83e-07 ),
          PARAMETER ( rel_Z = 3.498e-06 ),
          PARAMETER ( DIA = 8.61e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[7]"
        PARAMETERS
          PARAMETER ( Z = 6.0407e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = 5.009e-06 ),
          PARAMETER ( PARENT = ../main[6] ),
          PARAMETER ( rel_X = -3.89e-06 ),
          PARAMETER ( rel_Y = 3.334e-06 ),
          PARAMETER ( rel_Z = 6.669e-06 ),
          PARAMETER ( DIA = 7.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[8]"
        PARAMETERS
          PARAMETER ( Z = 6.9848e-05 ),
          PARAMETER ( Y = 2.2265e-05 ),
          PARAMETER ( X = -1.656e-06 ),
          PARAMETER ( PARENT = ../main[7] ),
          PARAMETER ( rel_X = -6.665e-06 ),
          PARAMETER ( rel_Y = -1.111e-06 ),
          PARAMETER ( rel_Z = 9.441e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "soma" "tests/segments/soma.ndf"
    FILE "maind" "tests/segments/maind.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "soma::/soma" "soma"
  END ALIAS
  ALIAS "maind::/maind" "maind"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "tensizesp"
    SEGMENT_GROUP "segments"
      CHILD "soma" "soma"
        PARAMETERS
          PARAMETER ( INJECT = 1e-08 ),
          PARAMETER ( rel_X = 0 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 2.98e-05 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[0]"
        PARAMETERS
          PARAMETER ( Z = 9.447e-06 ),
          PARAMETER ( Y = 9.447e-06 ),
          PARAMETER ( X = 5.557e-06 ),
          PARAMETER ( PARENT = ../soma ),
          PARAMETER ( rel_X = 5.557e-06 ),
          PARAMETER ( rel_Y = 9.447e-06 ),
          PARAMETER ( rel_Z = 9.447e-06 ),
          PARAMETER ( DIA = 7.72e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[1]"
        PARAMETERS
          PARAMETER ( Z = 3.1356e-05 ),
          PARAMETER ( Y = 1.0571e-05 ),
          PARAMETER ( X = 1.3983e-05 ),
          PARAMETER ( PARENT = ../main[0] ),
          PARAMETER ( rel_X = 8.426e-06 ),
          PARAMETER ( rel_Y = 1.124e-06 ),
          PARAMETER ( rel_Z = 2.1909e-05 ),
          PARAMETER ( DIA = 8.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[2]"
        PARAMETERS
          PARAMETER ( Z = 3.8022e-05 ),
          PARAMETER ( Y = 1.1682e-05 ),
          PARAMETER ( X = 1.5649e-05 ),
          PARAMETER ( PARENT = ../main[1] ),
          PARAMETER ( rel_X = 1.666e-06 ),
          PARAMETER ( rel_Y = 1.111e-06 ),
          PARAMETER ( rel_Z = 6.666e-06 ),
          PARAMETER ( DIA = 8.5e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[3]"
        PARAMETERS
          PARAMETER ( Z = 3.9689e-05 ),
          PARAMETER ( Y = 1.3905e-05 ),
          PARAMETER ( X = 1.287e-05 ),
          PARAMETER ( PARENT = ../main[2] ),
          PARAMETER ( rel_X = -2.779e-06 ),
          PARAMETER ( rel_Y = 2.223e-06 ),
          PARAMETER ( rel_Z = 1.667e-06 ),
          PARAMETER ( DIA = 9.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[4]"
        PARAMETERS
          PARAMETER ( Z = 4.5242e-05 ),
          PARAMETER ( Y = 2.0014e-05 ),
          PARAMETER ( X = 1.1759e-05 ),
          PARAMETER ( PARENT = ../main[3] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = 6.109e-06 ),
          PARAMETER ( rel_Z = 5.553e-06 ),
          PARAMETER ( DIA = 8.89e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[5]"
        PARAMETERS
          PARAMETER ( Z = 5.024e-05 ),
          PARAMETER ( Y = 1.9459e-05 ),
          PARAMETER ( X = 1.0648e-05 ),
          PARAMETER ( PARENT = ../main[4] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 4.998e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[6]"
        PARAMETERS
          PARAMETER ( Z = 5.3738e-05 ),
          PARAMETER ( Y = 2.0042e-05 ),
          PARAMETER ( X = 8.899e-06 ),
          PARAMETER ( PARENT = ../main[5] ),
          PARAMETER ( rel_X = -1.749e-06 ),
          PARAMETER ( rel_Y = 5.83e-07 ),
          PARAMETER ( rel_Z = 3.498e-06 ),
          PARAMETER ( DIA = 8.61e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[7]"
        PARAMETERS
          PARAMETER ( Z = 6.0407e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = 5.009e-06 ),
          PARAMETER ( PARENT = ../main[6] ),
          PARAMETER ( rel_X = -3.89e-06 ),
          PARAMETER ( rel_Y = 3.334e-06 ),
          PARAMETER ( rel_Z = 6.669e-06 ),
          PARAMETER ( DIA = 7.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[8]"
        PARAMETERS
          PARAMETER ( Z = 6.9848e-05 ),
          PARAMETER ( Y = 2.2265e-05 ),
          PARAMETER ( X = -1.656e-06 ),
          PARAMETER ( PARENT = ../main[7] ),
          PARAMETER ( rel_X = -6.665e-06 ),
          PARAMETER ( rel_Y = -1.111e-06 ),
          PARAMETER ( rel_Z = 9.441e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of a model with ten passive compartments",
				},
				{
				 arguments => [
					       '-q',
					       '-v',
					       '1',
					       'tests/cells/purk_test.ndf',
					      ],
				 command => './neurospacesparse',
				 command_tests => [
						   {
						    description => "Is neurospaces startup successful ?",
						    read => [ '-re', './neurospacesparse: No errors for .+?/tests/cells/purk_test.ndf.', ],
						    timeout => 15,
						   },
						   {
						    description => 'Did the algorithm add spines?',
						    read => '
name: SpinesInstance SpinesNormal_13_1
report:
    number_of_added_spines: 8
    number_of_virtual_spines: 503.150268
    number_of_spiny_segments: 8
    number_of_failures_adding_spines: 0
    SpinesInstance_prototype: Purkinje_spine
    SpinesInstance_surface: 1.33079e-12
',
						    write => 'algorithminstance',
						   },
						   {
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "maind" "segments/purkinje/maind.ndf"
    FILE "soma" "segments/purkinje/soma.ndf"
    FILE "spine" "segments/spines/purkinje.ndf"
    FILE "spinyd" "segments/purkinje/spinyd.ndf"
    FILE "thickd" "segments/purkinje/thickd.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "maind::/maind" "maind"
  END ALIAS
  ALIAS "soma::/soma" "soma"
  END ALIAS
  ALIAS "spine::/Purk_spine" "Purkinje_spine"
  END ALIAS
  ALIAS "spinyd::/spinyd" "spinyd"
  END ALIAS
  ALIAS "thickd::/thickd" "thickd"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "purk_test"
    ALGORITHM "Spines" "SpinesNormal_13_1"
      PARAMETERS
        PARAMETER ( PROTOTYPE = "Purkinje_spine" ),
        PARAMETER ( DIA_MIN = 0 ),
        PARAMETER ( DIA_MAX = 3.18 ),
        PARAMETER ( SPINE_DENSITY = 13 ),
        PARAMETER ( SPINE_FREQUENCY = 1 ),
      END PARAMETERS
    END ALGORITHM
    SEGMENT_GROUP "segments"
      CHILD "soma" "soma"
        PARAMETERS
          PARAMETER ( rel_X = 0 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 2.98e-05 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[0]"
        PARAMETERS
          PARAMETER ( Z = 9.447e-06 ),
          PARAMETER ( Y = 9.447e-06 ),
          PARAMETER ( X = 5.557e-06 ),
          PARAMETER ( PARENT = ../soma ),
          PARAMETER ( rel_X = 5.557e-06 ),
          PARAMETER ( rel_Y = 9.447e-06 ),
          PARAMETER ( rel_Z = 9.447e-06 ),
          PARAMETER ( DIA = 7.72e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[1]"
        PARAMETERS
          PARAMETER ( Z = 3.1356e-05 ),
          PARAMETER ( Y = 1.0571e-05 ),
          PARAMETER ( X = 1.3983e-05 ),
          PARAMETER ( PARENT = ../main[0] ),
          PARAMETER ( rel_X = 8.426e-06 ),
          PARAMETER ( rel_Y = 1.124e-06 ),
          PARAMETER ( rel_Z = 2.1909e-05 ),
          PARAMETER ( DIA = 8.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[2]"
        PARAMETERS
          PARAMETER ( Z = 3.8022e-05 ),
          PARAMETER ( Y = 1.1682e-05 ),
          PARAMETER ( X = 1.5649e-05 ),
          PARAMETER ( PARENT = ../main[1] ),
          PARAMETER ( rel_X = 1.666e-06 ),
          PARAMETER ( rel_Y = 1.111e-06 ),
          PARAMETER ( rel_Z = 6.666e-06 ),
          PARAMETER ( DIA = 8.5e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[3]"
        PARAMETERS
          PARAMETER ( Z = 3.9689e-05 ),
          PARAMETER ( Y = 1.3905e-05 ),
          PARAMETER ( X = 1.287e-05 ),
          PARAMETER ( PARENT = ../main[2] ),
          PARAMETER ( rel_X = -2.779e-06 ),
          PARAMETER ( rel_Y = 2.223e-06 ),
          PARAMETER ( rel_Z = 1.667e-06 ),
          PARAMETER ( DIA = 9.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[4]"
        PARAMETERS
          PARAMETER ( Z = 4.5242e-05 ),
          PARAMETER ( Y = 2.0014e-05 ),
          PARAMETER ( X = 1.1759e-05 ),
          PARAMETER ( PARENT = ../main[3] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = 6.109e-06 ),
          PARAMETER ( rel_Z = 5.553e-06 ),
          PARAMETER ( DIA = 8.89e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[5]"
        PARAMETERS
          PARAMETER ( Z = 5.024e-05 ),
          PARAMETER ( Y = 1.9459e-05 ),
          PARAMETER ( X = 1.0648e-05 ),
          PARAMETER ( PARENT = ../main[4] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 4.998e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[6]"
        PARAMETERS
          PARAMETER ( Z = 5.3738e-05 ),
          PARAMETER ( Y = 2.0042e-05 ),
          PARAMETER ( X = 8.899e-06 ),
          PARAMETER ( PARENT = ../main[5] ),
          PARAMETER ( rel_X = -1.749e-06 ),
          PARAMETER ( rel_Y = 5.83e-07 ),
          PARAMETER ( rel_Z = 3.498e-06 ),
          PARAMETER ( DIA = 8.61e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[7]"
        PARAMETERS
          PARAMETER ( Z = 6.0407e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = 5.009e-06 ),
          PARAMETER ( PARENT = ../main[6] ),
          PARAMETER ( rel_X = -3.89e-06 ),
          PARAMETER ( rel_Y = 3.334e-06 ),
          PARAMETER ( rel_Z = 6.669e-06 ),
          PARAMETER ( DIA = 7.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[8]"
        PARAMETERS
          PARAMETER ( Z = 6.9848e-05 ),
          PARAMETER ( Y = 2.2265e-05 ),
          PARAMETER ( X = -1.656e-06 ),
          PARAMETER ( PARENT = ../main[7] ),
          PARAMETER ( rel_X = -6.665e-06 ),
          PARAMETER ( rel_Y = -1.111e-06 ),
          PARAMETER ( rel_Z = 9.441e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[0]"
        PARAMETERS
          PARAMETER ( Z = 6.9848e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = -6.099e-06 ),
          PARAMETER ( PARENT = ../main[8] ),
          PARAMETER ( rel_X = -4.443e-06 ),
          PARAMETER ( rel_Y = 1.111e-06 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 7.94e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[1]"
        PARAMETERS
          PARAMETER ( Z = 7.0958e-05 ),
          PARAMETER ( Y = 2.2821e-05 ),
          PARAMETER ( X = -1.0539e-05 ),
          PARAMETER ( PARENT = ../br1[0] ),
          PARAMETER ( rel_X = -4.44e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 1.11e-06 ),
          PARAMETER ( DIA = 5.39e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[2]"
        PARAMETERS
          PARAMETER ( Z = 7.2069e-05 ),
          PARAMETER ( Y = 2.2821e-05 ),
          PARAMETER ( X = -2.3873e-05 ),
          PARAMETER ( PARENT = ../br1[1] ),
          PARAMETER ( rel_X = -1.3334e-05 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 1.111e-06 ),
          PARAMETER ( DIA = 5.06e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[3]"
        PARAMETERS
          PARAMETER ( Z = 7.4844e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = -2.7203e-05 ),
          PARAMETER ( PARENT = ../br1[2] ),
          PARAMETER ( rel_X = -3.33e-06 ),
          PARAMETER ( rel_Y = 5.55e-07 ),
          PARAMETER ( rel_Z = 2.775e-06 ),
          PARAMETER ( DIA = 4.83e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "b0s02[0]"
        PARAMETERS
          PARAMETER ( Z = 3.8022e-05 ),
          PARAMETER ( Y = 1.0571e-05 ),
          PARAMETER ( X = 2.5647e-05 ),
          PARAMETER ( PARENT = ../main[2] ),
          PARAMETER ( rel_X = 9.998e-06 ),
          PARAMETER ( rel_Y = -1.111e-06 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 6.17e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[1]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.81579e-10 ),
          PARAMETER ( LENGTH = 6.71006e-06 ),
          PARAMETER ( Z = 3.8577e-05 ),
          PARAMETER ( Y = 1.0016e-05 ),
          PARAMETER ( X = 3.2311e-05 ),
          PARAMETER ( PARENT = ../b0s02[0] ),
          PARAMETER ( rel_X = 6.664e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 5.55e-07 ),
          PARAMETER ( DIA = 3.17e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[2]"
        PARAMETERS
          PARAMETER ( SURFACE = 9.71509e-11 ),
          PARAMETER ( LENGTH = 3.96965e-06 ),
          PARAMETER ( Z = 3.4686e-05 ),
          PARAMETER ( Y = 1.0572e-05 ),
          PARAMETER ( X = 3.2867e-05 ),
          PARAMETER ( PARENT = ../b0s02[1] ),
          PARAMETER ( rel_X = 5.56e-07 ),
          PARAMETER ( rel_Y = 5.56e-07 ),
          PARAMETER ( rel_Z = -3.891e-06 ),
          PARAMETER ( DIA = 2.39e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[3]"
        PARAMETERS
          PARAMETER ( SURFACE = 7.39547e-11 ),
          PARAMETER ( LENGTH = 3.23978e-06 ),
          PARAMETER ( Z = 3.1908e-05 ),
          PARAMETER ( Y = 1.0572e-05 ),
          PARAMETER ( X = 3.4534e-05 ),
          PARAMETER ( PARENT = ../b0s02[2] ),
          PARAMETER ( rel_X = 1.667e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -2.778e-06 ),
          PARAMETER ( DIA = 1.89e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[4]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.264e-10 ),
          PARAMETER ( LENGTH = 5.57967e-06 ),
          PARAMETER ( Z = 2.6356e-05 ),
          PARAMETER ( Y = 1.0572e-05 ),
          PARAMETER ( X = 3.5089e-05 ),
          PARAMETER ( PARENT = ../b0s02[3] ),
          PARAMETER ( rel_X = 5.55e-07 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -5.552e-06 ),
          PARAMETER ( DIA = 1.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[5]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.3969e-10 ),
          PARAMETER ( LENGTH = 6.16021e-06 ),
          PARAMETER ( Z = 2.0246e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.4534e-05 ),
          PARAMETER ( PARENT = ../b0s02[4] ),
          PARAMETER ( rel_X = -5.55e-07 ),
          PARAMETER ( rel_Y = 5.55e-07 ),
          PARAMETER ( rel_Z = -6.11e-06 ),
          PARAMETER ( DIA = 1.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[6]"
        PARAMETERS
          PARAMETER ( SURFACE = 6.88639e-11 ),
          PARAMETER ( LENGTH = 3.13955e-06 ),
          PARAMETER ( Z = 1.8026e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.2314e-05 ),
          PARAMETER ( PARENT = ../b0s02[5] ),
          PARAMETER ( rel_X = -2.22e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -2.22e-06 ),
          PARAMETER ( DIA = 1.61e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[7]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.35952e-10 ),
          PARAMETER ( LENGTH = 6.29042e-06 ),
          PARAMETER ( Z = 1.1837e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.3439e-05 ),
          PARAMETER ( PARENT = ../b0s02[6] ),
          PARAMETER ( rel_X = 1.125e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -6.189e-06 ),
          PARAMETER ( DIA = 1.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[8]"
        PARAMETERS
          PARAMETER ( SURFACE = 9.32422e-11 ),
          PARAMETER ( LENGTH = 4.22991e-06 ),
          PARAMETER ( Z = 1.858e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.8422e-05 ),
          PARAMETER ( PARENT = ../b0s02[5] ),
          PARAMETER ( rel_X = 3.888e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -1.666e-06 ),
          PARAMETER ( DIA = 1.61e-06 ),
        END PARAMETERS
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						    write => "export no ndf STDOUT /**",
						   },
						   {
						    description => "Can we export the model as NDF with namespace support ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE "maind" "segments/purkinje/maind.ndf"
    FILE "soma" "segments/purkinje/soma.ndf"
    FILE "spine" "segments/spines/purkinje.ndf"
    FILE "spinyd" "segments/purkinje/spinyd.ndf"
    FILE "thickd" "segments/purkinje/thickd.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS "maind::/maind" "maind"
  END ALIAS
  ALIAS "soma::/soma" "soma"
  END ALIAS
  ALIAS "spine::/Purk_spine" "Purkinje_spine"
  END ALIAS
  ALIAS "spinyd::/spinyd" "spinyd"
  END ALIAS
  ALIAS "thickd::/thickd" "thickd"
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "purk_test"
    ALGORITHM "Spines" "SpinesNormal_13_1"
      PARAMETERS
        PARAMETER ( PROTOTYPE = "Purkinje_spine" ),
        PARAMETER ( DIA_MIN = 0 ),
        PARAMETER ( DIA_MAX = 3.18 ),
        PARAMETER ( SPINE_DENSITY = 13 ),
        PARAMETER ( SPINE_FREQUENCY = 1 ),
      END PARAMETERS
    END ALGORITHM
    SEGMENT_GROUP "segments"
      CHILD "soma" "soma"
        PARAMETERS
          PARAMETER ( rel_X = 0 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 2.98e-05 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[0]"
        PARAMETERS
          PARAMETER ( Z = 9.447e-06 ),
          PARAMETER ( Y = 9.447e-06 ),
          PARAMETER ( X = 5.557e-06 ),
          PARAMETER ( PARENT = ../soma ),
          PARAMETER ( rel_X = 5.557e-06 ),
          PARAMETER ( rel_Y = 9.447e-06 ),
          PARAMETER ( rel_Z = 9.447e-06 ),
          PARAMETER ( DIA = 7.72e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[1]"
        PARAMETERS
          PARAMETER ( Z = 3.1356e-05 ),
          PARAMETER ( Y = 1.0571e-05 ),
          PARAMETER ( X = 1.3983e-05 ),
          PARAMETER ( PARENT = ../main[0] ),
          PARAMETER ( rel_X = 8.426e-06 ),
          PARAMETER ( rel_Y = 1.124e-06 ),
          PARAMETER ( rel_Z = 2.1909e-05 ),
          PARAMETER ( DIA = 8.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[2]"
        PARAMETERS
          PARAMETER ( Z = 3.8022e-05 ),
          PARAMETER ( Y = 1.1682e-05 ),
          PARAMETER ( X = 1.5649e-05 ),
          PARAMETER ( PARENT = ../main[1] ),
          PARAMETER ( rel_X = 1.666e-06 ),
          PARAMETER ( rel_Y = 1.111e-06 ),
          PARAMETER ( rel_Z = 6.666e-06 ),
          PARAMETER ( DIA = 8.5e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[3]"
        PARAMETERS
          PARAMETER ( Z = 3.9689e-05 ),
          PARAMETER ( Y = 1.3905e-05 ),
          PARAMETER ( X = 1.287e-05 ),
          PARAMETER ( PARENT = ../main[2] ),
          PARAMETER ( rel_X = -2.779e-06 ),
          PARAMETER ( rel_Y = 2.223e-06 ),
          PARAMETER ( rel_Z = 1.667e-06 ),
          PARAMETER ( DIA = 9.22e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[4]"
        PARAMETERS
          PARAMETER ( Z = 4.5242e-05 ),
          PARAMETER ( Y = 2.0014e-05 ),
          PARAMETER ( X = 1.1759e-05 ),
          PARAMETER ( PARENT = ../main[3] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = 6.109e-06 ),
          PARAMETER ( rel_Z = 5.553e-06 ),
          PARAMETER ( DIA = 8.89e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[5]"
        PARAMETERS
          PARAMETER ( Z = 5.024e-05 ),
          PARAMETER ( Y = 1.9459e-05 ),
          PARAMETER ( X = 1.0648e-05 ),
          PARAMETER ( PARENT = ../main[4] ),
          PARAMETER ( rel_X = -1.111e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 4.998e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[6]"
        PARAMETERS
          PARAMETER ( Z = 5.3738e-05 ),
          PARAMETER ( Y = 2.0042e-05 ),
          PARAMETER ( X = 8.899e-06 ),
          PARAMETER ( PARENT = ../main[5] ),
          PARAMETER ( rel_X = -1.749e-06 ),
          PARAMETER ( rel_Y = 5.83e-07 ),
          PARAMETER ( rel_Z = 3.498e-06 ),
          PARAMETER ( DIA = 8.61e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[7]"
        PARAMETERS
          PARAMETER ( Z = 6.0407e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = 5.009e-06 ),
          PARAMETER ( PARENT = ../main[6] ),
          PARAMETER ( rel_X = -3.89e-06 ),
          PARAMETER ( rel_Y = 3.334e-06 ),
          PARAMETER ( rel_Z = 6.669e-06 ),
          PARAMETER ( DIA = 7.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "maind" "main[8]"
        PARAMETERS
          PARAMETER ( Z = 6.9848e-05 ),
          PARAMETER ( Y = 2.2265e-05 ),
          PARAMETER ( X = -1.656e-06 ),
          PARAMETER ( PARENT = ../main[7] ),
          PARAMETER ( rel_X = -6.665e-06 ),
          PARAMETER ( rel_Y = -1.111e-06 ),
          PARAMETER ( rel_Z = 9.441e-06 ),
          PARAMETER ( DIA = 8.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[0]"
        PARAMETERS
          PARAMETER ( Z = 6.9848e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = -6.099e-06 ),
          PARAMETER ( PARENT = ../main[8] ),
          PARAMETER ( rel_X = -4.443e-06 ),
          PARAMETER ( rel_Y = 1.111e-06 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 7.94e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[1]"
        PARAMETERS
          PARAMETER ( Z = 7.0958e-05 ),
          PARAMETER ( Y = 2.2821e-05 ),
          PARAMETER ( X = -1.0539e-05 ),
          PARAMETER ( PARENT = ../br1[0] ),
          PARAMETER ( rel_X = -4.44e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 1.11e-06 ),
          PARAMETER ( DIA = 5.39e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[2]"
        PARAMETERS
          PARAMETER ( Z = 7.2069e-05 ),
          PARAMETER ( Y = 2.2821e-05 ),
          PARAMETER ( X = -2.3873e-05 ),
          PARAMETER ( PARENT = ../br1[1] ),
          PARAMETER ( rel_X = -1.3334e-05 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = 1.111e-06 ),
          PARAMETER ( DIA = 5.06e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "br1[3]"
        PARAMETERS
          PARAMETER ( Z = 7.4844e-05 ),
          PARAMETER ( Y = 2.3376e-05 ),
          PARAMETER ( X = -2.7203e-05 ),
          PARAMETER ( PARENT = ../br1[2] ),
          PARAMETER ( rel_X = -3.33e-06 ),
          PARAMETER ( rel_Y = 5.55e-07 ),
          PARAMETER ( rel_Z = 2.775e-06 ),
          PARAMETER ( DIA = 4.83e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "thickd" "b0s02[0]"
        PARAMETERS
          PARAMETER ( Z = 3.8022e-05 ),
          PARAMETER ( Y = 1.0571e-05 ),
          PARAMETER ( X = 2.5647e-05 ),
          PARAMETER ( PARENT = ../main[2] ),
          PARAMETER ( rel_X = 9.998e-06 ),
          PARAMETER ( rel_Y = -1.111e-06 ),
          PARAMETER ( rel_Z = 0 ),
          PARAMETER ( DIA = 6.17e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[1]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.81579e-10 ),
          PARAMETER ( LENGTH = 6.71006e-06 ),
          PARAMETER ( Z = 3.8577e-05 ),
          PARAMETER ( Y = 1.0016e-05 ),
          PARAMETER ( X = 3.2311e-05 ),
          PARAMETER ( PARENT = ../b0s02[0] ),
          PARAMETER ( rel_X = 6.664e-06 ),
          PARAMETER ( rel_Y = -5.55e-07 ),
          PARAMETER ( rel_Z = 5.55e-07 ),
          PARAMETER ( DIA = 3.17e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[2]"
        PARAMETERS
          PARAMETER ( SURFACE = 9.71509e-11 ),
          PARAMETER ( LENGTH = 3.96965e-06 ),
          PARAMETER ( Z = 3.4686e-05 ),
          PARAMETER ( Y = 1.0572e-05 ),
          PARAMETER ( X = 3.2867e-05 ),
          PARAMETER ( PARENT = ../b0s02[1] ),
          PARAMETER ( rel_X = 5.56e-07 ),
          PARAMETER ( rel_Y = 5.56e-07 ),
          PARAMETER ( rel_Z = -3.891e-06 ),
          PARAMETER ( DIA = 2.39e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[3]"
        PARAMETERS
          PARAMETER ( SURFACE = 7.39547e-11 ),
          PARAMETER ( LENGTH = 3.23978e-06 ),
          PARAMETER ( Z = 3.1908e-05 ),
          PARAMETER ( Y = 1.0572e-05 ),
          PARAMETER ( X = 3.4534e-05 ),
          PARAMETER ( PARENT = ../b0s02[2] ),
          PARAMETER ( rel_X = 1.667e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -2.778e-06 ),
          PARAMETER ( DIA = 1.89e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[4]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.264e-10 ),
          PARAMETER ( LENGTH = 5.57967e-06 ),
          PARAMETER ( Z = 2.6356e-05 ),
          PARAMETER ( Y = 1.0572e-05 ),
          PARAMETER ( X = 3.5089e-05 ),
          PARAMETER ( PARENT = ../b0s02[3] ),
          PARAMETER ( rel_X = 5.55e-07 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -5.552e-06 ),
          PARAMETER ( DIA = 1.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[5]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.3969e-10 ),
          PARAMETER ( LENGTH = 6.16021e-06 ),
          PARAMETER ( Z = 2.0246e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.4534e-05 ),
          PARAMETER ( PARENT = ../b0s02[4] ),
          PARAMETER ( rel_X = -5.55e-07 ),
          PARAMETER ( rel_Y = 5.55e-07 ),
          PARAMETER ( rel_Z = -6.11e-06 ),
          PARAMETER ( DIA = 1.78e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[6]"
        PARAMETERS
          PARAMETER ( SURFACE = 6.88639e-11 ),
          PARAMETER ( LENGTH = 3.13955e-06 ),
          PARAMETER ( Z = 1.8026e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.2314e-05 ),
          PARAMETER ( PARENT = ../b0s02[5] ),
          PARAMETER ( rel_X = -2.22e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -2.22e-06 ),
          PARAMETER ( DIA = 1.61e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[7]"
        PARAMETERS
          PARAMETER ( SURFACE = 1.35952e-10 ),
          PARAMETER ( LENGTH = 6.29042e-06 ),
          PARAMETER ( Z = 1.1837e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.3439e-05 ),
          PARAMETER ( PARENT = ../b0s02[6] ),
          PARAMETER ( rel_X = 1.125e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -6.189e-06 ),
          PARAMETER ( DIA = 1.44e-06 ),
        END PARAMETERS
      END CHILD
      CHILD "spinyd" "b0s02[8]"
        PARAMETERS
          PARAMETER ( SURFACE = 9.32422e-11 ),
          PARAMETER ( LENGTH = 4.22991e-06 ),
          PARAMETER ( Z = 1.858e-05 ),
          PARAMETER ( Y = 1.1127e-05 ),
          PARAMETER ( X = 3.8422e-05 ),
          PARAMETER ( PARENT = ../b0s02[5] ),
          PARAMETER ( rel_X = 3.888e-06 ),
          PARAMETER ( rel_Y = 0 ),
          PARAMETER ( rel_Z = -1.666e-06 ),
          PARAMETER ( DIA = 1.61e-06 ),
        END PARAMETERS
      END CHILD
    END SEGMENT_GROUP
  END CELL
END PUBLIC_MODELS
',
						    write => "export names ndf STDOUT /**",
						   },
						  ],
				 description => "export of a model with the spines algorithm enabled",
				},
			       ),

			       # reading, writing and then parsing a couple of ndf files

			       (
				map
				{
				    my $ndf = $_;

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
							 timeout => 15,
							},
							{
							 description => "Can we export the model as NDF ?",
							 wait => 1,
							 write => "export no ndf /tmp/1.ndf /**",
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
							 timeout => 15,
							},
						       ],
				      description => "reading of $ndf after exporting it",
				      disabled => ($ndf eq "networks/input.ndf" ? "export of $ndf does not work correctly, connection vectors and connection symbol vectors are messed up." : 0),
				     },
				    );
				}
				qw(
				   channels/nmda.ndf
				   cells/purkinje/edsjb1994.ndf
				   cells/purkinje/edsjb1994_partitioned.ndf
				   networks/input.ndf
				   networks/white-matter.ndf
				  )
			       ),
			      ],
       description => "exporting models in a variety of export formats",
       name => 'export.t',
      };


return $test;


