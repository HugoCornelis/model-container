//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialpopulation.h 1.13 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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

#ifndef ALGORITHM_SERIALPOPULATION_H
#define ALGORITHM_SERIALPOPULATION_H


/// \struct
/// \struct population array entry
/// \struct

struct SymbolSerialPopulation
{
    /// population symbol

    struct symtab_Population *ppopu;

    /// first cell, -1 for none

    int iFirstCell;

    /// number of cells

    int iCells;
};


/// \struct serial population struct

struct SerialPopulationVariables
{
    /// number of serialized created populations

    int iPopulationsCreated;

    /// number of serialized added populations

    int iPopulationsAdded;

    /// array of all populations

    struct SymbolSerialPopulation *psymserpopu;
};


/// serial population array

extern struct SerialPopulationVariables serpopuVariables;


extern struct symtab_Algorithm *palgSerialPopulation;


#endif


