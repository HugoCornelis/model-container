#! /usr/bin/env python

import os
import sys

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

my_path = root_path + "/glue/swig/python/"

sys.path.append(my_path)


import nmc


my_nmc = nmc.ModelContainer(None)

my_nmc.Read("utilities/empty_model.ndf")

print "Done!"

