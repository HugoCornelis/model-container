//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
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



#ifndef NEUROSPACES_EXPORTER_H
#define NEUROSPACES_EXPORTER_H


#include <stdio.h>

#include "neurospaces/pidinstack.h"
#include "neurospaces/treespacetraversal.h"


int ExporterModel(struct PidinStack *ppistWildcard, int iType, char *pcFilename);


#endif


