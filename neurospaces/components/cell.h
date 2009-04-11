//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: cell.h 1.61 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef CELL_H
#define CELL_H


#include <stdio.h>


/// \struct structure declarations

struct descr_Cell;
struct symtab_Cell;


#include "neurospaces/idin.h"
#include "segmenter.h"
#include "neurospaces/treespacetraversal.h"



struct symtab_Cell * CellCalloc(void);

struct symtab_HSolveListElement * 
CellCreateAlias
(struct symtab_Cell *pcell,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

void CellInit(struct symtab_Cell *pcell);

struct symtab_Cell * CellNewAtXYZ(double dx, double dy, double dz);


#include "biocomp.h"


/// \struct
/// \struct cell description
/// \struct

struct descr_Cell
{
    /// type of cell data

    int iType;

    /// cell specific flags (OPTIONS keyword)

    int iFlags;
};


/// \struct
/// \struct struct symtab_Cell
/// \struct

struct symtab_Cell
{
    /// base struct : segmenter

    struct symtab_Segmenter segr;

    /// cell description

    struct descr_Cell decell;
};


#endif


