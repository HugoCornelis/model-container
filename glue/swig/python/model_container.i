/* -*- c -*- */

%module model_container_base	

/***************************************************
* Start C code block
***************************************************/
%{


struct symtab_Invisible;


#include "neurospaces/algorithminstance.h"
#include "neurospaces/biolevel.h"
#include "neurospaces/cachedconnection.h"
#include "neurospaces/components/algorithmsymbol.h"
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/axonhillock.h"
#include "neurospaces/components/biocomp.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/channel.h"
#include "neurospaces/components/connection.h"
#include "neurospaces/components/connectionsymbol.h"
#include "neurospaces/components/equationexponential.h"
#include "neurospaces/components/fiber.h"
#include "neurospaces/components/gatekinetic.h"
#include "neurospaces/components/group.h"
#include "neurospaces/components/groupedparameters.h"
#include "neurospaces/components/hhgate.h"
#include "neurospaces/components/network.h"
#include "neurospaces/components/pool.h"
#include "neurospaces/components/population.h"
#include "neurospaces/components/projection.h"
#include "neurospaces/components/randomvalue.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/components/segmenter.h"
#include "neurospaces/components/vector.h"
#include "neurospaces/components/vectorconnectionsymbol.h"
#include "neurospaces/components/vectorsegment.h"
#include "neurospaces/dependencyfile.h"
#include "neurospaces/exporter.h"
#include "neurospaces/function.h"
#include "neurospaces/hines_list.h"
#include "neurospaces/idin.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/iocontainer.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/positionD3.h"
#include "neurospaces/projectionquery.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/traversalinfo.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/workload.h"

#include "neurospaces/symbolvirtual_protos.h"

#include "hierarchy/output/symbols/all_callees_headers.h"

#include <Python.h>

%}


//------------------------- Start of Inline functons  ---------------------------
%inline %{
PyObject * PyBCreateMap(struct Neurospaces *pneuro, char *pcPrototype, char *pcNamespaces, 
		char *pcComponent);


PyObject * PyBCreateMap(struct Neurospaces *pneuro, char *pcPrototype, char *pcNamespaces, 
		char *pcComponent)
{

  char pcErrorMsg[1024];
  int iResult = 0;
  struct PidinStack *ppistPrototype = NULL;
  struct PidinStack *ppistNamespaces = NULL;
  struct symtab_IdentifierIndex *pidinComponent = NULL;
  struct PidinStack *ppistRoot = NULL;
  struct symtab_HSolveListElement *phslePrototype = NULL;
  struct symtab_HSolveListElement *phsleAlias = NULL;
  struct symtab_HSolveListElement *phsleRoot = NULL;

  ppistPrototype = PidinStackParse(pcPrototype);

  if( !ppistPrototype )
  {
    //- Use snprint to make a better error string just in case

    snprintf(pcErrorMsg, 1024, "Can't parse prototype '%s'", pcPrototype);

    PyErr_SetString(PyExc_Exception, pcErrorMsg);
    return NULL;

  }


  phslePrototype = SymbolsLookupHierarchical(pneuro->psym, ppistPrototype);

  if( !phslePrototype )
  {

    snprintf(pcErrorMsg, 1024, "Can't get symbol from prototype context for '%s'", pcPrototype);

    PyErr_SetString(PyExc_Exception, pcErrorMsg);
    return NULL; 

  }


  pidinComponent = IdinCallocUnique(pcComponent);

  if( !pidinComponent )
  {

    snprintf(pcErrorMsg, 1024, "Can't create unique identifier from component '%s'", pcComponent);

    PyErr_SetString(PyExc_Exception, pcErrorMsg);
    return NULL;

  }

  phsleAlias = SymbolCreateAlias(phslePrototype, pcNamespaces, pidinComponent);

  if( !phsleAlias )
  {

    snprintf(pcErrorMsg, 1024, "Can't create alias from component '%s'", pcComponent);

    PyErr_SetString(PyExc_Exception, pcErrorMsg);
    return NULL;    

  }


  ppistRoot = PidinStackParse("::/");

  phsleRoot = PidinStackLookupTopSymbol(ppistRoot);

  if( !phsleRoot )
  {

    PyErr_SetString(PyExc_Exception, "Cannot get a private root context (has a model been loaded ?)");
    return NULL;        

  }

  
  iResult = SymbolAddChild(phsleRoot, phsleAlias);

  if( !iResult )
  {

    snprintf(pcErrorMsg, 1024, "Can't alias of '%s' as child", pcPrototype);


    PyErr_SetString(PyExc_Exception, pcErrorMsg);
    return NULL;        

  }

  Py_RETURN_NONE;

}

%}
//------------------------- End of Inline functons  ---------------------------




