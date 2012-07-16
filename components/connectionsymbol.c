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
//' Copyright (C) 1999-2008 Hugo Cornelis
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


#include "neurospaces/components/connectionsymbol.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \return struct symtab_ConnectionSymbol * 
/// 
///	Newly allocated connection, NULL for failure
/// 
/// \brief Allocate a new connection symbol table element
/// 

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


/// 
/// \arg pconsy connection with spike generator reference
/// \arg phsle symbol relative to which connection occurs (== population)
/// \arg ppist context of connection (== population)
/// 
/// \return struct PidinStack *
/// 
///	spike generator, -1 for failure, NULL for none
/// 
/// \brief Get spike generator for connection
/// 
/// \details 
/// 
///	ppist is context of source of projection to which this connection
///	belongs, phsle is referred to by ppist.
/// 

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


/// 
/// \arg pconsy connection with spike receiver reference
/// \arg phsle symbol relative to which connection occurs (== population)
/// \arg ppist context of connection (== population)
/// 
/// \return struct PidinStack *
/// 
///	spike receiver, -1 for failure, NULL for none
/// 
/// \brief Get spike receiver for connection
/// 
/// \details 
/// 
///	ppist is context of target of projection to which this connection
///	belongs, phsle is referred to by ppist.
/// 

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


/// 
/// \arg pconsy connection to init
/// 
/// \return void
/// 
/// \brief init connection
/// 

/// next identifier for any connection

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


/// 
/// \arg pconsy connection to print symbols for
/// \arg bAll TRUE == full list of symbols, FALSE == only given conn
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print symbol info for connection
/// 

#define PrintConnectionSymbolIndent(iIndent,pfile)			\
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

    /// section element

    struct symtab_HSolveListElement *phsle = NULL;

    /// \todo should call to biocomponent ?

    //- do indent

    PrintConnectionSymbolIndent(iIndent, pfile);

    //- print pre, post

    fprintf
	(pfile,
	 "pre(%f) -> post(%f)\n",
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, NULL, "PRE"),
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, NULL, "POST"));

    //- do indent

    PrintConnectionSymbolIndent(iIndent, pfile);

    //- print weight, delay

    fprintf
	(pfile,
	 "Delay, Weight (%f,%f)\n",
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, NULL, "DELAY"),
	 SymbolParameterResolveValue(&pconsy->bio.ioh.iol.hsle, NULL, "WEIGHT"));

    //- parameters

    pconsy->bio.pparc
	&& ParContainerPrint(pconsy->bio.pparc, TRUE, iIndent + 4, pfile);

    //- return result

    return(bResult);
}


/// 
/// \arg pconsy connection to print symbols for.
/// 
/// \return double
/// 
///	Delay of connection, DBL_MAX for failure.
/// 
/// \brief Get delay of connection.
/// 

double
ConnectionSymbolGetDelay(struct symtab_ConnectionSymbol *pconsy)
{
    //- set default result: failure

    double dResult = DBL_MAX;

    //- get parameter

    /// \note with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPost */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, ppist, "POST"); */

    /// \note without parameter caches

    struct symtab_Parameters *pparDelay
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, NULL, "DELAY");

    //- set result

    if (pparDelay)
    {
	double dDelay = ParameterResolveValue(pparDelay, NULL);

	if (dDelay != DBL_MAX)
	{
	    dResult = dDelay;
	}
    }
    else
    {
	fprintf(stderr, "*** Warning: request for DELAY but none found in connection %s\n", SymbolGetName(&pconsy->bio.ioh.iol.hsle));
    }

    //- return result

    return(dResult);
}


/// 
/// \arg pconsy connection to print symbols for.
/// 
/// \return int
/// 
///	Serial of post synaptic symbol, -1 for failure.
/// 
/// \brief Get serial of post synaptic symbol.
/// 

