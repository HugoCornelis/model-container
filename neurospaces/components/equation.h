//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: equation.h 1.26 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef EQUATION_H
#define EQUATION_H


#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct descr_Equation;
struct symtab_Equation;



struct symtab_Equation * EquationCalloc(void);

struct symtab_HSolveListElement * 
EquationCreateAlias
(struct symtab_Equation *peq,
 struct symtab_IdentifierIndex *pidin);

int EquationGetType(struct symtab_Equation *peq);

void EquationInit(struct symtab_Equation * peq);

int EquationSetType(struct symtab_Equation *peq, int iType);


#include "biocomp.h"
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parcontainer.h"


/// \struct
/// \struct equation description
/// \struct

struct descr_Equation
{
    /// type of equation

    int iType;
};


/// \struct
/// \struct HH and alike equations
/// \struct

struct symtab_Equation
{
    /// base struct : symbol

    struct symtab_BioComponent bio;

    /// type of equation, see TYPE_EQUATION_*

    struct descr_Equation deeq;
};


/* /// \def Hodgkin-Huxley type of equation */

/* #define TYPE_EQUATION_HH		1 */

/* /// \def alpha equation */

/* #define TYPE_EQUATION_ALPHA		2 */

/// \def dual exponential equation

#define TYPE_EQUATION_EXPONENTIAL	3


#endif


