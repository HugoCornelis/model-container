//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialprojection.h 1.13 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/*
** algorithm structures
*/

#ifndef ALGORITHM_SERIALPROJECTION_H
#define ALGORITHM_SERIALPROJECTION_H


//s
//s projection array entry
//s

struct SymbolSerialProjection
{
    //m projection symbol

    struct symtab_Projection *pproj;

    //m first connection, -1 for none

    int iFirstConnection;

    //m number of connections

    int iConnections;
};


//s serial projection struct

struct SerialProjectionVariables
{
    //m number of serialized created projections

    int iProjectionsCreated;

    //m number of serialized added projections

    int iProjectionsAdded;

    //m array of all projections

    struct SymbolSerialProjection *psymserproj;
};


//v serial projection array

extern struct SerialProjectionVariables serprojVariables;


extern struct symtab_Algorithm *palgSerialProjection;


#endif


