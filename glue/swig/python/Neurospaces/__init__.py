#!/usr/bin/python

import sys
sys.path.append('/usr/local/glue/swig/python')
import SwiggableNeurospaces

nmcGlobal = None


classes = { 'Symbol': { 'methods': { 'backend_object': 'self.backend',
                                     'insert_child': 'abc',
                                     },
                        },
            }

# print type(classes)

for class_name in classes.keys():
    class_definition = classes[class_name]
    method_definitions = class_definition['methods']
    for method_name in method_definitions.keys():
        method_definition = method_definitions[method_name]
        string = ("class " + class_name + ":\n"
                  + "    def " + method_name + "(self):"
                  + "        return " + method_definition + "\n")
#         print "exec " + string
        exec string


exec """
class Symbol:
    def backend_object(self):
        return self.backend
    
    def insert_child(self, child):
        s = self.backend_object()
        c = child.backend_object()
        return SwiggableNeurospaces.SymbolAddChild(s, c)
        
    def parameter(self, name, value):
        return SwiggableNeurospaces.SymbolSetParameterDouble(self.backend_object(), name, value)

class Cell(Symbol):
    "Cell class"
    def __init__(self, name):
        cell = SwiggableNeurospaces.CellCalloc()
        SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = cell

    def backend_object(self):
        return self.backend.segr.bio.ioh.iol.hsle
"""

class ContourGroup(Symbol):
    "ContourGroup class"
    def __init__(self, name):
        group = SwiggableNeurospaces.VContourCalloc()
        SwiggableNeurospaces.SymbolSetName(group.vect.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = group

    def backend_object(self):
        return self.backend.vect.bio.ioh.iol.hsle

class ContourPoint(Symbol):
    "ContourPoint class"
    def __init__(self, name):
        point = SwiggableNeurospaces.ContourPointCalloc()
        SwiggableNeurospaces.SymbolSetName(point.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = point

    def backend_object(self):
        return self.backend.bio.ioh.iol.hsle

class EMContour(Symbol):
    "EMContour class"
    def __init__(self, name):
        contour = SwiggableNeurospaces.EMContourCalloc()
        SwiggableNeurospaces.SymbolSetName(contour.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = contour

    def backend_object(self):
        return self.backend.bio.ioh.iol.hsle

class Segment(Symbol):
    "Segment class"
    def __init__(self, name):
        segment = SwiggableNeurospaces.SegmentCalloc()
        SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = segment

    def backend_object(self):
        return self.backend.segr.bio.ioh.iol.hsle

    def parameter(self, name, value):
        SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.segr.bio.ioh.iol.hsle, name, value)

class Channel(Symbol):
    "Channel class"
    def __init__(self, name):
        channel = SwiggableNeurospaces.ChannelCalloc()
        SwiggableNeurospaces.SymbolSetName(channel.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = channel

    def backend_object(self):
        return self.backend.bio.ioh.iol.hsle

    def parameter(self, name, value):
        SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.bio.ioh.iol.hsle, name, value)

class GateKinetic(Symbol):
    "GateKinetic class"
    def __init__(self, name):
        gk = SwiggableNeurospaces.GateKineticCalloc()
        SwiggableNeurospaces.SymbolSetName(gk.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinCallocUnique(name))
        self.backend = gk

    def backend_object(self):
        return self.backend.bio.ioh.iol.hsle

    def parameter(self, name, value):
        SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.bio.ioh.iol.hsle, name, value)

# should remain here

class Context:
    "pidinstack context class"
    def __init__(self, path):
        self.backend = SwiggableNeurospaces.PidinStackParse(path);

class ModelContainer:
    def __init__(self, backend):
        if backend == None:
#             print "Constructing a new ModelContainer for the python interface"
            self.backend = SwiggableNeurospaces.NeurospacesNew()
        else:
#             print "Recycling an existing ModelContainer for the python interface"
            self.backend = backend
            pif = backend.pifRootImport
            SwiggableNeurospaces.ImportedFileSetRootImport(pif)
            
    def import_file(self, filename):
        pass
    
    def insert(self, path, symbol):
        context = SwiggableNeurospaces.PidinStackParse(path)
        top = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
        SwiggableNeurospaces.SymbolAddChild(top, symbol.backend_object())

    def lookup(self, name):
        pass

    def query(self, command):
        "submit querymachine commands to the model container"
        SwiggableNeurospaces.QueryMachineHandle(self.backend, command)
    
    def read(self, filename):
        "read an NDF model file"
        SwiggableNeurospaces.NeurospacesRead(self.backend, 2, [ "python", filename ] )

    def read_python(self, filename):
        "read an NPY model file"
#         execfile("/usr/local/neurospaces/models/library/" + filename)
        execfile("/local_home/hugo/neurospaces_project/model-container/source/snapshots/0/library/" + filename)

    class Channel(Symbol):
        "ModelContainer.Channel constructor"
        def __init__(self, path):
            [ name, top_symbol ] = prepare(path)
            import Neurospaces
            channel = Neurospaces.Channel(name.pcIdentifier)
            if top_symbol == None:
                print "Error: top_symbol is None"
            else:
                SwiggableNeurospaces.SymbolAddChild(top_symbol, channel.backend.bio.ioh.iol.hsle)
            self.backend = channel
        
        def parameter(self, name, value):
            self.backend.parameter(name, value)

    class GateKinetic(Symbol):
        "ModelContainer.GateKinetic constructor"
        def __init__(self, path):
            [ name, top_symbol ] = prepare(path)
            import Neurospaces
            gk = Neurospaces.GateKinetic(name.pcIdentifier)
            if top_symbol == None:
                print "Error: top_symbol is None"
            else:
                SwiggableNeurospaces.SymbolAddChild(top_symbol, gk.backend.bio.ioh.iol.hsle)
            self.backend = gk
        
        def parameter(self, name, value):
            self.backend.parameter(name, value)

def prepare(path):
    context = SwiggableNeurospaces.PidinStackParse(path)
    name = SwiggableNeurospaces.PidinStackTop(context)
    SwiggableNeurospaces.PidinStackPop(context)
    top_symbol = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
    return [ name, top_symbol ]

def getModelContainer():
    global nmcGlobal
    if nmcGlobal == None:
        backend = SwiggableNeurospaces.NeurospacesNew()
        SwiggableNeurospaces.NeurospacesRead(backend, 2, [ "Neurospaces.__init__", "utilities/empty_model.ndf", ], )
        nmcGlobal = ModelContainer(backend)
    return nmcGlobal

def setModelContainer(nmc):
    global nmcGlobal
    nmcGlobal = nmc


# if __name__ == '__main__':
#     pass


