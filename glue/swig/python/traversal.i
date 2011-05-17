/* -*- c -*- */

/**********************************************************
python list methods from http://www.swig.org/Doc1.3/Python.html


PyObject *PyList_New(int size);
int       PyList_Size(PyObject *list);
PyObject *PyList_GetItem(PyObject *list, int i);
int       PyList_SetItem(PyObject *list, int i, PyObject *item);
int       PyList_Insert(PyObject *list, int i, PyObject *item);
int       PyList_Append(PyObject *list, PyObject *item);
PyObject *PyList_GetSlice(PyObject *list, int i, int j);
int       PyList_SetSlice(PyObject *list, int i, int , PyObject *list2);
int       PyList_Sort(PyObject *list);
int       PyList_Reverse(PyObject *list);
PyObject *PyList_AsTuple(PyObject *list);
int       PyList_Check(PyObject *);
***********************************************************/

%{

//--------------------------- Start neurospaces includes ---------------------
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
#include "neurospaces/components/emcontour.h"
#include "neurospaces/components/equationexponential.h"
#include "neurospaces/components/fiber.h"
#include "neurospaces/components/gatekinetic.h"
#include "neurospaces/components/group.h"
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
#include "neurospaces/function.h"
#include "neurospaces/idin.h"
#include "neurospaces/importedfile.h"
#include "neurospaces/inputoutput.h"
#include "neurospaces/iocontainer.h"
#include "neurospaces/neurospaces.h"
#include "neurospaces/parameters.h"
#include "neurospaces/parsersupport.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/positionD3.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/solverinfo.h"
#include "neurospaces/symbols.h"
#include "neurospaces/symboltable.h"
#include "neurospaces/traversalinfo.h"
#include "neurospaces/treespacetraversal.h"
#include "neurospaces/workload.h"
#include "neurospaces/symbolvirtual_protos.h"
#include "hierarchy/output/symbols/all_callees_headers.h"
//--------------------------- End neurospaces includes ------------------------


#include <Python.h>


//-----------------------------------------------------------------------------
/*
 * \param pneuro A pointer to a Neurospaces object
 * \returns A pointer to a python list
 *  
 *  
 */
PyObject * SymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{

  int i;
  int iTraverse;
  PyObject * ppoSymbolList = NULL;
  PyObject * ppoTmpName = NULL;
  struct TreespaceTraversal *ptstr = NULL;


  //- Start out with an empty list

  ppoSymbolList = PyList_New(0);

  if( !ppoSymbolList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate symbol list");
    return NULL;
  }

  //- construct children info

  struct traversal_info ci =
    {
      //m information request flags
      
      (TRAVERSAL_INFO_NAMES
       | TRAVERSAL_INFO_TYPES
       | TRAVERSAL_INFO_COORDS_LOCAL
       | TRAVERSAL_INFO_COORDS_ABSOLUTE),

      //m traversal method flags

      0,

      //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

      0,

      //m current child index

      0,

      //m pidinstack pointing to root

      NULL,

      //m serials of symbols

      NULL,

      //m types of symbols

      NULL,

      //m chars with complete contexts

      NULL,

      //m chars with symbol names

      NULL,

      //m chars with symbol types

      NULL,

      //m local coordinates of symbols

      NULL,

      //m absolute coordinates of symbols

      NULL,

      //m absolute coordinates of parent segments

      NULL,

      NULL,

      //m non-cumulative workload for symbols

      NULL,

      //m cumulative workload for symbols

      NULL,

      //m current cumulative workload

      0,

      //m stack top

      -1,

      //m stack used for accumulation

      NULL,

      //m stack used to track the traversal index of visited symbols

      NULL,

      //m allocation count

      0,
    };


  ptstr = TstrNew(ppist,
		  NULL,
		  NULL,
		  TraversalInfoCollectorProcessor,
		  (void *)&ci,
		  NULL,
		  NULL);


  iTraverse = TstrGo(ptstr, phsle);

  TstrDelete(ptstr);

  // Loop through all found children and append them to the list

  if (ci.iChildren)
  {

    for (i = 0; i < ci.iChildren; i++)
    {
      
      if ( !ci.ppcNames[i] )
	continue;

      ppoTmpName = PyString_AsString(ci.ppcNames[i]);

      if (!PyString_Check(ppoTmpName))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoSymbolList);
	return NULL;

      }

      // After converting the string to a python string we append 
      PyList_Append(ppoSymbolList, ppoTmpName);

    }
  }

  //- free allocated memory

  TraversalInfoFree(&ci);

  if( !PyList_Check(ppoSymbolList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid list was generated from the model container");

  }

  return ppoSymbolList;
}

//-----------------------------------------------------------------------------



%}


%inline %{

%}





