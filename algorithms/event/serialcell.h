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


/// \struct
/// \struct cell array entry
/// \struct

struct SymbolSerialCell
{
    /// cell symbol

    struct symtab_Cell *pcell;

    /// first segment, -1 for none

    int iFirstSegment;

    /// number of segments

    int iSegments;
};


/// \struct serial cell struct

struct SerialCellVariables
{
    /// number of serialized created cells

    int iCellsCreated;

    /// number of serialized added cells

    int iCellsAdded;

    /// array of all cells

    struct SymbolSerialCell *psymsercell;
};


/// \struct serial cell query

struct SerialCellQuery
{
    /// cell to look up

    struct symtab_Cell *pcell;

    /// result cell index

    int iIndexCell;

    /// result segment index

    int iIndexSegment;

    /// result segment symbols

    struct SymbolSerialSegment *psymsersegment;

    /// result number of segments

    int iSegments;
};

/// serial cell array

extern struct SerialCellVariables sercellVariables;


extern struct symtab_Algorithm *palgSerialCell;


#endif


