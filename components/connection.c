//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: connection.c 1.56 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
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


#include "neurospaces/components/connection.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \return struct symtab_Connection * 
/// 
///	Newly allocated connection, NULL for failure
/// 
/// \brief Allocate a new connection symbol table element
/// 

struct symtab_Connection * ConnectionCalloc(void)
{
    //- set default result : failure

    struct symtab_Connection *pconnResult = NULL;

/*     //- construct function table */

/* #include "hierarchy/output/symbols/connection_vtable.c" */

/*     //- allocate connection */

/*     pconnResult */
/* 	= (struct symtab_Connection *) */
/* 	  SymbolCalloc(1, sizeof(struct symtab_Connection), _vtable_connection, HIERARCHY_TYPE_symbols_connection); */

     0;

    pconnResult = (struct symtab_Connection *)calloc(1, sizeof(struct symtab_Connection));

    //- initialize connection

    ConnectionInit(pconnResult);

    //- return result

    return(pconnResult);
}


/// 
/// \arg pconn connection.
/// \arg ppist context of connection.
/// \arg pcName name of parameter.
/// 
/// \return struct symtab_Parameters *
/// 
///	static parameter struct, NULL for failure.
/// 
/// \brief Get parameter for connection.
/// 

struct symtab_Parameters *
ConnectionGetParameter
(struct symtab_Connection *pconn,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set default result : failure

    struct symtab_Parameters *pparResult = NULL;

    //- if pre-synaptic

    if (strcmp(pcName,"PRE") == 0)
    {
	static struct symtab_Parameters *pparPre = NULL;

	//- if not allocated yet

	if (!pparPre)
	{
	    //- allocate

	    pparPre
		= ParameterNewFromNumber("PRE",0.0);
	}

	//- set number

	ParameterSetNumber(pparPre,pconn->deconn.iPreSynaptic);

	//- set result

	pparResult = pparPre;
    }

    //- if post-synaptic

    else if (strcmp(pcName,"POST") == 0)
    {
	static struct symtab_Parameters *pparPost = NULL;

	//- if not allocated yet

	if (!pparPost)
	{
	    //- allocate

	    pparPost
		= ParameterNewFromNumber("POST",0.0);
	}

	//- set number

	ParameterSetNumber(pparPost,pconn->deconn.iPostSynaptic);

	//- set result

	pparResult = pparPost;
    }

    //- if weight

    else if (strcmp(pcName,"WEIGHT") == 0)
    {
	static struct symtab_Parameters *pparWeight = NULL;

	//- if not allocated yet

	if (!pparWeight)
	{
	    //- allocate

	    pparWeight
		= ParameterNewFromNumber("WEIGHT",0.0);
	}

	//- set number

	ParameterSetNumber(pparWeight,pconn->deconn.dWeight);

	//- set result

	pparResult = pparWeight;
    }

    //- if delay

    else if (strcmp(pcName,"DELAY") == 0)
    {
	static struct symtab_Parameters *pparDelay = NULL;

	//- if not allocated yet

	if (!pparDelay)
	{
	    //- allocate

	    pparDelay
		= ParameterNewFromNumber("DELAY",0.0);
	}

	//- set number

	ParameterSetNumber(pparDelay,pconn->deconn.dDelay);

	//- set result

	pparResult = pparDelay;
    }

    //- return result

    return(pparResult);
}


/// 
/// \arg pconn connection with spike generator reference
/// \arg phsle symbol relative to which connection occurs (== population)
/// \arg ppist context of connection (== population)
/// 
/// \return struct PidinStack *
/// 
///	spike generator, -1 for failure, NULL for none
/// 
/// \brief Get spike generator for connection.
///
/// \details 
/// 
///	ppist is context of source of projection to which this connection
///	belongs, phsle is referred to by ppist.
/// 

struct PidinStack *
ConnectionGetSpikeGenerator
(struct symtab_Connection *pconn,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- init result : context of connection

    struct PidinStack *ppistResult
	= PidinStackDuplicate(ppist);

    //- transform connection pre-synaptic serial ID to context

    int iSource = PidinStackToSerial(ppist);

    struct PidinStack *ppistPre
	= SymbolPrincipalSerial2Context
	  (phsle, ppist, ConnectionGetPre(pconn, iSource));

    //- append stacks

    if (PidinStackAppendCompact(ppistResult, ppistPre))
    {
	//- ok
    }
    else
    {
	PidinStackFree(ppistResult);

	ppistResult = NULL;
    }

    //- free connection pre-synaptic stack

    PidinStackFree(ppistPre);

    //- return result

    return(ppistResult);
}


/// 
/// \arg pconn connection with spike receiver reference
/// \arg phsle symbol relative to which connection occurs (== population)
/// \arg ppist context of connection (== population)
/// 
/// \return struct PidinStack *
/// 
///	spike receiver, -1 for failure, NULL for none
/// 
/// \brief Get spike receiver for connection
/// 
///	ppist is context of target of projection to which this connection
///	belongs, phsle is referred to by ppist.
/// 

