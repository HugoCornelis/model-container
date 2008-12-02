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

#ifndef ALGORITHM_SERIALNETWORK_H
#define ALGORITHM_SERIALNETWORK_H


/// \struct
/// \struct network array entry
/// \struct

struct SymbolSerialNetwork
{
    /// network symbol

    struct symtab_Network *pnetw;

    /// first cell, -1 for none

    int iFirstCell;

    /// number of cells

    int iCells;

    /// first population, -1 for none

    int iFirstPopulation;

    /// number of populations

    int iPopulations;

    /// first connection, -1 for none

    int iFirstConnection;

    /// number of connections

    int iConnections;

    /// first projection, -1 for none

    int iFirstProjection;

    /// number of projections

    int iProjections;
};


/// \struct serial network struct

struct SerialNetworkVariables
{
    /// number of serialized created networks

    int iNetworksCreated;

    /// number of serialized added networks

    int iNetworksAdded;

    /// array of all networks

    struct SymbolSerialNetwork *psymsernetw;
};


/// serial network array

extern struct SerialNetworkVariables sernetwVariables;


extern struct symtab_Algorithm *palgSerialNetwork;


#endif


