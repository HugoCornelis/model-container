//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connectionsymbol.c 1.12 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Neurospaces : testbed C implementation that integrates with genesis
//'
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>


#include "neurospaces/connectionsymbol.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: ConnectionSymbolCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_ConnectionSymbol * 
///
///	Newly allocated connection, NULL for failure
///
/// DESCR: Allocate a new connection symbol table element
///
/// **************************************************************************

struct symtab_ConnectionSymbol * ConnectionSymbolCalloc(void)
{
    //- set default result : failure

    struct symtab_ConnectionSymbol *pconsyResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/connection_symbol_vtable.c"

    //- allocate connection

    pconsyResult
	= (struct symtab_ConnectionSymbol *)
	  SymbolCalloc(1, sizeof(struct symtab_ConnectionSymbol), _vtable_connection_symbol, HIERARCHY_TYPE_symbols_connection_symbol);

    //- initialize connection

    ConnectionSymbolInit(pconsyResult);

    //- return result

    return(pconsyResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolGetSpikeGenerator()
///
/// ARGS.:
///
///	pconsy: connection with spike generator reference
///	phsle.: symbol relative to which connection occurs (== population)
///	ppist.: context of connection (== population)
///
/// RTN..: struct PidinStack *
///
///	spike generator, -1 for failure, NULL for none
///
/// DESCR: Get spike generator for connection
///
///	ppist is context of source of projection to which this connection
///	belongs, phsle is referred to by ppist.
///
/// **************************************************************************

struct PidinStack *
ConnectionSymbolGetSpikeGenerator
(struct symtab_ConnectionSymbol *pconsy,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- init result : context of connection

    struct PidinStack *ppistResult
	= PidinStackDuplicate(ppist);

    return(NULL);

/*     //- transform connection pre-synaptic serial ID to context */

/*     struct PidinStack *ppistPre */
/* 	= SymbolPrincipalSerial2Context */
/* 	  (phsle,ppist,ConnectionSymbolGetPrePrincipalSerial(pconsy)); */

/*     //- append stacks */

/*     if (PidinStackAppendCompact(ppistResult,ppistPre)) */
/*     { */
/* 	//- ok */
/*     } */
/*     else */
/*     { */
/* 	PidinStackFree(ppistResult); */

/* 	ppistResult = NULL; */
/*     } */

/*     //- free connection pre-synaptic stack */

/*     PidinStackFree(ppistPre); */

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolGetSpikeReceiver()
///
/// ARGS.:
///
///	pconsy: connection with spike receiver reference
///	phsle.: symbol relative to which connection occurs (== population)
///	ppist.: context of connection (== population)
///
/// RTN..: struct PidinStack *
///
///	spike receiver, -1 for failure, NULL for none
///
/// DESCR: Get spike receiver for connection
///
///	ppist is context of target of projection to which this connection
///	belongs, phsle is referred to by ppist.
///
/// **************************************************************************

struct PidinStack *
ConnectionSymbolGetSpikeReceiver
(struct symtab_ConnectionSymbol *pconsy,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- init result : context of connection

    struct PidinStack *ppistResult
	= PidinStackDuplicate(ppist);

    return(NULL);

/*     //- transform connection post-synaptic serial ID to context */

/*     struct PidinStack *ppistPost */
/* 	= SymbolPrincipalSerial2Context */
/* 	  (phsle,ppist,ConnectionSymbolGetPostPrincipalSerial(pconsy)); */

/*     //- append stacks */

/*     if (PidinStackAppendCompact(ppistResult,ppistPost)) */
/*     { */
/* 	//- ok */
/*     } */
/*     else */
/*     { */
/* 	PidinStackFree(ppistResult); */

/* 	ppistResult = NULL; */
/*     } */

/*     //- free connection post-synaptic stack */

/*     PidinStackFree(ppistPost); */

    //- return result

    return(ppistResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolInit()
///
/// ARGS.:
///
///	pconsy.: connection to init
///
/// RTN..: void
///
/// DESCR: init connection
///
/// **************************************************************************

//v next identifier for any connection

static int iStaticPidin = 1;

void ConnectionSymbolInit(struct symtab_ConnectionSymbol *pconsy)
{
    //- initialize base symbol

    BioComponentInit(&pconsy->bio);

    //- set type

    pconsy->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_connection_symbol;

    //- initialize pidin

    struct symtab_IdentifierIndex *pidin = IdinCalloc();

    char pc[100];

    sprintf(pc, "%i", iStaticPidin);

    char *pcName = (char *)calloc(1 + strlen(pc), sizeof(char));

    strcpy(pcName, pc);

    IdinSetName(pidin, pcName);

    SymbolSetName(&pconsy->bio.ioh.iol.hsle, pidin);

    //- get pidin for next connection

    iStaticPidin += 2;
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolPrint()
///
/// ARGS.:
///
///	pconsy...: connection to print symbols for
///	bAll.....: TRUE == full list of symbols, FALSE == only given conn
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Print symbol info for connection
///
/// **************************************************************************

#define PrintConnectionSymbolIndent(iIndent,pfile)				\
do									\
{									\
    PrintIndent(iIndent,pfile);						\
    fprintf(pfile,"CONNSY");						\
}									\
while (0)								\

int ConnectionSymbolPrint
(struct symtab_ConnectionSymbol *pconsy,int bAll,int iIndent,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //v section element

    struct symtab_HSolveListElement *phsle = NULL;

    //t should call to biocomponent ?

    //- do indent

    PrintConnectionSymbolIndent(iIndent, pfile);

    //- print pre, post

    fprintf
	(pfile,
	 "pre(%f) -> post(%f)\n",
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, "PRE", NULL),
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, "POST", NULL));

    //- do indent

    PrintConnectionSymbolIndent(iIndent, pfile);

    //- print weight, delay

    fprintf
	(pfile,
	 "Delay, Weight (%f,%f)\n",
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, "DELAY", NULL),
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, "WEIGHT", NULL));

    //- parameters

    pconsy->bio.pparc
	&& ParContainerPrint(pconsy->bio.pparc, TRUE, iIndent + 4, pfile);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolGetDelay()
///
/// ARGS.:
///
///	pconsy...: connection to print symbols for.
///
/// RTN..: double
///
///	Delay of connection, FLT_MAX for failure.
///
/// DESCR: Get delay of connection.
///
/// **************************************************************************

double
ConnectionSymbolGetDelay(struct symtab_ConnectionSymbol *pconsy)
{
    //- set default result: failure

    double dResult = FLT_MAX;

    //- get parameter

    //! with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPost */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, "POST", ppist); */

    //! without parameter caches

    struct symtab_Parameters *pparPost
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, "POST", NULL);

    //- set result

    double dDelay = ParameterResolveValue(pparPost, NULL);

    if (dDelay != FLT_MAX)
    {
	dResult = dDelay;
    }

    //- return result

    return(dResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolGetPost()
///
/// ARGS.:
///
///	pconsy...: connection to print symbols for.
///
/// RTN..: int
///
///	Serial of post synaptic symbol, -1 for failure.
///
/// DESCR: Get serial of post synaptic symbol.
///
/// **************************************************************************

int
ConnectionSymbolGetPost(struct symtab_ConnectionSymbol *pconsy)
{
    //- set default result: failure

    int iResult = -1;

    //- get parameter

    //! with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPost */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, "POST", ppist); */

    //! without parameter caches

    struct symtab_Parameters *pparPost
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, "POST", NULL);

    //- set result

    double dResult = ParameterResolveValue(pparPost, NULL);

    if (dResult != FLT_MAX)
    {
	iResult = dResult;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolGetPre()
///
/// ARGS.:
///
///	pconsy...: connection to print symbols for.
///
/// RTN..: int
///
///	Serial of pre synaptic symbol, -1 for failure.
///
/// DESCR: Get serial of pre synaptic symbol.
///
/// **************************************************************************

int
ConnectionSymbolGetPre(struct symtab_ConnectionSymbol *pconsy)
{
    //- set default result: failure

    int iResult = -1;

    //- get parameter

    //! with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPre */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, "PRE", ppist); */

/* struct PidinStack * */
/* ParameterResolveToPidinStack */
/* (struct symtab_Parameters *ppar, */
/*  struct PidinStack *ppist) */

    //! without parameter caches

    struct symtab_Parameters *pparPre
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, "PRE", NULL);

    //- set result

    double dResult = ParameterResolveValue(pparPre, NULL);

    if (dResult != FLT_MAX)
    {
	iResult = dResult;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: ConnectionSymbolGetWeight()
///
/// ARGS.:
///
///	pconsy...: connection to print symbols for.
///
/// RTN..: double
///
///	Weight of connection, FLT_MAX for failure.
///
/// DESCR: Get weight of connection.
///
/// **************************************************************************

double
ConnectionSymbolGetWeight(struct symtab_ConnectionSymbol *pconsy)
{
    //- set default result: failure

    double dResult = FLT_MAX;

    //- get parameter

    //! with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPost */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, "POST", ppist); */

    //! without parameter caches

    struct symtab_Parameters *pparPost
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, "POST", NULL);

    //- set result

    double dWeight = ParameterResolveValue(pparPost, NULL);

    if (dWeight != FLT_MAX)
    {
	dResult = dWeight;
    }

    //- return result

    return(dResult);
}


