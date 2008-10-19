//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: vectorconnection.h 1.3 Fri, 24 Aug 2007 17:53:16 -0500 hugo $
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


#ifndef VECTORCONNECTION_H
#define VECTORCONNECTION_H


#include <stdio.h>


#include "connection.h"


//s structure declarations

struct descr_VConnection;
struct symtab_VConnection;


//f exported functions

int
VConnectionAddConnection
(struct symtab_VConnection *pvconn, struct symtab_Connection *pconn);

struct symtab_VConnection * VConnectionCalloc(void);

void VConnectionInit(struct symtab_VConnection *pvconn);

int
VConnectionTraverse
(struct TreespaceTraversal *ptstr, struct symtab_VConnection *pvconn);


#include "vector.h"


//s
//s vector description
//s

struct descr_VConnection
{
    //m number of connections

    int iConnections;

    int iConnectionsAllocated;

    //m number of reallocations done, for optimization purposes during compile time

    int iReallocations;

    //m allocated connections

    struct symtab_Connection *pconn;
};


//s
//s struct symtab_VConnection
//s

struct symtab_VConnection
{
    //m base struct : vector

    struct symtab_Vector vect;

    //m enumeration container

    struct descr_VConnection devconn;
};


#endif


