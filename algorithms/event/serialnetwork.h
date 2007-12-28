//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialnetwork.h 1.13 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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


/*
** algorithm structures
*/

#ifndef ALGORITHM_SERIALNETWORK_H
#define ALGORITHM_SERIALNETWORK_H


//s
//s network array entry
//s

struct SymbolSerialNetwork
{
    //m network symbol

    struct symtab_Network *pnetw;

    //m first cell, -1 for none

    int iFirstCell;

    //m number of cells

    int iCells;

    //m first population, -1 for none

    int iFirstPopulation;

    //m number of populations

    int iPopulations;

    //m first connection, -1 for none

    int iFirstConnection;

    //m number of connections

    int iConnections;

    //m first projection, -1 for none

    int iFirstProjection;

    //m number of projections

    int iProjections;
};


//s serial network struct

struct SerialNetworkVariables
{
    //m number of serialized created networks

    int iNetworksCreated;

    //m number of serialized added networks

    int iNetworksAdded;

    //m array of all networks

    struct SymbolSerialNetwork *psymsernetw;
};


//v serial network array

extern struct SerialNetworkVariables sernetwVariables;


extern struct symtab_Algorithm *palgSerialNetwork;


#endif


