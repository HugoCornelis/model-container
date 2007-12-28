//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: inserterinstance.h 1.1 Tue, 19 Jun 2007 17:47:36 -0500 hugo $
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


#ifndef ALGORITHMINSTANCE_INSERTERINSTANCE_H
#define ALGORITHMINSTANCE_INSERTERINSTANCE_H


struct AlgorithmInstance *
InserterInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal, struct symtab_AlgorithmSymbol *palgs);


#endif


