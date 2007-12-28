//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: inputoutput.h 1.21 Tue, 28 Aug 2007 17:38:54 -0500 hugo $
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


#ifndef INPUTOUTPUT_H
#define INPUTOUTPUT_H


#include "hines_list.h"
#include "idin.h"


//s
//s input/output description
//s

struct symtab_InputOutput
{
    //m link structures into list

    struct symtab_InputOutput *pioNext;

    //m pointer to first entry in this list

    struct symtab_InputOutput *pioFirst;

    //m hierarchical field identifier with index

    struct symtab_IdentifierIndex *pidinField;

    //m type of input

    int iType;

    // optional name of prototype

    //! check if this can be used for connections

    //char *pcPrototype;

    //m flags, see below

    int iFlags;

/*     //m related symbol */

/*     struct symtab_HSolveListElement *phsle; */
};


//d input specification

#define INPUT_TYPE_INPUT			1

//d output specification

#define INPUT_TYPE_OUTPUT			2


#include "pidinstack.h"


/* struct symtab_InputOutput * InputOutputCalloc(void); */

char * InputOutputFieldName(struct symtab_InputOutput *pio);

void InputOutputInit(struct symtab_InputOutput *pio);

struct symtab_InputOutput * InputOutputNewForType(int iType);

struct PidinStack * 
InputOutputResolve
(struct symtab_InputOutput *pio, struct PidinStack *ppist);


#endif


