#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      '-q',
					      'networks/network-test.ndf',
					     ],
				command => './neurospacesparse',
				command_tests => [
						  {
						   description => "Is neurospaces startup successful ?",
						   read => [ '-re', './neurospacesparse: No errors for .+?/networks/network-test.ndf.', ],
						   timeout => 100,
						   write => undef,
						  },
						  {
						   description => "How many granule cells do we have ?",
						   read => 'Number of cells : 6240
',
						   write => "cellcount /CerebellarCortex/Granules",
						  },
						  {
						   description => "How many compartments do the granule cells have in total ?",
						   read => 'Number of segments : 6240
',
						   write => "segmentcount /CerebellarCortex/Granules",
						  },
						  {
						   description => "How does neurospaces react if we try to access parameters that are not defined ?",
						   read => "parameter not found in symbol
",
						   write => "printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Emax",
						  },
						  {
						   description => "Are all the required files really loaded ?",
						   read => [ '-re', "    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/nmda.ndf\\)
    Imported file : \\(                                                    nmda.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/segments/spines/purkinje.ndf\\)
    Imported file : \\(                                                purkinje.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/segments/purkinje_spinyd.ndf\\)
    Imported file : \\(                                         purkinje_spinyd.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/segments/purkinje_thickd.ndf\\)
    Imported file : \\(                                         purkinje_thickd.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_kc.ndf\\)
    Imported file : \\(                                             purkinje_kc.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_k2.ndf\\)
    Imported file : \\(                                             purkinje_k2.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_cap.ndf\\)
    Imported file : \\(                                            purkinje_cap.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/non_nmda.ndf\\)
    Imported file : \\(                                                non_nmda.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/segments/purkinje_maind.ndf\\)
    Imported file : \\(                                          purkinje_maind.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/pools/purkinje_ca.ndf\\)
    Imported file : \\(                                             purkinje_ca.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_nap.ndf\\)
    Imported file : \\(                                            purkinje_nap.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_naf.ndf\\)
    Imported file : \\(                                            purkinje_naf.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_km.ndf\\)
    Imported file : \\(                                             purkinje_km.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_kdr.ndf\\)
    Imported file : \\(                                            purkinje_kdr.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_ka.ndf\\)
    Imported file : \\(                                             purkinje_ka.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_h2.ndf\\)
    Imported file : \\(                                             purkinje_h2.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_h1.ndf\\)
    Imported file : \\(                                             purkinje_h1.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/purkinje_cat.ndf\\)
    Imported file : \\(                                            purkinje_cat.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/gaba.ndf\\)
    Imported file : \\(                                                    gaba.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/segments/purkinje_soma.ndf\\)
    Imported file : \\(                                           purkinje_soma.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/cells/purk2m9s.ndf\\)
    Imported file : \\(                                                purk2m9s.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/populations/purkinje.ndf\\)
    Imported file : \\(                                                purkinje.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/pools/granule_ca.ndf\\)
    Imported file : \\(                                              granule_ca.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_gabab.ndf\\)
    Imported file : \\(                                           granule_gabab.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_gabaa.ndf\\)
    Imported file : \\(                                           granule_gabaa.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_ampa.ndf\\)
    Imported file : \\(                                            granule_ampa.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_nmda.ndf\\)
    Imported file : \\(                                            granule_nmda.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_kc.ndf\\)
    Imported file : \\(                                              granule_kc.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_h.ndf\\)
    Imported file : \\(                                               granule_h.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_cahva.ndf\\)
    Imported file : \\(                                           granule_cahva.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_ka.ndf\\)
    Imported file : \\(                                              granule_ka.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_kdr.ndf\\)
    Imported file : \\(                                             granule_kdr.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/granule_inna.ndf\\)
    Imported file : \\(                                            granule_inna.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/cells/granule.ndf\\)
    Imported file : \\(                                                 granule.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/populations/granule.ndf\\)
    Imported file : \\(                                                 granule.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/pools/golgi_ca.ndf\\)
    Imported file : \\(                                                golgi_ca.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_gabab.ndf\\)
    Imported file : \\(                                             golgi_gabab.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_gabaa.ndf\\)
    Imported file : \\(                                             golgi_gabaa.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_ampa.ndf\\)
    Imported file : \\(                                              golgi_ampa.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/mappers/spikereceiver.ndf\\)
    Imported file : \\(                                           spikereceiver.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_nmda.ndf\\)
    Imported file : \\(                                              golgi_nmda.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_kc.ndf\\)
    Imported file : \\(                                                golgi_kc.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_h.ndf\\)
    Imported file : \\(                                                 golgi_h.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_cahva.ndf\\)
    Imported file : \\(                                             golgi_cahva.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_ka.ndf\\)
    Imported file : \\(                                                golgi_ka.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_kdr.ndf\\)
    Imported file : \\(                                               golgi_kdr.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/channels/golgi_inna.ndf\\)
    Imported file : \\(                                              golgi_inna.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/cells/golgi.ndf\\)
    Imported file : \\(                                                   golgi.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/populations/golgi.ndf\\)
    Imported file : \\(                                                   golgi.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/mappers/spikegenerator.ndf\\)
    Imported file : \\(                                          spikegenerator.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/fibers/mossyfiber.ndf\\)
    Imported file : \\(                                              mossyfiber.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000000\\)
    Parse Method : \\(no info\\)

    
    
    ------------------------------------------------------------------------------
    Imported file : \\(.+?/networks/network-test.ndf\\)
    Imported file : \\(                                            network-test.ndf\\)
    ------------------------------------------------------------------------------
    Flags : \\(00000001\\)
	Root imported file
    Parse Method : \\(no info\\)

", ],
						   timeout => 10,
						   write => "importedfiles",
						  },
						  {
						   description => "What is the namespace mapping of the thick dendrite of the Purkinje cells ?",
						   read => [ '-re', "File \\(.+?/pools/purkinje_ca.ndf\\) --> Namespace \\(Ca_pool::\\)
File \\(.+?/channels/purkinje_km.ndf\\) --> Namespace \\(KM::\\)
File \\(.+?/channels/purkinje_kdr.ndf\\) --> Namespace \\(Kdr::\\)
File \\(.+?/channels/purkinje_kc.ndf\\) --> Namespace \\(KC::\\)
File \\(.+?/channels/purkinje_ka.ndf\\) --> Namespace \\(KA::\\)
File \\(.+?/channels/purkinje_k2.ndf\\) --> Namespace \\(K2::\\)
File \\(.+?/channels/purkinje_cat.ndf\\) --> Namespace \\(CaT::\\)
File \\(.+?/channels/purkinje_cap.ndf\\) --> Namespace \\(CaP::\\)
File \\(.+?/channels/non_nmda.ndf\\) --> Namespace \\(non_NMDA::\\)
File \\(.+?/channels/gaba.ndf\\) --> Namespace \\(GABA::\\)
", ],
						   write => "namespaces ::Purkinje::P::thickd::",
						  },
						  {
						   description => "What symbols/channels are defined in the namespace of the thick dendrite of the Purkinje cells ?",
						   read => [ '-re', "Imported file : \\(.+?/segments/purkinje_thickd.ndf\\)
Imported file : \\(                                         purkinje_thickd.ndf\\)
------------------------------------------------------------------------------
Flags : \\(00000000\\)
Parse Method : \\(no info\\)



    PRIVATE_MODELS

            Name, index \\(GABA,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(GABA,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(Purk_GABA,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.077000e\\+00\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.000000e-02\\)
                channe\\{-- begin HIER sections ---
                    Name, index \\(synapse,-1\\)
                    Type \\(T_sym_attachment\\)
                    attachName, index \\(synapse,-1\\)
                    attach\\{-- begin HIER sections ---
                    attach\\}--  end  HIER sections ---
                        attachName, index \\(Synapse,-1\\)
                        attach\\{-- begin HIER sections ---
                        attach\\}--  end  HIER sections ---
                            attachName, index \\(Synapse,-1\\)
                                PARA  Name \\(weight\\)
                                PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                PARA  Name \\(delay\\)
                                PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                            attach\\{-- begin HIER sections ---
                            attach\\}--  end  HIER sections ---
                    Name, index \\(exp2,-1\\)
                    Type \\(T_sym_equation\\)
                    equatiName, index \\(exp2,-1\\)
                        PARA  Name \\(TAU1\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(9.300000e-04\\)
                        PARA  Name \\(TAU2\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.650000e-02\\)
                    equati\\{-- begin HIER sections ---
                    equati\\}--  end  HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(non_NMDA,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(non_NMDA,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(Purk_non_NMDA,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.077000e\\+00\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                    Name, index \\(synapse,-1\\)
                    Type \\(T_sym_attachment\\)
                    attachName, index \\(synapse,-1\\)
                    attach\\{-- begin HIER sections ---
                    attach\\}--  end  HIER sections ---
                        attachName, index \\(Synapse,-1\\)
                        attach\\{-- begin HIER sections ---
                        attach\\}--  end  HIER sections ---
                            attachName, index \\(Synapse,-1\\)
                                PARA  Name \\(weight\\)
                                PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                PARA  Name \\(delay\\)
                                PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                            attach\\{-- begin HIER sections ---
                            attach\\}--  end  HIER sections ---
                    Name, index \\(exp2,-1\\)
                    Type \\(T_sym_equation\\)
                    equatiName, index \\(exp2,-1\\)
                        PARA  Name \\(TAU1\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(5.000000e-04\\)
                        PARA  Name \\(TAU2\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.200000e-03\\)
                    equati\\{-- begin HIER sections ---
                    equati\\}--  end  HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(CaP,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(CaP,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(CaP,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(CaT,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(CaT,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(CaT,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(K2,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(K2,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(K2,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(KA,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(KA,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(KA,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(KC,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(KC,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(KC,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(Kdr,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(Kdr,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(Kdr,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(KM,-1\\)
            Type \\(T_sym_channel\\)
            channeName, index \\(KM,-1\\)
            channe\\{-- begin HIER sections ---
            channe\\}--  end  HIER sections ---
                channeName, index \\(KM,-1\\)
                    PARA  Name \\(Xpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                    PARA  Name \\(Ypower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                    PARA  Name \\(Zpower\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
            Name, index \\(Ca_pool,-1\\)
            Type \\(T_sym_pool\\)
            pool  Name, index \\(Ca_pool,-1\\)
            pool  \\{-- begin HIER sections ---
            pool  \\}--  end  HIER sections ---
                pool  Name, index \\(Ca_concen,-1\\)
                pool  \\{-- begin HIER sections ---
                pool  \\}--  end  HIER sections ---
                    pool  Name, index \\(Ca_concen,-1\\)
                        PARA  Name \\(concen_init\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e-05\\)
                        PARA  Name \\(BASE\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e-05\\)
                        PARA  Name \\(TAU\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e-04\\)
                        PARA  Name \\(VAL\\)
                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                        PARA  Name \\(DIA\\)
                        PARA  Type \\(TYPE_PARA_FUNCTION\\), Value\\(MAXIMUM\\)
                            FUNC  Name \\(MAXIMUM\\)
                                PARA  Name \\(value1\\)
                                PARA  Type \\(TYPE_PARA_FIELD\\), Value : ..->DIA
                                PARA  Name \\(value2\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e-07\\)
                        PARA  Name \\(LENGTH\\)
                        PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\.->LENGTH
                        PARA  Name \\(THICK\\)
                        PARA  Type \\(TYPE_PARA_FUNCTION\\), Value\\(HIGHER\\)
                            FUNC  Name \\(HIGHER\\)
                                PARA  Name \\(value\\)
                                PARA  Type \\(TYPE_PARA_FIELD\\), Value : ..->DIA
                                PARA  Name \\(comparator\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e-07\\)
                                PARA  Name \\(result1\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e-07\\)
                                PARA  Name \\(result2\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e-08\\)
                    pool  \\{-- begin HIER sections ---
                    pool  \\}--  end  HIER sections ---

    END PRIVATE_MODELS


    PUBLIC_MODELS

            Name, index \\(Purk_thickd,-1\\)
            Type \\(T_sym_segment\\)
            segmenName, index \\(Purk_thickd,-1\\)
                PARA  Name \\(Vm_init\\)
                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-6.800000e-02\\)
                PARA  Name \\(RM\\)
                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(3.000000e\\+00\\)
                PARA  Name \\(RA\\)
                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.500000e\\+00\\)
                PARA  Name \\(CM\\)
                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.640000e-02\\)
                PARA  Name \\(ELEAK\\)
                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.000000e-02\\)
            segmen\\{-- begin HIER sections ---
                Name, index \\(Ca_pool,-1\\)
                Type \\(T_sym_pool\\)
                pool  Name, index \\(Ca_pool,-1\\)
                pool  \\{-- begin HIER sections ---
                pool  \\}--  end  HIER sections ---
                    pool  Name, index \\(Ca_pool,-1\\)
                    pool  \\{-- begin HIER sections ---
                    pool  \\}--  end  HIER sections ---
                        pool  Name, index \\(Ca_concen,-1\\)
                        pool  \\{-- begin HIER sections ---
                        pool  \\}--  end  HIER sections ---
                            pool  Name, index \\(Ca_concen,-1\\)
                                PARA  Name \\(concen_init\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e-05\\)
                                PARA  Name \\(BASE\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e-05\\)
                                PARA  Name \\(TAU\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e-04\\)
                                PARA  Name \\(VAL\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                                PARA  Name \\(DIA\\)
                                PARA  Type \\(TYPE_PARA_FUNCTION\\), Value\\(MAXIMUM\\)
                                    FUNC  Name \\(MAXIMUM\\)
                                        PARA  Name \\(value1\\)
                                        PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\.->DIA
                                        PARA  Name \\(value2\\)
                                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e-07\\)
                                PARA  Name \\(LENGTH\\)
                                PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\.->LENGTH
                                PARA  Name \\(THICK\\)
                                PARA  Type \\(TYPE_PARA_FUNCTION\\), Value\\(HIGHER\\)
                                    FUNC  Name \\(HIGHER\\)
                                        PARA  Name \\(value\\)
                                        PARA  Type \\(TYPE_PARA_FIELD\\), Value : ..->DIA
                                        PARA  Name \\(comparator\\)
                                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.000000e-07\\)
                                        PARA  Name \\(result1\\)
                                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e-07\\)
                                        PARA  Name \\(result2\\)
                                        PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e-08\\)
                            pool  \\{-- begin HIER sections ---
                            pool  \\}--  end  HIER sections ---
                Name, index \\(CaT,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(CaT,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(5.000000e\\+00\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_FUNCTION\\), Value\\(NERNST\\)
                        FUNC  Name \\(NERNST\\)
                            PARA  Name \\(Cin\\)
                            PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\./Ca_pool->concen
                            PARA  Name \\(Cout\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.400000e\\+00\\)
                            PARA  Name \\(valency\\)
                            PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\./Ca_pool->VAL
                            PARA  Name \\(T\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(3.700000e\\+01\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(CaT,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(CaT,-1\\)
                            PARA  Name \\(Xpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Ypower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Zpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                        channe\\{-- begin HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(CaP,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(CaP,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(4.500000e\\+01\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_FUNCTION\\), Value\\(NERNST\\)
                        FUNC  Name \\(NERNST\\)
                            PARA  Name \\(Cin\\)
                            PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\./Ca_pool->concen
                            PARA  Name \\(Cout\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.400000e\\+00\\)
                            PARA  Name \\(valency\\)
                            PARA  Type \\(TYPE_PARA_FIELD\\), Value : \\.\\./Ca_pool->VAL
                            PARA  Name \\(T\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(3.700000e\\+01\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(CaP,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(CaP,-1\\)
                            PARA  Name \\(Xpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Ypower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Zpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                        channe\\{-- begin HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(KC,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(KC,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(8.000000e\\+02\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.500000e-02\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(KC,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(KC,-1\\)
                            PARA  Name \\(Xpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Ypower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                            PARA  Name \\(Zpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                        channe\\{-- begin HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(K2,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(K2,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(3.900000e\\+00\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.500000e-02\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(K2,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(K2,-1\\)
                            PARA  Name \\(Xpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Ypower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                            PARA  Name \\(Zpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.000000e\\+00\\)
                        channe\\{-- begin HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(KM,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(KM,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.300000e-01\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.500000e-02\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(KM,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(KM,-1\\)
                            PARA  Name \\(Xpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.000000e\\+00\\)
                            PARA  Name \\(Ypower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                            PARA  Name \\(Zpower\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                        channe\\{-- begin HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(stellate1,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(stellate1,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.400000e\\+01\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.000000e-02\\)
                    PARA  Name \\(FREQUENCY\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(GABA,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(Purk_GABA,-1\\)
                            PARA  Name \\(GMAX\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.077000e\\+00\\)
                            PARA  Name \\(Erev\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.000000e-02\\)
                        channe\\{-- begin HIER sections ---
                            Name, index \\(synapse,-1\\)
                            Type \\(T_sym_attachment\\)
                            attachName, index \\(synapse,-1\\)
                            attach\\{-- begin HIER sections ---
                            attach\\}--  end  HIER sections ---
                                attachName, index \\(Synapse,-1\\)
                                attach\\{-- begin HIER sections ---
                                attach\\}--  end  HIER sections ---
                                    attachName, index \\(Synapse,-1\\)
                                        PARA  Name \\(weight\\)
                                        PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                        PARA  Name \\(delay\\)
                                        PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                    attach\\{-- begin HIER sections ---
                                    attach\\}--  end  HIER sections ---
                            Name, index \\(exp2,-1\\)
                            Type \\(T_sym_equation\\)
                            equatiName, index \\(exp2,-1\\)
                                PARA  Name \\(TAU1\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(9.300000e-04\\)
                                PARA  Name \\(TAU2\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.650000e-02\\)
                            equati\\{-- begin HIER sections ---
                            equati\\}--  end  HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(stellate2,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(stellate2,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.400000e\\+01\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.000000e-02\\)
                    PARA  Name \\(FREQUENCY\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(GABA,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(Purk_GABA,-1\\)
                            PARA  Name \\(GMAX\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.077000e\\+00\\)
                            PARA  Name \\(Erev\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(-8.000000e-02\\)
                        channe\\{-- begin HIER sections ---
                            Name, index \\(synapse,-1\\)
                            Type \\(T_sym_attachment\\)
                            attachName, index \\(synapse,-1\\)
                            attach\\{-- begin HIER sections ---
                            attach\\}--  end  HIER sections ---
                                attachName, index \\(Synapse,-1\\)
                                attach\\{-- begin HIER sections ---
                                attach\\}--  end  HIER sections ---
                                    attachName, index \\(Synapse,-1\\)
                                        PARA  Name \\(weight\\)
                                        PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                        PARA  Name \\(delay\\)
                                        PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                    attach\\{-- begin HIER sections ---
                                    attach\\}--  end  HIER sections ---
                            Name, index \\(exp2,-1\\)
                            Type \\(T_sym_equation\\)
                            equatiName, index \\(exp2,-1\\)
                                PARA  Name \\(TAU1\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(9.300000e-04\\)
                                PARA  Name \\(TAU2\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(2.650000e-02\\)
                            equati\\{-- begin HIER sections ---
                            equati\\}--  end  HIER sections ---
                        channe\\}--  end  HIER sections ---
                Name, index \\(climb,-1\\)
                Type \\(T_sym_channel\\)
                channeName, index \\(climb,-1\\)
                    PARA  Name \\(GMAX\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.500000e\\+02\\)
                    PARA  Name \\(Erev\\)
                    PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                channe\\{-- begin HIER sections ---
                channe\\}--  end  HIER sections ---
                    channeName, index \\(non_NMDA,-1\\)
                    channe\\{-- begin HIER sections ---
                    channe\\}--  end  HIER sections ---
                        channeName, index \\(Purk_non_NMDA,-1\\)
                            PARA  Name \\(GMAX\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.077000e\\+00\\)
                            PARA  Name \\(Erev\\)
                            PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(0.000000e\\+00\\)
                        channe\\{-- begin HIER sections ---
                            Name, index \\(synapse,-1\\)
                            Type \\(T_sym_attachment\\)
                            attachName, index \\(synapse,-1\\)
                            attach\\{-- begin HIER sections ---
                            attach\\}--  end  HIER sections ---
                                attachName, index \\(Synapse,-1\\)
                                attach\\{-- begin HIER sections ---
                                attach\\}--  end  HIER sections ---
                                    attachName, index \\(Synapse,-1\\)
                                        PARA  Name \\(weight\\)
                                        PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                        PARA  Name \\(delay\\)
                                        PARA  Type \\(TYPE_PARA_ATTRIBUTE\\), 
                                    attach\\{-- begin HIER sections ---
                                    attach\\}--  end  HIER sections ---
                            Name, index \\(exp2,-1\\)
                            Type \\(T_sym_equation\\)
                            equatiName, index \\(exp2,-1\\)
                                PARA  Name \\(TAU1\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(5.000000e-04\\)
                                PARA  Name \\(TAU2\\)
                                PARA  Type \\(TYPE_PARA_NUMBER\\), Value\\(1.200000e-03\\)
                            equati\\{-- begin HIER sections ---
                            equati\\}--  end  HIER sections ---
                        channe\\}--  end  HIER sections ---
            segmen\\}--  end  HIER sections ---

    END PUBLIC_MODELS
", ],
						   timeout => 10,
						   write => "listsymbols Purkinje::P::thickd::",
						  },
						  {
						   description => "What are the parameters for the stellate synaptic channels of the Purkinje cells ?",
						   read => "    Name, index (stellate1,-1)
    Type (T_sym_channel)
    channeName, index (stellate1,-1)
        PARA  Name (GMAX)
        PARA  Type (TYPE_PARA_NUMBER), Value(1.400000e+01)
        PARA  Name (Erev)
        PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
        PARA  Name (FREQUENCY)
        PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
    channe{-- begin HIER sections ---
    channe}--  end  HIER sections ---
        channeName, index (GABA,-1)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (Purk_GABA,-1)
                PARA  Name (GMAX)
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
						   write => "printinfo Purkinje::P::thickd::Purk_thickd/stellate1",
						  },
						  {
						   description => "Can we create new namespaces, for cached files ?",
						   read => "importing file ok
",
						   write => "importfile /tmp/neurospaces/test/models/segments/spines/purkinje.ndf spines_imported",
						  },
						  {
						   description => "Does the created namespace contain symbols ?",
						   read => "    Name, index (par,-1)
    Type (T_sym_channel)
    channeName, index (par,-1)
        PARA  Name (GMAX)
        PARA  Type (TYPE_PARA_NUMBER), Value(7.500000e+02)
        PARA  Name (Erev)
        PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
        PARA  Name (FREQUENCY)
        PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
    channe{-- begin HIER sections ---
    channe}--  end  HIER sections ---
        channeName, index (NMDA,-1)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (NMDA,-1)
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
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.000000e-04)
                    PARA  Name (TAU2)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.200000e-03)
                equati{-- begin HIER sections ---
                equati}--  end  HIER sections ---
            channe}--  end  HIER sections ---
",
						   write => "printinfo spines_imported::/Purk_spine/head/par",
						  },
						 ],
				description => "network model : file loading",
			       },
			      ],
       description => "file loading",
       name => 'files.t',
      };


return $test;


