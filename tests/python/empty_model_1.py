#! /usr/bin/env python

import os
import sys


from test_library import add_package_path

add_package_path('model-container')


import model_container as nmc


my_nmc = nmc.ModelContainer(None)


print "Done!"

