//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
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

#include "neurospaces/components/biocomp.h"
#include "neurospaces/defsym.h"
#include "neurospaces/exporter.h"
#include "neurospaces/importedfile.h"


/// \struct data to describe how to export a model.

struct exporter_data
{
    /// file to write to

    FILE *pfile;

    /// current indentation level

    int iIndent;

    /// wildcard selector

    struct PidinStack *ppistWildcard;

    /// output type

    int iType;

    /// output flags

    int iFlags;

    /// serial of the symbol that starts the traversal

    int iStarter;
};


static
int
ExporterBindables
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd);

static
int
ExporterBindings
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd);

static
int
ExporterChildren
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd);

static
int
ExporterChildrenForLibrary
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd);

static
int 
ExporterLibraryChildren
(struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 int iIndent,
 FILE *pfile);

static int
ExporterLibraryFinalizer
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int 
ExporterLibraryPublisher
(struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 int iIndent,
 FILE *pfile);

static int
ExporterLibraryPublisherSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static int
ExporterLibraryPublisherProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static int
ExporterLibraryProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static int
ExporterLibrarySelector
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
ExporterSymbol
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 int iIndent,
 FILE *pfile);

static
int 
ExporterSymbolStarter
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int 
ExporterSymbolStopper
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int 
ExporterSymbolUntagger
(struct TreespaceTraversal *ptstr, void *pvUserdata);

/* static */
/* int */
/* ExporterTagSymbols */
/* (struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistWildcard, */
/*  int iType, */
/*  int iFlags, */
/*  int iIndent, */
/*  FILE *pfile); */


///
/// \arg phsle symbol to export bindables of.
/// \arg ppist context of symbol.
/// \arg pexd exporter configuration.
///
/// \return int success of operation.
///
/// \brief Export the bindables of a symbol.
///

static
int
ExporterBindables
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd)
{
    //- set default result: success

    int iResult = 1;

    //- if has bindables

    if (instanceof_iol(phsle))
    {
	struct symtab_IOList *piol
	    = (struct symtab_IOList *)phsle;

	//- lookup bindables

	struct symtab_IOContainer * pioc
	    = IOListGetBindables(piol);

	//- loop over bindables

	struct symtab_InputOutput *pio
	    = pioc ? IOContainerIterateRelations(pioc) : NULL;

	if (pio)
	{
	    PrintIndent(pexd->iIndent + 2, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "BINDABLES\n");
	    }
	    else
	    {
		fprintf(pexd->pfile, "<bindables>\n");
	    }

	    while (pio)
	    {
		//- export this bindable

		if (!InputOutputExport(pio, ppist, pexd->iIndent + 4, pexd->iType, pexd->pfile))
		{
		    iResult = 0;

		    break;
		}

		pio = IOContainerNextRelation(pio);
	    }

	    PrintIndent(pexd->iIndent + 2, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "END BINDABLES\n");
	    }
	    else
	    {
		fprintf(pexd->pfile, "</bindables>\n");
	    }

	}
    }

    //- return result

    return(iResult);
}


///
/// \arg phsle symbol to export bindings of.
/// \arg ppist context of symbol.
/// \arg pexd exporter configuration.
///
/// \return int success of operation.
///
/// \brief Export the bindings of a symbol.
///

static
int
ExporterBindings
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd)
{
    //- set default result: success

    int iResult = 1;

    //- if has bindings

    if (instanceof_iol(phsle))
    {
	struct symtab_IOList *piol
	    = (struct symtab_IOList *)phsle;

	//- lookup bindings

	struct symtab_IOContainer * pioc
	    = IOListGetInputs(piol);

	//- loop over bindings

	struct symtab_InputOutput *pio
	    = IOContainerIterateRelations(pioc);

	if (pio)
	{
	    PrintIndent(pexd->iIndent + 2, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "BINDINGS\n");
	    }
	    else
	    {
		fprintf(pexd->pfile, "<bindings>\n");
	    }

	    while (pio)
	    {
		//- export this binding

		if (!InputOutputExport(pio, ppist, pexd->iIndent + 4, pexd->iType, pexd->pfile))
		{
		    iResult = 0;

		    break;
		}

		pio = IOContainerNextRelation(pio);
	    }

	    PrintIndent(pexd->iIndent + 2, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "END BINDINGS\n");
	    }
	    else
	    {
		fprintf(pexd->pfile, "</bindings>\n");
	    }
	}
    }

    //- return result

    return(iResult);
}


///
/// \arg phsle symbol to export bindings of.
/// \arg ppist context of symbol.
/// \arg pexd exporter configuration.
///
/// \return int success of operation.
///
/// \brief Export the symbols bound to this symbol.  The bound ones
/// must be children of this symbol.
///

