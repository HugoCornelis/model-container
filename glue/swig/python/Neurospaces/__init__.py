#!/usr/bin/python

import SwiggableNeurospaces

classes = { 'Symbol': { 'methods': { 'backend_object': 'self.backend',
                                     'insert_child': 'abc',
                                     },
                        },
            }

print type(classes)

for class_name in classes.keys():
    class_definition = classes[class_name]
    method_definitions = class_definition['methods']
    for method_name in method_definitions.keys():
        method_definition = method_definitions[method_name]
        string = ("class " + class_name + ":\n"
                  + "    def " + method_name + "(self):"
                  + "        return " + method_definition + "\n")
        print "exec " + string
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

# should remain here

class Context:
    "pidinstack context class"
    def __init__(self, path):
        self.backend = SwiggableNeurospaces.PidinStackParse(path);

class ModelContainer:
    def __init__(self, backend):
        if backend == None:
            print "Constructing a new ModelContainer for the python interface"
            self.backend = SwiggableNeurospaces.NeurospacesNew()
        else:
            print "Recycling an existing ModelContainer for the python interface"
            self.backend = backend
            
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

# def new():
#     "Construct a model container"
#     self.backend = SwiggableNeurospaces.NeurospacesNew()
#     return self

# globalNmc = None

# def setModelContainer(nmc):
#     "Set the reference to the model-container"
#     globalNmc = nmc

# def getModelContainer():
#     "Produce a reference to the active model-container"
#     return nmc