struct PidinStack *
ConnectionGetSpikeReceiver
(struct symtab_Connection *pconn,
 struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist)
{
    //- transform connection post-synaptic serial ID to context

    int iTarget = PidinStackToSerial(ppist);

    struct PidinStack *ppistResult
	= SymbolPrincipalSerial2Context
	  (phsle, ppist, ConnectionGetPost(pconn, iTarget));

    //- return result

    return(ppistResult);
}


/// 
/// \arg pconn connection to init
/// 
/// \return void
/// 
/// \brief init connection
/// 

void ConnectionInit(struct symtab_Connection *pconn)
{
}


/// 
///	iPreSynaptic.: pre-synaptic serial ID
///	iPostSynaptic: post-synaptic serial ID
/// \arg dWeight weight of connection
/// \arg dDelay delay of connection
/// 
/// \return struct symtab_Connection *
/// 
///	newly allocated and initialized connection
/// 
/// \brief Allocate connection, assign parameters.
/// 

struct symtab_Connection *
ConnectionNewForStandardConnection
(int iPreSynaptic,int iPostSynaptic,double dWeight,double dDelay)
{
    //- set result : new connection

    struct symtab_Connection *pconnResult
	= ConnectionCalloc();

    if (pconnResult)
    {
	//- set parameters

	pconnResult->deconn.iPreSynaptic = iPreSynaptic;
	pconnResult->deconn.iPostSynaptic = iPostSynaptic;
	pconnResult->deconn.dWeight = dWeight;
	pconnResult->deconn.dDelay = dDelay;
    }

    //- return result

    return(pconnResult);
}


/// 
/// \arg pconn connection.
/// \arg ppist context of connection.
/// \arg pcName name of parameter.
/// 
/// \return double : parameter value, FLT_MAX for failure.
/// 
/// \brief Resolve parameter value for connection.
/// 

double
ConnectionParameterResolveValue
(struct symtab_Connection *pconn,
 struct PidinStack *ppist,
 char *pcName)
{
    //- set result : failure

    double dResult = FLT_MAX;

    //- if pre-synaptic

    if (strcmp(pcName,"PRE") == 0)
    {
	//- set number

	dResult = pconn->deconn.iPreSynaptic;
    }

    //- if post-synaptic

    else if (strcmp(pcName,"POST") == 0)
    {
	//- set number

	dResult = pconn->deconn.iPostSynaptic;
    }

    //- if weight

    else if (strcmp(pcName,"WEIGHT") == 0)
    {
	//- set number

	dResult = pconn->deconn.dWeight;
    }

    //- if delay

    else if (strcmp(pcName,"DELAY") == 0)
    {
	//- set number

	dResult = pconn->deconn.dDelay;
    }

    //- return result

    return(dResult);
}


/// 
/// \arg pconn connection to print symbols for
/// \arg bAll TRUE == full list of symbols, FALSE == only given conn
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Print symbol info for connection
/// 

#define PrintConnectionIndent(iIndent,pfile)				\
do									\
{									\
    PrintIndent(iIndent, pfile);					\
    fprintf(pfile, "CONN  ");						\
}									\
while (0)								\

int ConnectionPrint
(struct symtab_Connection *pconn, int bAll, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- do indent

    PrintConnectionIndent(iIndent,pfile);

    //- print pre, post

    fprintf
	(pfile,
	 "pre(%f) -> post(%f)\n",
	 (double)pconn->deconn.iPreSynaptic,
	 (double)pconn->deconn.iPostSynaptic);

    //- do indent

    PrintConnectionIndent(iIndent,pfile);

    //- print weight, delay

    fprintf
	(pfile,
	 "Delay, Weight (%f,%f)\n",
	 pconn->deconn.dDelay,
	 pconn->deconn.dWeight);

/*     //- parameters */

/*     pconn->deconn.pparc */
/* 	&& ParContainerPrint(pconn->deconn.pparc,TRUE,iIndent + 4,pfile); */

    //- return result

    return(bResult);
}


/// 
/// \arg ptstr initialized treespace traversal
/// \arg pconn symbol to traverse
/// 
/// \return int
/// 
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
/// 
/// \brief Traverse symbols in tree manner.
/// 
/// \note  See IOHierarchyTraverse()
/// 
///	Note that not all symbols are required to have a pidin.
///	Interfaces with Tstr{Prepare,Traverse,Repair}() :
/// 
///	Loops over children of top symbol
///		1. Calls TstrPrepare()
///		2. Calls TstrTraverse()
///		3. Calls TstrRepair()
/// 
///	Use Tstr.*() to obtain info on serial IDs and contexts
///	during traversals.
/// 

int
ConnectionTraverse
(struct TreespaceTraversal *ptstr, struct symtab_Connection *pconn)
{
    //- set default result : ok

    int iResult = 1;

    //- connections never have any children

    //- return result

    return(iResult);
}


