#! /usr/bin/env python
"""
Basic test to check the segment data type.
"""
import os
import pdb
import sys

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

my_path = root_path + "/glue/swig/python/"

sys.path.append(my_path)

import neurospaces.model_container as nmc
import neurospaces.model_container.symbols as symbols

my_model_container = nmc.ModelContainer(None)

cell = symbols.Cell("/cell")

seg = symbols.Segment("/cell/soma")

seg.SetInitialVm(-0.0680)
seg.SetRm(1.000)
seg.SetRa(2.50)
seg.SetCm(0.0164)
seg.SetEleak(-0.0800)
seg.SetInject(1e-9)

par = seg.GetParameter("RM")

my_model_container.Query("setparameterconcept spine::/Purk_spine/head/par 25")

my_model_container.Query("setparameterconcept thickd::gaba::/Purk_GABA 1")

# print statement?

print "Done!"

