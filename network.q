//printinfo /CerebellarCortex/ForwardProjection
printinfo Golgi::G::Golgi/Golgi_soma
printparameter Golgi::G::Golgi/Golgi_soma/Ca_pool DIA
spikereceivercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse
spikesendercount /CerebellarCortex/ForwardProjection /CerebellarCortex/Granules/1/Granule_soma/spikegen
solverregistrations
targetcount /CerebellarCortex/BackwardProjection /CerebellarCortex/Granules/0/Granule_soma/GABAB/synapse
cellcount /CerebellarCortex/Purkinjes
segmentcount /CerebellarCortex/Purkinjes/0
solverinfo /CerebellarCortex/Purkinjes/0
serialID /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine/head/par
serialID /CerebellarCortex/Purkinjes/0 /CerebellarCortex/Purkinjes/0/segments/b3s46[15]/Purkinje_spine/head/par
serialID /CerebellarCortex/ForwardProjection /CerebellarCortex
printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Xpower
printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Ypower
printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Zpower
printparameterscaled /CerebellarCortex/Golgis/0/Golgi_soma/KDr GMAX
printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr GMAX
printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Ek
printparameter /CerebellarCortex/Golgis/0/Golgi_soma/KDr Emax
printparameter /CerebellarCortex/Golgis/0/Golgi_soma DIA
connectioncount /CerebellarCortex/ForwardProjection
importedfiles
namespaces ::Purkinje::P::thickd::
listsymbols Purkinje::P::thickd::
printinfo Purkinje::P::thickd::Purk_thickd/stellate1
solverset /CerebellarCortex/Granules /Granules
solverset /CerebellarCortex/Golgis /Golgis
solverset /CerebellarCortex/Purkinjes/0 /Purkinje[0]
solverset /CerebellarCortex/Purkinjes/1 /Purkinje[1]
resolvesolver /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine/head/par
solverregistrations
//solverserialID /CerebellarCortex/Granules/0/Granule_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/ParallelFiberProjection
//solverserialID /CerebellarCortex/Purkinjes/Purkinje[0]/segments/main[0]/climb/synapse /CerebellarCortex/ForwardProjection /CerebellarCortex/ParallelFiberProjection
match /Purk /Purk/**
match /Purk1 /Purk/**
match /Purk/soma/gaba/synapse /Purk/soma/**/synapse
printcoordinates /CerebellarCortex /CerebellarCortex/Golgis/0
printcoordinates /CerebellarCortex /CerebellarCortex/Golgis/1
projectionquery c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection
projectionquerycount c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection
projectionquerycount c /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection
serialMapping /CerebellarCortex
serialMapping /CerebellarCortex/Purkinjes /CerebellarCortex/Purkinjes/0/segments/b0s01[1]/Purkinje_spine/neck
serial2context /CerebellarCortex 12
pqset c /CerebellarCortex/ForwardProjection /CerebellarCortex/BackwardProjection /CerebellarCortex/MossyFiberProjection
pqcount n
pqcount n /CerebellarCortex/Golgis/0/Golgi_soma/spikegen
pqcount n /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse
pqcount c
pqcount c /CerebellarCortex/Golgis/0/Golgi_soma/spikegen
pqcount c /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse
//
// obsolete use of solverserialID
//
//solverserialID /CerebellarCortex/ForwardProjection /CerebellarCortex/Purkinjes/Purkinje[1]/segments/b0s01[1]/Purkinje_spine/head/par/synapse
//solverserialID /CerebellarCortex/ForwardProjection /CerebellarCortex/Golgis/0/Golgi_soma/pf_AMPA/synapse
//solverserialID /CerebellarCortex/ForwardProjection /CerebellarCortex/Granules/Granule[0]/Granule_soma/spikegen
//
// snapshot of old output
//
//    Name, index (ForwardProjection,-1)
//    Type (TYPE_HSLE_PROXY)
//        Name, index (GrGoProjection,-1)
//        Type (TYPE_HSLE_PROJECTION)
//        PROJ   Name, index (GrGoProjection,-1)
//        PROJ   Prototype(Undefined)
//            PARA  Name (SOURCE)
//            PARA  Type (TYPE_PARA_SYMBOLIC), Value : /CerebellarCortex/Granules
//            PARA  Name (TARGET)
//            PARA  Type (TYPE_PARA_SYMBOLIC), Value : /CerebellarCortex/Golgis
//        PROJ   --- begin HIER sections ---
//            Name, index (conns1,-1)
//            Type (TYPE_HSLE_VECTOR)
//            VECT   Name, index (conns1,-1)
//            VECT   Prototype(Undefined)
//            VECT   --- begin HIER sections ---
//                Name, index ((null),-1)
//                Type (TYPE_HSLE_CONNECTION)
//                CONN  Serial ID (-1)
//                CONN  Delay, Weight (0.000000,1.000000)
//                    PARA  Name (PRE)
//                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : /Granule[1]/Granule_soma/spikegen
//                    PARA  Name (POST)
//                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : /Golgi[0]/Golgi_soma/pf_AMPA/synapse
//                    PARA  Name (WEIGHT)
//                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                    PARA  Name (DELAY)
//                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//                Name, index ((null),-1)
//                Type (TYPE_HSLE_CONNECTION)
//                CONN  Serial ID (-1)
//                CONN  Delay, Weight (0.000000,1.000000)
//                    PARA  Name (PRE)
//                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : /Granule[0]/Granule_soma/spikegen
//                    PARA  Name (POST)
//                    PARA  Type (TYPE_PARA_SYMBOLIC), Value : /Golgi[0]/Golgi_soma/pf_AMPA/synapse
//                    PARA  Name (WEIGHT)
//                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                    PARA  Name (DELAY)
//                    PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            VECT   ---  end  HIER sections ---
//        PROJ   ---  end  HIER sections ---
//     Name, index (Golgi_soma,-1)
//    Type (TYPE_HSLE_SEGMENT)
//    COMP   Name, index (Golgi_soma,-1)
//    COMP   Prototype(Undefined)
//        PARA  Name (DIA)
//        PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e-05)
//        PARA  Name (Vm_init)
//        PARA  Type (TYPE_PARA_NUMBER), Value(-6.500000e-02)
//        PARA  Name (RM)
//        PARA  Type (TYPE_PARA_NUMBER), Value(3.030000e+00)
//        PARA  Name (RA)
//        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//        PARA  Name (CM)
//        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e-02)
//        PARA  Name (ELEAK)
//        PARA  Type (TYPE_PARA_NUMBER), Value(-5.500000e-02)
//    COMP   --- begin HIER sections ---
//        Name, index (spikegen,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (SpikeGen,-1)
//            Type (TYPE_HSLE_ATTACHMENT)
//            Type (TYPE_HSLE_ATTACHMENT) : no specifics report implemented
//        Name, index (Ca_pool,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (Ca_concen,-1)
//            Type (TYPE_HSLE_POOL)
//            Type (TYPE_HSLE_POOL) : no specifics report implemented
//        Name, index (CaHVA,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (CaHVA,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (CaHVA,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (Xpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(2.000000e+00)
//                PARA  Name (Ypower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                PARA  Name (Zpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//            CHAN   ---  end  HIER sections ---
//        Name, index (H,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (H,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (H,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (Xpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                PARA  Name (Ypower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//                PARA  Name (Zpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//            CHAN   ---  end  HIER sections ---
//        Name, index (InNa,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (InNa,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (InNa,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (Xpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e+00)
//                PARA  Name (Ypower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                PARA  Name (Zpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//            CHAN   ---  end  HIER sections ---
//        Name, index (KA,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (KA,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (KA,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (Xpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(3.000000e+00)
//                PARA  Name (Ypower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                PARA  Name (Zpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//            CHAN   ---  end  HIER sections ---
//        Name, index (KDr,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (KDr,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (KDr,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (Xpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(4.000000e+00)
//                PARA  Name (Ypower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                PARA  Name (Zpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//            CHAN   ---  end  HIER sections ---
//        Name, index (Moczyd_KC,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (Moczyd_KC,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (Moczyd_KC,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (Xindex)
//                PARA  Type (TYPE_PARA_NUMBER), Value(-1.000000e+00)
//                PARA  Name (Xpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
//                PARA  Name (Ypower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//                PARA  Name (Zpower)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//            CHAN   ---  end  HIER sections ---
//        Name, index (pf_AMPA,-1)
//        Type (TYPE_HSLE_PROXY)
//            Name, index (AMPA,-1)
//            Type (TYPE_HSLE_CHANNEL)
//            CHAN   Name, index (AMPA,-1)
//            CHAN   Prototype(Undefined)
//                PARA  Name (GMAX)
//                PARA  Type (TYPE_PARA_NUMBER), Value(3.577338e-01)
//                PARA  Name (Ek)
//                PARA  Type (TYPE_PARA_NUMBER), Value(0.000000e+00)
//            CHAN   --- begin HIER sections ---
//                Name, index (synapse,-1)
//                Type (TYPE_HSLE_PROXY)
//                    Name, index (Synapse,-1)
//                    Type (TYPE_HSLE_ATTACHMENT)
//                    Type (TYPE_HSLE_ATTACHMENT) : no specifics report implemented
//            CHAN   ---  end  HIER sections ---
//    COMP   ---  end  HIER sections ---
// value = 3e-05
// Number of connections : 2
// Number of connections : 1
// Number of affected synapses : 2
// Number of cells : 2
// Number of segments : 4548
// No solver
// serial ID = 854
// serial ID = 17673
// Connection with serial (0)
// Connection with serial (1)
// value = 4
// value = 1
// value = 0
// scaled value = 1.91937e-07
// value = 67.8839
// value = -0.09
// parameter not found in symbol
// value = 3e-05
// Number of connections : 2
// Number of connections : 2
// 
