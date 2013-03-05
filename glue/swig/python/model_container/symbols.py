"""!
@file symbols.py 


File contains the implentation for symbols in the model
container.
"""
import pdb
import errors

try:

    import model_container_base as nmc_base

except ImportError, e:
    sys.exit("Could not import compiled SWIG model container base library: %s", e)



class SymbolError(Exception):
    pass


#*************************** Start Symbol **************************


class Symbol:
    """!
    @class Symbol An abstract class used for all symbols.

    A base object for a symbol in the model container. Object contains
    the only methods needed to  perform basic symbol manipulation such
    as adding parameters.
    Can be inherited by more complex objects for more complex symbols.
    Should note that currently in Python there is no difference between
    an Abstract class and a concrete class when they are user defined.
    """

#---------------------------------------------------------------------------

    def __init__(self, path=None, typ="segment", model=None):
        """!
        @brief Constructor
        """

        if path is None:

            raise errors.SymbolError("Cannot create symbol, no path given")
        
        self.path = path

        try:
            
            self._nmc_core = model.GetCore()

        except AttributeError:

            self._nmc_core = model

        self.symbol = None

        self.name = None

        self._CreateNameAndSymbol(path=path, typ=typ)
        
#---------------------------------------------------------------------------

    def GetSymbol(self):

        return self.symbol

#---------------------------------------------------------------------------

    def GetPath(self):
        """!
        @brief Returns the saved pathname in a python string
        @returns self._path The class variable that holds the path for the symbol
        """
        return self.path

#---------------------------------------------------------------------------

#     def GetCore(self):
#         """!
#         @brief Returns the core object in the Symbol abstraction

#         Returns the Hsolve list element pointer that is managed by
#         the object. Replaces the previous \"backend_object\",hopefully
#         is more clear :)
#         """
#         return self._core

#---------------------------------------------------------------------------

    def InsertChild(self, child):
        """!
        @brief Inserts the child object under the core_symbol

 
        """
        core_symbol = self.GetSymbol()

        try:

            core_child = child.GetSymbol()

        except AttributeError:

            # if it is not a high level object symbol
            # we assume it is a core C struct symbol
            core_child = child


        result = nmc_base.SymbolAddChild(core_symbol,core_child)

        return result

#---------------------------------------------------------------------------

    def ImportChild(self, path):
        """!
        @brief Imports a child into the current symbol from the given path
        """
        if self._nmc_core is None:

            raise errors.ImportChildError("No model container defined for symbol '%s', can't perform child import for '%s'" % (self._path, path))

        import re

        p = re.split("::", path)

        if len(p) != 2:

            raise errors.ImportChildError("Error importing '%s' into symbol '%s'" %
                                          path, self._path)

        filename = p[0]
        component = p[1]

        result = nmc_base.NeurospacesRead(self._nmc_core, 2, [ "python", filename ] )

        if result < 1:

            raise errors.ImportChildError("Error importing '%s' into symbol '%s'" %
                                          path, self._path)

        context = nmc_base.PidinStackParse(component)
        
        top = nmc_base.PidinStackLookupTopSymbol(context)

        self.InsertChild(top)
        
        # check result 

#---------------------------------------------------------------------------

    def GetParameter(self, parameter):
        """!
        @brief Returns a parameter value from the current symbol.
        @param parameter The parameter value to look up
        """

        path = self.GetPath()
        
        ppist = nmc_base.PidinStackParse(path)

        phsle = self.GetSymbol()
                               
        if phsle is None:

            return None

        value = nmc_base.SymbolParameterResolveValue(phsle, ppist, parameter)

        return value

#---------------------------------------------------------------------------

    def SetParameter(self, parameter, value):
        """!
        @brief Sets a parameter for the symbol

        A \"smart\" method that will determine the value
        type and pass it to the appropriate model container
        parameter set method.
        """
        result = self.SetParameterDouble(parameter,value)

        # Exception if bad?
        
        return result


#---------------------------------------------------------------------------

    def SetParameters(self, parameters):
        """
        @brief Sets a set of parameters in a dictionary
        """

        try:

            items = parameters.items()
            
        except AttributeError:

            raise errors.ParameterError("Error Invalid dictionary: %s" % str(parameters))

        for key, value in parameters.iteritems():

            self.SetParameter(key, value)
            
