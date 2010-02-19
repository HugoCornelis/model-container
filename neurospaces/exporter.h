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


int ExporterModel(struct PidinStack *ppistWildcard, int iType, int iFlags, char *pcFilename);


//d export the old info type cryptic format.

#define EXPORTER_TYPE_INFO	5

//d export in NDF format.

#define EXPORTER_TYPE_NDF	11

//d export in a custom XML format.

#define EXPORTER_TYPE_XML	12


//d export namespaces

#define EXPORTER_FLAG_NAMESPACES 1

//d export prototypes

#define EXPORTER_FLAG_PROTOTYPES 2


#endif


