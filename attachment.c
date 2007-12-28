//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: attachment.c 1.34 Fri, 28 Sep 2007 22:25:58 -0500 hugo $
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


#include <stdlib.h>
#include <string.h>

#include "neurospaces/attachment.h"


/// **************************************************************************
///
/// SHORT: AttachmentCalloc()
///
/// ARGS.:
///
/// RTN..: struct symtab_Attachment * 
///
///	Newly allocated attachment point, NULL for failure
///
/// DESCR: Allocate a new attachment point symbol table element.
///
/// **************************************************************************

struct symtab_Attachment * AttachmentCalloc(void)
{
    //- set default result : failure

    struct symtab_Attachment *pattaResult = NULL;

    //- construct function table

#include "hierarchy/output/symbols/attachment_vtable.c"

    //- allocate attachment

    pattaResult
	= (struct symtab_Attachment *)
	  SymbolCalloc(1, sizeof(struct symtab_Attachment), _vtable_attachment, HIERARCHY_TYPE_symbols_attachment);

    //- initialize attachment

    AttachmentInit(pattaResult);

    //- return result

    return(pattaResult);
}


/// **************************************************************************
///
/// SHORT: AttachmentCreateAlias()
///
/// ARGS.:
///
///	patta.: symbol to alias
///	pidin.: name of new symbol
///
/// RTN..: struct symtab_HSolveListElement * : alias for original symbol
///
/// DESCR: Create alias to given symbol
///
/// **************************************************************************

struct symtab_HSolveListElement * 
AttachmentCreateAlias
(struct symtab_Attachment *patta,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Attachment *pattaResult = AttachmentCalloc();

    //- set name and prototype

    SymbolSetName(&pattaResult->bio.ioh.iol.hsle, pidin);
    SymbolSetPrototype(&pattaResult->bio.ioh.iol.hsle, &patta->bio.ioh.iol.hsle);

    //- copy type of attachment

    AttachmentSetType(pattaResult, AttachmentGetType(patta));

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_attachment);

    //- return result

    return(&pattaResult->bio.ioh.iol.hsle);
}


/// **************************************************************************
///
/// SHORT: AttachmentGetType()
///
/// ARGS.:
///
///	patta.: attachment to init
///
/// RTN..: int : type of attachment (incoming, outgoing).
///
/// DESCR: Get type of attachment.
///
/// **************************************************************************

int AttachmentGetType(struct symtab_Attachment *patta)
{
    return(patta->deatta.iType);
}


/// **************************************************************************
///
/// SHORT: AttachmentInit()
///
/// ARGS.:
///
///	patta.: attachment to init
///
/// RTN..: void
///
/// DESCR: init attachment
///
/// **************************************************************************

void AttachmentInit(struct symtab_Attachment *patta)
{
    //- initialize base symbol

    BioComponentInit(&patta->bio);

    //- set type

    patta->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_attachment;
}


/// **************************************************************************
///
/// SHORT: AttachmentSetType()
///
/// ARGS.:
///
///	patta.: attachment to set type for.
///	iType.: type of attachment.
///
/// RTN..: int : success of operation.
///
/// DESCR: Set type of attachment.
///
/// **************************************************************************

int AttachmentSetType(struct symtab_Attachment *patta, int iType)
{
    //- set type, return success.

    int iResult = TRUE;

    patta->deatta.iType = iType;

    return(iResult);
}