static
int
ExporterChildren
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd)
{
    //- set default result: success

    int iResult = 1;

    //- if can have bindings

    if (instanceof_iol(phsle))
    {
	//- create a new wildcarded selector for the current context

	struct PidinStack *ppistChildren
	    = PidinStackDuplicate(ppist);

	PidinStackPush(ppistChildren, IdinNewFromChars("*"));

	//- export children as aliasses

	iResult = ExporterSymbol(phsle, ppist, ppistChildren, pexd->iType, pexd->iFlags/*  | EXPORTER_FLAG_PROTOTYPES */, pexd->iIndent, pexd->pfile);

	//- free allocated resources

	PidinStackFree(ppistChildren);
    }
    else
    {
	//t
    }

    //- return result

    return(iResult);
}


///
/// \arg phsle symbol to export bindings of.
/// \arg ppist context of symbol.
/// \arg pexd exporter configuration.
///
/// \return int success of operation.
///
/// \brief Export the symbols bound to this symbol.  The bound ones
/// must be children of this symbol.
///

static
int
ExporterChildrenForLibrary
(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, struct exporter_data *pexd)
{
    //- set default result: success

    int iResult = 1;

    //- if can have bindings

    if (instanceof_iol(phsle))
    {
	//- create a new wildcarded selector for the current context

	struct PidinStack *ppistChildren
	    = PidinStackDuplicate(ppist);

	PidinStackPush(ppistChildren, IdinNewFromChars("*"));

	//- allocate traversal structure

	struct exporter_data exd =
	    {
		/// file to write to

		pexd->pfile,

		/// current indentation level

		pexd->iIndent + 2,

		/// wildcard selector

		ppistChildren,

		/// output type

		pexd->iType,

		/// output flags

		pexd->iFlags,

		/// serial of the symbol that starts the traversal

		PidinStackToSerial(ppist),

	    };

	//- allocate treespace traversal

	struct TreespaceTraversal *ptstr
	    = TstrNew
	      (ppist,
	       WildcardSelector,
	       (void *)ppistChildren,
	       ExporterSymbolStarter,
	       (void *)&exd,
	       ExporterSymbolStopper,
	       (void *)&exd);

	ptstr->iFlags |= TSTR_FLAG_NO_PROTOTYPE_TRAVERSAL;

	//- traverse symbols, looking for serial

	int iTraversal = TstrGo(ptstr,phsle);

	//- delete treespace traversal

	TstrDelete(ptstr);

	if (iTraversal != 1)
	{
	    fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");

	    iResult = 0;
	}

	//- free allocated resources

	PidinStackFree(ppistChildren);
    }
    else
    {
	//t
    }

    //- return result

    return(iResult);
}


/// 
/// \arg ppistWildcard wildcard of symbols to export.
/// \arg iType type of export, see below.
/// \arg iFlags export flags (eg. namespacing flags).
/// \arg pcFilename name of exported file.
/// 
/// \return int success of operation.
/// 
/// \brief Export a model in a defined format to a file.
/// 
/// \details
///
///	Use the EXPORTER_TYPE_NDF and related to export in various
///	formats.
///

