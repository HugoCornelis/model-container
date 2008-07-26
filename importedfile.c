//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: importedfile.c 1.31 Sat, 13 Oct 2007 20:56:19 -0500 hugo $
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


#include <string.h>

#include "neurospaces/dependencyfile.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/symbolvirtual_protos.h"


//v root imported file

struct ImportedFile *pifRootImport = NULL;


//////////////////////////////////////////////////////////////////////////////
//o
//o struct ImportedFile :
//o ---------------------
//o
//o An imported file is a stream of data that has been imported and is
//o present for access in Neurospaces. The imported file has some overhead
//o due to import and parsing and defines a set of symbols (see
//o struct DefinedSymbols, ImportedFileGetDefinedSymbols()).
//o
//////////////////////////////////////////////////////////////////////////////

/// **************************************************************************
///
/// SHORT: ImportedFileCalloc()
///
/// ARGS.:
///
///	pc.: name of imported file
///
/// RTN..: struct ImportedFile * : new imported file struct
///
/// DESCR: Allocated new imported file struct.
///
/// **************************************************************************

struct ImportedFile *ImportedFileCalloc(char *pc)
{
    //- allocate for imported file struct

    struct ImportedFile *pifResult
	= (struct ImportedFile *)calloc(1,sizeof(*pifResult));

    //- allocate for defined symbols

    struct DefinedSymbols *pdefsym
	= DefSymCalloc();

    //- clear flags

    pifResult->iFlags = 0;

    //- register qualified filename

    ImportedFileSetFilename(pifResult,pc);

    //- register defined symbols

    ImportedFileSetDefinedSymbols(pifResult,pdefsym);

    //- return result

