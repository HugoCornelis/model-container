//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: randomizeinstance.h 1.5 Sun, 20 May 2007 22:11:53 -0500 hugo $
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


#ifndef ALGORITHMINSTANCE_RANDOMIZEINSTANCE_H
#define ALGORITHMINSTANCE_RANDOMIZEINSTANCE_H


struct AlgorithmInstance *
RandomizeInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal, struct symtab_AlgorithmSymbol *palgs);


#endif


