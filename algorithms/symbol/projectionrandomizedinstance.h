//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: projectionrandomizedinstance.h 1.5 Sun, 20 May 2007 22:11:53 -0500 hugo $
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


#ifndef ALGORITHMINSTANCE_PROJECTIONRANDOMIZEDINSTANCE_H
#define ALGORITHMINSTANCE_PROJECTIONRANDOMIZEDINSTANCE_H


struct AlgorithmInstance *
ProjectionRandomizedInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal, struct symtab_AlgorithmSymbol *palgs);


#endif


