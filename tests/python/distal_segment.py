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

import model_container as nmc

my_nmc = nmc.ModelContainer(None)


my_nmc.Read("cells/purkinje/edsjb1994.ndf")

my_nmc.Query("segmentertips /Purkinje")

print "Done!"

