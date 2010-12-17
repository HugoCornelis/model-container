#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import sys

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

my_path = root_path + "/glue/swig/python/"

sys.path.append(my_path)

import nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("cells/purkinje/edsjb1994.ndf")


som_cm = my_model_container.GetParameter("/Purkinje/segments/soma","CM")

som_erev = my_model_container.GetParameter("/Purkinje/segments/soma/cat", "Erev")

print "Soma CM is %f and EREV is %f" % (som_cm, som_erev)


my_model_container.SetParameter("/Purkinje/segments/soma","CM",300.0)

som_cm = my_model_container.GetParameter("/Purkinje/segments/soma","CM")

print "Soma CM is %f and EREV is %f" % (som_cm, som_erev)

print "Done!"
