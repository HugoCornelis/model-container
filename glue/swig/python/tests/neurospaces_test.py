#!/usr/bin/python

import Neurospaces

print "Neurospaces loaded"

##s1 = Neurospaces.SegmentCalloc()

##print "Segment created"

##s2 = Neurospaces.Segment()

##print "Segment object created"

import Neurospaces.SingleModelContainer

print "SingleModelContainer loaded"

s = Neurospaces.SingleModelContainer.Segment("/segment");

print "Segment object created and inserted"

c = Neurospaces.SingleModelContainer.Cell("/cell");

print "Cell object created and inserted"

