#!/usr/bin/python

import Neurospaces.SingleCellContainer

# import Heccer

print "SingleCellContainer loaded"

c = Neurospaces.SingleCellContainer.Cell("/cell");

print "Cell object created and inserted"

# Neurospaces.SingleCellContainer.querymachine("expand /**")

s = Neurospaces.SingleCellContainer.Segment("/cell/segment");

print "Segment object created and inserted"

# Neurospaces.SingleCellContainer.querymachine("expand /**")

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

# s.parameter("DIA", 29.80e-6)

# s.parameter("SURFACE", 2.78986e-09)
# s.parameter("VOLUME", 1.38563e-14)
# s.parameter("LENGTH", 0.000100575244000493)

s.parameter("DIA", 2e-05)
s.parameter("LENGTH", 4.47e-05)

s.parameter("INJECT", 1e-9)

print "Segment parameter set"

# s.insert_child("channels/hodgkin-huxley/potassium.ndf::/k")
# s.insert_child("channels/hodgkin-huxley/sodium.ndf::/na")

# Neurospaces.SingleCellContainer.querymachine("printinfo /cell")

Neurospaces.SingleCellContainer.set_output_filename("/tmp/output")

Neurospaces.SingleCellContainer.compile()

Neurospaces.SingleCellContainer.querymachine("printinfo /cell")

Neurospaces.SingleCellContainer.querymachine("printparameterscaled /cell/segment CM")
Neurospaces.SingleCellContainer.querymachine("printparameterscaled /cell/segment RM")
Neurospaces.SingleCellContainer.querymachine("printparameterscaled /cell/segment RA")

print "Neurospaces.SingleCellContainer.compile() called"

try:
    Neurospaces.SingleCellContainer.output("/cell/segment", "Vm")
except Heccer.AddressError, e:
    print "*** Error: " + e.cause
    import sys
    sys.exit(2)
    
print "output attached"

Neurospaces.SingleCellContainer.run(0.5)

print "simulation finished"


