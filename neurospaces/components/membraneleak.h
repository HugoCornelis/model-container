//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
//
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


#ifndef MEMBRANE_LEAK_H
#define MEMBRANE_LEAK_H


#include <stdio.h>


#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct descr_MembraneLeak;
struct symtab_MembraneLeak;


#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"



struct symtab_MembraneLeak * MembraneLeakCalloc(void);

int
MembraneLeakCollectMandatoryParameterValues
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist);

struct symtab_HSolveListElement * 
MembraneLeakCreateAlias
(struct symtab_MembraneLeak *pmeml,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

int
MembraneLeakHasMGBlockGMAX
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist);

int MembraneLeakHasNernstErev
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist);

void MembraneLeakInit(struct symtab_MembraneLeak *pmeml);

int
MembraneLeakReduce
(struct symtab_MembraneLeak *pmeml, struct PidinStack *ppist);


#include "biocomp.h"
/* #include "neurospaces/idin.h" */
/* #include "neurospaces/inputoutput.h" */


/// \struct struct symtab_MembraneLeak

struct symtab_MembraneLeak
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

/*     /// membrane leak description */

/*     struct descr_MembraneLeak dememl; */
};


#endif


