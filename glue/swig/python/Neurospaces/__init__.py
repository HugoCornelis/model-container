#!/usr/bin/python

import SwiggableNeurospaces

# should go to Component.py

class Cell:
    "Cell class"
    def __init__(self, name):
        cell = SwiggableNeurospaces.CellCalloc()
        SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("cell"))
#         SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinDuplicate(SwiggableNeurospaces.IdinNewFromChars("cell")))
        self.backend = cell

class Segment:
    "Segment class"
    def __init__(self, name):
        segment = SwiggableNeurospaces.SegmentCalloc()
        SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars("segment"))
#         SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinDuplicate(SwiggableNeurospaces.IdinNewFromChars(name)))
        self.backend = segment
        
# should remain here

class Context:
    "pidinstack context class"
    def __init__(self, path):
        self.backend = SwiggableNeurospaces.PidinStackParse(path);


def new():
    "Construct a model container"
    self.backend = SwiggableNeurospaces.NeurospacesNew()
    return self


def querymachine(self, command):
    "submit querymachine commands to the model container"
    SwiggableNeurospaces.QueryMachineHandle(self, command)
    
