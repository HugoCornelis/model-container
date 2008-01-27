#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-h',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is a help message been given ?",
						   read => [ '-re', 'Usage: .*?neurospacesparse <options> <filenames>
	options :
		-d <filename> : debug output to given file
		-h : give help and exit
		-i : print imported files to stderr at end of parsing
		-m <directory> : set model library location
		-p : only parse the files to check its syntax
		-q : enter query machine after parsing
		-t : report symbol table after parsing
		-v <level> : set verbosity level
		-A : turn off algorithm processing
		-D : turn on parser debug flag
		-M : report algorithm info after parsing
		-Q : followed by a query machine command
		-R : disable readline
		-T <level> : set timing report level
		-V <level> : set exclusive verbosity level


	verbosity levels :

	\(5\) = LEVEL_GLOBALMSG_IMPORTANT \(level for important messages\)
	\(-10\) = LEVEL_GLOBALMSG_FILEIMPORT \(report import of files\)
	\(-20\) = LEVEL_GLOBALMSG_ALGORITHMIMPORT \(report import of algorithms\)
	\(-30\) = LEVEL_GLOBALMSG_SYMBOLREPORT \(report actions taken on \'END \{PRIVATE,PUBLIC\}_MODELS\' etc.\)
	\(-40\) = LEVEL_GLOBALMSG_SYMBOLADD \(report add of symbols\)
	\(-50\) = LEVEL_GLOBALMSG_SYMBOLCREATE \(report creation of symbols\)


	timing levels :

	2 : report timing for all logged messages.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "help message",
			       },
			       {
				arguments => [
					      '-i',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have imported files been reported ?",
						   read => [ '-re', '    ------------------------------------------------------------------------------
    Imported file : \(.+?/mappers/spikereceiver.ndf\)
    Imported file : \(                                           spikereceiver.ndf\)
    ------------------------------------------------------------------------------
    Flags : \(00000000\)
    Parse Method : \(no info\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \(.+?/channels/golgi_gabaa.ndf\)
    Imported file : \(                                             golgi_gabaa.ndf\)
    ------------------------------------------------------------------------------
    Flags : \(00000001\)
	Root imported file
    Parse Method : \(no info\)
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "reporting of imported files",
			       },
			       {
				arguments => [
					      '-m',
					      '/asfdsadfasdfasdf',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Can we set the model library directory ?",
						   read => [ 'Could not find file (number 0, 0), path name (channels/golgi_gabaa.ndf)
Set one of the environment variables NEUROSPACES_USER_MODELS,
NEUROSPACES_PROJECT_MODELS, NEUROSPACES_SYSTEM_MODELS or NEUROSPACES_MODELS
to point to a library where the required model is located,
or use the -m switch to configure where neurospaces looks for models.
', ],
						   write => undef,
						  },
						 ],
				description => "setting of the model library directory",
				preparation => {
						description => "Removing the environment entry to point to a model library",
						preparer =>
						sub
						{
						    $previous_library = $ENV{NEUROSPACES_MODELS};

						    if (defined $ENV{NEUROSPACES_MODELS})
						    {
# 							use Data::Dumper;

# 							print Dumper($ENV{NEUROSPACES_MODELS});

							undef $ENV{NEUROSPACES_MODELS};
						    }
						},
					       },
				reparation => {
					       description => "Restoring the environment entry to point to a model library",
					       reparer =>
					       sub
					       {
						   $ENV{NEUROSPACES_MODELS} = $previous_library;

						   return undef;
					       },
					      },
			       },
			       {
				arguments => [
					      '-s',
					      'channels/golgi_gabab.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Symbol reporting is broken for the moment.",
						   read => [ '-re', 'Type \(T_sym_root\) : no specifics report implemented', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "reporting of symbols",
				disabled => "this was obsoleted a long time ago",
			       },
			       {
				arguments => [
					      '-t',
					      'channels/golgi_gabaa.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has the symbol table been reported ?",
						   read => [ '-re', '------------------------------------------------------------------------------
Imported file : \(.+?/mappers/spikereceiver.ndf\)
Imported file : \(                                           spikereceiver.ndf\)
------------------------------------------------------------------------------
Flags : \(00000000\)
Parse Method : \(no info\)



    PRIVATE_MODELS


    END PRIVATE_MODELS


    PUBLIC_MODELS

            Name, index \(Synapse,-1\)
            Type \(T_sym_attachment\)
            attachName, index \(Synapse,-1\)
                PARA  Name \(weight\)
                PARA  Type \(TYPE_PARA_ATTRIBUTE\), 
                PARA  Name \(delay\)
                PARA  Type \(TYPE_PARA_ATTRIBUTE\), 
            attach\{-- begin HIER sections ---
            attach\}--  end  HIER sections ---

    END PUBLIC_MODELS



------------------------------------------------------------------------------
Imported file : \(.+?/channels/golgi_gabaa.ndf\)
Imported file : \(                                             golgi_gabaa.ndf\)
------------------------------------------------------------------------------
Flags : \(00000001\)
	Root imported file
Parse Method : \(no info\)



    PRIVATE_MODELS

            Name, index \(Synapse,-1\)
            Type \(T_sym_attachment\)
            attachName, index \(Synapse,-1\)
            attach\{-- begin HIER sections ---
            attach\}--  end  HIER sections ---
                attachName, index \(Synapse,-1\)
                    PARA  Name \(weight\)
                    PARA  Type \(TYPE_PARA_ATTRIBUTE\), 
                    PARA  Name \(delay\)
                    PARA  Type \(TYPE_PARA_ATTRIBUTE\), 
                attach\{-- begin HIER sections ---
                attach\}--  end  HIER sections ---

    END PRIVATE_MODELS


    PUBLIC_MODELS

            Name, index \(GABAA,-1\)
            Type \(T_sym_channel\)
            channeName, index \(GABAA,-1\)
                PARA  Name \(GMAX\)
                PARA  Type \(TYPE_PARA_NUMBER\), Value\(1.000000e\+00\)
                PARA  Name \(Erev\)
                PARA  Type \(TYPE_PARA_NUMBER\), Value\(-7.000000e-02\)
            channe\{-- begin HIER sections ---
                Name, index \(synapse,-1\)
                Type \(T_sym_attachment\)
                attachName, index \(synapse,-1\)
                attach\{-- begin HIER sections ---
                attach\}--  end  HIER sections ---
                    attachName, index \(Synapse,-1\)
                    attach\{-- begin HIER sections ---
                    attach\}--  end  HIER sections ---
                        attachName, index \(Synapse,-1\)
                            PARA  Name \(weight\)
                            PARA  Type \(TYPE_PARA_ATTRIBUTE\), 
                            PARA  Name \(delay\)
                            PARA  Type \(TYPE_PARA_ATTRIBUTE\), 
                        attach\{-- begin HIER sections ---
                        attach\}--  end  HIER sections ---
                Name, index \(exp2,-1\)
                Type \(T_sym_equation\)
                equatiName, index \(exp2,-1\)
                    PARA  Name \(TAU1\)
                    PARA  Type \(TYPE_PARA_NUMBER\), Value\(9.300000e-04\)
                    PARA  Name \(TAU2\)
                    PARA  Type \(TYPE_PARA_NUMBER\), Value\(2.650000e-02\)
                equati\{-- begin HIER sections ---
                equati\}--  end  HIER sections ---
            channe\}--  end  HIER sections ---

    END PUBLIC_MODELS
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "reporting of symbol table",
			       },
			       {
				arguments => [
					      '-D',
					      'mappers/spikegenerator.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  #t because this test is not that important, it should be using regexes.

						  {
						   description => "Have parsing states been reported ?",
						   read => [
							    '-re',
							    'Reducing stack by rule(.|\n)*ParseStateDone(.|\n)*Reading a token: Now at end of input.',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "parsing states and tokens for debugging",
			       },
			       {
				arguments => [
					      '-M',
					      'legacy/cells/purk2m9s.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have algorithms given feedback to stdout ?",
						   read => [
							    '-re',
							    '---
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
    number_of_created_instances: 1
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
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 0
---
number_of_algorithm_instances: 1
---
name: SpinesInstance SpinesNormal_13_1
report:
    number_of_added_spines: 1474
    number_of_virtual_spines: 142982.466417
    number_of_spiny_segments: 1474
    number_of_failures_adding_spines: 0
    SpinesInstance_prototype: Purkinje_spine
    SpinesInstance_surface: 1.33079e-12
',
							   ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "algorithm reporting",
			       },
			       {
				arguments => [
					      '-V',
					      '-10',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have imported files been reported to stdout ?",
						   read => [ '-re', '0,golgi.ndf   ,15	\|\|->Dependency file\(.*?/mappers/spikegenerator.ndf\)
0,golgi.ndf   ,15	\|\|->End\(.*?/mappers/spikegenerator.ndf\)
0,golgi.ndf   ,17	\|\|->Dependency file\(.*?/channels/golgi_inna.ndf\)
0,golgi.ndf   ,17	\|\|->End\(.*?/channels/golgi_inna.ndf\)
0,golgi.ndf   ,19	\|\|->Dependency file\(.*?/channels/golgi_kdr.ndf\)
0,golgi.ndf   ,19	\|\|->End\(.*?/channels/golgi_kdr.ndf\)
0,golgi.ndf   ,21	\|\|->Dependency file\(.*?/channels/golgi_ka.ndf\)
0,golgi.ndf   ,21	\|\|->End\(.*?/channels/golgi_ka.ndf\)
0,golgi.ndf   ,23	\|\|->Dependency file\(.*?/channels/golgi_cahva.ndf\)
0,golgi.ndf   ,23	\|\|->End\(.*?/channels/golgi_cahva.ndf\)
0,golgi.ndf   ,25	\|\|->Dependency file\(.*?/channels/golgi_h.ndf\)
0,golgi.ndf   ,25	\|\|->End\(.*?/channels/golgi_h.ndf\)
0,golgi.ndf   ,27	\|\|->Dependency file\(.*?/channels/golgi_kc.ndf\)
0,golgi.ndf   ,27	\|\|->End\(.*?/channels/golgi_kc.ndf\)
0,golgi.ndf   ,29	\|\|->Dependency file\(.*?/channels/golgi_nmda.ndf\)
1,golgi_nmda.n,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_nmda.n,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
0,golgi.ndf   ,29	\|\|->End\(.*?/channels/golgi_nmda.ndf\)
0,golgi.ndf   ,31	\|\|->Dependency file\(.*?/channels/golgi_ampa.ndf\)
1,golgi_ampa.n,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_ampa.n,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
0,golgi.ndf   ,31	\|\|->End\(.*?/channels/golgi_ampa.ndf\)
0,golgi.ndf   ,33	\|\|->Dependency file\(.*?/channels/golgi_gabaa.ndf\)
1,golgi_gabaa.,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_gabaa.,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
0,golgi.ndf   ,33	\|\|->End\(.*?/channels/golgi_gabaa.ndf\)
0,golgi.ndf   ,35	\|\|->Dependency file\(.*?/channels/golgi_gabab.ndf\)
1,golgi_gabab.,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_gabab.,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
0,golgi.ndf   ,35	\|\|->End\(.*?/channels/golgi_gabab.ndf\)
0,golgi.ndf   ,37	\|\|->Dependency file\(.*?/pools/golgi_ca.ndf\)
0,golgi.ndf   ,37	\|\|->End\(.*?/pools/golgi_ca.ndf\)
.*?neurospacesparse: No errors for .*?/cells/golgi.ndf.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "file importing",
			       },
			       {
				arguments => [
					      '-V',
					      '-20',
					      'legacy/networks/networksmall.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have algorithms been activated during parsing ?",
						   read => [ '-re', '1,mossyfibersm,90	\|\|  Import Algorithm\(Grid3D -> MossyGrid\(.*?\)\)
1,mossyfibersm,124	\|\|  AlgorithmInstance\(MossyGrid\) handles \(no context\)
1,mossyfibersm,124	\|\|  AlgorithmInstance\(MossyGrid\) handled \(no context\)
1,mossyfibersm,124	\|\|  Disable Algorithm\(MossyGrid\)
1,golgismall.n,46	\|\|  Import Algorithm\(Grid3D -> GolgiGrid\(.*?\)\)
1,golgismall.n,64	\|\|  AlgorithmInstance\(GolgiGrid\) handles \(no context\)
1,golgismall.n,64	\|\|  AlgorithmInstance\(GolgiGrid\) handled \(no context\)
1,golgismall.n,64	\|\|  Disable Algorithm\(GolgiGrid\)
1,granulesmall,46	\|\|  Import Algorithm\(Grid3D -> GranuleGrid\(.*?\)\)
1,granulesmall,64	\|\|  AlgorithmInstance\(GranuleGrid\) handles \(no context\)
1,granulesmall,64	\|\|  AlgorithmInstance\(GranuleGrid\) handled \(no context\)
1,granulesmall,64	\|\|  Disable Algorithm\(GranuleGrid\)
2,purk2m9s.ndf,82	\|\|    Import Algorithm\(Spines -> SpinesNormal_13_1\(.*?\)\)
2,purk2m9s.ndf,14539	\|\|    AlgorithmInstance\(SpinesNormal_13_1\) handles \(no context\)
2,purk2m9s.ndf,14539	\|\|    AlgorithmInstance\(SpinesNormal_13_1\) handled \(no context\)
2,purk2m9s.ndf,14539	\|\|    Disable Algorithm\(SpinesNormal_13_1\)
1,purkinjesmal,46	\|\|  Import Algorithm\(Grid3D -> PurkinjeGrid\(.*?\)\)
1,purkinjesmal,64	\|\|  AlgorithmInstance\(PurkinjeGrid\) handles \(no context\)
1,purkinjesmal,64	\|\|  AlgorithmInstance\(PurkinjeGrid\) handled \(no context\)
1,purkinjesmal,64	\|\|  Disable Algorithm\(PurkinjeGrid\)
0,networksmall,82	\|\|Import Algorithm\(ProjectionVolume -> Mossies2Granules_NMDA\(.*?\)\)
0,networksmall,116	\|\|Import Algorithm\(ProjectionVolume -> Mossies2Granules_AMPA\(.*?\)\)
0,networksmall,151	\|\|Import Algorithm\(ProjectionVolume -> Granules2Golgis\(.*?\)\)
0,networksmall,185	\|\|Import Algorithm\(ProjectionVolume -> Golgis2Granules_GABAA\(.*?\)\)
0,networksmall,283	\|\|AlgorithmInstance\(Golgis2Granules_GABAA\) handles \(no context\)
0,networksmall,283	\|\|AlgorithmInstance\(Golgis2Granules_GABAA\) handled \(no context\)
0,networksmall,283	\|\|Disable Algorithm\(Golgis2Granules_GABAA\)
0,networksmall,283	\|\|AlgorithmInstance\(Granules2Golgis\) handles \(no context\)
0,networksmall,283	\|\|AlgorithmInstance\(Granules2Golgis\) handled \(no context\)
0,networksmall,283	\|\|Disable Algorithm\(Granules2Golgis\)
0,networksmall,283	\|\|AlgorithmInstance\(Mossies2Granules_AMPA\) handles \(no context\)
0,networksmall,283	\|\|AlgorithmInstance\(Mossies2Granules_AMPA\) handled \(no context\)
0,networksmall,283	\|\|Disable Algorithm\(Mossies2Granules_AMPA\)
0,networksmall,283	\|\|AlgorithmInstance\(Mossies2Granules_NMDA\) handles \(no context\)
0,networksmall,283	\|\|AlgorithmInstance\(Mossies2Granules_NMDA\) handled \(no context\)
0,networksmall,283	\|\|Disable Algorithm\(Mossies2Granules_NMDA\)
.*?neurospacesparse: No errors for .*?/networks/networksmall.ndf.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "activation of algorithms during parsing",
			       },
			       {
				arguments => [
					      '-V',
					      '-30',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have symbols been reported to stdout ?",
						   read => [ '-re', '1,golgi_nmda.n,17	\|\|  Activating golgi_nmda.ndf\'s dependencies\(dependency list not yet\)
1,golgi_nmda.n,23	\|\|  Activating golgi_nmda.ndf\'s private models\(private models list not yet\)
1,golgi_nmda.n,23	\|\|  Activating golgi_nmda.ndf\'s private models\(private models list not yet\)
1,golgi_ampa.n,15	\|\|  .*?/mappers/spikereceiver.ndf is cached\(public model list not yet\)
1,golgi_ampa.n,17	\|\|  Activating golgi_ampa.ndf\'s dependencies\(dependency list not yet\)
1,golgi_ampa.n,23	\|\|  Activating golgi_ampa.ndf\'s private models\(private models list not yet\)
1,golgi_ampa.n,23	\|\|  Activating golgi_ampa.ndf\'s private models\(private models list not yet\)
1,golgi_gabaa.,15	\|\|  .*?/mappers/spikereceiver.ndf is cached\(public model list not yet\)
1,golgi_gabaa.,17	\|\|  Activating golgi_gabaa.ndf\'s dependencies\(dependency list not yet\)
1,golgi_gabaa.,23	\|\|  Activating golgi_gabaa.ndf\'s private models\(private models list not yet\)
1,golgi_gabaa.,23	\|\|  Activating golgi_gabaa.ndf\'s private models\(private models list not yet\)
1,golgi_gabab.,15	\|\|  .*?/mappers/spikereceiver.ndf is cached\(public model list not yet\)
1,golgi_gabab.,17	\|\|  Activating golgi_gabab.ndf\'s dependencies\(dependency list not yet\)
1,golgi_gabab.,23	\|\|  Activating golgi_gabab.ndf\'s private models\(private models list not yet\)
1,golgi_gabab.,23	\|\|  Activating golgi_gabab.ndf\'s private models\(private models list not yet\)
1,golgi_ca.ndf,31	\|\|  Activating golgi_ca.ndf\'s private models\(private models list not yet\)
1,golgi_ca.ndf,31	\|\|  Activating golgi_ca.ndf\'s private models\(private models list not yet\)
0,golgi.ndf   ,39	\|\|Activating golgi.ndf\'s dependencies\(dependency list not yet\)
0,golgi.ndf   ,112	\|\|Activating golgi.ndf\'s private models\(private models list not yet\)
0,golgi.ndf   ,112	\|\|Activating golgi.ndf\'s private models\(private models list not yet\)
.*?neurospacesparse: No errors for .*?/cells/golgi.ndf.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "symbols during parsing",
			       },
			       {
				arguments => [
					      '-V',
					      '-40',
					      'legacy/cells/granule.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have symbols been reported to be published to stdout ?",
						   read => [ '-re', '1,spikegenerat,25	\|\|  Add Public Model\(T_sym_attachment,SpikeGen\)
1,granule_inna,30	\|\|  Add Public Model\(T_sym_channel,InNa\)
1,granule_kdr.,30	\|\|  Add Public Model\(T_sym_channel,KDr\)
1,granule_ka.n,30	\|\|  Add Public Model\(T_sym_channel,KA\)
1,granule_cahv,30	\|\|  Add Public Model\(T_sym_channel,CaHVA\)
1,granule_h.nd,30	\|\|  Add Public Model\(T_sym_channel,H\)
1,granule_kc.n,36	\|\|  Add Public Model\(T_sym_channel,Moczyd_KC\)
2,spikereceive,25	\|\|    Add Public Model\(T_sym_attachment,Synapse\)
1,granule_nmda,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,granule_nmda,76	\|\|  Add Public Model\(T_sym_channel,NMDA\)
1,granule_ampa,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,granule_ampa,67	\|\|  Add Public Model\(T_sym_channel,AMPA\)
1,granule_gaba,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,granule_gaba,61	\|\|  Add Public Model\(T_sym_channel,GABAA\)
1,granule_gaba,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,granule_gaba,61	\|\|  Add Public Model\(T_sym_channel,GABAB\)
1,granule_ca.n,29	\|\|  Add Private Model\(T_sym_pool,Ca_concen\)
1,granule_ca.n,36	\|\|  Add Public Model\(T_sym_pool,Ca_concen\)
1,granule_ca.n,44	\|\|  Add Public Model\(T_sym_pool,Ca_concen_standalone\)
0,granule.ndf ,46	\|\|Add Private Model\(T_sym_attachment,SpikeGen\)
0,granule.ndf ,48	\|\|Add Private Model\(T_sym_channel,InNa\)
0,granule.ndf ,50	\|\|Add Private Model\(T_sym_channel,KDr\)
0,granule.ndf ,52	\|\|Add Private Model\(T_sym_channel,KA\)
0,granule.ndf ,54	\|\|Add Private Model\(T_sym_channel,CaHVA\)
0,granule.ndf ,56	\|\|Add Private Model\(T_sym_channel,H\)
0,granule.ndf ,58	\|\|Add Private Model\(T_sym_channel,Moczyd_KC\)
0,granule.ndf ,60	\|\|Add Private Model\(T_sym_channel,NMDA\)
0,granule.ndf ,62	\|\|Add Private Model\(T_sym_channel,AMPA\)
0,granule.ndf ,64	\|\|Add Private Model\(T_sym_channel,GABAA\)
0,granule.ndf ,66	\|\|Add Private Model\(T_sym_channel,GABAB\)
0,granule.ndf ,68	\|\|Add Private Model\(T_sym_pool,Ca_concen\)
0,granule.ndf ,318	\|\|Add Public Model\(T_sym_cell,Granule\)
.*?neurospacesparse: No errors for .*?/cells/granule.ndf.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "symbol publication during parsing",
			       },
			       {
				arguments => [
					      '-V',
					      '-50',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have symbols been reported to be created to stdout ?",
						   read => [ '-re', '', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "symbols creation during parsing",
			       },
			       {
				arguments => [
					      '-v',
					      '-50',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Have all levels been reported to stdout ?",
						   read => [ '-re', '0,golgi.ndf   ,15	\|\|->Dependency file\(.*?/mappers/spikegenerator.ndf\)
1,spikegenerat,25	\|\|  Add Public Model\(T_sym_attachment,SpikeGen\)
0,golgi.ndf   ,15	\|\|->End\(.*?/mappers/spikegenerator.ndf\)
0,golgi.ndf   ,17	\|\|->Dependency file\(.*?/channels/golgi_inna.ndf\)
1,golgi_inna.n,30	\|\|  Add Public Model\(T_sym_channel,InNa\)
0,golgi.ndf   ,17	\|\|->End\(.*?/channels/golgi_inna.ndf\)
0,golgi.ndf   ,19	\|\|->Dependency file\(.*?/channels/golgi_kdr.ndf\)
1,golgi_kdr.nd,30	\|\|  Add Public Model\(T_sym_channel,KDr\)
0,golgi.ndf   ,19	\|\|->End\(.*?/channels/golgi_kdr.ndf\)
0,golgi.ndf   ,21	\|\|->Dependency file\(.*?/channels/golgi_ka.ndf\)
1,golgi_ka.ndf,30	\|\|  Add Public Model\(T_sym_channel,KA\)
0,golgi.ndf   ,21	\|\|->End\(.*?/channels/golgi_ka.ndf\)
0,golgi.ndf   ,23	\|\|->Dependency file\(.*?/channels/golgi_cahva.ndf\)
1,golgi_cahva.,30	\|\|  Add Public Model\(T_sym_channel,CaHVA\)
0,golgi.ndf   ,23	\|\|->End\(.*?/channels/golgi_cahva.ndf\)
0,golgi.ndf   ,25	\|\|->Dependency file\(.*?/channels/golgi_h.ndf\)
1,golgi_h.ndf ,30	\|\|  Add Public Model\(T_sym_channel,H\)
0,golgi.ndf   ,25	\|\|->End\(.*?/channels/golgi_h.ndf\)
0,golgi.ndf   ,27	\|\|->Dependency file\(.*?/channels/golgi_kc.ndf\)
1,golgi_kc.ndf,36	\|\|  Add Public Model\(T_sym_channel,Moczyd_KC\)
0,golgi.ndf   ,27	\|\|->End\(.*?/channels/golgi_kc.ndf\)
0,golgi.ndf   ,29	\|\|->Dependency file\(.*?/channels/golgi_nmda.ndf\)
1,golgi_nmda.n,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
2,spikereceive,25	\|\|    Add Public Model\(T_sym_attachment,Synapse\)
1,golgi_nmda.n,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
1,golgi_nmda.n,17	\|\|  Activating golgi_nmda.ndf\'s dependencies\(dependency list not yet\)
1,golgi_nmda.n,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,golgi_nmda.n,23	\|\|  Activating golgi_nmda.ndf\'s private models\(private models list not yet\)
1,golgi_nmda.n,23	\|\|  Activating golgi_nmda.ndf\'s private models\(private models list not yet\)
1,golgi_nmda.n,76	\|\|  Add Public Model\(T_sym_channel,NMDA\)
0,golgi.ndf   ,29	\|\|->End\(.*?/channels/golgi_nmda.ndf\)
0,golgi.ndf   ,31	\|\|->Dependency file\(.*?/channels/golgi_ampa.ndf\)
1,golgi_ampa.n,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_ampa.n,15	\|\|  .*?/mappers/spikereceiver.ndf is cached\(public model list not yet\)
1,golgi_ampa.n,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
1,golgi_ampa.n,17	\|\|  Activating golgi_ampa.ndf\'s dependencies\(dependency list not yet\)
1,golgi_ampa.n,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,golgi_ampa.n,23	\|\|  Activating golgi_ampa.ndf\'s private models\(private models list not yet\)
1,golgi_ampa.n,23	\|\|  Activating golgi_ampa.ndf\'s private models\(private models list not yet\)
1,golgi_ampa.n,67	\|\|  Add Public Model\(T_sym_channel,AMPA\)
0,golgi.ndf   ,31	\|\|->End\(.*?/channels/golgi_ampa.ndf\)
0,golgi.ndf   ,33	\|\|->Dependency file\(.*?/channels/golgi_gabaa.ndf\)
1,golgi_gabaa.,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_gabaa.,15	\|\|  .*?/mappers/spikereceiver.ndf is cached\(public model list not yet\)
1,golgi_gabaa.,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
1,golgi_gabaa.,17	\|\|  Activating golgi_gabaa.ndf\'s dependencies\(dependency list not yet\)
1,golgi_gabaa.,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,golgi_gabaa.,23	\|\|  Activating golgi_gabaa.ndf\'s private models\(private models list not yet\)
1,golgi_gabaa.,23	\|\|  Activating golgi_gabaa.ndf\'s private models\(private models list not yet\)
1,golgi_gabaa.,67	\|\|  Add Public Model\(T_sym_channel,GABAA\)
0,golgi.ndf   ,33	\|\|->End\(.*?/channels/golgi_gabaa.ndf\)
0,golgi.ndf   ,35	\|\|->Dependency file\(.*?/channels/golgi_gabab.ndf\)
1,golgi_gabab.,15	\|\|  ->Dependency file\(.*?/mappers/spikereceiver.ndf\)
1,golgi_gabab.,15	\|\|  .*?/mappers/spikereceiver.ndf is cached\(public model list not yet\)
1,golgi_gabab.,15	\|\|  ->End\(.*?/mappers/spikereceiver.ndf\)
1,golgi_gabab.,17	\|\|  Activating golgi_gabab.ndf\'s dependencies\(dependency list not yet\)
1,golgi_gabab.,21	\|\|  Add Private Model\(T_sym_attachment,Synapse\)
1,golgi_gabab.,23	\|\|  Activating golgi_gabab.ndf\'s private models\(private models list not yet\)
1,golgi_gabab.,23	\|\|  Activating golgi_gabab.ndf\'s private models\(private models list not yet\)
1,golgi_gabab.,67	\|\|  Add Public Model\(T_sym_channel,GABAB\)
0,golgi.ndf   ,35	\|\|->End\(.*?/channels/golgi_gabab.ndf\)
0,golgi.ndf   ,37	\|\|->Dependency file\(.*?/pools/golgi_ca.ndf\)
1,golgi_ca.ndf,29	\|\|  Add Private Model\(T_sym_pool,Ca_concen\)
1,golgi_ca.ndf,31	\|\|  Activating golgi_ca.ndf\'s private models\(private models list not yet\)
1,golgi_ca.ndf,31	\|\|  Activating golgi_ca.ndf\'s private models\(private models list not yet\)
1,golgi_ca.ndf,36	\|\|  Add Public Model\(T_sym_pool,Ca_concen\)
1,golgi_ca.ndf,44	\|\|  Add Public Model\(T_sym_pool,Ca_concen_standalone\)
0,golgi.ndf   ,37	\|\|->End\(.*?/pools/golgi_ca.ndf\)
0,golgi.ndf   ,39	\|\|Activating golgi.ndf\'s dependencies\(dependency list not yet\)
0,golgi.ndf   ,46	\|\|Add Private Model\(T_sym_attachment,SpikeGen\)
0,golgi.ndf   ,48	\|\|Add Private Model\(T_sym_channel,InNa\)
0,golgi.ndf   ,50	\|\|Add Private Model\(T_sym_channel,KDr\)
0,golgi.ndf   ,52	\|\|Add Private Model\(T_sym_channel,KA\)
0,golgi.ndf   ,54	\|\|Add Private Model\(T_sym_channel,CaHVA\)
0,golgi.ndf   ,56	\|\|Add Private Model\(T_sym_channel,H\)
0,golgi.ndf   ,58	\|\|Add Private Model\(T_sym_channel,Moczyd_KC\)
0,golgi.ndf   ,60	\|\|Add Private Model\(T_sym_channel,NMDA\)
0,golgi.ndf   ,62	\|\|Add Private Model\(T_sym_channel,AMPA\)
0,golgi.ndf   ,64	\|\|Add Private Model\(T_sym_channel,GABAA\)
0,golgi.ndf   ,66	\|\|Add Private Model\(T_sym_channel,GABAB\)
0,golgi.ndf   ,68	\|\|Add Private Model\(T_sym_pool,Ca_concen\)
0,golgi.ndf   ,109	\|\|Add Private Model\(T_sym_group,CalciumComplex\)
0,golgi.ndf   ,112	\|\|Activating golgi.ndf\'s private models\(private models list not yet\)
0,golgi.ndf   ,112	\|\|Activating golgi.ndf\'s private models\(private models list not yet\)
0,golgi.ndf   ,353	\|\|Add Public Model\(T_sym_cell,Golgi\)
.*?neurospacesparse: No errors for .*?/cells/golgi.ndf.
', ],
						   timeout => 3,
						   write => undef,
						  },
						 ],
				description => "all reports during parsing",
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
					      'tests/cells/purkinje/edsjb1994.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has algorithm processing been disabled ?",
						   read => 'number_of_algorithm_classes: 7
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
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 0
---
number_of_algorithm_instances: 0
',
						   write => 'algorithmset',
						  },
						 ],
				description => "turning off algorithm processing (1)",
				disabled => (!-e "$ENV{NEUROSPACES_MODELS}/gates/kdr_steadystate.ndf" ? "purkinje cell potassium channels not found" : ""),
			       },
			       {
				arguments => [
					      '-q',
					      '-R',
					      '-A',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Has algorithm processing been disabled ?",
						   read => 'number_of_algorithm_classes: 7
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
    number_of_created_instances: 0
---
name: Grid3DClass
report:
    number_of_created_instances: 0
---
number_of_algorithm_instances: 0
',
						   write => 'algorithmset',
						  },
						 ],
				description => "turning off algorithm processing (2)",
			       },
			       {
				arguments => [
					      '-Q',
					      'expand /*',
					      '-R',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Are single query commands using a command line option processed properly ?",
						   read => 'query: \'expand /*\'
/Golgi
',
						   write => undef,
						  },
						 ],
				description => "processing of a single query machine command using a command line option",
				side_effects => 'query command line options',
			       },
			       {
				arguments => [
					      '-Q',
					      'expand /*',
					      '-Q',
					      'expand /*',
					      '-R',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Are multiple query commands using a command line option processed properly (2) ?",
						   read => 'query: \'expand /*\'
/Golgi
query: \'expand /*\'
/Golgi
',
						   write => undef,
						  },
						 ],
				description => "processing of multiple query machine commands using a command line option (2)",
			       },
			       {
				arguments => [
					      (
					       map
					       {
						   (
						    '-Q',
						    'expand /*'
						   ),
					       }
					       1 .. 10
					      ),
					      '-R',
					      'legacy/cells/golgi.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Are multiple query commands using a command line option processed properly (3) ?",
						   read => 'query: \'expand /*\'
/Golgi
' x 10,
						   write => undef,
						  },
						 ],
				description => "processing of multiple query machine commands using a command line option (3)",
			       },
			       {
				arguments => [
					      '-R',
					      'legacy/networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						 ],
				description => "timings when loading the test network",
				disabled => 'my laziness',
			       },
			      ],
       description => "command line switches",
       name => 'switches.t',
      };


return $test;


