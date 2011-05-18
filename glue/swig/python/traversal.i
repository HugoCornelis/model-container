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

//------------------------------------------ Prototypes -------------------------------
PyObject * ChildSymbolsToDictList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, 
				  int iTypes, int iCoordsLocal, int iCoordsAbsolute, int iCoordsAbsoluteParent,
				  int iLevel, int iMode);

static PyObject * CoordinateTuple(double dX, double dY, double dZ);

PyObject * ChildSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);

PyObject * ChildTypedSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist);
//------------------------------------------ End Prototypes ---------------------------


//------------------------------------------------------------------------------
/*
 * Returns a tuple of coodinates in the form (x, y z)
 * Attempts cleanup of objects in the event of an error.
 */
static PyObject * CoordinateTuple(double dX, double dY, double dZ)
{

  PyObject * ppoTuple = PyTuple_New(3);
  
  if( !ppoTuple )
  {
    return NULL;
  }

  PyObject * ppoX = NULL;
  PyObject * ppoY = NULL;
  PyObject * ppoZ = NULL;

  ppoX = PyFloat_FromDouble(dX);

  if( !PyFloat_Check(ppoX) )
  {
    free(ppoX);
    return NULL;
  }

  ppoY = PyFloat_FromDouble(dY);

  if( !PyFloat_Check(ppoY) )
  {
    free(ppoX);
    free(ppoY);
    return NULL;
  }

  ppoZ = PyFloat_FromDouble(dZ);
  
  if( !PyFloat_Check(ppoZ) )
  {
    free(ppoX);
    free(ppoY);
    free(ppoZ);
    return NULL;
  }

  ppoTuple = PyTuple_New(3);

  if( !ppoTuple )
  {
    free(ppoX);
    free(ppoY);
    free(ppoZ);
    return NULL;
  }

  PyTuple_SetItem(ppoTuple, 0, ppoX);
  PyTuple_SetItem(ppoTuple, 1, ppoY);
  PyTuple_SetItem(ppoTuple, 2, ppoZ);

  if( !PyTuple_Check(ppoTuple) )
  {
    free(ppoX);
    free(ppoY);
    free(ppoZ);
    return NULL;
  }

  return ppoTuple;

}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
/*
 *
 * Depending on flags given it will construct a python dict object. 
 */
PyObject * ChildSymbolsToDictList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, 
				  int iTypes, int iCoordsLocal, int iCoordsAbsolute, int iCoordsAbsoluteParent,
				  int iLevel, int iMode)
{

  int i;
  int iTraverse;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpDict = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  PyObject * ppoTmpCoord = NULL;
  struct TreespaceTraversal *ptstr = NULL;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate dict list");
    return NULL;
  }

  //- construct children info

  int iTraversalFlags = TRAVERSAL_INFO_NAMES;

  if( iTypes )
  {
    iTraversalFlags |= TRAVERSAL_INFO_TYPES;
  }

  if( iCoordsLocal )
  {
    iTraversalFlags |= TRAVERSAL_INFO_COORDS_LOCAL;
  }

  if( iCoordsAbsolute )
  {
    iTraversalFlags |= TRAVERSAL_INFO_COORDS_ABSOLUTE;
  }

  if( iCoordsAbsoluteParent )
  {
    iTraversalFlags |= TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT;
  }

  struct traversal_info ci =
    {
      //m information request flags
      
      iTraversalFlags,

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
      
      ppoTmpDict = PyDict_New();

      if( !ppoTmpDict )
      {
	PyErr_SetString(PyExc_MemoryError,"can't allocate dict for child");
	return NULL;
      }
      
      // First we set the name to the dict
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(ci.ppcNames[i]);

      if (!PyString_Check(ppoTmpName))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoList);
	return NULL;

      }

      PyDict_SetItemString(ppoTmpDict, "name", ppoTmpName);


      // If we want types we add the type here
      if( iTypes )
      {

	ppoTmpType = PyString_FromString(ci.ppcTypes[i]);

	PyDict_SetItemString(ppoTmpDict, "type", ppoTmpType);

      }
      
      // Add the different levels of coordinates here
      if( iCoordsLocal || iCoordsAbsolute || iCoordsAbsoluteParent )
      {
	
	


      }

      // After converting the string to a python string we append 
      PyList_Append(ppoList, ppoTmpDict);

    }
  }

  //- free allocated memory

  TraversalInfoFree(&ci);

  if( !PyList_Check(ppoList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid dict list was generated from the model container");
    free(ppoList);

  }

  return ppoList;
}
//------------------------------------------------------------------------------



//-----------------------------------------------------------------------------
/*
 * \fun PyObject * ChildSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
 * \param phsle A pointer to an hsolve list element  
 * \param ppist A pointer to an identifier context
 * \returns A pointer to a python list object of type string.
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
      
      (TRAVERSAL_INFO_NAMES),

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





//-----------------------------------------------------------------------------
/*
 * \fun PyObject * ChildTypedSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
 * \param phsle A pointer to an hsolve list element  
 * \param ppist A pointer to an identifier context
 * \returns A pointer to a python list object containing python tuples (name, type)
 *
 * Performs a traversal and returns a list of all symbols that are children to the given
 * symbol+context with the approrpiate type.
 */
PyObject * ChildTypedSymbolsToList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist)
{

  int i;
  int iTraverse;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpType = NULL;
  PyObject * ppoTmpTuple = NULL;
  struct TreespaceTraversal *ptstr = NULL;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate symbol list");
    return NULL;
  }

  //- construct children info

  struct traversal_info ci =
    {
      //m information request flags
      
      (TRAVERSAL_INFO_NAMES	     
       | TRAVERSAL_INFO_TYPES),

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
      
      if ( !ci.ppcNames[i] || !ci.ppcTypes[i] )
	continue; // This might not be a good idea, no error reporting
      
      // Converts the regular string into a python string object
      ppoTmpName = PyString_FromString(ci.ppcNames[i]);
      ppoTmpType = PyString_FromString(ci.ppcTypes[i]);
      

      if (!PyString_Check(ppoTmpName) || !PyString_Check(ppoTmpType))
      {

	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free(ppoList);
	return NULL;

      }


      //
      // Creates a tuple in the form (Name, Type)
      //
      ppoTmpTuple = PyTuple_New(2);

      if( !ppoTmpTuple )
      {
	PyErr_SetString(PyExc_MemoryError,"can't allocate a new Python tuple");
	return NULL;
      }

      PyTuple_SetItem(ppoTmpTuple, 0, ppoTmpName);
      PyTuple_SetItem(ppoTmpTuple, 1, ppoTmpType);

      if( !PyTuple_Check(ppoTmpTuple) )
      {

	PyErr_SetString(PyExc_TypeError,"error creating PyTuple (Name, Type)");
	free(ppoList);

	return NULL;
      }

      // After converting the string to a python string we append 
      PyList_Append(ppoList, ppoTmpTuple);

    }
  }

  //- free allocated memory

  TraversalInfoFree(&ci);

  if( !PyList_Check(ppoList) )
  {

    PyErr_SetString(PyExc_Exception,"invalid list was generated from the model container");
    free(ppoList);

  }

  return ppoList;
}

//-----------------------------------------------------------------------------


%}





