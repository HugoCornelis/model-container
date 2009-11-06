//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: pulse.h 1.20.1.37 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#ifndef PULSE_H
#define PULSE_H


#include <stdio.h>

#include "biocomp.h"
#include "neurospaces/pidinstack.h"


/// \struct structure declarations

struct descr_Pulse;
struct symtab_Pulse;



struct symtab_Pulse * PulseCalloc(void);

struct symtab_HSolveListElement * 
PulseCreateAlias
(struct symtab_Pulse *ppulse,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin);

struct symtab_Parameters * 
PulseGetParameter
(struct symtab_Pulse *ppulse,
 struct PidinStack *ppist,
 char *pcName);

void PulseInit(struct symtab_Pulse *ppulse);

struct symtab_HSolveListElement *
PulseLookupHierarchical
(struct symtab_Pulse *ppulse,
 struct PidinStack *ppist,
 int iLevel,
 int bAll);

double
PulseParameterScaleValue
(struct symtab_Pulse *ppulse,
 struct PidinStack *ppist,
 double dValue,
 struct symtab_Parameters *ppar);

int
PulseReduce
(struct symtab_Pulse *ppulse, struct PidinStack *ppist);


/* #include "equationexponential.h" */
#include "neurospaces/idin.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/parameters.h"


/// \struct
/// \struct pulse description
/// \struct

struct descr_Pulse
{
    /// keeping things happy

    int iHappy;

/*     /// type of pulse data */

/*     int iType; */

/*     /// actual data : should still be changed */

/*     union  */
/*     { */
/* 	/// equation describing pulse */

/* 	struct symtab_Equation *peq; */

/* 	/// file with table describing pulse */

/* 	char *pcFilename; */
/*     } */
/*     uData; */
};


/// \struct
/// \struct struct symtab_Pulse
/// \struct

struct symtab_Pulse
{
    /// base struct : bio component

    struct symtab_BioComponent bio;

    /// pulse description

    struct descr_Pulse depulse;
};


/// \def equation type

#define TYPE_PULSE_EQUATION		1

/// \def table in file

#define TYPE_PULSE_TABLEFILE		2

/// \def attachment point data

#define TYPE_PULSE_VIRTUALCONNECTION	4

/// \def additional pulse parameters

#define TYPE_PULSE_PARAMETERS		5


#endif