#---------------------------------------------------------------------------


    def SetParameterDouble(self, parameter, value):
        """!
        @brief Sets a double parameter

        Should note that python does not use actual doubles but
        instead uses floats, so we check for a float value. Name is kept
        the same to ensure compatability with the model container code.
        """

        symbol = self.GetSymbol()
        
        result = nmc_base.SymbolSetParameterDouble(symbol, parameter, value)

        return result

#---------------------------------------------------------------------------

    def _ConvertType(self, t):

        _type = t

        parts = _type.split('_')

        cparts = []
        
        for p in parts:

            cparts.append(p.capitalize())

            
        return ''.join(cparts)

#---------------------------------------------------------------------------

    def _CreateNameAndSymbol(self, path, typ):
        """!
        @brief Creates a name and context
        @returns result A tuple with a name and symbol 

        An internal helper method that creates a name and symbol
        """

        if typ == 'single_connection':

            _type = 'connection_symbol'

        elif typ == 'single_connection_group':

            _type = 'connection_symbol_group'

        else:

            _type = typ
            

        allocated_symbol = None

        path_parts = path.split('/')

        # kind of ugly but it works. May put this on three lines
        # to mmake it neater. On a string like '/n_cells/projection/a'
        # it will set parent_path to '/n_cells/parent_path'
        parent_path = '/'.join(path.split('/')[0:len(path_parts)-1])

        name = path_parts[-1]
        
#         parent_path = path_parts[0]

#         name = path_parts[1]

        c_type = self._ConvertType(_type)

        allocator = ''.join([c_type, "Calloc()"])

        allocate_command = "nmc_base.%s" % allocator

        try:
            
            allocated_symbol = eval(allocate_command)

        except AttributeError, e:

            raise SymbolError("Can't create '%s' of type '%s', '%s' is not a valid type" % (path, _type, _type))


        if allocated_symbol is None:

            raise SymbolError("Can't allocate '%s' of type '%s'" % (path, _type))

            #allocated_symbol = eval("nmc_base.GroupCalloc()")

            #cast_command = "nmc_base.cast_group_2_symbol(allocated_symbol)"

        else:
                
                cast_command = "nmc_base.cast_%s_2_symbol(allocated_symbol)" % _type

            
        pidin = nmc_base.IdinCallocUnique(name)

        try:
            
            casted_allocated_symbol = eval(cast_command)

        except AttributeError, e:

            raise SymbolError("Can't create '%s' of type '%s', no caster found" % (path, _type))

        nmc_base.SymbolSetName(casted_allocated_symbol, pidin)

        context = nmc_base.PidinStackParse(parent_path)

        if context is None:

            raise SymbolError("Cannot create context out of path '%s' (does it exist?)" % parent_path)

        parent = nmc_base.SymbolsLookupHierarchical(self._nmc_core.psym, context)

        if parent is None:

            raise SymbolError("Cannot find parent symbol '%s'" % parent_path)


        add_child_result = nmc_base.SymbolAddChild(parent, casted_allocated_symbol)

        if add_child_result == 0:

            raise SymbolError("Can't add child symbol to '%s'" % path)


        recalc_result = nmc_base.SymbolRecalcAllSerials(None,None)

        if recalc_result == 0:

            raise SymbolError("Can't recalculate serials when creating '%s'" % path)


        # Here I want to do a verify. Since we use eval to allocate, there's no way
        # to check the whole thing at a low level to see if it passed. Takes up a
        # minimal amount of extra time to do but necessary.

        verify_context = nmc_base.PidinStackParse(path)

        if verify_context is None:

            raise SymbolError("Can't verify context for '%s' of type '%s'" % (path, _type))

        verify_symbol = nmc_base.PidinStackLookupTopSymbol(verify_context)

        if verify_symbol is None:

            nmc_base.PidinStackFree(verify_context)

            raise SymbolError("Can't create symbol for '%s' of type '%s'" % (path, _type))            

        nmc_base.PidinStackFree(verify_context)

        #-- End verification --
        

        # set the attributes at the end
        
        self.path = path
        
        self.name = name

        self.type = _type
        
        self.symbol = casted_allocated_symbol

        self.context = context

