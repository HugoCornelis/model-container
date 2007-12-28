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

#ifndef ALGORITHM_SERIALPOPULATION_H
#define ALGORITHM_SERIALPOPULATION_H


//s
//s population array entry
//s

struct SymbolSerialPopulation
{
    //m population symbol

    struct symtab_Population *ppopu;

    //m first cell, -1 for none

    int iFirstCell;

    //m number of cells

    int iCells;
};


//s serial population struct

struct SerialPopulationVariables
{
    //m number of serialized created populations

    int iPopulationsCreated;

    //m number of serialized added populations

    int iPopulationsAdded;

    //m array of all populations

    struct SymbolSerialPopulation *psymserpopu;
};


//v serial population array

extern struct SerialPopulationVariables serpopuVariables;


extern struct symtab_Algorithm *palgSerialPopulation;


#endif


