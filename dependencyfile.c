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
#include "neurospaces/exporter.h"


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

/// 
/// \arg pc associated namespace
/// \arg pif associated imported file
/// 
/// \return struct DependencyFile * :
/// 
///	allocated dependency file, NULL for failure
/// 
/// \brief Allocate a dependency file associated with given namespace and 
///
/// \details 
///	imported file.
/// 

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


/// 
/// \arg pdf dependency file.
/// 
/// \return struct ImportedFile *
/// 
///	imported file.
/// 
/// \brief Get imported file attached to this dependency file.
/// 

struct ImportedFile *
DependencyFileGetImportedFile(struct DependencyFile *pdf)
{
    return(pdf->pifSymbols);
}


/// 
/// \arg pdf dependency file.
/// 
/// \return char *
/// 
///	namespace.
/// 
/// \brief Get namespace attached to this dependency file.
/// 

char *
DependencyFileGetNameSpace(struct DependencyFile *pdf)
{
    return(pdf->pcNameSpace);
}


/// 
/// \arg pdf dependency file to print
/// \arg iIndent number of indentation spaces
/// \arg pfile file to print output to
/// 
/// \return int : success of operation
/// 
/// \brief Pretty print dependency file
/// 

int
DependencyFilePrint
(struct DependencyFile *pdf, int iIndent, int iType, FILE *pfile)
{
    //- set default result : ok

    int bResult = TRUE;

    //- print local name space of dependency file

    PrintIndent(iIndent,pfile);

    if (iType == EXPORTER_TYPE_INFO)
    {
	fprintf
	    (pfile,
	     "Aliased to local name space : (%s)\n",
	     DependencyFileGetNameSpace(pdf));
    }
    else if (iType == EXPORTER_TYPE_NDF)
    {
	fprintf
	    (pfile,
	     "FILE %s\n",
	     DependencyFileGetNameSpace(pdf));
    }

    if (iType == EXPORTER_TYPE_INFO)
    {
	//- pretty print symbols of imported file

	ImportedFilePrint
	    (DependencyFileGetImportedFile(pdf), MoreIndent(iIndent), iType, pfile);
    }

    //- return result

    return(bResult);
}


/// 
/// \arg pdf dependency file.
/// \arg pif associated imported file.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Set imported file attached to this dependency file.
/// 

int
DependencyFileSetImportedFile
(struct DependencyFile *pdf, struct ImportedFile *pif)
{
    pdf->pifSymbols = pif;

    return(1);
}


/// 
/// \arg pdf dependency file.
/// \arg pc associated namespace.
/// 
/// \return int
/// 
///	success of operation.
/// 
/// \brief Set namespace attached to this dependency file.
/// 

int
DependencyFileSetNameSpace
(struct DependencyFile *pdf, char *pc)
{
    pdf->pcNameSpace = pc;
}


