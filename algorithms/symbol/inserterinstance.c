//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: inserterinstance.c 1.24 Wed, 14 Nov 2007 16:32:22 -0600 hugo $
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


#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces/algorithmclass.h"
#include "neurospaces/algorithminstance.h"
#include "neurospaces/algorithminstance_vtable.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/idin.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "connectionworkerinstance.h"
#include "contextworkerinstance.h"
#include "inserter.h"
#include "inserterinstance.h"


/// \struct inserter algorithm private data

/*s */
/*s struct with inserter options */
/*S */

struct InserterOptions_type
{
    /*m name of filename with parameters */

    char *pcHeightsFile;

    /*m name matcher, selects segment candidates by name */

    char *pcSelector;

    /*m insert frequency */

    float fInsertFrequency;
};

typedef struct InserterOptions_type InserterOptions;


#define ELEMENT_NAME_SIZE 100

/// \struct height record

struct HeightRecord
{
    /// height

    double dHeight;

    /// prototype

    char pcPrototype[ELEMENT_NAME_SIZE];

    struct symtab_HSolveListElement *phslePrototype;

    /// name of new symbol

    char pcInstance[ELEMENT_NAME_SIZE];
};


/// \struct heights array

struct HeightsArray
{
    /// number allocated

    int iAllocated;

    /// number used

    int iRead;

    /// \struct heights records

    struct HeightRecord *phr;
};


/// \struct
/// \struct inserter variables
/// \struct

struct InserterVariables_type
{
    /// base symbol, start of traversal

    struct symtab_HSolveListElement *phsleBase;

    struct PidinStack *ppistBase;

    /// number of inserted symbols

    int iInsertedSymbols;

    /// number of tries

    int iInserterTries;

    /// number of failures

    int iInserterFailures;

    /// heights file

    FILE *pfileHeights;

    /// \struct heights array

    struct HeightsArray *pha;

    /// current parser context

    struct ParserContext *pacContext;

    /// number of segments receiving new symbols

    int iSegments;

    /// segments receiving new symbols

#define MAX_SEGMENTS 1000

    struct
    {
	/// serial

	int iSerial;

	/// symbol

	struct symtab_HSolveListElement *phsle;

	/// position

	struct D3Position D3;
    }
	psegments_info[MAX_SEGMENTS];
};

typedef struct InserterVariables_type InserterVariables;


/// \struct inserter instance, derives from algorithm instance

struct InserterInstance
{
    /// base struct

    struct AlgorithmInstance algi;

    /// options for this instance

    InserterOptions io;

    /// variables for this instance

    InserterVariables iv;
};


// local functions

static
int
InserterInstanceHeightsLookup
(struct InserterInstance *pii,
 struct HeightsArray *pha,
 double dHeight,
 double dRange,
 int *piRecords);

static
int
InserterInstanceInsert
(struct InserterInstance *pii,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsle);

static
int
InserterInstanceProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata);

static int InserterInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile);

static
int
InserterInstanceReadHeights
(struct InserterInstance *pii, FILE *pfile);

static 
int
InserterInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac);


/// 
/// 
/// \arg pii inserter algorithm instance.
/// \arg pha height array.
/// \arg dHeight height to search.
/// \arg dRange height range for matching.
/// \arg piRecords number of matching records.
/// 
/// \return int
/// 
///	index of first matching record, -1 if none.
/// 
///	piRecords.: number of matching records.
/// 
/// \brief Find first height record that matches with the given height.
/// \details 
/// 

static
int
InserterInstanceHeightsLookup
(struct InserterInstance *pii,
 struct HeightsArray *pha,
 double dHeight,
 double dRange,
 int *piRecords)
{
    //- set default result: not found

    int iResult = -1;

    //- we found none matching record so far

    int iRecords = 0;

    //- determine the stop height

    double dStop = dHeight + dRange;

    //- loop over the heights array

    int iRecord;

    for (iRecord = 0 ; iRecord < pii->iv.pha->iRead ; iRecord++)
    {
	struct HeightRecord *phr = &pii->iv.pha->phr[iRecord];

	//- if current height within range

	if (phr->dHeight > dHeight
	    && phr->dHeight <= dStop)
	{
	    //- we found the first record

	    iResult = iRecord;

	    iRecords++;

	    //- break searching loop

	    break;
	}
    }

    //- if we found the first matching record

    if (iResult != -1)
    {
	//- loop over the rest of the heights array

	int iRecord;

	for (iRecord = iResult + 1 ; iRecord < pii->iv.pha->iRead ; iRecord++)
	{
	    struct HeightRecord *phr = &pii->iv.pha->phr[iRecord];

	    //- if current height over range

	    if (phr->dHeight > dStop)
	    {
		//- break searching loop

		break;
	    }

	    //- increment number of matching records

	    iRecords++;
	}
    }

    //- set number of matching records as result

    if (piRecords)
    {
	*piRecords = iRecords;
    }

    //- return result

    return(iResult);
}


