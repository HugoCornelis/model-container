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
						   write => "export ndf /tmp/1.ndf /**",
						  },
						  {
						   description => "Does the exported NDF file contain the correct model ?",
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
    PARAMETERS
      PARAMETER ( Erev = 0 ),
      PARAMETER ( G_MAX = 
        FIXED
          (
              PARAMETER ( value = 6.87066e-10 ),
              PARAMETER ( scale = 1 ),
          ),
    END PARAMETERS
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
  CHANNEL NMDA
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
PUBLIC_MODELS
',
							   },
						  },
						  {
						   description => "Can we export the model to an XML file ?",
						   read => 'neurospaces',
						   wait => 1,
						   write => "export xml /tmp/1.xml /**",
						  },
						  {
						   comment => 'xml to html conversion fails when converting this test to html',
						   description => "Does the exported XML file contain the correct model ?",
						   read => {
							    application_output_file => '/tmp/1.xml',
							    expected_output => '<import>
    <file> <namespace>mapper</namespace> <filename>mappers/spikereceiver.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>mapper</namespace><prototype>/Synapse</prototype> <name>Synapse</name>
  </alias>
</private_models>

<public_models>
  <CHANNEL> <name>NMDA_fixed_conductance</name>
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
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
  <CHANNEL> <name>NMDA</name>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
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
						   write => "export ndf /tmp/1.ndf /**",
						  },
						  {
						   description => "Does the exported NDF file contain the correct model ?",
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
PUBLIC_MODELS
',
							   },
						  },
						  {
						   description => "Can we export the model to an XML file ?",
						   read => 'neurospaces',
						   wait => 1,
						   write => "export xml /tmp/1.xml /**",
						  },
						  {
						   comment => 'xml to html conversion fails when converting this test to html',
						   description => "Does the exported XML file contain the correct model ?",
						   read => {
							    application_output_file => '/tmp/1.xml',
							    expected_output => '<import>
    <file> <namespace>k</namespace> <filename>channels/hodgkin-huxley/potassium.ndf</filename> </file>
    <file> <namespace>na</namespace> <filename>channels/hodgkin-huxley/sodium.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>k</namespace><prototype>/k</prototype> <name>k</name>
  </alias>
  <alias> <namespace>na</namespace><prototype>/na</prototype> <name>na</name>
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
						   write => "export ndf /tmp/1.ndf /**",
						  },
						  {
						   description => "Does the exported NDF file contain the correct model ?",
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
    PARAMETERS
      PARAMETER ( Erev = 0 ),
      PARAMETER ( G_MAX = 
        FIXED
          (
              PARAMETER ( value = 6.87066e-10 ),
              PARAMETER ( scale = 1 ),
          ),
    END PARAMETERS
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
  CHANNEL NMDA
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
PUBLIC_MODELS
',
							   },
						  },
						  {
						   description => "Can we export the model to an XML file ?",
						   read => 'neurospaces',
						   wait => 1,
						   write => "export xml /tmp/1.xml /**",
						  },
						  {
						   comment => 'xml to html conversion fails when converting this test to html',
						   description => "Does the exported XML file contain the correct model ?",
						   read => {
							    application_output_file => '/tmp/1.xml',
							    expected_output => '<import>
    <file> <namespace>mapper</namespace> <filename>mappers/spikereceiver.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>mapper</namespace><prototype>/Synapse</prototype> <name>Synapse</name>
  </alias>
</private_models>

<public_models>
  <CHANNEL> <name>NMDA_fixed_conductance</name>
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
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
  <CHANNEL> <name>NMDA</name>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
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
    PARAMETERS
      PARAMETER ( Erev = 0 ),
      PARAMETER ( G_MAX = 
        FIXED
          (
              PARAMETER ( value = 6.87066e-10 ),
              PARAMETER ( scale = 1 ),
          ),
    END PARAMETERS
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
  CHANNEL NMDA
    CHILD Synapse synapse
    END CHILD
    EQUATION_EXPONENTIAL exp2
      PARAMETERS
        PARAMETER ( TAU1 = 0.0005 ),
        PARAMETER ( TAU2 = 0.0012 ),
      END PARAMETERS
    END EQUATION_EXPONENTIAL
  END CHANNEL
PUBLIC_MODELS
',
						   write => 'export ndf STDOUT /**',
						  },
						  {
						   description => 'Are the imported namespaces present in the xml export ?',
						   read => '<import>
    <file> <namespace>mapper</namespace> <filename>mappers/spikereceiver.ndf</filename> </file>
    <file> <namespace>gaba</namespace> <filename>channels/gaba.ndf</filename> </file>
    <file> <namespace>basket</namespace> <filename>channels/purkinje_basket.ndf</filename> </file>
</import>

<private_models>
  <alias> <namespace>mapper</namespace><prototype>/Synapse</prototype> <name>Synapse</name>
  </alias>
</private_models>

<public_models>
  <CHANNEL> <name>NMDA_fixed_conductance</name>
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
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
  <CHANNEL> <name>NMDA</name>
    <child> <prototype>Synapse</prototype> <name>synapse</name>
    </child>
    <EQUATION_EXPONENTIAL> <name>exp2</name>
      <parameters>
        <parameter> <name>TAU1</name><value>0.0005</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0012</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
</public_models>
',
						   write => 'export xml STDOUT /**',
						  },
						 ],
				description => "export of a simple model and manually importing files",
			       },
			      ],
       description => "exporting models in a variety of export formats",
       name => 'export.t',
      };


return $test;


