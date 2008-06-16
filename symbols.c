//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: symbols.c 1.64 Wed, 03 Oct 2007 17:21:51 -0500 hugo $
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

#include "neurospaces/neurospaces.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/defsym.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/algorithmset.h"
#include "neurospaces/root.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"

#include "neurospaces/symbolvirtual_protos.h"


//////////////////////////////////////////////////////////////////////////////
//o
//o struct Symbols :
//o ----------------
//o
//o Symbols defines a set of imported files (see struct ImportedFile) and a
//o a set of algorithms (see struct Algorithm).
//o
//////////////////////////////////////////////////////////////////////////////

/// **************************************************************************
///
/// SHORT: SymbolsAddImportedFile()
///
/// ARGS.:
///
///	pisSymbols..: symbol table
///	pcFilename..: file to add
///	pac.........: current parser context, NULL for none
///
/// RTN..: struct ImportedFile * : new imported file struct, NULL for failure
///
/// DESCR: add an filename to the imported files
///
///	Qualifies pcFilename, allocates new imported file and adds to 
///	cache list.
///	No duplicate checking is done
///
/// **************************************************************************

struct ImportedFile *
SymbolsAddImportedFile
(struct Symbols *pisSymbols,
 char *pcFilename,
 struct ParserContext *pac)
{
    //- set default result : failure

    struct ImportedFile *pifResult = NULL;

    //v qualified filename to lookup

    char *pcQualified = NULL;

    pcQualified = pcFilename;

    //- allocate new imported file struct

    pifResult = ImportedFileCalloc(pcQualified);

    //- insert file (at head : gives good chance for early match)

    //! list is in order traversal of dependency tree
    //! dependency tree can be a graph : shared dependencies
    //! shared dependencies give worse performance

    HSolveListEnqueue(&pisSymbols->hslFiles,&pifResult->hsleLink);

    //- return result

