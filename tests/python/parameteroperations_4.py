#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import sys
import pdb

from test_library import add_package_path

add_package_path('model-container')

import neurospaces.model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("cells/purkinje/edsjb1994.ndf")

my_model_container.Query("printparameter /Purkinje/segments/soma CM")
my_model_container.Query("printparameterscaled /Purkinje/segments/soma CM")
my_model_container.Query("printparameter /Purkinje/segments/main[0]/ca_pool LENGTH")
my_model_container.Query("printparameter /Purkinje/SpinesNormal_13_1 PROTOTYPE")
my_model_container.Query("printparameterinfo /Purkinje/segments/soma/cat Erev")
my_model_container.Query("printparametertraversal /Purkinje/segments/soma/cat")
my_model_container.Query("symbolparameters /Purkinje/segments/main[2]")

print "Done!"
