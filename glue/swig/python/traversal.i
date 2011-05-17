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

Link to the PyString API functions: http://docs.python.org/c-api/string.html
***********************************************************/

%{
//------------------------- Start Neurospaces includes -------------------------
#include "neurospaces/traversalinfo.h"
//------------------------- End Neurospaces includes ---------------------------


#include <Python.h>
%}


%inline %{

 
PyObject * ChildSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);


//-----------------------------------------------------------------------------
/*
 * \fun PyObject * SymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
 * \param phsle A pointer to an hsolve list element  
 * \param ppist A pointer to an identifier context
 * \returns A pointer to a python list object
 *
 * Performs a traversal and returns a list of all symbols that are children to the given
 * symbol+context. 
 */
PyObject * ChildSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
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
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(ci.ppcNames[i]);

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





