#!/usr/bin/python

import SwiggableNeurospaces

# should go to Component.py

class Symbol:
    def insert_child(self, nmc, name):
        import re
        paths = re.split("::", name)
        if len(paths) != 2:
            raise Error
        filename = paths[0]
        component = paths[1]
        #t import the file
        #t lookup the symbol
        #t call lowlevel SwiggableNeurospaces.SymbolAddChild()

    def parameter(self, name, value):
        return SwiggableNeurospaces.SymbolSetParameterDouble(self.backend_object(), name, value)

class Cell(Symbol):
    "Cell class"
    def __init__(self, name):
        cell = SwiggableNeurospaces.CellCalloc()
        SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("cell"))
#         SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinDuplicate(SwiggableNeurospaces.IdinNewFromChars("cell")))
        self.backend = cell

class ContourGroup(Symbol):
    "ContourGroup class"
    def __init__(self, name):
        group = SwiggableNeurospaces.VContourCalloc()
        SwiggableNeurospaces.SymbolSetName(groupbio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("group"))
        self.backend = group

class ContourPoint(Symbol):
    "ContourPoint class"
    def __init__(self, name):
        point = SwiggableNeurospaces.ContourPointCalloc()
        SwiggableNeurospaces.SymbolSetName(point.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("point"))
        self.backend = point

class EMContour(Symbol):
    "EMContour class"
    def __init__(self, name):
        contour = SwiggableNeurospaces.EMContourCalloc()
        SwiggableNeurospaces.SymbolSetName(contour.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("contour"))
        self.backend = contour

    def backend_object(self):
        return self.backend.bio.ioh.iol.hsle

class Segment(Symbol):
    "Segment class"
    def __init__(self, name):
        segment = SwiggableNeurospaces.SegmentCalloc()
        SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("soma"))
#         SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinDuplicate(SwiggableNeurospaces.IdinNewFromChars(name)))
        self.backend = segment

    def parameter(self, name, value):
        SwiggableNeurospaces.SymbolSetParameterDouble(self.backend.segr.bio.ioh.iol.hsle, name, value)

    def insert_child(self, nmc, name):
        Symbol.insert_child(self, nmc, name)
        
# should remain here

class Context:
    "pidinstack context class"
    def __init__(self, path):
        self.backend = SwiggableNeurospaces.PidinStackParse(path);

class ModelContainer:
    def __init__(self):
        self.backend = SwiggableNeurospaces.NeurospacesNew()

    def insert(self, path, symbol):
        context = SwiggableNeurospaces.PidinStackParse(path)
        top = SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
        SwiggableNeurospaces.SymbolAddChild(top, symbol)

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

