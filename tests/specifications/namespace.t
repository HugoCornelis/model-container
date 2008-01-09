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

						  # tests taken from network.t

						  (
						   {
						    description => "Is the Golgi cell loaded in an appropriate namespace ?",
						    read => '    Name, index (Golgi_soma,-1)
    Type (T_sym_segment)
    segmenName, index (Golgi_soma,-1)
        PARA  Name (ELEAK)
        PARA  Type (TYPE_PARA_FIELD), Value : ..->ELEAK
        PARA  Name (DIA)
        PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e-05)
        PARA  Name (Vm_init)
        PARA  Type (TYPE_PARA_NUMBER), Value(-6.500000e-02)
        PARA  Name (RM)
        PARA  Type (TYPE_PARA_NUMBER), Value(3.030000e+00)
        PARA  Name (RA)
        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
        PARA  Name (CM)
        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e-02)
        PARA  Name (ELEAK)
        PARA  Type (TYPE_PARA_NUMBER), Value(-5.500000e-02)
    segmen{-- begin HIER sections ---
        Name, index (spikegen,-1)
        Type (T_sym_attachment)
        attachName, index (spikegen,-1)
            PARA  Name (THRESHOLD)
            PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e-02)
            PARA  Name (REFRACTORY)
            PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e-03)
        attach{-- begin HIER sections ---
        attach}--  end  HIER sections ---
            attachName, index (SpikeGen,-1)
            attach{-- begin HIER sections ---
            attach}--  end  HIER sections ---
                attachName, index (SpikeGen,-1)
                    PARA  Name (THRESHOLD)
                    PARA  Type (TYPE_PARA_ATTRIBUTE), 
                    PARA  Name (REFRACTORY)
                    PARA  Type (TYPE_PARA_ATTRIBUTE), 
                attach{-- begin HIER sections ---
                attach}--  end  HIER sections ---
        Name, index (Ca_pool,-1)
        Type (T_sym_pool)
        pool  Name, index (Ca_pool,-1)
        pool  {-- begin HIER sections ---
        pool  }--  end  HIER sections ---
            pool  Name, index (Ca_concen,-1)
            pool  {-- begin HIER sections ---
            pool  }--  end  HIER sections ---
                pool  Name, index (Ca_concen,-1)
                pool  {-- begin HIER sections ---
                pool  }--  end  HIER sections ---
                    pool  Name, index (Ca_concen,-1)
                        PARA  Name (concen_init)
                        PARA  Type (TYPE_PARA_NUMBER), Value(7.550000e-05)
                        PARA  Name (BASE)
                        PARA  Type (TYPE_PARA_NUMBER), Value(7.550000e-05)
                        PARA  Name (TAU)
                        PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e-01)
                        PARA  Name (VAL)
                        PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e+00)
                        PARA  Name (DIA)
                        PARA  Type (TYPE_PARA_FIELD), Value : ..->DIA
                        PARA  Name (LENGTH)
                        PARA  Type (TYPE_PARA_FIELD), Value : ..->LENGTH
                        PARA  Name (THICK)
                        PARA  Type (TYPE_PARA_NUMBER), Value(6.000000e-07)
                        PARA  Name (BETA)
                        PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                            FUNC  Name (FIXED)
                                PARA  Name (value)
                                PARA  Type (TYPE_PARA_NUMBER), Value(2.023795e+10)
                                PARA  Name (scale)
                                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    pool  {-- begin HIER sections ---
                    pool  }--  end  HIER sections ---
        Name, index (CaHVA,-1)
        Type (T_sym_channel)
        channeName, index (CaHVA,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_FIELD), Value : ../..->GMAX
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(8.317569e+00)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_FUNCTION), Value(NERNST)
                FUNC  Name (NERNST)
                    PARA  Name (Cin)
                    PARA  Type (TYPE_PARA_FIELD), Value : ../Ca_pool->concen
                    PARA  Name (Cout)
                    PARA  Type (TYPE_PARA_NUMBER), Value(2.400000e+00)
                    PARA  Name (valency)
                    PARA  Type (TYPE_PARA_FIELD), Value : ../Ca_pool->VAL
                    PARA  Name (T)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.700000e+01)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (CaHVA,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (CaHVA,-1)
                    PARA  Name (Xpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e+00)
                    PARA  Name (Ypower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (Zpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                channe{-- begin HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (H,-1)
        Type (T_sym_channel)
        channeName, index (H,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(1.714963e+00)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(-4.200000e-02)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (H,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (H,-1)
                    PARA  Name (Xpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (Ypower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (Zpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                channe{-- begin HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (InNa,-1)
        Type (T_sym_channel)
        channeName, index (InNa,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(4.001580e+02)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(5.500000e-02)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (InNa,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (InNa,-1)
                    PARA  Name (Xpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e+00)
                    PARA  Name (Ypower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (Zpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                channe{-- begin HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (KA,-1)
        Type (T_sym_channel)
        channeName, index (KA,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(5.244928e+00)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(-9.000000e-02)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (KA,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (KA,-1)
                    PARA  Name (Xpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e+00)
                    PARA  Name (Ypower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (Zpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                channe{-- begin HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (KDr,-1)
        Type (T_sym_channel)
        channeName, index (KDr,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(6.788394e+01)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(-9.000000e-02)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (KDr,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (KDr,-1)
                    PARA  Name (Xpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(4.000000e+00)
                    PARA  Name (Ypower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (Zpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                channe{-- begin HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (Moczyd_KC,-1)
        Type (T_sym_channel)
        channeName, index (Moczyd_KC,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(5.716543e+00)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(-9.000000e-02)
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (Moczyd_KC,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (Moczyd_KC,-1)
                    PARA  Name (Xindex)
                    PARA  Type (TYPE_PARA_NUMBER), Value(-1.000000e+00)
                    PARA  Name (Xpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (Ypower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                    PARA  Name (Zpower)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
                channe{-- begin HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (mf_AMPA,-1)
        Type (T_sym_channel)
        channeName, index (mf_AMPA,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.577338e-01)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (NORMALIZE)
            PARA  Type (TYPE_PARA_FUNCTION), Value(SUM)
                FUNC  Name (SUM)
                    PARA  Name (COUNT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : synapse
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (AMPA,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (AMPA,-1)
                    PARA  Name (GMAX)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.577338e-01)
                    PARA  Name (Erev)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
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
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.500000e-03)
                        PARA  Name (TAU2)
                        PARA  Type (TYPE_PARA_NUMBER), Value(9.000000e-05)
                    equati{-- begin HIER sections ---
                    equati}--  end  HIER sections ---
                channe}--  end  HIER sections ---
        Name, index (pf_AMPA,-1)
        Type (T_sym_channel)
        channeName, index (pf_AMPA,-1)
            PARA  Name (GMAX)
            PARA  Type (TYPE_PARA_NUMBER), Value(3.577338e-01)
            PARA  Name (Erev)
            PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
            PARA  Name (NORMALIZE)
            PARA  Type (TYPE_PARA_FUNCTION), Value(SUM)
                FUNC  Name (SUM)
                    PARA  Name (COUNT)
                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : synapse
        channe{-- begin HIER sections ---
        channe}--  end  HIER sections ---
            channeName, index (AMPA,-1)
            channe{-- begin HIER sections ---
            channe}--  end  HIER sections ---
                channeName, index (AMPA,-1)
                    PARA  Name (GMAX)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.577338e-01)
                    PARA  Name (Erev)
                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
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
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.500000e-03)
                        PARA  Name (TAU2)
                        PARA  Type (TYPE_PARA_NUMBER), Value(9.000000e-05)
                    equati{-- begin HIER sections ---
                    equati}--  end  HIER sections ---
                channe}--  end  HIER sections ---
    segmen}--  end  HIER sections ---
',
						    timeout => 5,
						    write => "printinfo Golgi::G::Golgi/Golgi_soma",
						   },
						   #t 			  {
						   #t 			   description => "Has the calcium pool in the Golgi cell a correct diameter ?",
						   #t 			   read => '1.27212e-08',
						   #t 			   write => "printparameter Golgi::G::Golgi/Golgi_soma/Ca_pool DIA",
						   #t 			  },
						  {
						   description => "What is the treespaces ID of a synaptic channel on a spine of the second Purkinje cell ?",
						   read => "serial ID = 25522
",
						   write => "serialID /CerebellarCortex/Purkinjes/1 /CerebellarCortex/Purkinjes/1/segments/b3s46[15]/Purkinje_spine_0/head/par",
						  },
						  ),
						  (
						   {
						    description => "What is the serial mapping for the fifth Purkine cell ?",
						    read => "Traversal serial ID = 265331
Principal serial ID = 265331 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /CerebellarCortex/Purkinjes/5"
						   },
						   {
						    description => "What is the serial mapping for the fifth Purkine cell when referenced with a parent reference ?",
						    read => "Traversal serial ID = 265331
Principal serial ID = 265331 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /CerebellarCortex/Purkinjes/5/segments/.."
						   },
						   {
						    description => "What is the serial mapping for the fifth Purkine cell segments ?",
						    read => "Traversal serial ID = 265332
Principal serial ID = 265332 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /CerebellarCortex/Purkinjes/5/segments"
						   },
						   {
						    description => "What is the serial mapping for the fifth Purkine cell segments when referenced using a parent reference ?",
						    read => "Traversal serial ID = 265332
Principal serial ID = 265332 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /CerebellarCortex/Purkinjes/5/segments/../segments"
						   },
						   {
						    description => "What is the serial mapping for the fifth Purkine cell when referenced using two parent references ?",
						    read => "Traversal serial ID = 265331
Principal serial ID = 265331 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /CerebellarCortex/Purkinjes/5/segments/soma/../.."
						   },
						   {
						    description => "Do we get an error if we try to reference a symbol that does not exist using parent references ?",
						    read => "symbol not found
",
						    write => "serialMapping /CerebellarCortex/Purkinjes/5/segments/soma/../../soma"
						   },
						   {
						    description => "What is the serial mapping for a symbol that does exist using parent references, yet with one intermediate reference to a symbol that does not exist ?",
						    read => "Traversal serial ID = 265331
Principal serial ID = 265331 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /CerebellarCortex/a_non_existent_population/../Purkinjes/5"
						   },
						   {
						    description => "What is the serial mapping for a symbol that does exist using parent references, yet with intermediate references to symbols that do not exist ?",
						    read => "Traversal serial ID = 265331
Principal serial ID = 265331 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping /a_non_existent_network/a_non_existent_population/../../CerebellarCortex/Purkinjes/5"
						   },
						   {
						    description => "What is the serial mapping for a symbol that does exist using parent references, yet with intermediate references to symbols that do not exist and using the root namespace operator ?",
						    read => "Traversal serial ID = 265331
Principal serial ID = 265331 of 439542 Principal successors
",
# Mechanism serial ID = 133390 of 146304 Mechanism successors
# Segment  serial  ID = 29000 of 33548  Segment  successors
						    write => "serialMapping ::/a_non_existent_network/a_non_existent_population/../../CerebellarCortex/Purkinjes/5"
						   },
						  ),
						 ],
				description => "parent context parsing",
			       },
			      ],
       description => "context and namespace definitions",
       name => 'namespace.t',
      };


return $test;


