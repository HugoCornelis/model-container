#! /usr/bin/env python
"""
Test for parameter operations.

Test causes a segmentation fault on Ubuntu with
python 2.5. Error occurs when trying to do a vtable
lookup in file: hierarchy/output/symbols/callee_get_parameter.c:38
"""
import os
import sys

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

my_path = root_path + "/glue/swig/python/"

sys.path.append(my_path)

import nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("legacy/networks/networksmall.ndf")

my_model_container.Query("printparameter /** PROTOTYPE")

print "Done!"