int ExporterModel(struct PidinStack *ppistWildcard, int iType, int iFlags, char *pcFilename)
{
    //- set default result: ok

    int iResult = 1;

    //- open output file

    FILE *pfile = NULL;

    if (strcmp(pcFilename, "STDOUT") == 0)
    {
	pfile = stdout;
    }
    else
    {
	pfile = fopen(pcFilename, "w");
    }

    if (!pfile)
    {
	fprintf(stderr, "*** Error: cannot open %s for writing\n", pcFilename);

	return(0);
    }

    //- start output

    if (iType == EXPORTER_TYPE_NDF)
    {
	fprintf(pfile, "#!neurospacesparse\n// -*- NEUROSPACES -*-\n\nNEUROSPACES NDF\n\n");
    }
    else if (iType == EXPORTER_TYPE_XML)
    {
	fprintf(pfile, "<neurospaces type=\"ndf\"/>\n\n");
    }

    //- export dependencies

    struct ImportedFile *pif = ImportedFileGetRootImport();

    struct DefinedSymbols *pdefsym = ImportedFileGetDefinedSymbols(pif);

    if (!(iFlags & EXPORTER_FLAG_LIBRARY))
    {
	iResult
	    = (iResult
	       && DefSymPrint(pdefsym, FLAG_SYMBOL_DEPENDENCY, 4, iType, pfile));
    }

    //- if exporting a library

    if (iFlags & EXPORTER_FLAG_LIBRARY)
    {
	//- tag dependencies

	//- start private models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "PRIVATE_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "<private_models>\n");
	}

	//- export dependencies in private section

	iResult
	    = (iResult && ExporterLibraryChildren(ppistWildcard, iType, iFlags, 0, pfile));

	//- end private models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END PRIVATE_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "</private_models>\n");
	}

	//- export main model in public section
    }

    //- else export private symbols

    else
    {
	//- start private models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "PRIVATE_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "<private_models>\n");
	}

	//- allocate pidin stack pointing to root

	struct PidinStack *ppistPrivate = PidinStackParse("::");

	if (!ppistPrivate)
	{
	    return(FALSE);
	}

	struct symtab_HSolveListElement *phslePrivate
	    = PidinStackLookupTopSymbol(ppistPrivate);

	phslePrivate = (struct symtab_HSolveListElement *)pdefsym->prootPrivate;

	//- private models always export their namespaces

	int iFlagsPrivate = iFlags | EXPORTER_FLAG_NAMESPACES;

	/// \note phslePrivate can be NULL if the model description file was not found ?

	if (phslePrivate)
	{
	    iResult = ExporterSymbol(phslePrivate, ppistPrivate, ppistWildcard, iType, iFlagsPrivate, 0, pfile);
	}

	//- end private models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END PRIVATE_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "</private_models>\n");
	}

	//- free allocated memory

	PidinStackFree(ppistPrivate);

	fprintf(pfile, "\n");
    }

    //- if exporting a library

    if (iFlags & EXPORTER_FLAG_LIBRARY)
    {
	//- start public models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "PUBLIC_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "<public_models>\n");
	}

	//- export dependencies in private section

	iResult
	    = (iResult && ExporterLibraryPublisher(ppistWildcard, iType, iFlags, 0, pfile));

	//- end public models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END PUBLIC_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "</public_models>\n");
	}

    }

    //- else export public symbols

    else
    {
	//- start public models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "PUBLIC_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "<public_models>\n");
	}

	//- allocate pidin stack pointing to root

	struct PidinStack *ppistRoot = PidinStackCalloc();

	if (!ppistRoot)
	{
	    return(FALSE);
	}

	PidinStackSetRooted(ppistRoot);

	struct symtab_HSolveListElement *phsleRoot
	    = PidinStackLookupTopSymbol(ppistRoot);

	/// \note so phsleRoot can be NULL if the model description file was not found

	if (phsleRoot)
	{
	    iResult = ExporterSymbol(phsleRoot, ppistRoot, ppistWildcard, iType, iFlags, 0, pfile);
	}

	//- end public models

	if (iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pfile, "END PUBLIC_MODELS\n");
	}
	else
	{
	    fprintf(pfile, "</public_models>\n");
	}

	//- free allocated memory

	PidinStackFree(ppistRoot);

    }

    //- close output file

    if (strcmp(pcFilename, "STDOUT") == 0)
    {
    }
    else
    {
	fclose(pfile);
    }

    //- return result

    return(iResult);
}


static
int
ExporterSymbol
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 int iIndent,
 FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    //- allocate traversal structure

    struct exporter_data exd =
	{
	    /// file to write to

	    pfile,

	    /// current indentation level

	    iIndent + 2,

	    /// wildcard selector

	    ppistWildcard,

	    /// output type

	    iType,

	    /// output flags

	    iFlags,

	    /// serial of the symbol that starts the traversal

	    PidinStackToSerial(ppist),

	};

    //- traverse symbols that match with wildcard

    int iTraversal
	= SymbolTraverseWildcard
	  (phsle,
	   ppist,
	   ppistWildcard,
	   ExporterSymbolStarter,
	   ExporterSymbolStopper,
	   (void *)&exd);

    if (iTraversal != 1)
    {
	fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");

	iResult = 0;
    }

    //- return result

    return(iResult);
}


static
int 
ExporterLibraryChildren
(struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 int iIndent,
 FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(FALSE);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    //- initialize exporter_data for library traversal

    struct exporter_data exd =
	{
	    /// file to write to

	    pfile,

	    /// current indentation level

	    iIndent + 2,

	    /// wildcard selector

	    ppistWildcard,

	    /// output type

	    iType,

	    /// output flags

	    iFlags,
	};

    //- allocate treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppistRoot,
	   ExporterLibrarySelector,
	   /* 	   (void *)&exd, */ NULL,
	   /* 	   ExporterLibraryProcessor, */ NULL,
	   (void *)&exd,
	   ExporterLibraryFinalizer,
	   (void *)&exd);

    //- traverse symbols, exporting the untagged ones

    int iTraversal1 = TstrGo(ptstr, phsleRoot);

    //- traverse symbols, untag the tagged ones

    /// \todo not sure if recycling is still allowed ...

    ptstr->iStatus = TSTR_STATUS_NEW;
    ptstr->pfPreSelector = NULL;
    ptstr->pfProcessor = ExporterSymbolUntagger;
    ptstr->pfFinalizer = NULL;

    int iTraversal2 = TstrGo(ptstr, phsleRoot);

    //- delete treespace traversal

    TstrDelete(ptstr);

    if (iTraversal1 != 1
	|| iTraversal2 != 1)
    {
	fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");

	iResult = 0;
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    return(iResult);
}


