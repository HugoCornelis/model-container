static char *pcVersionTime="(08/06/15) Sunday, June 15, 2008 22:02:17 hugo";

//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: neurospaces.c 1.118 Sat, 13 Oct 2007 20:56:19 -0500 hugo $
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

#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include <sys/resource.h>
#include <sys/time.h>
#include <unistd.h>


#include <EXTERN.h>
#include <perl.h>

//! perl.h defines YYSTYPE, redefine it to void

#define YYSTYPE void

#include "neurospaces/lexsupport.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/hines_listlist.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/algorithmset.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/symbols.h"


static struct NeurospacesConfig *pnscGlobal = NULL;


// prototypes

static
struct NeurospacesConfig *
ConfigCalloc(int argc, char *argv[]);

static int ConfigExport(struct NeurospacesConfig *pnsc, int argc, char *argv[]);

static int ConfigParse(struct NeurospacesConfig *pnsc, int argc, char *argv[]);

static int ConfigProcess(struct NeurospacesConfig *pnsc, struct Neurospaces *pneuro);


static int NeurospacesEndTimingReport(void);

static int NeurospacesStartTimingReport(void);


// command line support routines

static 
struct NeurospacesConfig *
ConfigCalloc(int argc, char *argv[])
{
    //- allocate cli

    struct NeurospacesConfig *pnscResult
	= (struct NeurospacesConfig *)calloc(1, sizeof(*pnscResult));

    //- parse command line

    ConfigParse(pnscResult, argc, argv);

    //- return result

    return(pnscResult);
}


static int ConfigParse(struct NeurospacesConfig *pnsc, int argc, char *argv[])
{
    //v loop var

    int i;

    //- default actual position in file array

    int iFilePos = 0;

    //- default actual position in query array

    int iQueryPos = 0;

    //- zero out command line interface

    memset(pnsc, 0, sizeof(*pnsc));

    //- register original command line arguments

    pnsc->iArgc = argc;

    pnsc->ppcArgv = argv;

    //- loop over command line args (skip exe filename)

    for (i = 1; i < argc; i++)
    {
	//- if option given

	if (argv[i][0] == '-')
	{
	    //- look at given option

	    switch (argv[i][1])
	    {
///		-d <filename> : debug output to given file
		case 'd':
		{
		    //- set flag for debug file

		    pnsc->nso.iFlags |= NSOFLAG_DEBUGFILE;

		    //- go to next argument

		    i++;

		    //- open debug file

		    pnsc->nso.pfileDebug = fopen(argv[i],"w");

		    //t test for success

		    break;
		}
///		-h : give help and exit
		case 'h':
		{
		    //- set flag to give help and exit

		    pnsc->nso.iFlags |= NSOFLAG_HELP;

		    break;
		}
///		-i : print imported files to stderr at end of parsing
		case 'i':
		{
		    //- set flag to print imported files

		    pnsc->nso.iFlags |= NSOFLAG_IMPORTPRINT;

		    break;
		}
///		-m <directory> : set model library location
		case 'm':
		{
		    //- go to next argument

		    i++;

		    //- register model directory

		    pnsc->nso.pcModelLibrary = argv[i];

		    //t test for success

		    break;
		}
///		-p : parsing only, no importing, no algorithm handling
		case 'p':
		{
		    //- set flag to disable parsing of other files

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_IMPORTING;

		    //- set flag to disable algorithm handling

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_ALGORITHM_HANDLING;

		    //- set flag to disable dependency lookups

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_DEPCY_LOOKUP;

		    //- set flag to disable private model lookups

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_PRIVATE_LOOKUP;

		    //- set flag to disable public model lookups

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_PUBLIC_LOOKUP;

		    break;
		}
///		-q : enter query machine after parsing
		case 'q':
		{
		    //- set flag to enter query machine after parsing

		    pnsc->nso.iFlags |= NSOFLAG_QUERYMACHINE;

		    break;
		}
///		-t : report symbol table after parsing
		case 't':
		{
		    //- set flag to print imported files

		    pnsc->nso.iFlags |= NSOFLAG_PRINTSYMBOLTABLE;

		    break;
		}
///		-v <level> : set verbosity level
		case 'v':
		{
		    //- set flag for verbosity mode

		    pnsc->nso.iFlags |= NSOFLAG_VERBOSE;

		    //- go to next argument

		    i++;

		    //- parse verbosity number

		    //t could do a ascii->int mapping here to allow ascii
		    //t command line options

		    //t use strtol() to detect errors

		    pnsc->nso.iVerbosity = atoi(argv[i]);

		    break;
		}
///		-A : turn off algorithm processing
		case 'A':
		{
		    //- set flag to turn off algorithm processing

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_ALGORITHM_HANDLING;

		    break;
		}
///		-D : turn on parser debug flag
		case 'D':
		{
		    //- set flag to debug parser

		    pnsc->nso.iFlags |= NSOFLAG_PARSERDEBUG;

		    break;
		}
///		-M : report algorithm info after parsing
		case 'M':
		{
		    //- set flag to report algorithm info after parsing

		    pnsc->nso.iFlags |= NSOFLAG_PRINTALGORITHMINFO;

		    break;
		}
///		-Q : a query machine command after parsing
		case 'Q':
		{
		    //- go to next argument

		    i++;

		    //- copy query machine command

		    strcpy(&pnsc->pcQueries[iQueryPos], argv[i]);

		    //- go to next query machine command position, skipping \0 char

		    iQueryPos += 1 + strlen(argv[i]);

		    break;
		}
///		-R : disable readline
		case 'R':
		{
		    //- set flag to disable readline

		    pnsc->nso.iFlags |= NSOFLAG_DISABLE_READLINE;

		    break;
		}
///		-T <level> : set timing report level
		case 'T':
		{
		    //- set flag for timing report level

		    pnsc->nso.iFlags |= NSOFLAG_TIMINGS;

		    //- go to next argument

		    i++;

		    //- parse timing type

		    //t could do a ascii->int mapping here to allow ascii
		    //t command line options

		    //t use strtol() to detect errors

		    pnsc->nso.iTiming = atoi(argv[i]);

		    break;
		}
///		-V <level> : set exclusive verbosity level
		case 'V':
		{
		    //- set flag for verbosity mode

		    pnsc->nso.iFlags |= NSOFLAG_EXCLUSIVEVERBOSE;

		    //- go to next argument

		    i++;

		    //- parse verbosity number

		    //t could do a ascii->int mapping here to allow ascii
		    //t command line options

		    //t use strtol() to detect errors

		    pnsc->nso.iVerbosity = atoi(argv[i]);

		    break;
		}
	    } // switch
	}

	//- else regular argument

	else
	{
	    //- copy filename

	    strcpy(&pnsc->pcFiles[iFilePos], argv[i]);

	    //- go to next file position, skipping \0 char

	    iFilePos += 1 + strlen(argv[i]);
	}
    } // for
}


