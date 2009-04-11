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


/// 
/// 
/// \return struct symtab_Network * 
/// 
///	Newly allocated network, NULL for failure
/// 
/// \brief Allocate a new network symbol table element
/// \details 
/// 

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


/// 
/// 
/// \arg pnetw network to count cells for
/// 
/// \return int : number of cells in network, -1 for failure
/// 
/// \brief count cells in network
/// \details 
/// 

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


/// 
/// 
/// \arg pnetw network
/// \arg ppist context of network
/// 
/// \return int : number of connections, -1 for failure
/// 
/// \brief Get number of connections in network
/// \details 
/// 
///	connections == synapses
/// 

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


/// 
/// 
/// \arg pnetw symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// \details 
/// 

struct symtab_HSolveListElement * 
NetworkCreateAlias
(struct symtab_Network *pnetw,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Network *pnetwResult = NetworkCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pnetwResult->segr.bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pnetwResult->segr.bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pnetwResult->segr.bio.ioh.iol.hsle, &pnetw->segr.bio.ioh.iol.hsle);

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_network);

    //- return result

    return(&pnetwResult->segr.bio.ioh.iol.hsle);
}


/// 
/// 
/// \arg pnetw network to init
/// 
/// \return void
/// 
/// \brief init network
/// \details 
/// 

void NetworkInit(struct symtab_Network *pnetw)
{
    //- initialize base symbol

    SegmenterInit(&pnetw->segr);

    //- set type

    pnetw->segr.bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_network;
}


/// 
/// 
/// \arg phsle network to traverse cells for
///	ppist.......: context of network, network assumed to be on top
/// \arg pfProcesor cell processor
/// \arg pfFinalizer cell finalizer
/// \arg pvUserdata any user data
/// 
/// \return see TstrTraverse()
/// 
/// \brief Traverse cells, call pfProcessor on each of them
/// \details 
/// 

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


/// 
/// 
/// \arg pnetw network to traverse connections for
///	ppist.......: context of network, network assumed to be on top
/// \arg pfProcessor mechanism processor
/// \arg pfFinalizer finalizer
/// \arg pvUserdata any user data
/// 
/// \return see TstrTraverse()
/// 
/// \brief Traverse connections, call pfProcesor on each of them
/// \details 
/// 
///	Does not use a selector to select connections yet, so calls 
///	pfProcesor on connection vectors also. Test with 
///	InstanceOfVConnection() and InstanceOfConnection() to make 
///	distinction between the two.
/// 

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


