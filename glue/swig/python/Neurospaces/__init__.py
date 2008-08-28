#!/usr/bin/python

import SwiggableNeurospaces


class Cell:
    "Cell class"
    def __init__(self, name):
        cell = SwiggableNeurospaces.CellCalloc()
        SwiggableNeurospaces.SymbolSetName(cell.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars(name))
        self.backend = cell

class Segment:
    "Segment class"
    def __init__(self, name):
        segment = SwiggableNeurospaces.SegmentCalloc()
        SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars(name))
        self.backend = segment
        
def new():
    "Construct a model container"
    self.backend = SwiggableNeurospaces.NeurospacesNew()
    return self


