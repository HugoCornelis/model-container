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
    FILE mapper "mappers/spikereceiver.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS mapper::/Synapse Synapse
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL NMDA_fixed_conductance
    BINDABLES
      INPUT Vm,
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
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
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
  CHANNEL NMDA
    BINDABLES
      INPUT Vm,
      OUTPUT I,
    END BINDABLES
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
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
    FILE k "channels/hodgkin-huxley/potassium.ndf"
    FILE na "channels/hodgkin-huxley/sodium.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS k::/k k
  END ALIAS
  ALIAS na::/na na
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  ALIAS k k
  END ALIAS
  ALIAS na na
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
						    description => "Does the exported NDF file contain the correct model (3) ?",
						    read => {
							     application_output_file => '/tmp/1.ndf',
							     expected_output => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE mapper "mappers/spikereceiver.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS mapper::/Synapse Synapse
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL NMDA_fixed_conductance
    BINDABLES
      INPUT Vm,
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
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
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
  CHANNEL NMDA
    BINDABLES
      INPUT Vm,
      OUTPUT I,
    END BINDABLES
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
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
    FILE mapper "mappers/spikereceiver.ndf"
    FILE gaba "channels/gaba.ndf"
    FILE basket "channels/purkinje_basket.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS mapper::/Synapse Synapse
  END ALIAS
END PRIVATE_MODELS

PUBLIC_MODELS
  CHANNEL NMDA_fixed_conductance
    BINDABLES
      INPUT Vm,
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
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
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
  CHANNEL NMDA
    BINDABLES
      INPUT Vm,
      OUTPUT I,
    END BINDABLES
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
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
						    description => "Can we export the model as NDF ?",
						    read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
    FILE soma "tests/segments/soma.ndf"
    FILE gate1 "gates/naf_activation.ndf"
    FILE gate2 "gates/naf_inactivation.ndf"
END IMPORT

PRIVATE_MODELS
  ALIAS gate1::/naf_activation naf_gate_activation
  END ALIAS
  ALIAS gate2::/naf_inactivation naf_gate_inactivation
  END ALIAS
  CHANNEL NaF
    BINDABLES
      INPUT Vm,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
      PARAMETER ( G_MAX = 75000 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD naf_gate_activation naf_gate_activation
    END CHILD
    CHILD naf_gate_inactivation naf_gate_inactivation
    END CHILD
  END CHANNEL
  SEGMENT soma2
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
    CHILD NaF NaF
    END CHILD
  END SEGMENT
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL singlea_naf
    SEGMENT_GROUP segments
      CHILD soma2 soma
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
			       ),
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