int
ConnectionSymbolGetPost(struct symtab_ConnectionSymbol *pconsy, int iTarget)
{
    //- set default result: failure

    int iResult = -1;

    //- get parameter

    /// \note with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPost */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, ppist, "POST"); */

    /// \note without parameter caches

    struct symtab_Parameters *pparPost
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, NULL, "POST");

    if (!pparPost)
    {
	fprintf(stderr, "*** Warning: request for POST but none found in connection %s\n", SymbolGetName(&pconsy->bio.ioh.iol.hsle));

	return(-1);
    }

    //- convert target to context

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	fprintf(stdout, "cannot allocate a context\n");

	return(-1);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    struct PidinStack *ppistTarget
	= SymbolPrincipalSerial2Context(phsleRoot, ppistRoot, iTarget);

    if (!ppistTarget)
    {
	return(-1);
    }

    //- convert post parameter to context

    struct PidinStack *ppistPost
	= ParameterResolveToPidinStack(pparPost, ppistTarget);

    if (!ppistPost)
    {
	return(-1);
    }

    //- convert pre context to serial

    PidinStackUpdateCaches(ppistPost);

    int iPost = PidinStackToSerial(ppistPost);

    //- set result

    if (iPost != INT_MAX)
    {
	iResult = iPost;
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pconsy connection to print symbols for.
/// 
/// \return int
/// 
///	Serial of pre synaptic symbol, -1 for failure.
/// 
/// \brief Get serial of pre synaptic symbol.
/// 

int
ConnectionSymbolGetPre(struct symtab_ConnectionSymbol *pconsy, int iSource)
{
    //- set default result: failure

    int iResult = -1;

    //- get parameter

    /// \note with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPre */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, ppist, "PRE"); */

    /// \note without parameter caches

    struct symtab_Parameters *pparPre
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, NULL, "PRE");

    if (!pparPre)
    {
	fprintf(stderr, "*** Warning: request for PRE but none found in connection %s\n", SymbolGetName(&pconsy->bio.ioh.iol.hsle));

	return(-1);
    }

    //- convert source to context

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	fprintf(stdout, "cannot allocate a context\n");

	return(-1);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    struct PidinStack *ppistSource
	= SymbolPrincipalSerial2Context(phsleRoot, ppistRoot, iSource);

    if (!ppistSource)
    {
	return(-1);
    }

    //- convert pre parameter to context

    struct PidinStack *ppistPre
	= ParameterResolveToPidinStack(pparPre, ppistSource);

    if (!ppistPre)
    {
	return(-1);
    }

    //- convert pre context to serial

    PidinStackUpdateCaches(ppistPre);

    int iPre = PidinStackToSerial(ppistPre);

    //- set result

    if (iPre != INT_MAX)
    {
	iResult = iPre;
    }
    else
    {
	fprintf(stderr, "*** Warning: connectionsymbol with an invalid presynaptic identifier\n");
    }

    //- return result

    return(iResult);
}


/// 
/// \arg pconsy connection to print symbols for.
/// 
/// \return double
/// 
///	Weight of connection, DBL_MAX for failure.
/// 
/// \brief Get weight of connection.
/// 

double
ConnectionSymbolGetWeight(struct symtab_ConnectionSymbol *pconsy)
{
    //- set default result: failure

    double dResult = DBL_MAX;

    //- get parameter

    /// \note with parameter caches, relies on a valid context so commented out

/*     struct symtab_Parameters *pparPost */
/* 	= SymbolFindParameter(&pconsy->bio.ioh.iol.hsle, ppist, "POST"); */

    /// \note without parameter caches

    struct symtab_Parameters *pparWeight
	= SymbolGetParameter(&pconsy->bio.ioh.iol.hsle, NULL, "WEIGHT");

    if (pparWeight)
    {
	//- set result

	double dWeight = ParameterResolveValue(pparWeight, NULL);

	if (dWeight != DBL_MAX)
	{
	    dResult = dWeight;
	}
    }
    else
    {
	fprintf(stderr, "*** Warning: request for WEIGHT but none found in connection %s\n", SymbolGetName(&pconsy->bio.ioh.iol.hsle));
    }


    //- return result

    return(dResult);
}


