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

PyObject * CoordinatesToDictList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iMode);
//------------------------------------------ End Prototypes ---------------------------


//------------------------------------------------------------------------------
/*
 * Returns a dict of coodinates in the form ['key'](x, y z)
 * Attempts cleanup of objects in the event of an error.
 */
static PyObject * CoordinateDict(char *pcKey, double dX, double dY, double dZ)
{

  PyObject * ppoDict = NULL;
  PyObject * ppoTuple = NULL;

  if(!pcKey)
  {
    return NULL;
  }

  ppoDict = PyDict_New();


  if( !ppoDict )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate coordinate dict");
    return NULL;
  } 
  
  ppoTuple = CoordinateTuple(dX, dY, dZ);

  if( !ppoTuple )
  {
    PyDict_Clear(ppoDict);
    return NULL;
  }
  
  PyDict_SetItemString(ppoDict, pcKey, ppoTuple);

  if( !PyDict_Check(ppoDict) )
  {
    PyDict_Clear(ppoDict);

    return NULL;
  }

}

//------------------------------------------------------------------------------



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
  PyObject * ppoTmpSubDict = NULL;
  PyObject * ppoTmpCoord = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  struct TreespaceTraversal *ptstr = NULL;
  double dX, dY, dZ;


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
      // Should be set as:
      //               ['coordinate']['local']
      //               ['coordinate']['absolute']
      //               ['coordinate']['absolute_parent']
      if( iCoordsLocal || iCoordsAbsolute || iCoordsAbsoluteParent )
      {
	
	ppoTmpSubDict = PyDict_New();
	  
	if(!ppoTmpSubDict)
	{
	  PyErr_SetString(PyExc_MemoryError,
			  "can't allocate dict object for coordinates");
	  return NULL;
	}

	// Short circuiting to make sure it doesn't crash
	if( iCoordsLocal && ci.ppD3CoordsLocal && 
	    ci.ppD3CoordsLocal[i] && ci.ppD3CoordsLocal[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(ci.ppD3CoordsLocal[i]->dx,
					ci.ppD3CoordsLocal[i]->dy,
					ci.ppD3CoordsLocal[i]->dz);
	  
	  PyDict_SetItemString(ppoTmpSubDict, "local", ppoTmpCoord);

	  ppoTmpCoord = NULL;

	}

	if( iCoordsAbsolute && ci.ppD3CoordsAbsolute && 
	    ci.ppD3CoordsAbsolute[i] && ci.ppD3CoordsAbsolute[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(ci.ppD3CoordsAbsolute[i]->dx,
					ci.ppD3CoordsAbsolute[i]->dy,
					ci.ppD3CoordsAbsolute[i]->dz);

	  PyDict_SetItemString(ppoTmpSubDict, "absolute", ppoTmpCoord);

	  ppoTmpCoord = NULL;

	}

	if( iCoordsAbsoluteParent && ci.ppD3CoordsAbsoluteParent && 
	    ci.ppD3CoordsAbsoluteParent[i] && 
	    ci.ppD3CoordsAbsoluteParent[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(ci.ppD3CoordsAbsoluteParent[i]->dx,
					ci.ppD3CoordsAbsoluteParent[i]->dy,
					ci.ppD3CoordsAbsoluteParent[i]->dz);

	  PyDict_SetItemString(ppoTmpSubDict, "absolute_parent", ppoTmpCoord);

	  ppoTmpCoord = NULL;
	}

	// Place all coordinates from the dict into the top level dict

	PyDict_SetItemString(ppoTmpDict, "coordinate", ppoTmpSubDict);

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




//------------------------------------------------------------------------------
/*
 *
 * Depending on flags given it will construct a python dict object. 
 */
PyObject * CoordinatesToDictList(struct symtab_HSolveListElement *phsle, struct PidinStack *ppist, int iLevel, int iMode)
{

  int i;
  int iTraverse;
  int iSuccess;
  PyObject * ppoList = NULL;
  PyObject * ppoTmpDia = NULL;
  PyObject * ppoTmpDict = NULL;
  PyObject * ppoTmpSubDict = NULL;
  PyObject * ppoTmpCoord = NULL;
  PyObject * ppoTmpName = NULL;
  PyObject * ppoTmpSerial = NULL;
  PyObject * ppoTmpKey = NULL;
  PyObject * ppoTmpType = NULL;
  struct TreespaceTraversal *ptstr = NULL;
  double dX, dY, dZ;


  //- Start out with an empty list

  ppoList = PyList_New(0);

  if( !ppoList )
  {
    PyErr_SetString(PyExc_MemoryError,"can't allocate coordinate dict list");
    return NULL;
  }

  //- construct children info

  int iTraversalFlags = TRAVERSAL_INFO_NAMES
    | TRAVERSAL_INFO_COORDS_LOCAL
    | TRAVERSAL_INFO_COORDS_ABSOLUTE
    | TRAVERSAL_INFO_COORDS_ABSOLUTE_PARENT
    | TRAVERSAL_INFO_TYPES;

  struct traversal_info ci =
    {
      //m information request flags
      
      iTraversalFlags,

      //m traversal method flags

      (iMode == SELECTOR_BIOLEVEL_INCLUSIVE) ? CHILDREN_TRAVERSAL_FIXED_RETURN : 0,

      //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN

      (iMode == SELECTOR_BIOLEVEL_INCLUSIVE) ? TSTR_PROCESSOR_SUCCESS : 0,

/* 	    //m traversal method flags */

/* 	    0, */

/* 	    //m traversal result for CHILDREN_TRAVERSAL_FIXED_RETURN */

/* 	    0, */

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

  struct BiolevelSelection bls =
    {
      //m chained user data
      
      NULL,

      //m mode : exclusive, inclusive

      iMode,

      //m selected level

      iLevel,

      //m all levels follow, not used for now
    };


  iSuccess = SymbolTraverseBioLevels(phsle,
				     ppist,
				     &bls,
				     TraversalInfoCollectorProcessor,
				     NULL,
				     (void *)&ci);


  // Loop through all found children and append them to the list

  if (iSuccess == 1 && ci.iChildren)
  {

    for (i = 0; i < ci.iChildren; i++)
    {
      

      if (strcmp(ci.ppcTypes[i], "segmen") == 0
	  || strcmp(ci.ppcTypes[i], "cell  ") == 0
	  || strcmp(ci.ppcTypes[i], "contou") == 0
	  || strcmp(ci.ppcTypes[i], "e_m_co") == 0
	  || strcmp(ci.ppcTypes[i], "fiber ") == 0
	  || strcmp(ci.ppcTypes[i], "popula") == 0
	  || strcmp(ci.ppcTypes[i], "networ") == 0
	  || strcmp(ci.ppcTypes[i], "random") == 0)
      {

	ppoTmpDict = PyDict_New();

	if( !ppoTmpDict )
	{
	  PyErr_SetString(PyExc_MemoryError,"can't allocate dict for child");
	  return NULL;
	}
      
      
	// Sets the name string ------------------------------------------------
	ppoTmpName = PyString_FromString(ci.ppcNames[i]);

	if (!PyString_Check(ppoTmpName))
	{

	  PyErr_SetString(PyExc_TypeError,"\"name\" dict key must contain strings");
	  PyDict_Clear(ppoTmpDict);
	  free(ppoList);
	  return NULL;

	}

	PyDict_SetItemString(ppoTmpDict, "name", ppoTmpName);
	//- End name set --------------------------------------------------------


	// Sets the serial value -----------------------------------------------
	ppoTmpSerial = PyInt_FromLong(ci.piSerials[i]);

	if (!PyString_Check(ppoTmpSerial))
	{

	  PyErr_SetString(PyExc_TypeError,"\"serial\" dict key must contain an integer");
	  PyDict_Clear(ppoTmpDict);
	  free(ppoList);
	  return NULL;

	}

	PyDict_SetItemString(ppoTmpDict, "serial", ppoTmpSerial);
	//- End setting the serial value ---------------------------------------

	
	// Sets the Dia value --------------------------------------------------
	ppoTmpDia = PyFloat_FromDouble(ci.pdDia[i]);

	if (!PyFloat_Check(ppoTmpDia))
	{

	  PyErr_SetString(PyExc_TypeError,"\"dia\" dict key must contain a double");
	  PyDict_Clear(ppoTmpDict);
	  free(ppoList);
	  return NULL;

	}

	PyDict_SetItemString(ppoTmpDict, "dia", ppoTmpDia);
	//- End setting dia value ----------------------------------------------


	// Add the type string here --------------------------------------------
	ppoTmpType = PyString_FromString(ci.ppcTypes[i]);
	
	PyDict_SetItemString(ppoTmpDict, "type", ppoTmpType);
	//- End setting type value ---------------------------------------------


	// Add the different levels of coordinates here
	// Should be set as:
	//               ['coordinate']['local']
	//               ['coordinate']['absolute']
	//               ['coordinate']['absolute_parent']
	
	ppoTmpSubDict = PyDict_New();
	  
	if(!ppoTmpSubDict)
	{
	  PyErr_SetString(PyExc_MemoryError,
			  "can't allocate dict object for coordinates");
	  return NULL;
	}

	// Short circuiting to make sure it doesn't crash
	if( ci.ppD3CoordsLocal && ci.ppD3CoordsLocal[i] && 
	    ci.ppD3CoordsLocal[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(ci.ppD3CoordsLocal[i]->dx,
					ci.ppD3CoordsLocal[i]->dy,
					ci.ppD3CoordsLocal[i]->dz);
	  
	  PyDict_SetItemString(ppoTmpSubDict, "local", ppoTmpCoord);

	  ppoTmpCoord = NULL;

	}

	if( ci.ppD3CoordsAbsolute && ci.ppD3CoordsAbsolute[i] && 
	    ci.ppD3CoordsAbsolute[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(ci.ppD3CoordsAbsolute[i]->dx,
					ci.ppD3CoordsAbsolute[i]->dy,
					ci.ppD3CoordsAbsolute[i]->dz);

	  PyDict_SetItemString(ppoTmpSubDict, "absolute", ppoTmpCoord);
	    
	  ppoTmpCoord = NULL;

	}

	if( ci.ppD3CoordsAbsoluteParent && ci.ppD3CoordsAbsoluteParent[i] && 
	    ci.ppD3CoordsAbsoluteParent[i]->dx != DBL_MAX )
	{

	  ppoTmpCoord = CoordinateTuple(ci.ppD3CoordsAbsoluteParent[i]->dx,
					ci.ppD3CoordsAbsoluteParent[i]->dy,
					ci.ppD3CoordsAbsoluteParent[i]->dz);

	  PyDict_SetItemString(ppoTmpSubDict, "parent", ppoTmpCoord);
	    
	  ppoTmpCoord = NULL;
	}

	// Place all coordinates from the dict into the top level dict

	PyDict_SetItemString(ppoTmpDict, "coordinate", ppoTmpSubDict);
	//- End the coordinate setting -----------------------------------------


	// After constructing the dict we append 
	PyList_Append(ppoList, ppoTmpDict);


      } // End visible if check

    } // End child loop

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





