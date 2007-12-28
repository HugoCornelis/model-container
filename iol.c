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
//' Copyright (C) 1999-2007 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/iol.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


/// **************************************************************************
///
/// SHORT: IOListGetInputs()
///
/// ARGS.:
///
///	piol....: symbol to get inputs from.
///
/// RTN..: struct symtab_IOContainer * 
///
///	input container of symbol.
///
/// DESCR: Find inputs of symbol.
///
/// **************************************************************************

struct symtab_IOContainer *
IOListGetInputs
(struct symtab_IOList *piol)
{
    //- set default result : not found

    struct symtab_IOContainer * piocResult = NULL;

    piocResult = piol->piocInputs;

    //- return result

    return(piocResult);
}


/// **************************************************************************
///
/// SHORT: IOListInit()
///
/// ARGS.:
///
///	piol.: list element with I/O to init
///
/// RTN..: void
///
/// DESCR: Init list element with I/O
///
/// **************************************************************************

void IOListInit(struct symtab_IOList * piol)
{
    //- init base symbol

    SymbolInit(&piol->hsle);

    //- initialize I/O containers

    piol->piocInputs = IOContainerCalloc();
    piol->piocBindable = IOContainerCalloc();
}


