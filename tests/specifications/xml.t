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
					      'channels/gaba.xml',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/channels/gaba.xml.', ],
						   timeout => 15,
						  },
						  {
						   description => "Can we export the model to an NDF file ?",
						   read => 'neurospaces',
						   wait => 1,
						   write => "export no ndf /tmp/1.ndf /**",
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
  CHANNEL Purk_GABA
    BINDABLES
      INPUT Vm,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 1.077 ),
      PARAMETER ( Erev = -0.08 ),
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
        PARAMETER ( TAU1 = 0.00093 ),
        PARAMETER ( TAU2 = 0.0265 ),
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
  <CHANNEL> <name>Purk_GABA</name>
    <bindables>
      <input> <name>Vm</name> </input>
      <output> <name>I</name> </output>
    </bindables>
    <parameters>
      <parameter> <name>G_MAX</name><value>1.077</value> </parameter>
      <parameter> <name>Erev</name><value>-0.08</value> </parameter>
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
        <parameter> <name>TAU1</name><value>0.00093</value> </parameter>
        <parameter> <name>TAU2</name><value>0.0265</value> </parameter>
      </parameters>
    </EQUATION_EXPONENTIAL>
  </CHANNEL>
</public_models>
',
							   },
						  },
						 ],
				description => "import and export of a model in xml",
			       },
			      ],
       description => "importing and processing of a model encoded in xml",
       name => 'xml.t',
      };


return $test;


