//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: hhgate.h 1.8 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef HHGATE_H
#define HHGATE_H


#include <stdio.h>


/// \struct structure declarations

struct descr_HHGate;
struct symtab_HHGate;


#include "neurospaces/pidinstack.h"


/// \struct info for traversals collecting data about gate kinetics belonging
/// \struct to the same gate

struct table_parameter_collector_data
{
    /// parameter under investigation

    char *pcParameter;

    /// current value

    /// \note must be initialized to zero for correct error processing

    int iValue;
};



struct symtab_HHGate * HHGateCalloc(void);

struct symtab_HSolveListElement * 
HHGateCreateAlias
(struct symtab_HHGate *pgathh,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
HHGateGetParameter
(struct symtab_HHGate *pgathh,
 struct PidinStack *ppist,
 char *pcName);

void HHGateInit(struct symtab_HHGate *pgathh);


#include "biocomp.h"


/// \struct
/// \struct gate kinetic description
/// \struct

struct descr_HHGate
{
    /// compiler happy

    int iHappy;
};


/// \struct
/// \struct struct symtab_HHGate
/// \struct

struct symtab_HHGate
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// gate kinetic description

    struct descr_HHGate degathh;
};


#endif