/***************************************************
* End C code block
***************************************************/



/***************************************************
* Imports and Typemaps
***************************************************/

%import "cpointer.i"

%pointer_functions(double,pdouble);

%import "typemaps.i"

# Some of these may not be needed if typemaps.i is imported
# need to check it later.

%typemap(out) int 
{
  $result = PyInt_FromLong($1);
}

%typemap(in) void * {

    $1 = $input;
};

// Taken from the python SWIG documentation.

// This tells SWIG to treat char ** as a special case
%typemap(in) char ** {
  /* Check if is a list */
  if (PyList_Check($source)) {
    int size = PyList_Size($source);
    int i = 0;
    $target = (char **) malloc((size+1)*sizeof(char *));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($source,i);
      if (PyString_Check(o))
	$target[i] = PyString_AsString(PyList_GetItem($source,i));
      else {
	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free($target);
	return NULL;
      }
    }
    $target[i] = 0;
  } else {
    PyErr_SetString(PyExc_TypeError,"not a list");
    return NULL;
  }
}

// This cleans up the char ** array we malloc'd before the function call
%typemap(freearg) char ** {
  free((char *) $source);
}

// This allows a C function to return a char ** as a Python list
%typemap(out) char ** {
  int len,i;
  len = 0;
  while ($source[len]) len++;
  $target = PyList_New(len);
  for (i = 0; i < len; i++) {
    PyList_SetItem($target,i,PyString_FromString($source[i]));
  }
}

%include "traversal.i"


/***************************************************
* End Imports and Typemaps
***************************************************/


/*------------------------------------------------------------------------
* This is a preload for some includes. Without it several casting functions
* will fail to compile.
*-------------------------------------------------------------------------*/
%include "_model_container.i"

/*------------------------------------------------------------------------
* Grab the original header file so SWIG can import the prototypes and
* create low level data classes out of the member structs. Apparently this
* line must be at the end of the file otherwise SWIG will ignore my typemaps.
*------------------------------------------------------------------------*/

%include "neurospaces/algorithminstance.h"
%include "neurospaces/biolevel.h"
%include "neurospaces/cachedconnection.h"
%include "neurospaces/components/algorithmsymbol.h"
%include "neurospaces/components/attachment.h"
%include "neurospaces/components/axonhillock.h"
%include "neurospaces/components/biocomp.h"
%include "neurospaces/components/cell.h"
%include "neurospaces/components/channel.h"
%include "neurospaces/components/connection.h"
%include "neurospaces/components/connectionsymbol.h"
%include "neurospaces/components/equationexponential.h"
%include "neurospaces/components/fiber.h"
%include "neurospaces/components/gatekinetic.h"
%include "neurospaces/components/group.h"
%include "neurospaces/components/groupedparameters.h"
%include "neurospaces/components/hhgate.h"
%include "neurospaces/components/network.h"
%include "neurospaces/components/pool.h"
%include "neurospaces/components/population.h"
%include "neurospaces/components/projection.h"
%include "neurospaces/components/randomvalue.h"
%include "neurospaces/components/segment.h"
%include "neurospaces/components/segmenter.h"
%include "neurospaces/components/vector.h"
%include "neurospaces/components/vectorconnectionsymbol.h"
%include "neurospaces/components/vectorsegment.h"
%include "neurospaces/dependencyfile.h"
%include "neurospaces/exporter.h"
%include "neurospaces/function.h"
%include "neurospaces/hines_list.h"
%include "neurospaces/idin.h"
%include "neurospaces/importedfile.h"
%include "neurospaces/inputoutput.h"
%include "neurospaces/iocontainer.h"
%include "neurospaces/neurospaces.h"
%include "neurospaces/parameters.h"
%include "neurospaces/parsersupport.h"
%include "neurospaces/pidinstack.h"
%include "neurospaces/positionD3.h"
%include "neurospaces/projectionquery.h"
%include "neurospaces/querymachine.h"
%include "neurospaces/solverinfo.h"
%include "neurospaces/symbols.h"
%include "neurospaces/symboltable.h"
%include "neurospaces/treespacetraversal.h"
%include "neurospaces/workload.h"

%include "neurospaces/symbolvirtual_protos.h"

%include "hierarchy/output/symbols/all_callees_headers.i"
%include "hierarchy/output/symbols/runtime_casters.i"





