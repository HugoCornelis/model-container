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


#include "neurospaces/connection.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/parameters.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symbolvirtual_protos.h"


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ConnectionAssignParameters() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pconn..: connection to assign parameters to */
/* ///	ppar...: parameters to assign to connection */
/* /// */
/* /// RTN..: int : success of operation. */
/* /// */
/* /// DESCR: Assign parameters to connection. */
/* /// */
/* ///	Goes through parameter set and frees all encountered parameters. */
/* ///	values are assigned to internal fields of the connection. */
/* /// */
/* /// NOTE.: Use this function as little as possible. */
/* /// */
/* /// ************************************************************************** */

/* int */
/* ConnectionAssignParameters */
/* (struct symtab_Connection *pconn,struct symtab_Parameters *ppar) */
/* { */
/*     //- set default result : success */

/*     int iResult = TRUE; */

/*     //- loop over given parameters */

/*     while (ppar) */
/*     { */
/* 	//- remember this parameter */

/* 	struct symtab_Parameters *pparLast = ppar; */

/* 	//- get name of parameter */

/* 	char *pcName = ParameterGetName(ppar); */

/* 	//- if pre-synaptic */

/* 	if (strcmp(pcName,"PRE") == 0) */
/* 	{ */
/* 	    //- set number */

/* 	    pconn->deconn.iPreSynaptic = ParameterValue(ppar); */
/* 	} */

/* 	//- if post-synaptic */

/* 	else if (strcmp(pcName,"POST") == 0) */
/* 	{ */
/* 	    //- set number */

/* 	    pconn->deconn.iPostSynaptic = ParameterValue(ppar); */
/* 	} */

/* 	//- if weight */

/* 	else if (strcmp(pcName,"WEIGHT") == 0) */
/* 	{ */
/* 	    //- set number */

/* 	    pconn->deconn.dWeight = ParameterValue(ppar); */
/* 	} */

/* 	//- if delay */

/* 	else if (strcmp(pcName,"DELAY") == 0) */
/* 	{ */
/* 	    //- set number */

/* 	    pconn->deconn.dDelay = ParameterValue(ppar); */
/* 	} */

/* 	//- else */

/* 	else */
/* 	{ */
/* 	    //- give diagnostics : unknown parameter */

/* 	    fprintf */
/* 		(stderr, */
/* 		 "ConnectionAssignParameters() :" */
/* 		 " Unknown parameter type %s\n", */
/* 		 pcName); */

/* 	    //- set result : failure */

/* 	    iResult = FALSE; */
/* 	} */

/* 	//- go to next parameter */

/* 	ppar = ppar->pparNext; */

/* 	//- free last parameter */

/* 	ParameterFree(pparLast); */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/// **************************************************************************
///
/// SHORT: ConnectionCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Connection * 
///
///	Newly allocated connection, NULL for failure
///
/// DESCR: Allocate a new connection symbol table element
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ConnectionGetParameter()
///
/// ARGS.:
///
///	pconn.: connection.
///	pcName: name of parameter.
///	ppist.: context of connection.
///
/// RTN..: struct symtab_Parameters *
///
///	static parameter struct, NULL for failure.
///
/// DESCR: Get parameter for connection.
///
/// **************************************************************************

struct symtab_Parameters *
ConnectionGetParameter
(struct symtab_Connection *pconn,
 char *pcName,
 struct PidinStack *ppist)
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


/// **************************************************************************
///
/// SHORT: ConnectionGetSpikeGenerator()
///
/// ARGS.:
///
///	pconn.: connection with spike generator reference
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


/// **************************************************************************
///
/// SHORT: ConnectionGetSpikeReceiver()
///
/// ARGS.:
///
///	pconn.: connection with spike receiver reference
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


/// **************************************************************************
///
/// SHORT: ConnectionInit()
///
/// ARGS.:
///
///	pconn.: connection to init
///
/// RTN..: void
///
/// DESCR: init connection
///
/// **************************************************************************

void ConnectionInit(struct symtab_Connection *pconn)
{
}


/* /// ************************************************************************** */
/* /// */
/* /// SHORT: ConnectionLookupHierarchical() */
/* /// */
/* /// ARGS.: */
/* /// */
/* ///	pconn.: connection container */
/* ///	ppist.: name(s) to search */
/* ///	iLevel: active level of ppist */
/* ///	bAll..: set TRUE if next entries in ppist have to be searched */
/* /// */
/* /// RTN..: struct symtab_HSolveListElement * : */
/* /// */
/* ///	found symbol, NULL for not found */
/* /// */
/* /// DESCR: Hierarchical lookup in connection subsymbols. */
/* /// */
/* ///	Always fails. */
/* /// */
/* /// ************************************************************************** */

/* struct symtab_HSolveListElement * */
/* ConnectionLookupHierarchical */
/* (struct symtab_Connection *pconn, */
/*  struct PidinStack *ppist, */
/*  int iLevel, */
/*  int bAll) */
/* { */
/*     //- set default result : failure */

/*     struct symtab_HSolveListElement *phsleResult = NULL; */

/*     //- return result */

/*     return(phsleResult); */
/* } */


/// **************************************************************************
///
/// SHORT: ConnectionNewForStandardConnection()
///
/// ARGS.:
///
///	iPreSynaptic.: pre-synaptic serial ID
///	iPostSynaptic: post-synaptic serial ID
///	dWeight......: weight of connection
///	dDelay.......: delay of connection
///
/// RTN..: struct symtab_Connection *
///
///	newly allocated and initialized connection
///
/// DESCR: Allocate connection, assign parameters.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ConnectionParameterResolveValue()
///
/// ARGS.:
///
///	pconn.: connection.
///	ppist.: context of connection.
///	pcName: name of parameter.
///
/// RTN..: double : parameter value, FLT_MAX for failure.
///
/// DESCR: Resolve parameter value for connection.
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ConnectionPrint()
///
/// ARGS.:
///
///	pconn....: connection to print symbols for
///	bAll.....: TRUE == full list of symbols, FALSE == only given conn
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Print symbol info for connection
///
/// **************************************************************************

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


/// **************************************************************************
///
/// SHORT: ConnectionTraverse()
///
/// ARGS.:
///
///	ptstr.: initialized treespace traversal
///	pconn.: symbol to traverse
///
/// RTN..: int
///
///	1  : success
///	0  : no success, failure
///	-1 : immediate abort
///
/// DESCR: Traverse symbols in tree manner.
///
/// NOTE.: See IOHierarchyTraverse()
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
/// **************************************************************************

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


