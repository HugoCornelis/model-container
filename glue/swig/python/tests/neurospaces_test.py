#!/usr/bin/python

import Neurospaces

print "Neurospaces loaded"

##s1 = Neurospaces.SegmentCalloc()

##print "Segment created"

##s2 = Neurospaces.Segment()

##print "Segment object created"

import Neurospaces.SingleModelContainer

print "SingleModelContainer loaded"

c = Neurospaces.SingleModelContainer.Cell("/cell");

print "Cell object created and inserted"

Neurospaces.SingleModelContainer.querymachine("expand /**")

s = Neurospaces.SingleModelContainer.Segment("/cell/segment");

print "Segment object created and inserted"

Neurospaces.SingleModelContainer.querymachine("expand /**")

s.parameter("Vm_init", -0.0680)
s.parameter("RM", 1.000)
s.parameter("RA", 2.50)
s.parameter("CM", 0.0164)
s.parameter("ELEAK", -0.0800)

Neurospaces.SingleModelContainer.querymachine("printinfo /cell")