#*************************** End Symbol ****************************




#*************************** Start Segment ****************************

class Segment(Symbol):
    
    """!
    @class Segment An object for managing a Segment symbol in the model container
    
    """
    def __init__(self, path=None, model=None):
        """!
        @brief Constructor

        @param path The complete path to the Segment object.
        """
        Symbol.__init__(self, path=path, typ="segment", model=model)
        

#---------------------------------------------------------------------------

#     def GetSymbol(self):
#         """!
#         @brief Returns the core objects hsolve list element (symbol).

#         """
#         return self._core.segr.bio.ioh.iol.hsle


#---------------------------------------------------------------------------

    def SetInitialVm(self,value):
        """!
        @brief Sets the initial membrane potential
        @param value float value for the membrane potential

        Sets the parameter \"Vm_init\" in the segment symbol
        in the model container.
        """
        self.SetParameter("Vm_init",value)
        
#---------------------------------------------------------------------------

    def SetRm(self,value):
        """!
        @brief Sets the membrane resistance
        @param value A float value to set the membrane resistance
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"RM\"
        parameter in the model container.
        """
        self.SetParameter("RM",value)

#---------------------------------------------------------------------------

    def SetRa(self,value):
        """!
        @brief Sets the axial resistance
        @param value A float value to set the axial resistance
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"RA\"
        parameter in the model container.

        """
        self.SetParameter("RA",value)

#---------------------------------------------------------------------------

    def SetCm(self,value):
        """!
        @brief Sets the membrane capacitance
        @param value A float value to set the membrane capacitance
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"CM\"
        parameter in the model container.
        """
        self.SetParameter("CM",value)

#---------------------------------------------------------------------------

    def SetDia(self,value):
        """!
        @brief Sets the segment diameter
        @param value A float value to set the segment diameter
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"DIA\"
        parameter in the model container.
        """
        self.SetParameter("DIA",value)

#---------------------------------------------------------------------------

    def SetEleak(self,value):
        """!
        @brief Sets Eleak
        @param value A float value to set Eleak
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"ELEAK\"
        parameter in the model container.
        """
        self.SetParameter("ELEAK",value)

#---------------------------------------------------------------------------

    def SetLength(self,value):
        """!
        @brief Sets Segment Length
        @param value A float value to set the segment length
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"LENGTH\"
        parameter in the model container.
        """
        self.SetParameter("LENGTH",value)

#---------------------------------------------------------------------------

    def SetInject(self,value):
        """!
        @brief Sets the injection value
        @param value A float value to set the injection voltage
        @sa SetParameter

        Just a simple wrapper to SetParameter. Sets the \"INJECT\"
        parameter in the model container.
        """
        self.SetParameter("INJECT",value)

        
#---------------------------------------------------------------------------

#     def __AllocateSegment(self,name):
#         """!
#         @brief Allocates and sets the name for a segment.

#         Method is name mangled since it should never be called
#         outside of initialization.
#         """
        
#         segment = nmc_base.SegmentCalloc()

#         if not segment:

#             raise Exception("Error allocating the Segment")

#         idin = nmc_base.IdinCallocUnique(name)

#         nmc_base.SymbolSetName(segment.segr.bio.ioh.iol.hsle, idin)
        
#         return segment
        

# An alias
Compartment = Segment

#*************************** End Segment ****************************




#*************************** Start Cell ****************************

class Cell(Symbol):
    """
    @class Cell A class object for managing a Cell symbol
    @brief A class object for managing a Cell symbol

    
    """
    def __init__(self, path=None, model=None):


        """!
        @brief Constructor

        @param path The complete path to the Segment object.
        """
        Symbol.__init__(self, path, "cell", model)


#*************************** End Cell ****************************


#*************************** Network Cell ************************

class Network(Symbol):

    def __init__(self, path=None, model=None):

        Symbol.__init__(self, path, "network", model)


#*************************** Network Cell ************************

#*************************** Projection ************************

class Projection(Symbol):

    def __init__(self, path=None, model=None):

        Symbol.__init__(self, path, "projection", model)


#***************************  Projection ************************


