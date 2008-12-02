//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vector.c 1.22 Fri, 14 Sep 2007 13:40:32 -0500 hugo $
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


#include "neurospaces/idin.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/components/vector.h"

#include "neurospaces/symbolvirtual_protos.h"


/// 
/// 
/// \arg pvect vector to init
/// 
/// \return void
/// 
/// \brief init vector
/// \details 
/// 

void VectorInit(struct symtab_Vector *pvect)
{
    //- initialize base symbol

    BioComponentInit(&pvect->bio);

    //- set type

    pvect->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_vector;
}


