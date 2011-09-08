#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import pdb
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("legacy/networks/networksmall.ndf")

my_model_container.Query("printparameter /CerebellarCortex/Golgis/0/Golgi_soma/** Erev")

