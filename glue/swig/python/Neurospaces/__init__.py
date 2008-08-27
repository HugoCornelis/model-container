#!/usr/bin/python

import SwiggableNeurospaces


SegmentCalloc = SwiggableNeurospaces.SegmentCalloc


class Segment:
    "Segment class"
    def __init__(self, name):
        segment = SegmentCalloc()
        SwiggableNeurospaces.SymbolSetName(segment.segr.bio.ioh.iol.hsle, SwiggableNeurospaces.IdinNewFromChars(name))
        self.backend = segment
        
    
def new():
    "Construct a model container"
    self.backend = SwiggableNeurospaces.NeurospacesNew()
    return self


