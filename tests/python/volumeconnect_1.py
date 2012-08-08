#! /usr/bin/env python
"""
Basic test to see if the volumeconnect returns any errors
"""
import os
import pdb
import pprint
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)


my_model_container.Read("cells/RScell-nolib2.ndf")


print "Done!"
