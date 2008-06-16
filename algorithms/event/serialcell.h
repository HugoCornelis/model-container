//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: serialcell.h 1.17 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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

#ifndef ALGORITHM_SERIALCELL_H
#define ALGORITHM_SERIALCELL_H


//s
//s cell array entry
//s

struct SymbolSerialCell
{
    //m cell symbol

    struct symtab_Cell *pcell;

    //m first segment, -1 for none

    int iFirstSegment;

    //m number of segments

    int iSegments;
};


//s serial cell struct

struct SerialCellVariables
{
    //m number of serialized created cells

    int iCellsCreated;

    //m number of serialized added cells

    int iCellsAdded;

    //m array of all cells

    struct SymbolSerialCell *psymsercell;
};


//s serial cell query

struct SerialCellQuery
{
    //m cell to look up

    struct symtab_Cell *pcell;

    //m result cell index

    int iIndexCell;

    //m result segment index

    int iIndexSegment;

    //m result segment symbols

    struct SymbolSerialSegment *psymsersegment;

    //m result number of segments

    int iSegments;
};

//v serial cell array

extern struct SerialCellVariables sercellVariables;


extern struct symtab_Algorithm *palgSerialCell;


#endif


