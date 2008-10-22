//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: network.c 1.47 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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



#include <math.h>
#include <stdio.h>
#include <stdlib.h>


#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/components/network.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: NetworkCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Network * 
///
///	Newly allocated network, NULL for failure
///
/// DESCR: Allocate a new network symbol table element
///
/// **************************************************************************

struct symtab_Network * NetworkCalloc(void)
{
    //- set default result : failure

    struct symtab_Network *pnetwResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/network_vtable.c"

    //- allocate network

    pnetwResult
	= (struct symtab_Network *)
	  SymbolCalloc(1, sizeof(struct symtab_Network), _vtable_network, HIERARCHY_TYPE_symbols_network);

    //- initialize network

    NetworkInit(pnetwResult);

    //- return result

    return(pnetwResult);
}


/// **************************************************************************
///
/// SHORT: NetworkCountCells()
///
/// ARGS.:
///
///	pnetw.: network to count cells for
///
/// RTN..: int : number of cells in network, -1 for failure
///
/// DESCR: count cells in network
///
/// **************************************************************************

int NetworkCountCells
(struct symtab_Network *pnetw,struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse network cells and count them

    if (NetworkTraverseCells
	(&pnetw->segr.bio.ioh.iol.hsle,
	 ppist,
	 SymbolCellCounter,
	 NULL,
	 (void *)&iResult)
	== FALSE)
    {
	iResult = FALSE;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: NetworkCountConnections()
///
/// ARGS.:
///
///	pnetw...: network
///	ppist...: context of network
///
/// RTN..: int : number of connections, -1 for failure
///
/// DESCR: Get number of connections in network
///
///	connections == synapses
///
/// **************************************************************************

int NetworkCountConnections
(struct symtab_Network *pnetw,struct PidinStack *ppist)
{
    //- set default result : none

    int iResult = 0;

    //- traverse connection symbols and count them

    if (NetworkTraverseConnections
	(pnetw,
	 ppist,
	 SymbolConnectionCounter,
	 NULL,
	 (void *)&iResult) != 1)
    {
	//- set result : failure

	iResult = -1;
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: NetworkCreateAlias()
///
/// ARGS.:
///
///	pnetw.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
NetworkCreateAlias
(struct symtab_Network *pnetw,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Network *pnetwResult = NetworkCalloc();

    //- set name and prototype

    SymbolSetName(&pnetwResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pnetwResult->segr.bio.ioh.iol.hsle, &pnetw->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_network);

    //- return result

    return(&pnetwResult->segr.bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: NetworkInit()
///
/// ARGS.:
///
///	pnetw.: network to init
///
/// RTN..: void
///
/// DESCR: init network
///
/// **************************************************************************

void NetworkInit(struct symtab_Network *pnetw)
{
    //- initialize base symbol

    SegmenterInit(&pnetw->segr);

    //- set type

    pnetw->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_network;
}


/// **************************************************************************
///
/// SHORT: NetworkTraverseCells()
///
/// ARGS.:
///
///	phsle.......: network to traverse cells for
///	ppist.......: context of network, network assumed to be on top
///	pfProcesor..: cell processor
///	pfFinalizer.: cell finalizer
///	pvUserdata..: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse cells, call pfProcessor on each of them
///
/// **************************************************************************

int NetworkTraverseCells
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcesor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = 1;

    //- init network treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolCellSelector,
	   NULL,
	   pfProcesor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse network symbol

    iResult = TstrGo(ptstr,phsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: NetworkTraverseConnections()
///
/// ARGS.:
///
///	pnetw.......: network to traverse connections for
///	ppist.......: context of network, network assumed to be on top
///	pfProcessor.: mechanism processor
///	pfFinalizer.: finalizer
///	pvUserdata..: any user data
///
/// RTN..: see TstrTraverse()
///
/// DESCR: Traverse connections, call pfProcesor on each of them
///
///	Does not use a selector to select connections yet, so calls 
///	pfProcesor on connection vectors also. Test with 
///	InstanceOfVConnection() and InstanceOfConnection() to make 
///	distinction between the two.
///
/// **************************************************************************

int
NetworkTraverseConnections
(struct symtab_Network *pnetw,
 struct PidinStack *ppist,
 TreespaceTraversalProcessor *pfProcessor,
 TreespaceTraversalProcessor *pfFinalizer,
 void *pvUserdata)
{
    //- set default result : ok

    int iResult = TRUE;

    //- init network treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppist,
	   SymbolConnectionSelector,
	   NULL,
	   pfProcessor,
	   pvUserdata,
	   pfFinalizer,
	   pvUserdata);

    //- traverse network symbol

    iResult = TstrGo(ptstr, &pnetw->segr.bio.ioh.iol.hsle);

    //- delete treespace traversal

    TstrDelete(ptstr);

    //- return result

    return(iResult);
}


