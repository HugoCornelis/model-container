#!/usr/bin/python

import Neurospaces.SingleCellContainer


Neurospaces.SingleCellContainer.read("cells/purkinje/edsjb1994.ndf")

Neurospaces.SingleCellContainer.query("segmentersetbase /Purkinje")
Neurospaces.SingleCellContainer.query("segmentertips /Purkinje")

Neurospaces.SingleCellContainer.query("printparameter /Purkinje/segments/b1s06[144] SOMATOPETAL_BRANCHPOINTS")
#/Purkinje/segments/b1s06[182]

Neurospaces.SingleCellContainer.query("setparameterconcept spine::/Purk_spine/head/par FREQUENCY number 25")
Neurospaces.SingleCellContainer.query("setparameterconcept thickd::gaba::/Purk_GABA FREQUENCY number 1")

Neurospaces.SingleCellContainer.set_output_filename("/tmp/output")

Neurospaces.SingleCellContainer.compile("/Purkinje")

Neurospaces.SingleCellContainer.output("/Purkinje/segments/soma", "Vm")

Neurospaces.SingleCellContainer.run(0.1)

print "simulation finished"