    return(pifResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileClearRootImport()
///
/// ARGS.:
///
/// RTN..: void
///
/// DESCR: Clear root import file
///
/// **************************************************************************

void ImportedFileClearRootImport(void)
{
    //- sanity test current root import

    if (!pifRootImport)
    {
	//- give important message

	NeurospacesMessage
	    (LEVEL_GLOBALMSG_IMPORTANT,
	     3, //pacCurrentContext->pcParser,
	     "Warning : Erasing erased root import file\n",
	     NULL);
    }

    //- clear root imported file

    pifRootImport = NULL;
}


/// **************************************************************************
///
/// SHORT: ImportedFileFindDependencyFile()
///
/// ARGS.:
///
///	pif.: imported file to look in
///	pc,.: namespace of dependency file to look for
///
/// RTN..: struct DependencyFile * : dependency file struct, NULL for failure
///
/// DESCR: find a dependency file
///
/// **************************************************************************

struct DependencyFile *
ImportedFileFindDependencyFile(struct ImportedFile *pif,char *pc)
{
    //- set default result : failure

    struct DependencyFile *pdfResult = NULL;

    //- get pointer to defined symbols in imported file

    struct DefinedSymbols *pdefsym
	= ImportedFileGetDefinedSymbols(pif);

    //- loop over dependency files

    struct DependencyFile *pdf
	= (struct DependencyFile *)
	  HSolveListHead(&pdefsym->hslDependencyFiles);

    while (HSolveListValidSucc(&pdf->hsleLink))
    {
	//- if namespace match

	if (strcmp(pc,DependencyFileGetNameSpace(pdf)) == 0)
	{
	    //- set result

	    pdfResult = pdf;

	    //- break loop

	    break;
	}

	//- go to next dependency file

	pdf = (struct DependencyFile *)HSolveListNext(&pdf->hsleLink);
    }

    //- return result

    return(pdfResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileGetBaseRoot()
///
/// ARGS.:
///
/// RTN..: struct symtab_HSolveListElement *
///
///	the absolute root symbol, that exports all models
///
/// DESCR: Get the absolute root symbol.
///
/// **************************************************************************

struct symtab_RootSymbol *ImportedFileGetBaseRootSymbol(void)
{
    //- set default result : from root imported file

    struct symtab_RootSymbol *prootResult
	= ImportedFileGetRootSymbol(pifRootImport);

    //- return result

    return(prootResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileGetDefinedSymbols()
///
/// ARGS.:
///
///	pif...: imported file
///
/// RTN..: struct DefinedSymbols *
///
///	symbols defined in this file.
///
/// DESCR: Get symbols defined in this file.
///
/// **************************************************************************

struct DefinedSymbols *
ImportedFileGetDefinedSymbols(struct ImportedFile *pif)
{
    //- set default result : from defined symbols

    struct DefinedSymbols *pdefsymResult = pif->pdefsym;

    //- return result

    return(pdefsymResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileGetFilename()
///
/// ARGS.:
///
///	pif...: imported file
///
/// RTN..: char *
///
///	original filename.
///
/// DESCR: Get original filename of this imported file.
///
/// **************************************************************************

char *
ImportedFileGetFilename(struct ImportedFile *pif)
{
    return(pif->pcFilename);
}


/// **************************************************************************
///
/// SHORT: ImportedFileGetBaseRoot()
///
/// ARGS.:
///
///	pif...: imported file
///
/// RTN..: struct symtab_HSolveListElement *
///
///	root symbol, that exports all models for imported file
///
/// DESCR: Get the root symbol.
///
/// **************************************************************************

struct symtab_RootSymbol *
ImportedFileGetRootSymbol(struct ImportedFile *pif)
{
    //- set default result : from defined symbols

    struct symtab_RootSymbol *prootResult
	= DefSymGetRootSymbol(pif->pdefsym);

    //- return result

    return(prootResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileGetRootImport()
///
/// ARGS.:
///
/// RTN..: struct ImportedFile * : root imported file
///
/// DESCR: Get main imported file.
///
/// **************************************************************************

struct ImportedFile *ImportedFileGetRootImport(void)
{
    //- set result

    return(pifRootImport);
}


/// **************************************************************************
///
/// SHORT: ImportedFileLookupHierarchical()
///
/// ARGS.:
///
///	pif...: imported file to search in
///	ppist.: element to search
///	iLevel: active level of ppist
///
/// RTN..: struct symtab_HSolveListElement * : matching symbol
///
/// DESCR: lookup a hierarchical symbol name in imported file
///
///	If pif is NULL, pifRootImport is used doing an absolute lookup.
///
/// **************************************************************************

struct symtab_HSolveListElement *
ImportedFileLookupHierarchical
(struct ImportedFile *pif,
 struct PidinStack *ppist,
 int iLevel)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    struct symtab_HSolveListElement * phsle = NULL;

    //- get pointer to defined symbols in imported file

    struct DefinedSymbols *pdefsym = NULL;

    //- get active entry from pidin stack

    struct symtab_IdentifierIndex *pidin
	= PidinStackElementPidin(ppist,iLevel);

    //- if null search

    if (pidin == NULL)
    {
	//- return failure

	return(NULL);
    }

    //- if null imported file

    if (pif == NULL)
    {
	//- set root import as imported file

	pif = pifRootImport;
    }

    //- if no imported file available

    if (pif == NULL)
    {
	//- return failure

	return(NULL);
    }

    //- if namespaced symbol name

    if (IdinIsNamespaced(pidin))
    {
	//- resolve namespaces

	pif = ImportedFileLookupNameSpace(pif,ppist,&iLevel);
    }

    //- get pointer to defined symbols in imported file

    pdefsym = ImportedFileGetDefinedSymbols(pif);

    //- lookup active context entry in defined symbols

    phsle
	= DefSymLookup
	  (pdefsym,
	   NULL,
	   IdinName(PidinStackElementPidin(ppist,iLevel)),
	   FLAG_SYMBOL_PUBLICMODEL);

    //- if found

    if (phsle)
    {
	//- lookup of next stack entries in symbol

	phsleResult
	    = SymbolLookupHierarchical(phsle,ppist,iLevel + 1,TRUE);
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileLookupNameSpace()
///
/// ARGS.:
///
///	pif.....: imported file to search in
///	ppist...: element to search
///	piLevel.: active level of ppist
///
/// RTN..: struct ImportedFile * : imported file associated with namespace
///
///	piLevel.: active level of ppist
///
/// DESCR: lookup a namespace in imported file
///
///	If ppist is namespaced
///	    resolve all namespaced pidins
///	else
///	    return pif
///
/// **************************************************************************

struct ImportedFile *
ImportedFileLookupNameSpace
(struct ImportedFile *pif, struct PidinStack *ppist, int *piLevel)
{
    //- set default result : not found

    struct ImportedFile *pifResult = NULL;

    //- get pointer to defined symbols in imported file

    struct DefinedSymbols *pdefsym = NULL;

    //- get active entry from pidin stack

    struct symtab_IdentifierIndex *pidin
	= PidinStackElementPidin(ppist,*piLevel);

    //- if null imported file

    if (pif == NULL)
    {
	//- set root import as imported file

	pif = pifRootImport;
    }

    //- if no imported file available

    if (pif == NULL)
    {
	//- return failure

	return(NULL);
    }

    //- if null search

    if (pidin == NULL)
    {
	//- return this imported file

	return(pif);
    }

    //- get pointer to defined symbols in imported file

    pdefsym = ImportedFileGetDefinedSymbols(pif);

    //- if namespaced symbol name

    if (IdinIsNamespaced(pidin))
    {
	//- find corresponding imported file

	struct DependencyFile *pdf
	    = ImportedFileFindDependencyFile(pif,IdinName(pidin));

	//- if found

	if (pdf)
	{
	    //- increase active search level

	    *piLevel += 1;

	    //- look for rest of searched symbol

	    pifResult
		= ImportedFileLookupNameSpace
		  (DependencyFileGetImportedFile(pdf),ppist,piLevel);
	}

	//- return result

	return(pifResult);
    }

    //- else

    else
    {
	//- set result : given imported file

	pifResult = pif;

	//- return result

	return(pifResult);
    }
}


/// **************************************************************************
///
/// SHORT: ImportedFilePrint()
///
/// ARGS.:
///
///	pif......: imported file to print symbols of
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print symbol table of imported file
///
/// **************************************************************************

int ImportedFilePrint(struct ImportedFile *pif,int iIndent,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get pointer to defined symbols in imported file

    struct DefinedSymbols *pdefsym
	= ImportedFileGetDefinedSymbols(pif);

    //- print properties of imported file

    bResult = ImportedFilePrintProperties(pif,iIndent,pfile);

    //- pretty print info about defined symbols

    //! only print private & public models, assuming that
    //! all dependencies will be printed too.

    bResult = DefSymPrint
		(pdefsym,
		 /* FLAG_SYMBOL_DEPENDENCY */
/* 		 |  */FLAG_SYMBOL_PRIVATEMODEL
		 | FLAG_SYMBOL_PUBLICMODEL,
		 MoreIndent(iIndent),
		 pfile);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFilePrintNameSpaces()
///
/// ARGS.:
///
///	pif......: imported file to print symbols of
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print symbol table of imported file
///
/// **************************************************************************

int
ImportedFilePrintNameSpaces
(struct ImportedFile *pif,int iIndent,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get pointer to defined symbols in imported file

    struct DefinedSymbols *pdefsym
	= ImportedFileGetDefinedSymbols(pif);

    //- print namespaces

    DefSymPrintNameSpaces(pdefsym,iIndent,pfile);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFilePrintRootImport()
///
/// ARGS.:
///
///	pif...: new root import file
///
/// RTN..: void
///
/// DESCR: Set new root import file
///
///	I use this function as an entry point for the debugger.
///
/// **************************************************************************

void ImportedFilePrintRootImport(void)
{
    fprintf(stdout, "importedfile.c: root import %p\n", pifRootImport);
}


/// **************************************************************************
///
/// SHORT: ImportedFilePrintProperties()
///
/// ARGS.:
///
///	pif......: imported file to print symbols of
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print symbol table of imported file
///
/// **************************************************************************

int ImportedFilePrintProperties
(struct ImportedFile *pif, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- get name

    char *pcName = ImportedFileGetFilename(pif);

    int iLength = strlen(pcName);

    int iPosition = iLength - 60 > 0 ? iLength - 60 : 0 ;

    char *pcFilename = strrchr(pcName,'/');

    int iFilename = pcFilename ? pcFilename - pcName + 1 : 0 ;

    //- name, flags, etc

    PrintIndent(iIndent,pfile);
    fprintf(pfile,"\n");
    PrintIndent(iIndent,pfile);
    fprintf(pfile,"\n");
    PrintIndent(iIndent,pfile);
    fprintf
	(pfile,
	 "-----------------%60.60s-\n",
	 "------------------------------------------------------------");
    PrintIndent(iIndent,pfile);
    fprintf(pfile,"Imported file : (%60.60s)\n",&pcName[iPosition]);
    PrintIndent(iIndent,pfile);
    fprintf(pfile,"Imported file : (%60.60s)\n",&pcName[iFilename]);
    PrintIndent(iIndent,pfile);
    fprintf
	(pfile,
	 "-----------------%60.60s-\n",
	 "------------------------------------------------------------");

    PrintIndent(iIndent,pfile);
    fprintf(pfile,"Flags : (%.8x)\n",pif->iFlags);

    if (pif->iFlags & IMPORTEDFILE_FLAG_ROOT)
    {
	fprintf(pfile,"\tRoot imported file\n");
    }

    PrintIndent(iIndent,pfile);
    fprintf
	(pfile,
	 "Parse Method : (%s)\n\n",
	 "no info" /* obsoleted thing, should be taken care of sometime ... */);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: ImportedFileSetDefinedSymbols()
///
/// ARGS.:
///
///	pif...: imported file.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Set set of defined symbols for an imported file.
///
/// **************************************************************************

int
ImportedFileSetDefinedSymbols
(struct ImportedFile *pif, struct DefinedSymbols *pdefsym)
{
    pif->pdefsym = pdefsym;

    return(1);
}


/// **************************************************************************
///
/// SHORT: ImportedFileSetFilename()
///
/// ARGS.:
///
///	pif...: imported file.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Set filename for an imported file.
///
/// **************************************************************************

int ImportedFileSetFilename(struct ImportedFile *pif, char *pc)
{
    pif->pcFilename = pc;

    return(1);
}


/// **************************************************************************
///
/// SHORT: ImportedFileSetRootImport()
///
/// ARGS.:
///
///	pif...: new root import file
///
/// RTN..: void
///
/// DESCR: Set new root import file
///
/// **************************************************************************

void ImportedFileSetRootImport(struct ImportedFile *pif)
{
    //- sanity test current root context

    if (pifRootImport
	&& pifRootImport != pif)
    {
	//- give important message

	NeurospacesMessage
	    (LEVEL_GLOBALMSG_IMPORTANT,
	     3, //pacCurrentContext->pcParser,
	     "Warning : Erasing root import file\n",
	     NULL);
    }

    //- register pif as root pif

    pifRootImport = pif;

    pifRootImport->iFlags |= IMPORTEDFILE_FLAG_ROOT;
}


