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
//' Copyright (C) 1999-2008 Hugo Cornelis
//'
//' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
//'
//////////////////////////////////////////////////////////////////////////////


#include <stdlib.h>
#include <string.h>

#include "neurospaces/components/attachment.h"


/// 
/// \return struct symtab_Attachment * 
/// 
///	Newly allocated attachment point, NULL for failure
/// 
/// \brief Allocate a new attachment point symbol table element.
/// 

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


/// 
/// \arg patta symbol to collect mandatory parameters for.
/// \arg ppist context.
/// 
/// \return int : success of operation.
/// 
/// \brief Collect mandatory simulation parameters for this symbol,
/// instantiate them in cache such that they are present during
/// serialization.
/// 

int
AttachmentCollectMandatoryParameterValues
(struct symtab_Attachment *patta, struct PidinStack *ppist)
{
    //- set default result: ok

    int iResult = 1;

    if (AttachmentPointIsOutgoing(patta))
    {
	static char *ppc_attachment_mandatory_parameter_names[] =
	    {
		"REFRACTORY",
		"THRESHOLD",
		(char *)0,
	    };

	int i;

	for (i = 0 ; ppc_attachment_mandatory_parameter_names[i] ; i++)
	{
	    struct symtab_Parameters *pparValue
		= SymbolFindParameter(&patta->bio.ioh.iol.hsle, ppist, ppc_attachment_mandatory_parameter_names[i]);

	    struct symtab_Parameters *pparOriginal
		= ParameterLookup(patta->bio.pparc->ppars, ppc_attachment_mandatory_parameter_names[i]);

	    if (pparValue && (!pparOriginal || ParameterIsSymbolic(pparOriginal) || ParameterIsField(pparOriginal)))
	    {
		double dValue = ParameterResolveValue(pparValue, ppist);

		struct symtab_Parameters *pparDuplicate = ParameterNewFromNumber(ppc_attachment_mandatory_parameter_names[i], dValue);

		BioComponentChangeParameter(&patta->bio, pparDuplicate);
	    }
	}
    }

    //- return result

    return(iResult);
}


/// 
/// \arg patta symbol to alias
/// \arg pidin name of new symbol
/// 
/// \return struct symtab_HSolveListElement * : alias for original symbol
/// 
/// \brief Create alias to given symbol
/// 

struct symtab_HSolveListElement * 
AttachmentCreateAlias
(struct symtab_Attachment *patta,
 char *pcNamespace,
 struct symtab_IdentifierIndex *pidin)
{
    //- set default result : allocate

    struct symtab_Attachment *pattaResult = AttachmentCalloc();

    //- set name, namespace and prototype

    SymbolSetName(&pattaResult->bio.ioh.iol.hsle, pidin);
    SymbolSetNamespace(&pattaResult->bio.ioh.iol.hsle, pcNamespace);
    SymbolSetPrototype(&pattaResult->bio.ioh.iol.hsle, &patta->bio.ioh.iol.hsle);

    //- copy type of attachment

    AttachmentSetType(pattaResult, AttachmentGetType(patta));

    //- increment number of created aliases

    SymbolIncrementAliases(HIERARCHY_TYPE_symbols_attachment);

    //- return result

    return(&pattaResult->bio.ioh.iol.hsle);
}


/// 
/// \arg patta attachment to init
/// 
/// \return int : type of attachment (incoming, outgoing).
/// 
/// \brief Get type of attachment.
/// 

int AttachmentGetType(struct symtab_Attachment *patta)
{
    return(patta->deatta.iType);
}


/// 
/// \arg patta attachment to init
/// 
/// \return void
/// 
/// \brief init attachment
/// 

void AttachmentInit(struct symtab_Attachment *patta)
{
    //- initialize base symbol

    BioComponentInit(&patta->bio);

    //- set type

    patta->bio.ioh.iol.hsle.iType = HIERARCHY_TYPE_symbols_attachment;
}


/// 
/// \arg patta attachment to set type for.
/// \arg iType type of attachment.
/// 
/// \return int : success of operation.
/// 
/// \brief Set type of attachment.
/// 

int AttachmentSetType(struct symtab_Attachment *patta, int iType)
{
    //- set type, return success.

    int iResult = TRUE;

    patta->deatta.iType = iType;

    return(iResult);
}