static int ConfigExport(struct NeurospacesConfig *pnsc, int argc, char *argv[])
{
/*     //- if perl has not been disabled */

/*     if (!(pnsc->nso.iFlags & NSOFLAG_DISABLE_PERL)) */
/*     { */
/* 	//- initialize bridge to perl */

/* 	int iPerlInitialized = br2p_initialize(); */
/*     } */

    //- if timings report for all messages

    if (pnsc->nso.iTiming == 2)
    {
	//- get time of day

	if (-1 == gettimeofday(&pnsc->nso.tvStart, NULL))
	{
	    fprintf(stderr,"Could not gettimeofday(), turning off timing\n");
	    pnsc->nso.iTiming = 0;
	}
    }

    //- help requested

    if (pnsc->nso.iFlags & NSOFLAG_HELP)
    {
	//- give help

	NeurospacesHelp(argc, argv);

	//- successfull return

	return(EXIT_SUCCESS);
    }

    //- if parser debug requested

    if (pnsc->nso.iFlags & NSOFLAG_PARSERDEBUG)
    {
	//- turn on parser debug flag

	extern int parserdebug;

	parserdebug = 1;
    }

}


static int ConfigProcess(struct NeurospacesConfig *pnsc, struct Neurospaces *pneuro)
{
    //- if imported table requested

    if (pnsc->nso.iFlags & NSOFLAG_IMPORTPRINT)
    {
	//- print imported table to stderr

	SymbolsPrintImportedFiles(pneuro->psym, stderr);
    }

    //- if symbol table requested

    if (pnsc->nso.iFlags & NSOFLAG_PRINTSYMBOLTABLE)
    {
	//- print symbol table

	SymbolsPrint(pneuro->psym, stderr);
    }

/*     //- if symbols requested */

/*     if (pnsc->nso.iFlags & NSOFLAG_PRINTSYMBOLS) */
/*     { */
/* 	//- print symbols */

/* 	SymbolsPrintHierarchy(pneuro->psym, stderr); */
/*     } */

    //- if algorithm info requested

    if (pnsc->nso.iFlags & NSOFLAG_PRINTALGORITHMINFO)
    {
	//- print symbol table

	AlgorithmSetPrint(pneuro->psym->pas, stderr);
    }

    //- if timing report

    if (pnsc->nso.iTiming & NSOFLAG_TIMINGS)
    {
    }

    //- process query machine commands from the command line

    int iQueryPos = 0;

    //- loop over query commands

    while (pnsc->pcQueries[iQueryPos] != 0)
    {
	//- call the query machine with the command

	char *pcQuery = &pnsc->pcQueries[iQueryPos];

	//- to have yaml alike output, we do some prefixing here

	fprintf(stdout, "query: '%s'\n", pcQuery);

	int iStop = QueryMachineHandle(pneuro, pcQuery);

/* 	if (!iHandled) */
/* 	{ */
/* 	    fprintf */
/* 		(stderr, */
/* 		 "*** Error: %s did not handle '%s' properly\n", */
/* 		 pnsc->ppcArgv[0], */
/* 		 pcQuery); */
/* 	} */

	//- go to next query command

	iQueryPos += 1 + strlen(&pnsc->pcQueries[iQueryPos]);

    } // loop over query commands

    //- if query machine requested

    if (pnsc->nso.iFlags & NSOFLAG_QUERYMACHINE)
    {
	//- start query machine

	QueryMachineStart(pneuro, (pnsc->nso.iFlags & NSOFLAG_DISABLE_READLINE) ? 0 : 1 );
    }

/*     //- if gtk interface requested */

/*     if (pnsc->nso.iFlags & NSOFLAG_GTK) */
/*     { */
/* 	//- start the gui */

/* 	br2p_gui("Called via the command line option"); */
/*     } */

}


