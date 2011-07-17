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
//' Copyright (C) 1999-2008 Hugo Cornelis
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


/// \struct
/// \struct input/output description
/// \struct

struct symtab_InputOutput
{
    /// link structures into list

    struct symtab_InputOutput *pioNext;

    /// pointer to first entry in this list

    struct symtab_InputOutput *pioFirst;

    /// hierarchical field identifier with index

    struct symtab_IdentifierIndex *pidinField;

    /// type of input (0 means invalid)

    // \todo figure out whether it would be better to split this
    // struct in separate input and output structs.

    int iType;

    /// optional type name for an input (iType == 1)

    char *pcType;
};


/// \def invalid IO type

#define INPUT_TYPE_INVALID			0

/// \def input specification

#define INPUT_TYPE_INPUT			1

/// \def output specification

#define INPUT_TYPE_OUTPUT			2


#include "pidinstack.h"


/* struct symtab_InputOutput * InputOutputCalloc(void); */

int
InputOutputExport
(struct symtab_InputOutput *pio,
 struct PidinStack *ppist,
 int iIndent,
 int iType,
 FILE *pfile);

char * InputOutputFieldName(struct symtab_InputOutput *pio);

int InputOutputInit(struct symtab_InputOutput *pio);

struct symtab_InputOutput * InputOutputNewForType(int iType);

struct PidinStack * 
InputOutputResolve
(struct symtab_InputOutput *pio, struct PidinStack *ppist);

char * InputOutputTypeName(struct symtab_InputOutput *pio);


#endif