/// 
/// 
/// \arg pii inserter algorithm instance.
/// \arg ptstr active traversal.
/// \arg phsle top symbol to consider.
/// 
/// \return int : number of added symbols, -1 for failure.
/// 
/// \brief Insert symbols.
/// \details 
/// 

static
int
InserterInstanceInsert
(struct InserterInstance *pii,
 struct PidinStack *ppist,
 struct symtab_HSolveListElement *phsle)
{
    //- set default result : none added

    int iResult = 0;

    if (!pii->iv.pha)
    {
	return(iResult);
    }

    fprintf(stdout, "Inserter instance %s\n", pii->algi.pcIdentifier);

    //- loop over the segments found

    int iSegment = 0;

    for (iSegment = 0 ; iSegment < pii->iv.iSegments ; iSegment++)
    {
	struct symtab_HSolveListElement *phsleSegment
	    = pii->iv.psegments_info[iSegment].phsle;

	//- default we do not add a symbol

	int iAdd = 0;

	//- if frequency is set to one

	if (pii->io.fInsertFrequency == 1)
	{
	    //- remember to add a symbol

	    iAdd = 1;
	}

	//- if frequency is set to zero

	else if (pii->io.fInsertFrequency == 0)
	{
	    //- we do nothing
	}

	//- if frequency is a probability

	else if (pii->io.fInsertFrequency > 0)
	{
	    /// \note this algorithm tries to spread as uniformly as possible,
	    /// \note by giving a guarantee that every dendrite receives at least
	    /// \note one symbol if the frequency is greater than or equal to 1.

	    double dFrequency = pii->io.fInsertFrequency;

	    //- set base number of symbols to add: the integer part of the frequency

	    iAdd = floor(dFrequency);

	    //- determine fractional frequency

	    dFrequency -= iAdd;

	    //- generate a random number

	    long int iRandom = random();

	    //- compute the probability for this random number

	    double dProbability = (double) iRandom / RAND_MAX;

	    //- if probability lower than frequency

	    if (dProbability < dFrequency)
	    {
		//- remember to add a symbol

		iAdd++;
	    }
	}

	//- else

	else
	{
	    //- increment failure count

	    pii->iv.iInserterFailures++;
	}

	//- if we need to insert symbols

	int iMax = iAdd;

	int iInfo = 0;

	while (iAdd > 0)
	{
	    //- determine the height of the segment

	    struct D3Position D3Segment = pii->iv.psegments_info[iSegment].D3;

	    double dRange = DBL_MAX;

	    if (iSegment < pii->iv.iSegments - 1)
	    {
		dRange = pii->iv.psegments_info[iSegment + 1].D3.dz - D3Segment.dz;
	    }

	    //- get info from heights records

	    int iRecords = -1;

	    int iHeight = InserterInstanceHeightsLookup(pii, pii->iv.pha, D3Segment.dz, dRange, &iRecords);

	    fprintf(stdout, "Found for height %g, range %g: %i records, starting at %i, height %g\n", D3Segment.dz, dRange, iRecords, iHeight, pii->iv.pha->phr[iHeight].dHeight);

	    if (iHeight != -1)
	    {
		//- loop over the heights range found

		int iRecord;

		for (iRecord = 0 ; iRecord < iRecords ; iRecord++)
		{
		    //- lookup the prototype

		    struct symtab_HSolveListElement *phslePrototype
			= pii->iv.pha->phr[iRecord + iHeight].phslePrototype;

		    if (!phslePrototype)
		    {
			//- get name of prototype from heights data

			char *pcPrototype = pii->iv.pha->phr[iRecord + iHeight].pcPrototype;

			//- lookup the prototype

			phslePrototype = ParserLookupPrivateModel(pcPrototype);
		    }

		    if (phslePrototype)
		    {
			//- fill in the prototype in the height record

			pii->iv.pha->phr[iRecord + iHeight].phslePrototype = phslePrototype;

			//- determine a name for the new symbol

			struct symtab_IdentifierIndex *pidinAlias = NULL;

			if (strlen(pii->iv.pha->phr[iRecord + iHeight].pcInstance) == 0)
			{
			    pidinAlias
				= IdinCreateAlias(SymbolGetPidin(phslePrototype), iMax - iAdd);
			}
			else
			{
			    char pcName[ELEMENT_NAME_SIZE];

			    strcpy(pcName, pii->iv.pha->phr[iRecord + iHeight].pcInstance);

			    /// \note memory leak

			    pidinAlias = IdinCreateAlias(IdinNewFromChars(pcName), 0);

			}

			//- create an alias (symbol must be biocomp)

			struct symtab_HSolveListElement *phsleNew
			    = SymbolCreateAlias(phslePrototype, NULL, pidinAlias);

			//- add algorithm info

			if (0
			    && !iInfo
			    && 0)
			{
			    if (SymbolSetAlgorithmInstanceInfo(phsleSegment, &pii->algi))
			    {
				iInfo = 1;
			    }
			    else
			    {
				pii->iv.iInserterFailures++;
			    }
			}

			if ((1
			     || iInfo
			     || 1)
			    && (1
				|| SymbolSetAlgorithmInstanceInfo(phsleNew, &pii->algi)
				|| 1))
			{
			    //- link symbol to segment

			    SymbolAddChild(phsleSegment, phsleNew);
    
			    //- increment added symbol count

			    pii->iv.iInsertedSymbols++;

			    //- increment result

			    iResult++;
			}

			//- else

			else
			{
			    //- increment failure count

			    pii->iv.iInserterFailures++;
			}
		    }
		    else
		    {
			NeurospacesError
			    (pii->iv.pacContext,
			     "InserterInstance",
			     "Inserter instance %s cannot find symbol %s\n",
			     pii->algi.pcIdentifier,
			     pii->iv.pha->phr[iRecord + iHeight].pcPrototype);
		    }
		}
	    }

	    //- decrement number of inserter to add

	    iAdd--;
	}

	//- increment tries count

	pii->iv.iInserterTries++;
    }

