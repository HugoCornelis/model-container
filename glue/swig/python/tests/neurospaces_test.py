#!/usr/bin/python

#t replace SimpleModelContainer with SimpleModelContainer

import Neurospaces

print "Neurospaces loaded"

##s1 = Neurospaces.SegmentCalloc()

##print "Segment created"

##s2 = Neurospaces.Segment()

##print "Segment object created"

import Neurospaces.SimpleModelContainer

print "SimpleModelContainer loaded"

c = Neurospaces.SimpleModelContainer.Cell("/cell");

print "Cell object created and inserted"

# Neurospaces.SimpleModelContainer.querymachine("expand /**")

s = Neurospaces.SimpleModelContainer.Segment("/cell/segment");

print "Segment object created and inserted"

Neurospaces.SimpleModelContainer.querymachine("expand /**")

s.parameter("Vm_init", -0.0680)
s.parameter("RM", 1.000)
s.parameter("RA", 2.50)
s.parameter("CM", 0.0164)
s.parameter("ELEAK", -0.0800)

# These are needed to make scaling on RM work properly, alternatively
# we can use the FIXED function to fix values to their unscaled value.

# s.parameter("rel_X", 0.000e-6)
# s.parameter("rel_Y", 0.000e-6)
# s.parameter("rel_Z", 0.000e-6)

s.parameter("DIA", 29.80e-6)

s.parameter("SURFACE", 2.78986e-09)
s.parameter("VOLUME", 1.38563e-14)
s.parameter("LENGTH", 0.000100575244000493)

Neurospaces.SimpleModelContainer.querymachine("printinfo /cell")

print "Neurospaces.SimpleModelContainer.compile"

Neurospaces.SimpleModelContainer.compile("/tmp/output")

Neurospaces.SimpleModelContainer.output("/cell/segment", "Vm")

Neurospaces.SimpleModelContainer.run(0.5)


