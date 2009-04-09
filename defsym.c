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



#include "neurospaces/components/root.h"
#include "neurospaces/defsym.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/exporter.h"
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

/// 
/// \arg pdefsym defined symbols to add public models to
/// \arg phsle model to add
/// 
/// \return int : success of operation
/// 
/// \brief add public model to defined symbols
///
/// \details 
/// 
///	No duplicate checking is done
/// 

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


/// 
/// \arg pdefsym defined symbols to add private models to
/// \arg phsle private model to add
/// 
/// \return int : success of operation
/// 
/// \brief add private model to defined symbols
///
/// \details 
/// 
///	No duplicate checking is done
/// 

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


/// 
/// \return struct DefinedSymbols * : newly allocated defined symbols
/// 
/// \brief Allocate & initialize defined symbols struct.
/// 

struct DefinedSymbols *DefSymCalloc(void)
{
    //- allocate defined symbols

    struct DefinedSymbols *pdefsymResult
	= (struct DefinedSymbols *)calloc(1, sizeof(*pdefsymResult));

    //- init

    if (DefSymInit(pdefsymResult) == FALSE)
    {
	free(pdefsymResult);

	pdefsymResult = NULL;
    }

    //- return result

    return(pdefsymResult);
}


/// 
/// \arg pdefsym defined symbols to init
/// 
/// \return int : success of operation
/// 
/// \brief Initialize defined symbols struct.
/// 

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
	(&pdefsym->hslPublicModels, &pdefsym->prootPublic->hsle.hsleLink);

    pdefsym->prootPrivate = RootSymbolCalloc();

    if (!pdefsym->prootPrivate)
    {
	free(pdefsym->prootPublic);

	return(FALSE);
    }

    HSolveListEnqueue
	(&pdefsym->hslPrivateModels, &pdefsym->prootPrivate->hsle.hsleLink);

    //- return result

    return(iResult);
}


/// 
/// \arg pdefsym defined symbols of imported file
/// 
/// \return struct symtab_HSolveListElement *
/// 
///	hypothetical root symbol, that exports all world visible symbols
/// 
/// \brief Get the world visible hypothetical root
/// 

struct symtab_RootSymbol *
DefSymGetRootSymbol(struct DefinedSymbols *pdefsym)
{
    //- return result : from public models

    return(pdefsym->prootPublic);
}


/// 
/// \arg pdefsym defined symbols of imported file
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Increment count of number of dependencies.
/// 

int
DefSymIncrementDependencyFiles(struct DefinedSymbols *pdefsym)
{
    pdefsym->iDependencyFiles++;

    return(1);
}


/// 
/// \arg pdefsym defined symbols of imported file
/// \arg pcSpace name space to search in
/// \arg pcName name to lookup
/// \arg iFlags see DefSymLookup() in header
/// 
/// \return struct symtab_HSolveListElement * : 
/// 
///	Matching symbol, NULL if not found
/// 
/// \brief lookup a symbol name in given defined symbols
///
/// \details 
/// 
///	If iFlags does not contain FLAG_SYMBOL_DEPENDENCY, pcSpace should be
///	NULL. If pcSpace is NULL, any FLAG_SYMBOL_DEPENDENCY is ignored.
/// 

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

	    if (strcmp(pcNameSpace, DependencyFileGetNameSpace(pdf)) == 0)
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
		    /// \note we could continue searching the files that have the same namespace
		    /// \note but that could lead to overwriting of symbols when multiple files
		    /// \note are given the same namespace

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

	phsleResult = RootSymbolLookup(pdefsym->prootPrivate, pcName);

	if (phsleResult)
	{
	    return(phsleResult);
	}
    }

    //- if should search public model list

    if (iFlags & FLAG_SYMBOL_PUBLICMODEL)
    {
	//- lookup in public models

	phsleResult = RootSymbolLookup(pdefsym->prootPublic, pcName);

	if (phsleResult)
	{
	    return(phsleResult);
	}
    }

    //- return result

    return(phsleResult);
}