static int
ExporterLibraryFinalizer
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- for a biocomponent

    int iType = TstrGetActualType(ptstr);

    if (subsetof_bio_comp(iType))
    {
	struct symtab_BioComponent *pbio = (struct symtab_BioComponent *)phsle;

	//- construct reverse order prototype list

	struct symtab_BioComponent *ppbioPrototypes[100];

	int iPrototypes = BioComponentGetPrototypeList(pbio, ppbioPrototypes, 100);

	{
	    //- export component

	    struct symtab_BioComponent * pbioPrototype = ppbioPrototypes[iPrototypes - 1];

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		char *pcToken = SymbolHSLETypeDescribeNDF(phsle->iType);

/* 		int iSerial = TstrGetPrincipalSerial(ptstr); */

		char pcName[1000];

/* 		sprintf(pcName, "%s_%i_0", SymbolName(&pbioPrototype->ioh.iol.hsle), iSerial); */

		sprintf(pcName, "%s_%i_%i", SymbolName(&pbioPrototype->ioh.iol.hsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier);

		fprintf(pexd->pfile, "%s \"%s\"\n", pcToken, pcName);
	    }
	    else
	    {
		char *pcToken = SymbolHSLETypeDescribeNDF(phsle->iType);

/* 		int iSerial = TstrGetPrincipalSerial(ptstr); */

		char pcName[1000];

/* 		sprintf(pcName, "%s_%i_0", SymbolName(&pbioPrototype->ioh.iol.hsle), iSerial); */

		sprintf(pcName, "%s_%i_%i", SymbolName(&pbioPrototype->ioh.iol.hsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier);

		fprintf(pexd->pfile, "<%s> <name>%s</name>\n", pcToken, pcName);
	    }

	    {
		//- set biocomp tag

		pbioPrototype->iOptions |= BIOCOMP_OPTION_TAG_SET;

		//- export bindables

		ExporterBindables(&pbioPrototype->ioh.iol.hsle, ptstr->ppist, pexd);

		//- export bindings

		ExporterBindings(&pbioPrototype->ioh.iol.hsle, ptstr->ppist, pexd);

		//- export parameter of this biological component

		struct symtab_ParContainer *pparc = pbioPrototype->pparc;

		if (pparc)
		{
		    if (!ParContainerExport(pparc, ptstr->ppist, pexd->iIndent + 2, pexd->iType, pexd->pfile))
		    {
			iResult = TSTR_PROCESSOR_ABORT;
		    }
		}

		//- export parameter caches of this biological component

		struct ParameterCache *pparcac = pbioPrototype->ioh.iol.hsle.pparcac;

		if (pparcac)
		{
		    if (!ParameterCacheExport(pparcac, ptstr->ppist, pexd->iIndent + 2, pexd->iType, pexd->pfile))
		    {
			iResult = TSTR_PROCESSOR_ABORT;
		    }
		}

		//- export this symbol children as aliasses

		int iOldFlags = pexd->iFlags;

		pexd->iFlags |= EXPORTER_FLAG_CHILDREN_INSTANCES;

		int iExported = ExporterChildrenForLibrary(&pbioPrototype->ioh.iol.hsle, ptstr->ppist, pexd);

		pexd->iFlags = iOldFlags;

		if (!iExported)
		{
		    iResult = TSTR_PROCESSOR_ABORT;
		}

	    }

	    //- end biological component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "END %s\n", SymbolHSLETypeDescribeNDF(phsle->iType));
	    }
	    else
	    {
		fprintf(pexd->pfile, "</%s>\n", SymbolHSLETypeDescribeNDF(phsle->iType));
	    }
	}

	//- loop over reverse order prototype list

	int i;

	for ( i = iPrototypes - 1; i >= 0 ; i--)
	{
	    struct symtab_BioComponent * pbioSource
		= i == 10 ? (struct symtab_BioComponent *)phsle : ppbioPrototypes[i];

	    struct symtab_BioComponent * pbioTarget
		= i == 0 ? NULL : ppbioPrototypes[i - 1];

	    //- export reference to component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		char *pcToken = "CHILD";

/* 		int iSerial = TstrGetPrincipalSerial(ptstr); */

		char pcPrototype[1000];

/* 		sprintf(pcPrototype, "%s_%i_%i", SymbolName(&pbioSource->ioh.iol.hsle), iSerial, iPrototypes - i - 1); */

		sprintf(pcPrototype, "%s_%i_%i", SymbolName(&pbioSource->ioh.iol.hsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - i - 1 */pbioSource->ioh.iol.hsle.iAllocationIdentifier);

		char pcName[1000];

		if (i == 0)
		{
/* 		    sprintf(pcName, "%s_inserted_%i", SymbolName(phsle), iSerial); */

		    sprintf(pcName, "%s_inserted_%i", SymbolName(phsle), /* ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier */phsle->iAllocationIdentifier);

		}
		else
		{
/* 		    sprintf(pcName, "%s_%i_%i", SymbolName(&pbioTarget->ioh.iol.hsle), iSerial, iPrototypes - i); */

		    sprintf(pcName, "%s_%i_%i", SymbolName(&pbioTarget->ioh.iol.hsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - i */pbioTarget->ioh.iol.hsle.iAllocationIdentifier);

		}

		fprintf(pexd->pfile, "%s \"%s\" \"%s\"\n", pcToken, pcPrototype, pcName);
	    }
	    else
	    {
		char *pcToken = "child";

/* 		int iSerial = TstrGetPrincipalSerial(ptstr); */

		char pcPrototype[1000];

/* 		sprintf(pcPrototype, "%s_%i_%i", SymbolName(&pbioSource->ioh.iol.hsle), iSerial, iPrototypes - i - 1); */

		sprintf(pcPrototype, "%s_%i_%i", SymbolName(&pbioSource->ioh.iol.hsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - i - 1 */pbioSource->ioh.iol.hsle.iAllocationIdentifier);

		char pcName[1000];

		if (i == 0)
		{
/* 		    sprintf(pcName, "%s_inserted_%i", SymbolName(phsle), iSerial); */

		    sprintf(pcName, "%s_inserted_%i", SymbolName(phsle), /* ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier */phsle->iAllocationIdentifier);
		}
		else
		{
/* 		    sprintf(pcName, "%s_%i_%i", SymbolName(&pbioTarget->ioh.iol.hsle), iSerial, iPrototypes - i); */

		    sprintf(pcName, "%s_%i_%i", SymbolName(&pbioTarget->ioh.iol.hsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - i */pbioTarget->ioh.iol.hsle.iAllocationIdentifier);
		}

		fprintf(pexd->pfile, "<%s> <prototype>%s</prototype> <name>%s</name>\n", pcToken, pcPrototype, pcName);
	    }

	    if (i != 0)
	    {
		//- set biocomp tag

		pbioTarget->iOptions |= BIOCOMP_OPTION_TAG_SET;

		//- export bindables

		ExporterBindables(&pbioTarget->ioh.iol.hsle, ptstr->ppist, pexd);

		//- export bindings

		ExporterBindings(&pbioTarget->ioh.iol.hsle, ptstr->ppist, pexd);

		//- export parameter of this biological component

		struct symtab_ParContainer *pparc = pbioTarget->pparc;

		if (pparc)
		{
		    if (!ParContainerExport(pparc, ptstr->ppist, pexd->iIndent + 2, pexd->iType, pexd->pfile))
		    {
			iResult = TSTR_PROCESSOR_ABORT;
		    }
		}

		//- export this symbol children as aliasses

		if (iResult != TSTR_PROCESSOR_ABORT)
		{
		    int iOldFlags = pexd->iFlags;

		    pexd->iFlags |= EXPORTER_FLAG_CHILDREN_INSTANCES;

		    int iExported = ExporterChildrenForLibrary(&pbioTarget->ioh.iol.hsle, ptstr->ppist, pexd);

		    pexd->iFlags = iOldFlags;

		    if (!iExported)
		    {
			iResult = TSTR_PROCESSOR_ABORT;
		    }
		}
	    }

	    {
		//- export reference to component

		PrintIndent(pexd->iIndent, pexd->pfile);

		if (pexd->iType == EXPORTER_TYPE_NDF)
		{
		    char *pcToken = "CHILD";

		    fprintf(pexd->pfile, "END %s\n", pcToken);
		}
		else
		{
		    char *pcToken = "child";

		    fprintf(pexd->pfile, "</%s>\n", pcToken);
		}
	    }
	}

/* 	//- clear biocomp tag */

/* 	pbio->iOptions &= ~BIOCOMP_OPTION_TAG_SET; */

    }

    //- non biocomponents

    else
    {
	//- just skip for the moment

	iResult = TSTR_PROCESSOR_SUCCESS;
    }

    //- return result

    return(iResult);
}


static
int 
ExporterLibraryPublisher
(struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 int iIndent,
 FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    //- allocate pidin stack pointing to root

    struct PidinStack *ppistRoot = PidinStackCalloc();

    if (!ppistRoot)
    {
	return(FALSE);
    }

    PidinStackSetRooted(ppistRoot);

    struct symtab_HSolveListElement *phsleRoot
	= PidinStackLookupTopSymbol(ppistRoot);

    //- initialize exporter_data for library traversal

    struct exporter_data exd =
	{
	    /// file to write to

	    pfile,

	    /// current indentation level

	    iIndent + 2,

	    /// wildcard selector

	    ppistWildcard,

	    /// output type

	    iType,

	    /// output flags

	    iFlags,
	};

    //- allocate treespace traversal

    struct TreespaceTraversal *ptstr
	= TstrNew
	  (ppistRoot,
	   ExporterLibraryPublisherSelector,
	   (void *)&exd,
	   ExporterLibraryPublisherProcessor,
	   (void *)&exd,
	   /* 	   (void *)&exd, */ NULL,
	   /* 	   ExporterLibraryProcessor, */ NULL);

    //- traverse symbols, looking for serial

    int iTraversal = TstrGo(ptstr, phsleRoot);

    //- delete treespace traversal

    TstrDelete(ptstr);

    if (iTraversal != 1)
    {
	fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");

	iResult = 0;
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

    //- return result

    return(iResult);
}


static int
ExporterLibraryPublisherSelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process only siblings

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- return result

    return(iResult);
}


static int
ExporterLibraryPublisherProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process only siblings

    int iResult = TSTR_PROCESSOR_SIBLINGS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- determine number of prototypes

    struct symtab_BioComponent *pbio = (struct symtab_BioComponent *)phsle;

    struct symtab_BioComponent *ppbioPrototypes[100];

    int iPrototypes = BioComponentGetPrototypeList(pbio, ppbioPrototypes, 100);

    if (pexd->iType == EXPORTER_TYPE_NDF)
    {
/* 	fprintf(pexd->pfile, "  CHILD \"%s_%i_%i\" \"%s\"\n", SymbolName(phsle), TstrGetPrincipalSerial(ptstr), iPrototypes - 1, SymbolName(phsle)); */

	fprintf(pexd->pfile, "  CHILD \"%s_%i_%i\" \"%s\"\n", SymbolName(phsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - 1 */phsle->iAllocationIdentifier, SymbolName(phsle));

	fprintf(pexd->pfile, "  END CHILD\n");
    }
    else
    {
/* 	fprintf(pexd->pfile, "  <child> <prototype>%s_%i_%i</prototype> <name>%s</name>\n", SymbolName(phsle), TstrGetPrincipalSerial(ptstr), iPrototypes - 1, SymbolName(phsle)); */

	fprintf(pexd->pfile, "  <child> <prototype>%s_%i_%i</prototype> <name>%s</name>\n", SymbolName(phsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - 1 */phsle->iAllocationIdentifier, SymbolName(phsle));

	fprintf(pexd->pfile, "  </child>\n");
    }

    //- return result

    return(iResult);
}


static int
ExporterLibraryProcessor
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- return result

    return(iResult);
}


static int
ExporterLibrarySelector
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : process children of this symbol

    int iResult = TSTR_SELECTOR_PROCESS_CHILDREN;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- for a biocomponent

    int iType = TstrGetActualType(ptstr);

    if (subsetof_bio_comp(iType))
    {
	//- if it has been tagged

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	if (pbio->iOptions & BIOCOMP_OPTION_TAG_SET)
	{
	    //- don't process

	    iResult = TSTR_SELECTOR_FAILURE;
	}
    }

    //- default

    else
    {
	//- selected

	iResult = TSTR_SELECTOR_PROCESS_CHILDREN;
    }

    //- return result

    return(iResult);
}


static
int 
ExporterSymbolStarter
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- only for bio components

    if (subsetof_bio_comp(iType))
    {
	//- if is prototype

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	struct symtab_BioComponent * pbioPrototype
	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if ((pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES)
	    || (pbioPrototype
		&& !(pexd->iFlags & EXPORTER_FLAG_ALL)))
	{
	    //- export reference to component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    char *pcNamespace = (pexd->iFlags & EXPORTER_FLAG_NAMESPACES) ? pbio->pcNamespace : NULL ;

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		char *pcToken
		    = (pexd->iIndent == 2
		       ? "ALIAS"
		       : "CHILD");

		char pc[1000];

		if (pcNamespace)
		{
		    strcpy(pc, pcNamespace);
		    strcat(pc, "::");
		}

		char pcPrototype[1000];

		if (pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES)
		{
		    if (pbioPrototype)
		    {
			//- determine number of prototypes

			struct symtab_BioComponent *pbio = (struct symtab_BioComponent *)phsle;

			struct symtab_BioComponent *ppbioPrototypes[100];

			int iPrototypes = BioComponentGetPrototypeList(pbio, ppbioPrototypes, 100);

/* 			sprintf(pcPrototype, "%s_inserted_%i", SymbolName(phsle), pexd->iStarter + TstrGetPrincipalSerial(ptstr)); */

			sprintf(pcPrototype, "%s_inserted_%i", SymbolName(phsle), /* ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier */phsle->iAllocationIdentifier);
		    }
		    else
		    {
			//- determine number of prototypes

			struct symtab_BioComponent *pbio = (struct symtab_BioComponent *)phsle;

			struct symtab_BioComponent *ppbioPrototypes[100];

			int iPrototypes = BioComponentGetPrototypeList(pbio, ppbioPrototypes, 100);

			//t so pexd->iStarter + TstrGetPrincipalSerial(ptstr) might have been tagged
			//t earlier in the traversal and not be available in the exported items.  Need here to figure out
			//t what serial was used for this prototype and if available use that instead.

			//t so this serial is available during the traversal of pbioPrototype and should be set there.

			//t may be it is also possible to use iAllocationIdentifier pbioPrototype

/* 			sprintf(pcPrototype, "%s_%i_%i", SymbolName(phsle), pexd->iStarter + TstrGetPrincipalSerial(ptstr), iPrototypes - 1); */

			sprintf(pcPrototype, "%s_%i_%i", SymbolName(phsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - 1 */phsle->iAllocationIdentifier);
		    }
		}
		else
		{
		    strcpy(pcPrototype, SymbolName(&pbioPrototype->ioh.iol.hsle));
		}

		char pcName[1000];

		strcpy(pcName, SymbolName(phsle));

		fprintf(pexd->pfile, "%s \"%s%s%s\" \"%s\"\n", pcToken, (pcNamespace ? pc : ""), (pcNamespace ? "/" : ""), pcPrototype, pcName);
	    }
	    else
	    {
		char *pcToken
		    = (pexd->iIndent == 2
		       ? "alias"
		       : "child");

		char pc[1000];

		if (pcNamespace)
		{
		    sprintf(pc, "<namespace>%s::</namespace>", pcNamespace);
		}

		char pcPrototype[1000];

		if (pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES)
		{
		    //- determine number of prototypes

		    struct symtab_BioComponent *pbio = (struct symtab_BioComponent *)phsle;

		    struct symtab_BioComponent *ppbioPrototypes[100];

		    int iPrototypes = BioComponentGetPrototypeList(pbio, ppbioPrototypes, 100);

		    if (pbioPrototype)
		    {
/* 			sprintf(pcPrototype, "%s_inserted_%i", SymbolName(phsle), pexd->iStarter + TstrGetPrincipalSerial(ptstr)); */

			sprintf(pcPrototype, "%s_inserted_%i", SymbolName(phsle), /* ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier */phsle->iAllocationIdentifier);
		    }
		    else
		    {
/* 			sprintf(pcPrototype, "%s_%i_%i", SymbolName(phsle), pexd->iStarter + TstrGetPrincipalSerial(ptstr), iPrototypes - 1); */

			sprintf(pcPrototype, "%s_%i_%i", SymbolName(phsle), ppbioPrototypes[iPrototypes - 1]->ioh.iol.hsle.iAllocationIdentifier, /* iPrototypes - 1 */phsle->iAllocationIdentifier);
		    }
		}
		else
		{
		    strcpy(pcPrototype, SymbolName(&pbioPrototype->ioh.iol.hsle));
		}

		char pcName[1000];

		strcpy(pcName, SymbolName(phsle));

		fprintf(pexd->pfile, "<%s> %s<prototype>%s%s</prototype> <name>%s</name>\n", pcToken, (pcNamespace ? pc : ""), (pcNamespace ? "/" : ""), pcPrototype, pcName);
	    }

	    //- if there was a namespace

	    if (pcNamespace)
	    {
		//- set result: only sibling processing

		iResult = TSTR_PROCESSOR_SIBLINGS;
	    }

	    //- if prototypes mode

	    if (!(pexd->iFlags & EXPORTER_FLAG_PROTOTYPES))
	    {
		//- set result: only sibling processing

		iResult = TSTR_PROCESSOR_SIBLINGS;
	    }

	    //- if children instances mode

	    if (pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES
		&& pbioPrototype)
	    {
		//- set result: only sibling processing

		iResult = TSTR_PROCESSOR_SIBLINGS;
	    }

	    //- if everything must be exported

	    if (pexd->iFlags & EXPORTER_FLAG_ALL)
	    {
		//- set result: only sibling processing

		iResult = TSTR_PROCESSOR_SUCCESS;
	    }
	}

	//- else hardcoded component

	else
	{
	    //- export component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "%s \"%s\"\n", SymbolHSLETypeDescribeNDF(phsle->iType), SymbolName(phsle));
	    }
	    else
	    {
		fprintf(pexd->pfile, "<%s> <name>%s</name>\n", SymbolHSLETypeDescribeNDF(phsle->iType), SymbolName(phsle));
	    }
	}

/* 	//- at this moment we never export bindables and bindings if this is symbol is an alias */

/* 	struct symtab_BioComponent * pbioPrototype */
/* 	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle); */

/* 	if (!pbioPrototype) */

	if (!(pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES))
	{
	    //- export bindables

	    ExporterBindables(phsle, ptstr->ppist, pexd);

	    //- export bindings

	    ExporterBindings(phsle, ptstr->ppist, pexd);

	}

	//- if exporting all we must export mandatory parameter values
	//- otherwise there is the risk that the exported model cannot
	//- be instantiated.

	if (pexd->iFlags & EXPORTER_FLAG_ALL)
	{
	    //- recollect mandatory parameter values

	    if (instanceof_channel(phsle)
		|| instanceof_equation_exponential(phsle)
		|| instanceof_attachment(phsle))
	    {
		SymbolCollectMandatoryParameterValues(phsle, ptstr->ppist);
	    }
	}

	//- export parameter of this biological component

	if (!(pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES))
	{
	    struct symtab_ParContainer *pparc = pbio->pparc;

	    if (pparc)
	    {
		if (!ParContainerExport(pparc, ptstr->ppist, pexd->iIndent + 2, pexd->iType, pexd->pfile))
		{
		    iResult = TSTR_PROCESSOR_ABORT;
		}
	    }
	}

	//- if not prototypes export

	if (!(pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES)
	    && (!pbioPrototype
		|| (pexd->iFlags & EXPORTER_FLAG_ALL)))
	{
	    //- export children (maybe in prototypes mode)

	    if (!ExporterChildren(phsle, ptstr->ppist, pexd))
	    {
		iResult = TSTR_PROCESSOR_ABORT;
	    }
	    else
	    {
		//- now skip to siblings

		iResult = TSTR_PROCESSOR_SIBLINGS;
	    }
	}
    }

    //- for an algorithm

    else if (subsetof_algorithm_symbol(iType))
    {
	struct symtab_AlgorithmSymbol *palgs = (struct symtab_AlgorithmSymbol *)phsle;

	//- export component

	PrintIndent(pexd->iIndent, pexd->pfile);

	if (pexd->iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pexd->pfile, "%s \"%s\" \"%s\"\n", SymbolHSLETypeDescribeNDF(phsle->iType), palgs->dealgs.palgi->palgc->pcIdentifier, SymbolName(phsle));
	}
	else
	{
	    fprintf(pexd->pfile, "<%s> <algorithm>%s</algorithm> <name>%s</name>\n", SymbolHSLETypeDescribeNDF(phsle->iType), palgs->dealgs.palgi->palgc->pcIdentifier, SymbolName(phsle));
	}

	//- export parameter of this algorithm instance

	struct symtab_ParContainer *pparc = palgs->pparc;

	if (pparc)
	{
	    if (!ParContainerExport(pparc, ptstr->ppist, pexd->iIndent + 2, pexd->iType, pexd->pfile))
	    {
		iResult = TSTR_PROCESSOR_ABORT;
	    }
	}
    }

    //- increase indent

    pexd->iIndent += 2;

    //- return result

    return(iResult);
}


