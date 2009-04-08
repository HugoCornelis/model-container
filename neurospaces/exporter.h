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


/// \struct data to describe how to export a model.

struct exporter_data
{
    /// file to write to

    FILE *pfile;

    /// current indentation level

    int iIndent;

    /// wildcard selector

    struct PidinStack *ppistWildcard;

    /// output type

    int iType;
};



int 
ExporterStarter
(struct TreespaceTraversal *ptstr, void *pvUserdata);

int 
ExporterStopper
(struct TreespaceTraversal *ptstr, void *pvUserdata);


#endif


