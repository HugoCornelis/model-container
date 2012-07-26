//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: querymachine.h 1.14 Fri, 12 Oct 2007 12:11:38 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


/*
** query machine support
*/

#ifndef QUERYMACHINE_H
#define QUERYMACHINE_H


#include "neurospaces.h"


typedef
int QueryHandler
    (char *pcLine, int iLength, struct Neurospaces *pneuro, void *pvData);


extern QueryHandler QueryHandlerAlgorithmClass;
extern QueryHandler QueryHandlerAlgorithmInstance;
extern QueryHandler QueryHandlerAlgorithmInstantiate;
extern QueryHandler QueryHandlerAlgorithmSet;
extern QueryHandler QueryHandlerAllocations;
extern QueryHandler QueryHandlerBiogroup2Biolevel;
extern QueryHandler QueryHandlerBiolevel2Biogroup;
extern QueryHandler QueryHandlerContextInfo;
extern QueryHandler QueryHandlerContextSubtract;
extern QueryHandler QueryHandlerCountAliases;
extern QueryHandler QueryHandlerCountAllocatedSymbols;
extern QueryHandler QueryHandlerDelete;
extern QueryHandler QueryHandlerEcho;
extern QueryHandler QueryHandlerExpand;
extern QueryHandler QueryHandlerExport;
extern QueryHandler QueryHandlerInsert;
extern QueryHandler QueryHandlerInputInfo;
extern QueryHandler QueryHandlerHelpCommands;
extern QueryHandler QueryHandlerImportFile;
extern QueryHandler QueryHandlerImportedFiles;
extern QueryHandler QueryHandlerListSymbols;
extern QueryHandler QueryHandlerMesh;
extern QueryHandler QueryHandlerNameSpaces;
extern QueryHandler QueryHandlerPartition;
extern QueryHandler QueryHandlerPidinStackMatch;
extern QueryHandler QueryHandlerPQCount;
extern QueryHandler QueryHandlerPQCountPre;
extern QueryHandler QueryHandlerPQGet;
extern QueryHandler QueryHandlerPQLoad;
extern QueryHandler QueryHandlerPQSave;
extern QueryHandler QueryHandlerPQSet;
extern QueryHandler QueryHandlerPQSetAll;
extern QueryHandler QueryHandlerPQTraverse;
extern QueryHandler QueryHandlerPrintCellCount;
extern QueryHandler QueryHandlerPrintChildren;
extern QueryHandler QueryHandlerPrintConnectionCount;
extern QueryHandler QueryHandlerPrintCoordinates;
extern QueryHandler QueryHandlerPrintInfo;
extern QueryHandler QueryHandlerPrintParameter;
extern QueryHandler QueryHandlerPrintParameterInfo;
extern QueryHandler QueryHandlerPrintParameterInput;
extern QueryHandler QueryHandlerPrintParameterScaled;
extern QueryHandler QueryHandlerPrintParameterSet;
extern QueryHandler QueryHandlerPrintSegmentCount;
extern QueryHandler QueryHandlerPrintSpikeReceiverCount;
extern QueryHandler QueryHandlerPrintSpikeReceiverSerialID;
extern QueryHandler QueryHandlerPrintSpikeSenderCount;
extern QueryHandler QueryHandlerPrintSymbolParameters;
extern QueryHandler QueryHandlerProjectionQuery;
extern QueryHandler QueryHandlerProjectionQueryCount;
extern QueryHandler QueryHandlerRecalculate;
extern QueryHandler QueryHandlerReduce;
extern QueryHandler QueryHandlerResolveSolverID;
extern QueryHandler QueryHandlerSegmenterLinearize;
extern QueryHandler QueryHandlerSegmenterParentCount;
extern QueryHandler QueryHandlerSegmenterSetBase;
extern QueryHandler QueryHandlerSegmenterTips;
extern QueryHandler QueryHandlerSerialID;
extern QueryHandler QueryHandlerSerialMapping;
extern QueryHandler QueryHandlerSerialToContext;
extern QueryHandler QueryHandlerSerializeForestspace;
extern QueryHandler QueryHandlerSetParameter;
extern QueryHandler QueryHandlerSetParameterConcept;
extern QueryHandler QueryHandlerShowParameters;
extern QueryHandler QueryHandlerSolverGet;
extern QueryHandler QueryHandlerSolverRegistrations;
extern QueryHandler QueryHandlerSolverSet;
extern QueryHandler QueryHandlerSymbolPrintParameterTraversal;
extern QueryHandler QueryHandlerValidateSegmentGroup;
extern QueryHandler QueryHandlerVersion;
extern QueryHandler QueryHandlerWriteLibrary;
extern QueryHandler QueryHandlerWriteModular;
extern QueryHandler QueryHandlerWriteSymbol;


int QueryMachineHandle(struct Neurospaces *pneuro, char *pcLine);

int QueryMachineInitialize(struct Neurospaces *pneuro);

void QueryMachineInput(char *pcLine, int iReadline);

void QueryMachineStart(struct Neurospaces *pneuro, int iReadline);


#endif


