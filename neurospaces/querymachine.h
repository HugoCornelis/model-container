//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: querymachine.h 1.14 Fri, 12 Oct 2007 12:11:38 -0500 hugo $
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
** query machine support
*/

#ifndef QUERYMACHINE_H
#define QUERYMACHINE_H


#include "neurospaces.h"


int QueryMachineHandle(struct Neurospaces *pneuro, char *pcLine);

int QueryMachineInitialize(struct Neurospaces *pneuro);

void QueryMachineInput(char *pcLine, int iReadline);

void QueryMachineStart(struct Neurospaces *pneuro, int iReadline);


#endif


