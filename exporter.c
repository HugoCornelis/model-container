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
ExporterSymbolStarter
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
ExporterSymbol
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
 FILE *pfile);

static
int 
ExporterSymbolStopper
(struct TreespaceTraversal *ptstr, void *pvUserdata);


///
/// \arg phsle symbol to export bindables of.
/// \arg ppist context of symbol.
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

    iResult
	= (iResult
	   && DefSymPrint(pdefsym, FLAG_SYMBOL_DEPENDENCY, 4, iType, pfile));

    //- export private symbols

    {
	//- start public models

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
	    iResult = ExporterSymbol(phslePrivate, ppistPrivate, ppistWildcard, iType, iFlagsPrivate, pfile);
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

    //- export public symbols

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
	    iResult = ExporterSymbol(phsleRoot, ppistRoot, ppistWildcard, iType, iFlags, pfile);
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

    //- if this is a cell

    if (0 && subsetof_cell(iType))
    {
	//- and it has no descendants

	int iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle);

	if (iSuccessors == 0)
	{
	    //- set result: siblings only

	    iResult = TSTR_PROCESSOR_FAILURE;
	}
    }

    //- only for bio components

    else if (subsetof_bio_comp(iType))
    {
	//- if is prototype

	//t and exporting prototypes enabled ?

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	struct symtab_BioComponent * pbioPrototype
	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if (pbioPrototype)
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

		if (pcNamespace)
		{
		    char pc[1000];

		    strcpy(pc, pcNamespace);
		    strcat(pc, "::");

		    pcNamespace = &pc[0];
		}

		fprintf(pexd->pfile, "%s %s%s%s %s\n", pcToken, (pcNamespace ? pcNamespace : ""), (pcNamespace ? "/" : ""), SymbolName(&pbioPrototype->ioh.iol.hsle), SymbolName(phsle));
	    }
	    else
	    {
		char *pcToken
		    = (pexd->iIndent == 2
		       ? "alias"
		       : "child");

		if (pcNamespace)
		{
		    char pc[1000];

		    sprintf(pc, "<namespace>%s::</namespace>", pcNamespace);

		    pcNamespace = &pc[0];
		}

		fprintf(pexd->pfile, "<%s> %s<prototype>%s%s</prototype> <name>%s</name>\n", pcToken, (pcNamespace ? pcNamespace : ""), (pcNamespace ? "/" : ""), SymbolName(&pbioPrototype->ioh.iol.hsle), SymbolName(phsle));
	    }

	    //- if there was a namespace

	    if (pcNamespace)
	    {
		//- set result: only sibling processing

		iResult = TSTR_PROCESSOR_SIBLINGS;
	    }

	    //- if prototypes allowed to be exported

	    if (!(pexd->iFlags & EXPORTER_FLAG_PROTOTYPES))
	    {
		//- set result: only sibling processing

		iResult = TSTR_PROCESSOR_SIBLINGS;
	    }
	}

	//- else hardcoded component

	else
	{
	    //- export component

	    PrintIndent(pexd->iIndent, pexd->pfile);

	    if (pexd->iType == EXPORTER_TYPE_NDF)
	    {
		fprintf(pexd->pfile, "%s %s\n", SymbolHSLETypeDescribeNDF(phsle->iType), SymbolName(phsle));
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
	{
	    //- export bindables

	    ExporterBindables(phsle, ptstr->ppist, pexd);

	    //- export bindings

	    ExporterBindings(phsle, ptstr->ppist, pexd);
	}

	//- export parameter of this biological component

	struct symtab_ParContainer *pparc = pbio->pparc;

	if (pparc)
	{
	    if (!ParContainerExport(pparc, ptstr->ppist, pexd->iIndent + 2, pexd->iType, pexd->pfile))
	    {
		iResult = TSTR_PROCESSOR_ABORT;
	    }
	}
    }

    //- for algorithm

    else if (subsetof_algorithm_symbol(iType))
    {
	struct symtab_AlgorithmSymbol *palgs = (struct symtab_AlgorithmSymbol *)phsle;

	//- export component

	PrintIndent(pexd->iIndent, pexd->pfile);

	if (pexd->iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(pexd->pfile, "%s %s %s\n", SymbolHSLETypeDescribeNDF(phsle->iType), palgs->dealgs.palgi->palgc->pcIdentifier, SymbolName(phsle));
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
ExporterSymbol
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 struct PidinStack *ppistWildcard,
 int iType,
 int iFlags,
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

	    2,

	    /// wildcard selector

	    ppistWildcard,

	    /// output type

	    iType,

	    /// output flags

	    iFlags,
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

    //- if this is a cell

    if (0 && subsetof_cell(iType))
    {
	//- and it has no descendants

	int iSuccessors = SymbolGetPrincipalNumOfSuccessors(phsle);

	if (iSuccessors == 0)
	{
	    //- set result: siblings only

	    iResult = TSTR_PROCESSOR_SIBLINGS;
	}
    }

    //- if a bio component

    else if (subsetof_bio_comp(iType))
    {
	//- if is prototype

	//t and exporting prototypes enabled ?

	struct symtab_BioComponent *pbio
	    = (struct symtab_BioComponent *)phsle;

	struct symtab_BioComponent * pbioPrototype
	    = (struct symtab_BioComponent *)SymbolGetPrototype(&pbio->ioh.iol.hsle);

	if (pbioPrototype)
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


