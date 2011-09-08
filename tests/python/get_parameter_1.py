#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import sys

from test_library import add_package_path

add_package_path('model-container')


import model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("cells/purkinje/edsjb1994.ndf")


som_cm = my_model_container.GetParameter("/Purkinje/segments/soma","CM")

som_erev = my_model_container.GetParameter("/Purkinje/segments/soma/cat", "Erev")

print "Soma CM is %f and EREV is %f" % (som_cm, som_erev)


my_model_container.SetParameter("/Purkinje/segments/soma","CM",300.0)

som_cm = my_model_container.GetParameter("/Purkinje/segments/soma","CM")

print "Soma CM is %f and EREV is %f" % (som_cm, som_erev)

print "Done!"
