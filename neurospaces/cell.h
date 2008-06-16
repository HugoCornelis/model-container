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


//s structure declarations

struct descr_Cell;
struct symtab_Cell;


#include "idin.h"
#include "segmenter.h"
#include "treespacetraversal.h"


//f exported functions

struct symtab_Cell * CellCalloc(void);

struct symtab_HSolveListElement * 
CellCreateAlias
(struct symtab_Cell *pcell,
 struct symtab_IdentifierIndex *pidin);

void CellInit(struct symtab_Cell *pcell);

struct symtab_Cell * CellNewAtXYZ(double dx, double dy, double dz);


#include "biocomp.h"


//s
//s cell description
//s

struct descr_Cell
{
    //m type of cell data

    int iType;

    //m cell specific flags (OPTIONS keyword)

    int iFlags;
};


//s
//s struct symtab_Cell
//s

struct symtab_Cell
{
    //m base struct : segmenter

    struct symtab_Segmenter segr;

    //m cell description

    struct descr_Cell decell;
};


#endif