static
int 
ExporterSymbolStopper
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- decrease indent

    pexd->iIndent -= 2;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- only for bio components

    if (subsetof_bio_comp(iType))
    {
	//- if is prototype

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	struct symtab_BioComponent * pbioPrototype
	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if ((pexd->iFlags & EXPORTER_FLAG_CHILDREN_INSTANCES)
	    || (pbioPrototype
		&& !(pexd->iFlags & EXPORTER_FLAG_ALL)))
	{
	    //- export reference to component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		char *pcToken
		    = (pexd->iIndent == 2
		       ? "ALIAS"
		       : "CHILD");

		fprintf(pexd->pfile, "END %s\n", pcToken);
	    }
	    else
	    {
		char *pcToken
		    = (pexd->iIndent == 2
		       ? "alias"
		       : "child");

		fprintf(pexd->pfile, "</%s>\n", pcToken);
	    }
	}

	//- else hardcoded component

	else
	{
	    //- end biological component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "END %s\n", SymbolHSLETypeDescribeNDF(phsle->iType));
	    }
	    else
	    {
		fprintf(pexd->pfile, "</%s>\n", SymbolHSLETypeDescribeNDF(phsle->iType));
	    }
	}
    }

    //- for an algorithm

    else if (subsetof_algorithm_symbol(iType))
    {
	//- end algorithm instance

	PrintIndent(pexd->iIndent, pexd->pfile);

	if (pexd->iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pexd->pfile, "END %s\n", SymbolHSLETypeDescribeNDF(phsle->iType));
	}
	else
	{
	    fprintf(pexd->pfile, "</%s>\n", SymbolHSLETypeDescribeNDF(phsle->iType));
	}
    }

    //- return result

    return(iResult);
}