/// 
/// \arg pdefsym defined symbols to print.
/// \arg iFlags flags specifying which symbols to print.
/// \arg iIndent number of indentation spaces.
/// \arg iType type of format to export.
/// \arg pfile file to print output to.
/// 
/// \return int : success of operation.
/// 
/// \brief Pretty print defined symbol.
///
/// \details 
/// 
///	iFlags is or'd from FLAG_SYMBOL_DEPENDENCY, FLAG_SYMBOL_PROTOTYPE,
///	FLAG_SYMBOL_MODEL or zero.
/// 

int
DefSymPrint
(struct DefinedSymbols *pdefsym, int iFlags, int iIndent, int iType, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- if dependency files requested

    if (bResult && iFlags & FLAG_SYMBOL_DEPENDENCY)
    {
	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "IMPORT\n");
	}
	else if (iType == EXPORTER_TYPE_XML)
	{
	    fprintf(pfile, "<import>\n");
	}

	//- loop over dependency files

	struct DependencyFile * pdf
	    = (struct DependencyFile *)
	      HSolveListHead(&pdefsym->hslDependencyFiles);

	while (bResult && HSolveListValidSucc(&pdf->hsleLink))
	{
	    //- pretty print dependency file

	    bResult = DependencyFilePrint(pdf, MoreIndent(iIndent), iType, pfile);

	    //- go to next dependency file

	    pdf = (struct DependencyFile *)HSolveListNext(&pdf->hsleLink);
	}

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END IMPORT\n");
	}
	else if (iType == EXPORTER_TYPE_XML)
	{
	    fprintf(pfile, "</import>\n");
	}

    }

    //- if private models requested

    if (bResult && iFlags & FLAG_SYMBOL_PRIVATEMODEL)
    {
	fprintf(pfile, "\n");
	fprintf(pfile, "\n");

	//- print info : public models

	PrintIndent(iIndent, pfile);

	if (iType == EXPORTER_TYPE_INFO
	    || iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "PRIVATE_MODELS\n");
	}
	else if (iType == EXPORTER_TYPE_XML)
	{
	    fprintf(pfile, "<private_models>\n");
	}

	fprintf(pfile, "\n");

	//- print private models

	RootSymbolPrint(pdefsym->prootPrivate, MoreIndent(iIndent), pfile);

	fprintf(pfile, "\n");

	//- print info : end public models

	PrintIndent(iIndent, pfile);

	if (iType == EXPORTER_TYPE_INFO
	    || iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END PRIVATE_MODELS\n");
	}
	else if (iType == EXPORTER_TYPE_XML)
	{
	    fprintf(pfile, "</private_models>\n");
	}
    }

    //- if public models requested

    if (bResult && iFlags & FLAG_SYMBOL_PUBLICMODEL)
    {
	fprintf(pfile, "\n");
	fprintf(pfile, "\n");

	//- print info : public models

	PrintIndent(iIndent, pfile);

	if (iType == EXPORTER_TYPE_INFO
	    || iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "PUBLIC_MODELS\n");
	}
	else if (iType == EXPORTER_TYPE_XML)
	{
	    fprintf(pfile, "<public_models>\n");
	}

	fprintf(pfile, "\n");

	//- print public models

	RootSymbolPrint(pdefsym->prootPublic, MoreIndent(iIndent), pfile);

	fprintf(pfile, "\n");

	//- print info : end public models

	PrintIndent(iIndent, pfile);

	if (iType == EXPORTER_TYPE_INFO
	    || iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END PUBLIC_MODELS\n");
	}
	else if (iType == EXPORTER_TYPE_XML)
	{
	    fprintf(pfile, "</public_models>\n");
	}
    }

    fprintf(pfile, "\n");

    //- return result

    return(bResult);
}


/// 
/// \arg pdf defined symbols to print namespaces for
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Pretty print namespaces in set of defined symbols.
///
/// \details 
/// 

int DefSymPrintNameSpaces
(struct DefinedSymbols *pdefsym, int iIndent, FILE *pfile)
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

	    PrintIndent(iIndent, pfile);
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
	PrintIndent(iIndent, pfile);
	fprintf(pfile, "No namespaces\n");
    }

    //- return result

    return(bResult);
}


