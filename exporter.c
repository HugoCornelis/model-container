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
#include "neurospaces/exporter.h"


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
};



static
int 
ExporterSymbolStarter
(struct TreespaceTraversal *ptstr, void *pvUserdata);

static
int
ExporterSymbols(struct PidinStack *ppistWildcard, int iType, char *pcFilename);

static
int 
ExporterSymbolStopper
(struct TreespaceTraversal *ptstr, void *pvUserdata);


/// 
/// \arg ppistWildcard wildcard of symbols to export.
/// \arg iType type of export, see below.
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

int ExporterModel(struct PidinStack *ppistWildcard, int iType, char *pcFilename)
{
    //- set default result: ok

    int iResult = 1;

    //t get dependencies / prototypes

    //- export symbols

    iResult = ExporterSymbols(ppistWildcard, iType, pcFilename);

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

    if (subsetof_bio_comp(iType))
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
		fprintf(pexd->pfile, "CHILD %s %s\n", SymbolName(&pbioPrototype->ioh.iol.hsle), SymbolName(phsle));
	    }
	    else
	    {
		fprintf(pexd->pfile, "<child> <name>%s</name> </child>\n", SymbolName(phsle));
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

    //- increase indent

    pexd->iIndent += 2;

    //- return result

    return(iResult);
}


static
int
ExporterSymbols(struct PidinStack *ppistWildcard, int iType, char *pcFilename)
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

    /// \note so phsleRoot can be NULL if the model description file was not found

    if (phsleRoot)
    {
	//- allocate traversal structure

	struct exporter_data exd =
	    {
		/// file to write to

		NULL,

		/// current indentation level

		0,

		/// wildcard selector

		ppistWildcard,

		/// output type

		iType,
	    };

	//- open output file

	exd.pfile = fopen(pcFilename, "w");

	//- start output

	if (exd.iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(exd.pfile, "#!neurospacesparse\n// -*- NEUROSPACES -*-\n\nNEUROSPACES NDF\n\n");
	}
	else
	{
	}

	//- start public models

	if (exd.iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(exd.pfile, "PUBLIC_MODELS\n");
	}
	else
	{
	    fprintf(exd.pfile, "<public_models>\n");
	}

	//- increase indent

	exd.iIndent += 2;

	//- traverse symbols that match with wildcard

	int iTraversal
	    = SymbolTraverseWildcard
	      (phsleRoot,
	       ppistRoot,
	       ppistWildcard,
	       ExporterSymbolStarter,
	       ExporterSymbolStopper,
	       (void *)&exd);

	if (iTraversal != 1)
	{
	    fprintf(stdout, "*** Error: SymbolTraverseWildcard() failed (or aborted)\n");

	    iResult = 0;
	}

	//- decrease indent

	exd.iIndent -= 2;

	//- end public models

	if (exd.iType == EXPORTER_TYPE_NDF)
	{
	    fprintf(exd.pfile, "PUBLIC_MODELS\n");
	}
	else
	{
	    fprintf(exd.pfile, "</public_models>\n");
	}

	//- close output file

	fclose(exd.pfile);
    }
    else
    {
	iResult = 0;
    }

    //- free allocated memory

    PidinStackFree(ppistRoot);

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

    if (subsetof_bio_comp(iType))
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
		fprintf(pexd->pfile, "END CHILD\n");
	    }
	    else
	    {
		fprintf(pexd->pfile, "</child>\n");
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

    //- return result

    return(iResult);
}


