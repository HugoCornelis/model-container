//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: defsym.c 1.18 Fri, 14 Sep 2007 22:28:37 -0500 hugo $
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



#include "neurospaces/defsym.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/root.h"
#include "neurospaces/symbolvirtual_protos.h"


//////////////////////////////////////////////////////////////////////////////
//o
//o struct DefinedSymbols :
//o -----------------------
//o
//o DefinedSymbols defines a set of symbols. These symbols are considered
//o private or public. Private symbols can have external dependencies
//o (see DependencyFile). 
//o
//////////////////////////////////////////////////////////////////////////////

/// **************************************************************************
///
/// SHORT: DefSymAddPublicModel()
///
/// ARGS.:
///
///	pdefsym...: defined symbols to add public models to
///	phsle.....: model to add
///
/// RTN..: int : success of operation
///
/// DESCR: add public model to defined symbols
///
///	No duplicate checking is done
///
/// **************************************************************************

int DefSymAddPublicModel
(struct DefinedSymbols *pdefsym,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = TRUE;

    //- delegate add of symbol to root symbol

    bResult = RootSymbolAddChild(pdefsym->prootPublic, phsle);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: DefSymAddPrivateModel()
///
/// ARGS.:
///
///	pdefsym...: defined symbols to add private models to
///	phsle.....: private model to add
///
/// RTN..: int : success of operation
///
/// DESCR: add private model to defined symbols
///
///	No duplicate checking is done
///
/// **************************************************************************

int DefSymAddPrivateModel
(struct DefinedSymbols *pdefsym,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : ok

    int bResult = TRUE;

    //- delegate add of symbol to root symbol

    bResult = RootSymbolAddChild(pdefsym->prootPrivate, phsle);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: DefSymCalloc()
///
/// ARGS.:
///
/// RTN..: struct DefinedSymbols * : newly allocated defined symbols
///
/// DESCR: Allocate & initialize defined symbols struct.
///
/// **************************************************************************

struct DefinedSymbols *DefSymCalloc(void)
{
    //- allocate defined symbols

    struct DefinedSymbols *pdefsymResult
	= (struct DefinedSymbols *)calloc(1,sizeof(*pdefsymResult));

    //- init

    if (DefSymInit(pdefsymResult) == FALSE)
    {
	free(pdefsymResult);

	pdefsymResult = NULL;
    }

    //- return result

    return(pdefsymResult);
}


/// **************************************************************************
///
/// SHORT: DefSymInit()
///
/// ARGS.:
///
/// 	pdefsym.: defined symbols to init
///
/// RTN..: int : success of operation
///
/// DESCR: Initialize defined symbols struct.
///
/// **************************************************************************

int DefSymInit(struct DefinedSymbols *pdefsym)
{
    //- set default result : ok

    int iResult = TRUE;

    //- initialize lists of dependencies, prototypes, models

    HSolveListInit(&pdefsym->hslDependencyFiles);

    HSolveListInit(&pdefsym->hslPrivateModels);

    HSolveListInit(&pdefsym->hslPublicModels);

    //- allocate root for model lists

    pdefsym->prootPublic = RootSymbolCalloc();

    if (!pdefsym->prootPublic)
    {
	return(FALSE);
    }

    HSolveListEnqueue
	(&pdefsym->hslPublicModels,&pdefsym->prootPublic->hsle.hsleLink);

    pdefsym->prootPrivate = RootSymbolCalloc();

    if (!pdefsym->prootPrivate)
    {
	free(pdefsym->prootPublic);
	return(FALSE);
    }

    HSolveListEnqueue
	(&pdefsym->hslPrivateModels,&pdefsym->prootPrivate->hsle.hsleLink);

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: DefSymGetRootSymbol()
///
/// ARGS.:
///
///	pdefsym.: defined symbols of imported file
///
/// RTN..: struct symtab_HSolveListElement *
///
///	hypothetical root symbol, that exports all world visible symbols
///
/// DESCR: Get the world visible hypothetical root
///
/// **************************************************************************

struct symtab_RootSymbol *
DefSymGetRootSymbol(struct DefinedSymbols *pdefsym)
{
    //- return result : from public models

    return(pdefsym->prootPublic);
}


/// **************************************************************************
///
/// SHORT: DefSymIncrementDependencyFiles()
///
/// ARGS.:
///
///	pdefsym.: defined symbols of imported file
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Increment count of number of dependencies.
///
/// **************************************************************************

int
DefSymIncrementDependencyFiles(struct DefinedSymbols *pdefsym)
{
    pdefsym->iDependencyFiles++;

    return(1);
}


/// **************************************************************************
///
/// SHORT: DefSymLookup()
///
/// ARGS.:
///
///	pdefsym.: defined symbols of imported file
///	pcSpace.: name space to search in
///	pcName..: name to lookup
///	iFlags..: see DefSymLookup() in header
///
/// RTN..: struct symtab_HSolveListElement * : 
///
///	Matching symbol, NULL if not found
///
/// DESCR: lookup a symbol name in given defined symbols
///
///	If iFlags does not contain FLAG_SYMBOL_DEPENDENCY, pcSpace should be
///	NULL. If pcSpace is NULL, any FLAG_SYMBOL_DEPENDENCY is ignored.
///
/// **************************************************************************

struct symtab_HSolveListElement *
DefSymLookup
(struct DefinedSymbols *pdefsym,
 char *pcNameSpace,
 char *pcName,
 int iFlags)
{
    //- set default result : not found

    struct symtab_HSolveListElement *phsleResult = NULL;

    //- if should search dependency list

    if ((iFlags & FLAG_SYMBOL_DEPENDENCY) && pcNameSpace)
    {
	//- loop over dependency files

	struct DependencyFile *pdf
	    = (struct DependencyFile *)
	      HSolveListHead(&pdefsym->hslDependencyFiles);

	while (HSolveListValidSucc(&pdf->hsleLink))
	{
	    //- if namespaces match

	    if (strcmp(pcNameSpace,DependencyFileGetNameSpace(pdf)) == 0)
	    {
		//- get pointer to imported file

		struct ImportedFile *pif
		    = DependencyFileGetImportedFile(pdf);

		//- get pointer to dependency file

		struct DefinedSymbols *pdefsym
		    = ImportedFileGetDefinedSymbols(pif);

		//- lookup symbol in models of the dependency file

		phsleResult
		    = DefSymLookup
		      (pdefsym,
		       NULL,
		       pcName,
		       FLAG_SYMBOL_PUBLICMODEL);

		//- if found

		if (phsleResult)
		{
		    //- return result

		    return(phsleResult);
		}
		else
		{
		    //! we could continue searching the files that have the same namespace
		    //! but that could lead to overwriting of symbols when multiple files
		    //! are given the same namespace

		    return(phsleResult);
		}
	    }

	    //- goto next element

	    pdf = (struct DependencyFile *)HSolveListNext(&pdf->hsleLink);
	}
    }

    //- if should search private model list

    if (iFlags & FLAG_SYMBOL_PRIVATEMODEL)
    {
	//- lookup in private models

	phsleResult = RootSymbolLookup(pdefsym->prootPrivate,pcName);

	if (phsleResult)
	{
	    return(phsleResult);
	}
    }

    //- if should search public model list

    if (iFlags & FLAG_SYMBOL_PUBLICMODEL)
    {
	//- lookup in public models

	phsleResult = RootSymbolLookup(pdefsym->prootPublic,pcName);

	if (phsleResult)
	{
	    return(phsleResult);
	}
    }

    //- return result

    return(phsleResult);
}


/// **************************************************************************
///
/// SHORT: DefSymPrint()
///
/// ARGS.:
///
///	pdefsym..: defined symbols to print
///	iFlags...: flags specifying which symbols to print
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print defined symbol
///
///	iFlags is or'd from FLAG_SYMBOL_DEPENDENCY, FLAG_SYMBOL_PROTOTYPE,
///	FLAG_SYMBOL_MODEL or zero.
///
/// **************************************************************************

int DefSymPrint
(struct DefinedSymbols *pdefsym,int iFlags,int iIndent,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- if dependency files requested

    if (bResult && iFlags & FLAG_SYMBOL_DEPENDENCY)
    {
	//- loop over dependency files

	struct DependencyFile * pdf
	    = (struct DependencyFile *)
	      HSolveListHead(&pdefsym->hslDependencyFiles);

	while (bResult && HSolveListValidSucc(&pdf->hsleLink))
	{
	    //- pretty print dependency file

	    bResult = DependencyFilePrint(pdf,MoreIndent(iIndent),pfile);

	    //- go to next dependency file

	    pdf = (struct DependencyFile *)HSolveListNext(&pdf->hsleLink);
	}
    }

    //- if private models requested

    if (bResult && iFlags & FLAG_SYMBOL_PRIVATEMODEL)
    {
	fprintf(pfile,"\n");
	fprintf(pfile,"\n");

	//- print info : public models

	PrintIndent(iIndent,pfile);
	fprintf(pfile,"PRIVATE_MODELS\n");

	fprintf(pfile,"\n");

	//- print private models

	RootSymbolPrint(pdefsym->prootPrivate,MoreIndent(iIndent),pfile);

	fprintf(pfile,"\n");

	//- print info : end public models

	PrintIndent(iIndent,pfile);
	fprintf(pfile,"END PRIVATE_MODELS\n");
    }

    //- if public models requested

    if (bResult && iFlags & FLAG_SYMBOL_PUBLICMODEL)
    {
	fprintf(pfile,"\n");
	fprintf(pfile,"\n");

	//- print info : public models

	PrintIndent(iIndent,pfile);
	fprintf(pfile,"PUBLIC_MODELS\n");

	fprintf(pfile,"\n");

	//- print public models

	RootSymbolPrint(pdefsym->prootPublic,MoreIndent(iIndent),pfile);

	fprintf(pfile,"\n");

	//- print info : end public models

	PrintIndent(iIndent,pfile);
	fprintf(pfile,"END PUBLIC_MODELS\n");
    }

    fprintf(pfile,"\n");

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: DefSymPrintNameSpaces()
///
/// ARGS.:
///
///	pdf......: defined symbols to print namespaces for
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print namespaces in set of defined symbols.
///
/// **************************************************************************

int DefSymPrintNameSpaces
(struct DefinedSymbols *pdefsym,int iIndent,FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- loop over dependency files

    struct DependencyFile *pdf
	= (struct DependencyFile *)
	  HSolveListHead(&pdefsym->hslDependencyFiles);

    if (HSolveListValidSucc(&pdf->hsleLink))
    {
	while (HSolveListValidSucc(&pdf->hsleLink))
	{
	    //- output filename, namespace

	    PrintIndent(iIndent,pfile);
	    fprintf
		(pfile,
		 "File (%s) --> Namespace (%s::)\n",
		 ImportedFileGetFilename(DependencyFileGetImportedFile(pdf)),
		 DependencyFileGetNameSpace(pdf));

	    pdf = (struct DependencyFile *)HSolveListNext(&pdf->hsleLink);
	}
    }
    else
    {
	PrintIndent(iIndent,pfile);
	fprintf(pfile,"No namespaces\n");
    }

    //- return result

    return(bResult);
}