    if (pii->iv.iInserterFailures)
    {
	NeurospacesError
	    (pii->iv.pacContext,
	     "InserterInstance",
	     "Inserter instance %s encountered %i failures\n",
	     pii->algi.pcIdentifier,
	     pii->iv.iInserterFailures);
    }

    //- return result

    return(iResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return struct AlgorithmInstance *  
/// 
///	created algorithm instance, NULL for failure
/// 
/// \brief Algorithm handler to create instance of inserter algorithm.
/// \details 
/// 

struct AlgorithmInstance *
InserterInstanceNew
(struct AlgorithmClass *palgc,
 char *pcInstance,
 void *pvGlobal,
 struct symtab_AlgorithmSymbol *palgs)
{
    //- set default result : failure

    struct AlgorithmInstance *palgiResult = NULL;

    //- set parser context

    struct ParserContext *pacContext = (struct ParserContext *)pvGlobal;

#include "hierarchy/output/algorithm_instances/inserter_vtable.c"

#include "hierarchy/output/algorithm_instances/type_defines.h"

    struct InserterInstance *pii
	= (struct InserterInstance *)
	  AlgorithmInstanceCalloc(1, sizeof(struct InserterInstance), _vtable_inserter, HIERARCHY_TYPE_algorithm_instances_inserter);

    AlgorithmInstanceSetName(&pii->algi, pcInstance);

    {
	struct PidinStack *ppist = ParserContextGetPidinContext(pacContext);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

	//- get heights parameter filename

	struct symtab_Parameters *pparHeights
	    = SymbolFindParameter(&palgs->hsle, ppist, "HEIGHTS_PARAMETER_FILENAME");

	if (pparHeights)
	{
	    pii->io.pcHeightsFile = ParameterGetString(pparHeights);
	}

	//- get symbol name selector

	struct symtab_Parameters *pparSelector
	    = SymbolFindParameter(&palgs->hsle, ppist, "NAME_SELECTOR");

	if (pparSelector)
	{
	    pii->io.pcSelector = ParameterGetString(pparSelector);
	}
	else
	{
	    NeurospacesError
		(pacContext,
		 "InserterInstance",
		 "Inserter instance %s cannot resolve NAME_SELECTOR parameter\n",
		 pcInstance);
	}

	//- scan frequency

	pii->io.fInsertFrequency = SymbolParameterResolveValue(&palgs->hsle, ppist, "INSERTION_FREQUENCY");
    }

    //- initialize counts

    pii->iv.iInsertedSymbols = 0;
    pii->iv.iInserterFailures = 0;
    pii->iv.iInserterTries = 0;

    //- register parser context

    pii->iv.pacContext = pacContext;

    //- if working with heights

    if (pii->io.pcHeightsFile)
    {
	//- have the parser qualify the filename

	char *pcHeights
	    = ParserContextQualifyFilename(pacContext, pii->io.pcHeightsFile);

	if (pcHeights)
	{
	    //- open file

	    pii->iv.pfileHeights = fopen(pcHeights, "r");

	    if (pii->iv.pfileHeights)
	    {
		//- parse file

		if (InserterInstanceReadHeights(pii, pii->iv.pfileHeights))
		{
		}
		else
		{
		    NeurospacesError
			(pacContext,
			 "InserterInstance",
			 "Inserter instance %s cannot parse file %s\n",
			 pcInstance,
			 pcHeights);
		}

		//- close file

		fclose(pii->iv.pfileHeights);
	    }

	    //- else

	    else
	    {
		//- give diag's: file problems

		NeurospacesError
		    (pacContext,
		     "InserterInstance",
		     "Inserter instance %s cannot open file %s\n",
		     pcInstance,
		     pcHeights);
	    }
	}

	//- else

	else
	{
	    //- give diag's: file problems

	    NeurospacesError
		(pacContext,
		 "InserterInstance",
		 "Inserter instance %s cannot find file %s\n",
		 pcInstance,
		 pii->io.pcHeightsFile);
	}
    }

    //- set result

    palgiResult = &pii->algi;

    //- return result

    return(palgiResult);
}


/// 
/// 
/// \arg std AlgorithmHandler args
/// 
/// \return int  std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to print info on inserter instance.
/// \details 
/// 

static int InserterInstancePrintInfo
(struct AlgorithmInstance *palgi, FILE *pfile)
{
    //- set default result

    int bResult = TRUE;

    //- get pointer to algorithm instance

    struct InserterInstance *pii = (struct InserterInstance *)palgi;

    //- get name of algorithm instance

    char *pcInstance = AlgorithmInstanceGetName(&pii->algi);

    //- print info

    fprintf
	(pfile,
	 "---\n"
	 "name: InserterInstance %s\n"
	 "report:\n"
	 "    number_of_tries: %i\n"
	 "    number_of_failures_adding: %i\n",
	 pcInstance,
	 pii->iv.iInserterTries,
	 pii->iv.iInserterFailures);

    fprintf
	(pfile,
	 "    InserterInstance heights file: %s\n"
	 "    InserterInstance insertion frequency: %f\n",
	 pii->io.pcHeightsFile,
	 pii->io.fInsertFrequency);

    //- return result

    return(bResult);
}


/// 
/// 
///	SymbolProcessor args
/// 
/// \return int : 
/// 
///	SymbolProcessor return value, always SYMBOL_PROCESSOR_SUCCESS
/// 
/// \brief Obtain coordinates from encountered symbols.
/// \details 
/// 

static
int
InserterInstanceProcessor
(struct TreespaceTraversal *ptstr,void *pvUserdata)
{
    //- set default result : ok

    int iResult = TSTR_PROCESSOR_SUCCESS;

    //- get pointer to algorithm instance

    struct InserterInstance *pii = (struct InserterInstance *)pvUserdata;

    //- get pointer to actual symbol

    struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)TstrGetActual(ptstr);

    //- get algorithm instance info on symbol

    struct AlgorithmInstance *palgi
	= SymbolGetAlgorithmInstanceInfo(phsle);

    //- if already attached by some algorithm

    if (0
	&& palgi
	&& 0)
    {
	//- register failure in algorithm instance

	pii->iv.iInserterFailures++;

	//- set result : ok, but process siblings

	iResult = TSTR_PROCESSOR_FAILURE;
    }

    //- if this is a segment

    if (instanceof_segment(phsle))
    {
	//- if name matches

	char *pcSymbol = SymbolGetName(phsle);

	if (pii->io.pcSelector
	    && strncmp(pcSymbol, pii->io.pcSelector, strlen(pii->io.pcSelector)) == 0)
	{
	    //- get height

	    struct D3Position D3;

	    SymbolParameterResolveCoordinateValue
		(pii->iv.phsleBase,
		 pii->iv.ppistBase,
		 ptstr->ppist,
		 &D3);

	    //- store segment info

	    pii->iv.psegments_info[pii->iv.iSegments].iSerial
		= TstrGetPrincipalSerial(ptstr);

	    pii->iv.psegments_info[pii->iv.iSegments].phsle = phsle;

	    pii->iv.psegments_info[pii->iv.iSegments].D3 = D3;

	    //- activate segment

	    pii->iv.iSegments++;
	}
    }

    //- return result

    return (iResult);
}


/// 
/// 
/// \arg pii inserter instance.
/// \arg pfile heights file.
/// 
/// \return int
/// 
///	Success of operation.
/// 
/// \brief Parse a heights file.
/// \details 
/// 

int HeightComparator(const void *a, const void *b);

int HeightComparator(const void *a, const void *b)
{
    struct HeightRecord *phr1 = (struct HeightRecord *)a;

    struct HeightRecord *phr2 = (struct HeightRecord *)b;

    if (phr1->dHeight < phr2->dHeight)
    {
	return(-1);
    }
    else if (phr1->dHeight == phr2->dHeight)
    {
	return(0);
    }
    else
    {
	return(1);
    }
}


static
int
InserterInstanceReadHeights
(struct InserterInstance *pii, FILE *pfile)
{
    //- set default result: ok

    int iResult = 1;

    //- allocate height records

    struct HeightsArray *pha
	= (struct HeightsArray *)calloc(1, sizeof(struct HeightsArray));

    pha->iAllocated = 100;

    pha->phr
	= (struct HeightRecord *)calloc(pha->iAllocated, sizeof(struct HeightRecord));

    if (pha->phr)
    {
	//- go through the file

	int iEOF = 0;

	pha->iRead = 0;

	while (!iEOF)
	{
	    //- read a record

	    char pc[ELEMENT_NAME_SIZE * 10];

	    if (fgets(pc, ELEMENT_NAME_SIZE * 10, pfile))
	    {
		//- if not an element of a yaml array

		/// \note hardcoded indentation, 4 spaces required

		if (pc[0] == ' '
		    && pc[1] == ' '
		    && pc[2] == ' '
		    && pc[3] == ' '
		    && pc[4] == '-'
		    && pc[5] == ' ')
		{
		    int iScanned
			= sscanf
			  (pc,
			   " - %lf: %s %s\n",
			   &pha->phr[pha->iRead].dHeight,
			   pha->phr[pha->iRead].pcPrototype,
			   pha->phr[pha->iRead].pcInstance);

		    //- if number of scanned values is ok

		    if (iScanned == 2 || iScanned == 3)
		    {
			//- next record

			pha->iRead++;

			//- check for reallocation need

			if (pha->iRead >= 100)
			{
			    pha->iAllocated += 100;

			    pha->phr = (struct HeightRecord *)realloc(pha->phr, pha->iAllocated * sizeof(struct HeightRecord));

			    if (!pha->phr)
			    {
				iResult = 0;

				break;
			    }
			}
		    }
		    else
		    {
			fprintf(stderr, "parse failure for InserterInstanceReadHeights, record %i, scanned %i items (instead of 2 or 3)\n", pha->iRead, iScanned); 

			iResult = 0;

			break;
		    }
		}
	    }

	    //- or

	    else
	    {
		//- end of file

		iEOF = 1;
	    }
	}
    }
    else
    {
	iResult = 0;
    }

    //- if success

    if (iResult)
    {
	//- sort heights records

	qsort(pha->phr, pha->iRead, sizeof(struct HeightRecord), HeightComparator);

	//- register the records in the algorithm instance variables

	pii->iv.pha = pha;
    }

    //- return result

    return(iResult);
}


/// 
/// 
///	AlgorithmInstanceSymbolHandler args.
/// 
/// \return int : std AlgorithmHandler return value
/// 
/// \brief Algorithm handler to add inserter on given symbol
/// \details 
/// 
///	Does it do a clean update of serials ?
/// 

static 
int
InserterInstanceSymbolHandler
(struct AlgorithmInstance *palgi, struct ParserContext *pac)
{
    //- set default result: ok

    int iResult = TRUE;

    //- get info about current symbol

    struct PidinStack *ppist = ParserContextGetPidinContext(pac);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    //- get pointer to algorithm instance

    struct InserterInstance *pii = (struct InserterInstance *)palgi;

    //- register current symbol as a variable

    pii->iv.phsleBase = phsle;

    pii->iv.ppistBase = ppist;

    //- select segment symbols

    iResult
	= SymbolTraverseSegments
	  (phsle,
	   ppist,
	   InserterInstanceProcessor,
	   NULL,
	   (void *)(struct InserterInstance *)palgi);

    if (iResult != 1)
    {
	iResult = FALSE;
    }

    //- add components

    int iAdded = InserterInstanceInsert(pii, ppist, phsle);

    if (iAdded == -1)
    {
	iResult = FALSE;
    }

    SymbolRecalcAllSerials(phsle,ppist);

    //- return result

    return(iResult);
}


