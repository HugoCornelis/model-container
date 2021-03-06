#! /usr/bin/env python

import os
import sys

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

my_path = root_path + "/glue/swig/python/"

sys.path.append(my_path)

import Neurospaces.SingleCellContainer

print "SingleCellContainer loaded"

c = Neurospaces.SingleCellContainer.Cell("/cell");

print "Cell object created and inserted"

s = Neurospaces.SingleCellContainer.Segment("/cell/soma");

print "Soma object created and inserted"

s.parameter("Vm_init", -0.0680)
s.parameter("RM", 1.000)
s.parameter("RA", 2.50)
s.parameter("CM", 0.0164)
s.parameter("ELEAK", -0.0800)

# These are needed to make scaling on RM work properly, alternatively
# we can use the FIXED function to fix values to their scaled value.

# s.parameter("rel_X", 0.000e-6)
# s.parameter("rel_Y", 0.000e-6)
# s.parameter("rel_Z", 0.000e-6)

# s.parameter("DIA", 29.80e-6)

# s.parameter("SURFACE", 2.78986e-09)
# s.parameter("VOLUME", 1.38563e-14)
# s.parameter("LENGTH", 0.000100575244000493)

s.parameter("DIA", 2e-05)
s.parameter("LENGTH", 4.47e-05)

s.parameter("INJECT", 1e-9)

print "Soma parameters set"

s.import_child("channels/hodgkin-huxley.ndf::/k")
s.import_child("channels/hodgkin-huxley.ndf::/na")

Neurospaces.SingleCellContainer.set_output_filename("/tmp/output")

Neurospaces.SingleCellContainer.compile("/cell")

Neurospaces.SingleCellContainer.query("printinfo /cell")

Neurospaces.SingleCellContainer.query("printparameterscaled /cell/soma CM")
Neurospaces.SingleCellContainer.query("printparameterscaled /cell/soma RM")
Neurospaces.SingleCellContainer.query("printparameterscaled /cell/soma RA")

print "Neurospaces.SingleCellContainer.compile() called"

try:
    Neurospaces.SingleCellContainer.output("/cell/soma", "Vm")
except Heccer.AddressError, e:
    print "*** Error: " + e.cause
    import sys
    sys.exit(2)
    
print "output attached"

Neurospaces.SingleCellContainer.run(0.5)

print "simulation finished"