static
int 
ExporterSymbolUntagger
(struct TreespaceTraversal *ptstr, void *pvUserdata)
{
    //- set default result : continue with children, then post processing

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get traversal data

    struct exporter_data *pexd
	= (struct exporter_data *)pvUserdata;

    //- set actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    int iType = TstrGetActualType(ptstr);

    //- only for bio components

    if (subsetof_bio_comp(iType))
    {
	//- if is prototype

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	pbio->iOptions &= ~BIOCOMP_OPTION_TAG_SET;
    }

    //- return result

    return(iResult);
}


/* static */
/* int */
/* ExporterTagSymbols */
/* (struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist, */
/*  struct PidinStack *ppistWildcard, */
/*  int iType, */
/*  int iFlags, */
/*  int iIndent, */
/*  FILE *pfile) */
/* { */
/*     //- set default result: ok */

/*     int iResult = 1; */

/*     //- allocate traversal structure */

/*     struct exporter_data exd = */
/* 	{ */
/* 	    /// file to write to */

/* 	    pfile, */

/* 	    /// current indentation level */

/* 	    -1, */

/* 	    /// wildcard selector */

/* 	    ppistWildcard, */

/* 	    /// output type */

/* 	    iType, */

/* 	    /// output flags */

/* 	    iFlags, */

/* 	    /// serial of the symbol that starts the traversal */

/* 	    -1, */
/* 	}; */

/*     //- traverse symbols that match with wildcard */

/*     int iTraversal */
/* 	= SymbolTraverseWildcard */
/* 	  (phsle, */
/* 	   ppist, */
/* 	   ppistWildcard, */
/* 	   ExporterSymbolTagger, */
/* 	   NULL, */
/* 	   (void *)&exd); */

/*     if (iTraversal != 1) */
/*     { */
/* 	fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n"); */

/* 	iResult = 0; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


