#! /usr/bin/env python
"""
This test checks for the for the nmc modules 
to be present and importable.
"""
import os
import sys
import pdb

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

nmc_path = root_path + "/glue/swig/python/"

sys.path.append(nmc_path)


print "Importing nmc_base"
import nmc.nmc_base

print "Importing nmc"
import nmc

print "Done!"
