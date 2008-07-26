//
// Neurospaces: a library which implements a global typed symbol table to
// be used in neurobiological model maintenance and simulation.
//
// $Id: dependencyfile.c 1.11 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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



#include <stdio.h>


#include "neurospaces/dependencyfile.h"


//////////////////////////////////////////////////////////////////////////////
//o
//o struct DependencyFile :
//o -----------------------
//o
//o DependencyFile associates an imported file (see struct ImportedFile) 
//o with a namespaces. The imported file is responsible for defining 
//o symbols.
//o
//////////////////////////////////////////////////////////////////////////////

/// **************************************************************************
///
/// SHORT: DependencyFileCallocNameSpaceImportedFile()
///
/// ARGS.:
///
///	pc...: associated namespace
///	pif..: associated imported file
///
/// RTN..: struct DependencyFile * :
///
///	allocated dependency file, NULL for failure
///
/// DESCR: Allocate a dependency file associated with given namespace and 
///	imported file.
///
/// **************************************************************************

struct DependencyFile * 
DependencyFileCallocNameSpaceImportedFile(char *pc, struct ImportedFile *pif)
{
    //- set default result : failure

    struct DependencyFile *pdfResult = NULL;

    //- allocate dependency file

    pdfResult
	= (struct DependencyFile *)calloc(1,sizeof(struct DependencyFile));

    //- assign name space

    DependencyFileSetNameSpace(pdfResult, pc);

    //- link with imported file

    DependencyFileSetImportedFile(pdfResult, pif);

    //- return result

    return(pdfResult);
}


/// **************************************************************************
///
/// SHORT: DependencyFileGetImportedFile()
///
/// ARGS.:
///
///	pdf..: dependency file.
///
/// RTN..: struct ImportedFile *
///
///	imported file.
///
/// DESCR: Get imported file attached to this dependency file.
///
/// **************************************************************************

struct ImportedFile *
DependencyFileGetImportedFile(struct DependencyFile *pdf)
{
    return(pdf->pifSymbols);
}


/// **************************************************************************
///
/// SHORT: DependencyFileGetNameSpace()
///
/// ARGS.:
///
///	pdf..: dependency file.
///
/// RTN..: char *
///
///	namespace.
///
/// DESCR: Get namespace attached to this dependency file.
///
/// **************************************************************************

char *
DependencyFileGetNameSpace(struct DependencyFile *pdf)
{
    return(pdf->pcNameSpace);
}


/// **************************************************************************
///
/// SHORT: DependencyFilePrint()
///
/// ARGS.:
///
///	pdf......: dependency file to print
///	iIndent..: number of indentation spaces
///	pfile....: file to print output to
///
/// RTN..: int : success of operation
///
/// DESCR: Pretty print dependency file
///
/// **************************************************************************

int DependencyFilePrint(struct DependencyFile *pdf, int iIndent, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- print local name space of dependency file

    PrintIndent(iIndent,pfile);
    fprintf
	(pfile,
	 "Aliased to local name space : (%s)\n",
	 DependencyFileGetNameSpace(pdf));

    //- pretty print symbols of imported file

    ImportedFilePrint
	(DependencyFileGetImportedFile(pdf), MoreIndent(iIndent), pfile);

    //- return result

    return(bResult);
}


/// **************************************************************************
///
/// SHORT: DependencyFileSetImportedFile()
///
/// ARGS.:
///
///	pdf..: dependency file.
///	pif..: associated imported file.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Set imported file attached to this dependency file.
///
/// **************************************************************************

int
DependencyFileSetImportedFile
(struct DependencyFile *pdf, struct ImportedFile *pif)
{
    pdf->pifSymbols = pif;

    return(1);
}


/// **************************************************************************
///
/// SHORT: DependencyFileSetNameSpace()
///
/// ARGS.:
///
///	pdf..: dependency file.
///	pc...: associated namespace.
///
/// RTN..: int
///
///	success of operation.
///
/// DESCR: Set namespace attached to this dependency file.
///
/// **************************************************************************

int
DependencyFileSetNameSpace
(struct DependencyFile *pdf, char *pc)
{
    pdf->pcNameSpace = pc;
}


