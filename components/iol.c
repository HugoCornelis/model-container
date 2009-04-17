//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: iol.c 1.18 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/components/iol.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// \arg piol symbol to get bindables from.
/// 
/// \return struct symtab_IOContainer * 
/// 
///	bindable container of symbol.
/// 
/// \brief Find bindables of symbol.
/// 

struct symtab_IOContainer *
IOListGetBindables
(struct symtab_IOList *piol)
{
    //- set default result: from symbol

    struct symtab_IOContainer * piocResult
	= piol->piocBindable;

    //- return result

    return(piocResult);
}


/// 
/// \arg piol symbol to get inputs from.
/// 
/// \return struct symtab_IOContainer * 
/// 
///	input container of symbol.
/// 
/// \brief Find inputs of symbol.
/// 

struct symtab_IOContainer *
IOListGetInputs
(struct symtab_IOList *piol)
{
    //- set default result: from symbol

    struct symtab_IOContainer * piocResult
	= piol->piocInputs;

    //- return result

    return(piocResult);
}


/// 
/// \arg piol list element with I/O to init.
/// 
/// \return int success of operation.
/// 
/// \brief Init list element with I/O
/// 

int IOListInit(struct symtab_IOList * piol)
{
    //- set default result: success

    int iResult = 1;

    //- init base symbol

    SymbolInit(&piol->hsle);

    //- initialize I/O containers

    piol->piocInputs = IOContainerCalloc();
    piol->piocBindable = IOContainerCalloc();

    //- return result

    return(iResult);
}