/// **************************************************************************
///
/// SHORT: NeurospacesHelp()
///
/// ARGS.:
///
///	std. ANSI main() args
///
/// RTN..: int : TRUE
///
/// DESCR: Give help message
///
/// **************************************************************************

int NeurospacesHelp(int argc, char *argv[])
{
    //- set default result : ok

    int bResult = TRUE;

    //- give help message

    fprintf(stderr, "Usage: %s <options> <filenames>\n", argv[0]);

    fprintf(stderr, "	options :\n");
    fprintf(stderr, "		-d <filename> : debug output to given file\n");
    fprintf(stderr, "		-h : give help and exit\n");
    fprintf(stderr, "		-i : print imported files to stderr at end of parsing\n");
    fprintf(stderr, "		-m <directory> : set model library location\n");
    fprintf(stderr, "		-p : only parse the files to check its syntax\n");
    fprintf(stderr, "		-q : enter query machine after parsing\n");
    fprintf(stderr, "		-t : report symbol table after parsing\n");
    fprintf(stderr, "		-v <level> : set verbosity level\n");
    fprintf(stderr, "		-A : turn off algorithm processing\n");
    fprintf(stderr, "		-D : turn on parser debug flag\n");
    fprintf(stderr, "		-M : report algorithm info after parsing\n");
    fprintf(stderr, "		-Q : followed by a query machine command\n");
    fprintf(stderr, "		-R : disable readline\n");
    fprintf(stderr, "		-T <level> : set timing report level\n");
    fprintf(stderr, "		-V <level> : set exclusive verbosity level\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "	verbosity levels :\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "\t(%i) = LEVEL_GLOBALMSG_IMPORTANT (level for important messages)\n", LEVEL_GLOBALMSG_IMPORTANT);
    fprintf(stderr, "\t(%i) = LEVEL_GLOBALMSG_FILEIMPORT (report import of files)\n", LEVEL_GLOBALMSG_FILEIMPORT);
    fprintf(stderr, "\t(%i) = LEVEL_GLOBALMSG_ALGORITHMIMPORT (report import of algorithms)\n", LEVEL_GLOBALMSG_ALGORITHMIMPORT);
    fprintf(stderr, "\t(%i) = LEVEL_GLOBALMSG_SYMBOLREPORT (report actions taken on 'END {PRIVATE,PUBLIC}_MODELS' etc.)\n", LEVEL_GLOBALMSG_SYMBOLREPORT);
    fprintf(stderr, "\t(%i) = LEVEL_GLOBALMSG_SYMBOLADD (report add of symbols)\n", LEVEL_GLOBALMSG_SYMBOLADD);
    fprintf(stderr, "\t(%i) = LEVEL_GLOBALMSG_SYMBOLCREATE (report creation of symbols)\n", LEVEL_GLOBALMSG_SYMBOLCREATE);

    fprintf(stderr, "\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "	timing levels :\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "\t2 : report timing for all logged messages.\n");

    fprintf(stderr, "\n");
    fprintf(stderr, "\n");

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesLogFileTree()
///
/// ARGS.:
///
///	pacContext.: parser context
///	pcError....: stdargs descriptive string for error that occurred
///
/// RTN..: int : 0
///
/// DESCR:
///
///	Log file tree from dependencies for parser position in
///	pacContext.
///
/// **************************************************************************

int
NeurospacesLogFileTree
(PARSERCONTEXT *pacContext, char *pcError,...)
{
    //- set default result : continue parsing

    int bResult = 0;

    //v stdargs list

    va_list vaList;

    //- get start of stdargs

    va_start(vaList, pcError);

    //- while nested parser context

    while (pacContext)
    {
	//- log info about nesting

	fprintf
	    (stderr,
	     "[%s%s line %i, near %s]\n",
	     ParserContextGetDirectory(pacContext),
	     ParserContextGetFilename(pacContext),
	     ParserContextGetLineNumber(pacContext),
	     parsertext);

	//- go to next parser context

	pacContext = pacContext->pacPrev;
    }

    //- end stdargs

    va_end(vaList);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesError()
///
/// ARGS.:
///
///	pacContext.: parser context.
///	pcContext..: descriptive string for parsing context.
///	pcError....: stdargs descriptive string for error that occurred.
///
/// RTN..: int : 0 : continue parsing
///
/// DESCR: log an error message from any of the parsing functions
///
/// **************************************************************************

int
NeurospacesError(PARSERCONTEXT *pacContext, char *pcContext, char *pcError, ...)
{
    //- set default result : continue parsing

    int bResult = 0;

    //v stdargs list

    va_list vaList;

    //- if no parser context given

    if (!pacContext)
    {
	//- parser context defaults to current context

	//pacContext = pacCurrent;
    }

    //- give diagnostics

    fprintf
	(stderr,
	 "%s: *** Error: ",
	 pcContext);

    //- get start of stdargs

    va_start(vaList, pcError);

    //- give diagnostics

    vfprintf(stderr, pcError, vaList);

    fprintf(stderr, "\n");

    //- end stdargs

    va_end(vaList);

    //- log info about nesting

    NeurospacesLogFileTree(pacContext, pcError);

    fprintf(stderr, "\n");

    //- increment total error count

    pacContext->pneuro->iErrorCount++;

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesImport()
///
/// ARGS.:
///
///	pneuro..: neurospaces.
///	pcAppl..: application name.
///
/// RTN..: int : success of operation.
///
/// DESCR: Import neurospaces description files.
///
/// NOTE.:
///
///	Errors are reported by incrementing the error variable,
///	ie. basic error handling only.
///
/// TODO.:
///
///	This function is the result of a refactoring and needs more
///	refactoring.  The fundamental problem for the hacky code is
///	interfacing with lex and yacc.
///
/// **************************************************************************

int
NeurospacesImport
(struct Neurospaces *pneuro,
 char *pcAppl)
{
    //- set default result : ok

    int bResult = TRUE;

    //! following allocators do not do error checking

    //- allocate and/or register symbol table

    if (!pneuro->psym)
    {
	pneuro->psym = SymbolsCalloc();
    }

    //- initialize root parser context

    struct ParserContext *pacRootContext = NULL;

    if (!pneuro->pacRootContext)
    {
	//- allocate root parser context

	pacRootContext = ParserContextCalloc();

	//- register root parser context

	pneuro->pacRootContext = pacRootContext;

	//- register neurospaces in root parser context

	pacRootContext->pneuro = pneuro;
    }

    //- or

    else
    {
	//- get already registered one

	pacRootContext = pneuro->pacRootContext;
    }

    //- default actual position in file array

    int iFilePos = 0;

    //v total number of file read by all instances, should get rid of
    //v this somehow, but flex is difficult to manage.

    static int iFileNumber = 0;

    //- loop over parsed command line

    struct NeurospacesConfig *pnsc = pneuro->pnsc;

    while (pnsc->pcFiles[iFilePos] != 0)
    {
	//v main inputfile

	FILE *inputfile = NULL;

	//- initialize root parser context

	pacRootContext->pacPrev = NULL;
	pacRootContext->pacNext = NULL;
	pacRootContext->pFILE = inputfile;
	pacRootContext->iNestingLevel = 0;

	//- set input filename

	//t why again was this one static ?

	/* static */ char *pcInputName = NULL;

	pcInputName = &pnsc->pcFiles[iFilePos];

	//- qualify input file name

	pcInputName
	    = ParserContextQualifyFilename(pacRootContext, pcInputName);

	if (!pcInputName)
	{
	    fprintf
		(stderr,
		 "Could not find file (number %i, %i), path name (%s)\n",
		 pneuro->iFileParseCount,
		 iFileNumber,
		 &pnsc->pcFiles[iFilePos]);

	    fprintf
		(stderr,
		 "Set one of the environment variables NEUROSPACES_NMC_USER_MODELS,\n"
		 "NEUROSPACES_NMC_PROJECT_MODELS, NEUROSPACES_NMC_SYSTEM_MODELS or NEUROSPACES_NMC_MODELS\n"
		 "to point to a library where the required model is located,\n"
		 "or use the -m switch to configure where neurospaces looks for models.\n");

	    pneuro->iErrorCount++;

	    return(FALSE);
	}

	//- add the file to symbols

	struct ImportedFile *pifFile
	    = SymbolsAddImportedFile(pneuro->psym, pcInputName, pacRootContext);

	//- link imported file its symbols into parser context

	ParserContextSetImportedFile(pacRootContext, pifFile);

	//- if not first file

	if (pneuro->iFileParseCount != 0
	    || iFileNumber != 0)
	{
	    //- unregister parser contexts

	    ParserClearContext();
	    ParserClearRootContext();
	}

	//- set current parser context, set root context

	ParserSetContext(pacRootContext);
	ParserSetRootContext(pacRootContext);

	//- open given file

	if ((inputfile = fopen(pcInputName, "r")) == NULL)
	{
	    fprintf(stderr,"%s: %s filename qualified, but cannot be opened\n", pcAppl, pcInputName);

	    pneuro->iErrorCount++;

	    //! huge memory leak.

	    return(FALSE);
	}

	//- set input for lexical analyzer

	//! lexical analyzer will automatically allocate
	//! one parser_buffer for parserin

	parserin = inputfile;

	//- if not first file

	if (pneuro->iFileParseCount != 0
	    || iFileNumber != 0)
	{
	    //- create buffer for lexical analyzer

	    LexFileSwitch(&pacRootContext->pyyBuffer, parserin);
	}

	//- parse the description file

	//! I should call ParserParse() here, but because of bad design of 
	//! (f)lex, I would need to give the Neurospaces struct every time as
	//! a parameter, this induces a (very small) performance penalty
	//! and is not clean either

	int bFail = parserparse(pacRootContext);

	//- remove pending lexical analyzer buffer

	if (pacRootContext->pyyBuffer)
	{
	    LexAssociateRemove(&pacRootContext->pyyBuffer);
	}

	//- increment number of files that have been parsed

	pneuro->iFileParseCount++;

	iFileNumber++;

	//- if errors

	if (pneuro->iErrorCount != 0)
	{
	    fprintf
		(stderr,
		 "%s: Parse of %s failed with %i (cumulative) error%s.\n",
		 pcAppl,
		 pcInputName,
		 pneuro->iErrorCount,
		 pneuro->iErrorCount == 1 ? "" : "s");
	}
	else
	{
	    if (pnsc->nso.iVerbosity)
	    {
		fprintf(stderr,"%s: No errors for %s.\n", pcAppl, pcInputName);
	    }
	}

	//- go to next file in parse command line args

	iFilePos += 1 + strlen(&pnsc->pcFiles[iFilePos]);

	//- if there was a first input file

	if (inputfile)
	{
	    //- close the input file

	    fclose(inputfile);		/* ==parserin	*/
	}

    } // loop over parsed command line

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesMessage()
///
/// ARGS.:
///
///	iPriority........: priority of given message
///	iContext.........: message context
///	pcFormat.........: vfprintf() format string.
///	vaList...........: stdarg list with messages to log
///
/// RTN..: int :  0 : continue parsing, msg logged
///		  1 : continue parsing, no msg logged
///		 -1 : stop parsing
///
/// DESCR: log a message
///
///	iPriority is compared with the verbosity option given on the 
///	command line, if higher, the message is written to stdout.
///
///	 iContext is important for timing reports. Flags are :
///		0 == no flags, in run message
///		1 == start message
///		2 == end message
///
/// **************************************************************************

int
NeurospacesMessage
(int iPriority,
 int iContext,
 char *pcFormat,
 va_list vaList)
{
    //- set default result : continue parsing

    int bResult = 0;

    //- if exclusive priority on

    if (pnscGlobal->nso.iFlags & NSOFLAG_EXCLUSIVEVERBOSE)
    {
	//- if priority level does not match nso verbosity level

	if (iPriority != pnscGlobal->nso.iVerbosity)
	{
	    //- no logging, continue parsing

	    return(1);
	}
    }

    //- else (assuming normal options)

    else
    {
	//- if priority level lower than nso verbosity level

	if (iPriority < pnscGlobal->nso.iVerbosity)
	{
	    //- no logging, continue parsing

	    return(1);
	}
    }

    //- if timings report for all messages

    if (pnscGlobal->nso.iTiming == 2

	//t or timings report for this message level
	)
    {
	//- report start timing

	if (iContext & 1)
	{
	    NeurospacesStartTimingReport();
	}
    }

    //- give diagnostics

    if (vaList)
    {
	vfprintf(stdout, pcFormat, vaList);
    }
    else
    {
	fprintf(stdout, pcFormat);
    }

    //- if timings report for all messages

    if (pnscGlobal->nso.iTiming == 2

	//t or timings report for this message level
	)
    {
	//- report end timing

	if (iContext & 2)
	{
	    NeurospacesEndTimingReport();
	}
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesQualifyFilename()
///
/// ARGS.:
///
///	pneuro..: neurospaces object.
///	pc......: a filename.
///
/// RTN..: char *
///
///	qualified malloc()ed filename, or NULL if not found.
///
/// DESCR: Qualify a filename.
///
/// **************************************************************************

char *
NeurospacesQualifyFilename(struct Neurospaces *pneuro, char *pc)
{
    //- set default result: failure.

    char *pcResult = NULL;

    //- let the current parser context do the work

    //t this is due to the double linking of heccer and neurospaces,
    //t should figure out how to use libtool.

    struct ParserContext *pac = pneuro->pacRootContext;

    while (pac && pac->pacNext)
    {
	pac = pac->pacNext;
    }

    //!  will call back if necessary.

    pcResult = ParserContextQualifyFilename(pac, pc);

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesQualifyToConfiguration()
///
/// ARGS.:
///
///	pneuro.: neurospaces object to use for qualification
///	pc.....: filename to qualify
///
/// RTN..: char * : qualified filename, NULL for failure
///
/// DESCR: qualify a filename using parser context configuration.
///
///	See NeurospacesQualifyToConfiguration().
///
/// **************************************************************************

char *NeurospacesQualifyToConfiguration(struct Neurospaces *pneuro, char *pc)
{
    //- set default result : failure

    char *pcResult = NULL;

    //- get model directory

    char *pcModels = pneuro->pnsc->nso.pcModelLibrary;

    if (pcModels)
    {
	//- calculate directory length

	int iDirectory = strlen(pcModels);

	//- allocate result

	pcResult = (char *)malloc(2 + iDirectory + strlen(pc));

	if (pcResult)
	{
	    strcpy(pcResult, pcModels);

	    strcat(pcResult, "/");

	    strcat(pcResult, pc);

	    //- test existence of file

	    FILE *pf = fopen(pcResult, "r");

	    if (!pf)
	    {
		free(pcResult);

		pcResult = NULL;
	    }
	    else
	    {
		fclose(pf);
	    }
	}
    }

    //- return result

    return(pcResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesRead()
///
/// ARGS.:
///
///	pneuro..: neurospaces.
///	argc....: std main() argument.
///	argv....: std main() argument.
///
/// RTN..: int : success of operation
///
/// DESCR: Instantiate neurospaces with a cmd like interface.
///
///	Std. neurospaces configuration options are recognized.
///
/// **************************************************************************

int NeurospacesRead(struct Neurospaces *pneuro, int argc, char *argv[])
{
    //- set default result : ok

    int iResult = TRUE;

    //- default : no configuration

    struct NeurospacesConfig *pnsc = NULL;

    //- if command line arguments

    if (argc && argv)
    {
	//- allocate cli

	pnsc = ConfigCalloc(argc, argv);

	//- register command line options

	pnscGlobal = pnsc;

	//- register parsed command line

	pneuro->pnsc = pnsc;

	//- export configuration to other modules

	ConfigExport(pnsc, argc, argv);

	//- import model description files

	int i = NeurospacesImport(pneuro, argv[0]);

	if (!i || pneuro->iErrorCount)
	{
	    iResult = FALSE;
	}

	//- process configuration to do reporting

	ConfigProcess(pnsc, pneuro);
    }

    //- register configuration

    pneuro->pnsc = pnsc;

/*     fprintf(stdout, "Neurospaces: root import is %p\n", ImportedFileGetRootImport()); */

    //- return success

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesRemoveProjectionQuery()
///
/// ARGS.:
///
///	pneuro..: neurospaces.
///
/// RTN..: int : success of operation
///
/// DESCR: Remove projection query.
///
/// **************************************************************************

int NeurospacesRemoveProjectionQuery(struct Neurospaces *pneuro)
{
    //- set default result : ok

    int bResult = TRUE;

    //- register projection query

    if (pneuro->ppq)
    {
	ProjectionQueryFree(pneuro->ppq);

	pneuro->ppq = NULL;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesSetProjectionQuery()
///
/// ARGS.:
///
///	pneuro..: neurospaces.
///	ppq.....: projection query to register.
///
/// RTN..: int : success of operation
///
/// DESCR: Register projection query.
///
/// **************************************************************************

int
NeurospacesSetProjectionQuery
(struct Neurospaces *pneuro,struct ProjectionQuery *ppq)
{
    //- set default result : ok

    int bResult = TRUE;

    //- register projection query

    if (!pneuro->ppq)
    {
	pneuro->ppq = ppq;
    }
    else
    {
	fprintf(stderr, "Neurospaces : could not register projection query\n");

	bResult = FALSE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesSetSolverMapper()
///
/// ARGS.:
///
///	pneuro..: neurospaces.
///	psm.....: solver mapper array.
///
/// RTN..: int : success of operation
///
/// DESCR: Register solver mapper array.
///
///	psm ends with 
///		{
///		    NULL,	
///		    -1,
///		    NULL,
///		    NULL,
///		}
///
/// **************************************************************************

int
NeurospacesSetSolverMapper
(struct Neurospaces *pneuro, struct SolverMapper *psm)
{
    //- set default result : ok

    int bResult = TRUE;

    //- register solver mapper

    if (!pneuro->psm)
    {
	pneuro->psm = psm;
    }
    else
    {
	fprintf(stderr, "Neurospaces : could not register solver mapper\n");

	bResult = FALSE;
    }

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesSetupSolverInstance()
///
/// ARGS.:
///
///	pneuro..: neurospaces.
///	pcName..: name of solver class.
///	ppist...: context of symbol to setup.
///
/// RTN..: int : success of operation
///
/// DESCR: Setup a solution engine.
///
/// **************************************************************************

int
NeurospacesSetupSolverInstance
(struct Neurospaces *pneuro, char *pcName, struct PidinStack *ppist)
{
    //- set default result

    int iResult = 0;

    int i;

    int iSolver = -1;

    //v indicates mismatch between symbol type and registered type

    int bMismatch = FALSE;

    struct symtab_HSolveListElement *phsle = NULL;

    //- lookup symbol

    phsle = SymbolsLookupHierarchical(pneuro->psym, ppist);

    //- if found

    if (phsle)
    {
	//- loop over the registered mappings

	for (i = 0 ; pneuro->psm[i].pcSolverClass ; i++)
	{
	    char *pcSolverClass = pneuro->psm[i].pcSolverClass;

	    //- found matching solver class name ?

	    if (strncmp(pcSolverClass, pcName, strlen(pcSolverClass)) == 0)
	    {
		//- if symbol type matches registered type for solver class

		if (pneuro->psm[i].iSymbolType == phsle->iType)
		{
		    //- remember : found

		    iSolver = i;

		    //- break loop

		    break;
		}

		//- else

		else
		{
		    //- register : mismatch for diag's purposes

		    bMismatch = TRUE;

		    //- but we continue attempting to get a next match

		    continue;
		}
	    }
	}
    }

    //- if solver class found

    if (iSolver != -1)
    {
	//- if solver class has associated setup method

	if (pneuro->psm[iSolver].setup)
	{
	    //- create and init solvers from the query

	    iResult
		= pneuro->psm[iSolver].setup
		  (pneuro, pneuro->psm[iSolver].pvUserdata, phsle, ppist);
	}
	else
	{
	    //- diag's

	    fprintf
		(stdout,
		 "%s is an unimplemented solver class (symbol ",
		 pcName);

	    PidinStackPrint(ppist, stdout);

	    fprintf(stdout, ")\n");
	}
    }

    //- else

    else
    {
	//- error : not implemented

	if (phsle)
	{
	    if (bMismatch)
	    {
		fprintf
		    (stdout,
		     "NeurospacesSetupSolverInstance() :"
		     " not implemented for solver class %s :"
		     " symbol type mismatch\n",
		     pcName);
	    }
	    else
	    {
		fprintf
		    (stdout,
		     "NeurospacesSetupSolverInstance() :"
		     " not implemented for solver class %s\n",
		     pcName);
	    }
	}

	//- else

	else
	{
	    //- diag's

	    fprintf(stdout, "symbol ");
	    PidinStackPrint(ppist, stdout);
	    fprintf(stdout, " not found\n");
	}
    }

    //- return result

    return(iResult);
}


/// **************************************************************************
///
/// SHORT: Neurospaces{End,Start}TimingReport()
///
/// ARGS.:
///
/// RTN..: int : success of operation
///
/// DESCR: Report timing as a log message.
///
/// **************************************************************************

// copied from GNU libc.
// modified : 
//	- const *x, *y
//	- changed to ANSI/ISO arg passing.

/* Subtract the `struct timeval' values X and Y,
**   storing the result in RESULT.
**   Return 1 if the difference is negative, otherwise 0.  */
     
static int
timeval_subtract
(struct timeval *result, struct timeval *x, struct timeval *y)
{
    // copy y before modifications

    struct timeval tv = *y;

    /* Perform the carry for the later subtraction by updating Y. */
    if (x->tv_usec < tv.tv_usec) {
	int nsec = (tv.tv_usec - x->tv_usec) / 1000000 + 1;
	tv.tv_usec -= 1000000 * nsec;
	tv.tv_sec += nsec;
    }
    if (x->tv_usec - tv.tv_usec > 1000000) {
	int nsec = (x->tv_usec - tv.tv_usec) / 1000000;
	tv.tv_usec += 1000000 * nsec;
	tv.tv_sec -= nsec;
    }
     
    /* Compute the time remaining to wait.
       `tv_usec' is certainly positive. */
    result->tv_sec = x->tv_sec - tv.tv_sec;
    result->tv_usec = x->tv_usec - tv.tv_usec;
     
    /* Return 1 if result is negative. */
    return x->tv_sec < tv.tv_sec;
}


static int NeurospacesEndTimingReport(void)
{
    //- set default result : ok

    int bResult = TRUE;

    //v non-offset timing

    struct timeval tvReport;

    //- get time of day

    struct timeval tv;

    if (-1 == gettimeofday(&tv, NULL))
    {
	return(FALSE);
    }

    //- calculate non-offset timing

    timeval_subtract(&tvReport, &tv, &pnscGlobal->nso.tvStart);

/*     fprintf */
/* 	(stdout, */
/* 	 "<!-- (%lisec,%liusec) ) -->", */
/* 	 tvReport.tv_sec, */
/* 	 tvReport.tv_usec); */

    fprintf(stdout, "</timing-report>\n");

    //- return result

    return(bResult);
}


static int NeurospacesStartTimingReport(void)
{
    //- set default result : ok

    int bResult = TRUE;

    //v non-offset timing

    struct timeval tvReport;

    //v resources

    struct rusage ru;

    //v time of day

    struct timeval tv;

    //- start timing report

    fprintf(stdout, "<timing-report>");

    //- put time of day

/*     fprintf(stdout,"<!-- ( -->"); */

    if (-1 == gettimeofday(&tv, NULL))
    {
	return(FALSE);
    }

    //- calculate non-offset timing

    timeval_subtract(&tvReport, &tv, &pnscGlobal->nso.tvStart);

    fprintf
	(stdout,
	 "<gettimeofday sec=\"%li\" usec=\"%li\" />",
	 tvReport.tv_sec,
	 tvReport.tv_usec);

    //- put resource usage

    if (-1 == getrusage(RUSAGE_SELF, &ru))
    {
	return(FALSE);
    }

    fprintf(stdout, "<getrusage>");
    fprintf
	(stdout,
	 "<ru_utime sec=\"%li\" usec=\"%li\" />",
	 ru.ru_utime.tv_sec,
	 ru.ru_utime.tv_usec);
    fprintf(stdout, "</getrusage>");

    //t other possibilities :
    //t time()
    //t localtime()
    //t gmtime()
    //t asctime(), ctime()
    //t strftime()

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesGetVersion()
///
/// ARGS.:
///
/// RTN..: char *
///
///	Version identifier.
///
/// DESCR: Obtain version identifier.
///
/// **************************************************************************

char * NeurospacesGetVersion(void)
{
    // $Format: "    static char *pcVersion=\"${package}-${label}\";"$
    static char *pcVersion="model-container-network-15";

    return(pcVersion);
}


/// **************************************************************************
///
/// SHORT: NeurospacesNew()
///
/// ARGS.:
///
/// RTN..: struct Neurospaces *
///
///	Empty neurospaces.
///
/// DESCR: Construct a neurospaces object.
///
/// **************************************************************************

//v hacker variable

//! this prevents diving to deeply into perl xs.

struct Neurospaces *pneuroGlobal;

struct Neurospaces *NeurospacesNew(void)
{
    //- set default result : failure

    struct Neurospaces *pneuroResult = NULL;

    //- allocate neurospaces

    pneuroResult = (struct Neurospaces *)calloc(1, sizeof(*pneuroResult));

    //- allocate a cache registry

    pneuroResult->pcr = CacheRegistryCalloc(100);

    if (!pneuroResult->pcr)
    {
	free(pneuroResult);

	return(NULL);
    }

    //- set the hacker variable for perl xs.

    pneuroGlobal = pneuroResult;

    //- return result

    return(pneuroResult);
}


/// **************************************************************************
///
/// SHORT: NeurospacesNewFromCmdLine()
///
/// ARGS.:
///
///	std. ANSI main() args
///
///	argv[].: files to parse or options
///
/// RTN..: struct Neurospaces *
///
///	Result of given command line.
///
/// DESCR: parse given files
///
///	options :
///		-d <filename> : debug output to given file
///		-h : give help and exit
///		-i : print imported files to stderr at end of parsing
///		-m <directory> : set model library location
///		-p : only parse the files to check their syntax
///		-q : enter query machine after parsing
///		-t : report symbol table after parsing
///		-v <level> : set verbosity level
///		-A : turn off algorithm processing
///		-D : turn on parser debug flag
///		-M : report algorithm info after parsing
///		-Q : followed by a query machine command
///		-R : disable readline
///		-T <level> : set timing report level
///		-V <level> : set exclusive verbosity level
///
///	Options on command line are to appear first
///
/// **************************************************************************

struct Neurospaces *
NeurospacesNewFromCmdLine(int argc, char *argv[])
{
    //- allocate new neurospaces object

    struct Neurospaces *pneuroResult = NeurospacesNew();

    //- read description files

    NeurospacesRead(pneuroResult, argc, argv);

    //- return result

    return(pneuroResult);
}


// Local variables:
// eval: (add-hook 'write-file-hooks 'time-stamp)
// time-stamp-start: "pcVersionTime="
// time-stamp-format: "\"(%02y/%02m/%02d) %a, %b %d, %y %02H:%02M:%02S %u\";"
// time-stamp-end: "$"
// End:
