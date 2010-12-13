"""!
@file symbols.py 


File contains the implentation for symbols in the model
container.
"""


try:

    import nmc_base

except ImportError:
    sys.exit("Could not import compiled SWIG nmc_base library: %s")





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

    def GetCore(self):
        """!
        @brief Returns the core object in the Symbol abstraction

        Returns the Hsolve list element pointer that is managed by
        the object. Replaces the previous \"backend_object\",hopefully
        is more clear :)
        """
        return self._core


    def InsertChild(self, child):

        core_symbol = self.GetCore()
        core_child = child.GetCore()

        result = nmc_base.SymbolAddChild(core_symbol,core_child)

        return result

#---------------------------------------------------------------------------

    def GetParameter(self, parameter):

        pass

#---------------------------------------------------------------------------

    def SetParameter(self, parameter, value):
        """!
        @brief Sets a parameter for the symbol

        A \"smart\" method that will determine the value
        type and pass it to the appropriate model container
        parameter set method.
        """
        result = None
        
        if isinstance(value,float):

            result = self.SetParameterDouble(value)


        return result
    
#---------------------------------------------------------------------------


    def SetParameterDouble(self, parameter, value):
        """!
        @brief Sets a double parameter

        Should note that python does not use actual doubles but
        instead uses floats, so we check for a float value. Name is kept
        the same to ensure compatability with the model container code.
        """
        if isinstance(value,float):

            return None

        symbol = self.GetCore()
        
        result = nmc_base.SymbolSetParameterDouble(symbol, name, value)

        return result


#---------------------------------------------------------------------------

#*************************** End Symbol ****************************




#*************************** Start Segment ****************************

class Segment(Symbol):
    
    """!
    @class Segment An object for managing a Segment symbol in the model container
    
    """
    def __init__(self, name):
        """!
        @brief Constructor

        @param The name for the Segment Symbol object
        """
        
        segment = nmc_base.SegmentCalloc()

        if not segment:

            raise Exception("Error allocating the Segment")

        nmc_base.SymbolSetName(segment.segr.bio.ioh.iol.hsle, nmc_base.IdinCallocUnique(name))
        
        self._core = segment


    def GetCore(self):
        """!
        @brief Returns the core object.

        Overloads the GetCore method from the symbol base class.
        """
        return self._core.segr.bio.ioh.iol.hsle



#*************************** End Segment ****************************



# class Cell(Symbol):
#     "Cell class"
#     def __init__(self, name):
#         cell = SwiggableNeurospaces.CellCalloc()
#         SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
#         self.backend = cell

#     def backend_object(self):
#         return self.backend.segr.bio.ioh.iol.hsle




#     class Channel(Symbol):
#         "ModelContainer.Channel constructor"
#         def __init__(self, path):
#             [ name, top_symbol ] = prepare(path)
#             import Neurospaces
#             channel = Neurospaces.Channel(name.pcIdentifier)
#             if top_symbol == None:
#                 print "Error: top_symbol is None"
#             else:
#                 SwiggableNeurospaces.SymbolAddChild(top_symbol, channel.backend.bio.ioh.iol.hsle)
#             self.backend = channel
        
#         def parameter(self, name, value):
#             self.backend.parameter(name, value)

#     class GateKinetic(Symbol):
#         "ModelContainer.GateKinetic constructor"
#         def __init__(self, path):
#             [ name, top_symbol ] = prepare(path)
#             import Neurospaces
#             gk = Neurospaces.GateKinetic(name.pcIdentifier)
#             if top_symbol == None:
#                 print "Error: top_symbol is None"
#             else:
#                 SwiggableNeurospaces.SymbolAddChild(top_symbol, gk.backend.bio.ioh.iol.hsle)
#             self.backend = gk
        
#         def parameter(self, name, value):
#             self.backend.parameter(name, value)




# class ContourGroup(Symbol):
#     "ContourGroup class"
#     def __init__(self, name):
#         group = SwiggableNeurospaces.VContourCalloc()
#         SwiggableNeurospaces.SymbolSetName(group.vect.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
#         self.backend = group

#     def backend_object(self):
#         return self.backend.vect.bio.ioh.iol.hsle

# class ContourPoint(Symbol):
#     "ContourPoint class"
#     def __init__(self, name):
#         point = SwiggableNeurospaces.ContourPointCalloc()
#         SwiggableNeurospaces.SymbolSetName(point.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
#         self.backend = point

#     def backend_object(self):
#         return self.backend.bio.ioh.iol.hsle

# class EMContour(Symbol):
#     "EMContour class"
#     def __init__(self, name):
#         contour = SwiggableNeurospaces.EMContourCalloc()
#         SwiggableNeurospaces.SymbolSetName(contour.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
#         self.backend = contour

#     def backend_object(self):
#         return self.backend.bio.ioh.iol.hsle

# class Channel(Symbol):
#     "Channel class"
#     def __init__(self, name):
#         channel = SwiggableNeurospaces.ChannelCalloc()
#         SwiggableNeurospaces.SymbolSetName(channel.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
#         self.backend = channel

#     def backend_object(self):
#         return self.backend.bio.ioh.iol.hsle

#     def parameter(self, name, value):
#         SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.bio.ioh.iol.hsle, name, value)

# class GateKinetic(Symbol):
#     "GateKinetic class"
#     def __init__(self, name):
#         gk = SwiggableNeurospaces.GateKineticCalloc()
#         SwiggableNeurospaces.SymbolSetName(gk.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
#         self.backend = gk

#     def backend_object(self):
#         return self.backend.bio.ioh.iol.hsle

#     def parameter(self, name, value):
#         SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.bio.ioh.iol.hsle, name, value)