    return(pifResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsCalloc()
///
/// ARGS.:
///
/// RTN..: struct Symbols * : new symbol table, NULL for failure
///
/// DESCR: Allocate new symbol table
///
/// **************************************************************************

struct Symbols * SymbolsCalloc(void)
{
    //- set default result : failure

    struct Symbols * psymResult = NULL;

    //- allocate symbol table

    psymResult = (struct Symbols *)calloc(1,sizeof(struct Symbols));

    //- initialize symbol table

    SymbolsInitialize(psymResult);

    //- return result

    return(psymResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsLookupImportedFile()
///
/// ARGS.:
///
///	pisSymbols..: symbol table
///	pcFilename..: file to lookup
///	pac.........: current parser context, NULL for none
///
/// RTN..: struct ImportedFile * : imported file struct, NULL for failure
///
/// DESCR: find an imported file
///
///	Qualifies pcFilename, checks if qualified filename is in 
///	cache list.
///
/// **************************************************************************

struct ImportedFile *
SymbolsLookupImportedFile
(struct Symbols *pisSymbols,
 char *pcFilename,
 struct ParserContext *pac)
{
    //- set default result : not found

    struct ImportedFile *pifResult = NULL;

    struct ImportedFile *pifLoop = NULL;

    //v qualified filename to lookup

    char *pcQualified = NULL;

    pcQualified = pcFilename;

    //- loop over the imported files

    pifLoop = (struct ImportedFile *)
	      HSolveListHead(&pisSymbols->hslFiles);

    while (HSolveListValidSucc(&pifLoop->hsleLink))
    {
	//- if found

	if (strcmp(pcQualified,pifLoop->pcFilename) == 0)
	{
	    //- set result

	    pifResult = pifLoop;

	    //- break loop

	    break;
	}

	//- go to next imported file

	pifLoop
	    = (struct ImportedFile *)HSolveListNext(&pifLoop->hsleLink);
    }

    //- return result

    return(pifResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsPrintImportedFiles()
///
/// ARGS.:
///
///	pisSymbols..: symbol table
///	pfile.......: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: print list of imported files
///
/// **************************************************************************

int SymbolsPrintImportedFiles(struct Symbols *pisSymbols,FILE *pfile)
{
    //- set default result : failure

    int bResult = FALSE;

    struct ImportedFile *pif
	= (struct ImportedFile *)
	  HSolveListHead(&pisSymbols->hslFiles);

    while (HSolveListValidSucc(&pif->hsleLink))
    {
	//- print properties of imported file

	ImportedFilePrintProperties(pif,4,pfile);

	//- go to next imported file

	pif
	    = (struct ImportedFile *)HSolveListNext(&pif->hsleLink);
    }

    //- set result

    bResult = TRUE;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsInitialize()
///
/// ARGS.:
///
///	pisSymbols..: symbol table to initialize
///
/// RTN..: int : success of operation
///
/// DESCR: initialize symbol table
///
///	Init imported file list, algorithms.
///
/// **************************************************************************

int SymbolsInitialize(struct Symbols *pisSymbols)
{
    //- set default result : failure

    int bResult = FALSE;

    //- zero out symbol table

    memset(pisSymbols,0,sizeof(*pisSymbols));

    //- initialize filename list

    HSolveListInit(&pisSymbols->hslFiles);

    //- initialize algorithm set

    pisSymbols->pas = AlgorithmSetCalloc();

    if (!pisSymbols->pas)
    {
	return(FALSE);
    }

    //- set result

    bResult = TRUE;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsLookupHierarchical()
///
/// ARGS.:
///
///	pisSymbols..: symbol table to search in
///	ppist.......: element to search
///
/// RTN..: struct symtab_HSolveListElement * : matching symbol
///
/// DESCR: lookup a hierarchical symbol name in given symbol table
///
/// NOTE.:
///
///	The tail of the imported file list is assumed to be the main symbol
///	file.
///
/// **************************************************************************

struct symtab_HSolveListElement *
SymbolsLookupHierarchical
(struct Symbols *pisSymbols, struct PidinStack *ppist)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    struct symtab_RootSymbol *proot = NULL;

    //- start lookup with first entry

    int iLevel = 0;

    //- get active entry from pidin stack

    struct symtab_IdentifierIndex *pidin
	= PidinStackElementPidin(ppist,iLevel);

    //- get root import

    struct ImportedFile *pif = ImportedFileGetRootImport();

    if (!pif)
    {
	return(NULL);
    }

    //- if namespaced symbol name

    if (pidin && IdinIsNamespaced(pidin))
    {
	//- resolve namespaces

	pif = ImportedFileLookupNameSpace(pif,ppist,&iLevel);

	if (!pif)
	{
	    return(NULL);
	}
    }

    //- get the root in current namespace

    proot
	= ImportedFileGetRootSymbol(pif);

    //- if pidin available

    if (pidin)
    {
	//- lookup symbol stack in root

	phsleResult
	    = SymbolLookupHierarchical(&proot->hsle,ppist,iLevel,TRUE);

/* 	//- lookup symbol in imported file */

/* 	phsleResult = ImportedFileLookupHierarchical(NULL,ppist,0); */
    }

    //- else

    else
    {
	//- set result : we assume root is ok

	phsleResult = &proot->hsle;
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsLookupNameSpace()
///
/// ARGS.:
///
///	pisSymbols..: symbol table to search in
///	ppist.......: namespace to search
///
/// RTN..: struct ImportedFile * : imported file associated to namespace
///
/// DESCR: lookup namespace, return defined symbols
///
/// **************************************************************************

struct ImportedFile *
SymbolsLookupNameSpace
(struct Symbols *pisSymbols, struct PidinStack *ppist)
{
    int iLevel = 0;

    //- lookup symbol in imported file

    struct ImportedFile *pifResult
	= ImportedFileLookupNameSpace(NULL,ppist,&iLevel);

    //- return result

    return(pifResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsPrint()
///
/// ARGS.:
///
///	pisSymbols..: symbol table to print
///	pfile.......: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print symbol table to given file
///
/// **************************************************************************

int SymbolsPrint(struct Symbols *pisSymbols,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- loop over imported files

    struct ImportedFile *pif
	= (struct ImportedFile *)HSolveListHead(&pisSymbols->hslFiles);

    while (HSolveListValidSucc(&pif->hsleLink))
    {
	//- print info about imported file

	if (!ImportedFilePrint(pif,0,pfile))
	{
	    bResult = FALSE;

	    break;
	}

	//- go to next imported file

	pif = (struct ImportedFile *)HSolveListNext(&pif->hsleLink);
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: SymbolsPrintModel()
///
/// ARGS.:
///
///	phsle....: model to print
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print model
///
/// **************************************************************************

int SymbolsPrintModel
(struct symtab_HSolveListElement *phsle,int iIndent,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- pretty print symbol info

    SymbolPrint(phsle,MoreIndent(iIndent),pfile);

    //- return result

    return(bResult);
}


