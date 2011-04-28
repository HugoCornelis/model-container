#! /usr/bin/env python
"""
Test for parameter operations
"""
import os
import sys

root_path = os.environ['HOME'] + "/neurospaces_project/model-container/source/snapshots/0"

my_path = root_path + "/glue/swig/python/"

sys.path.append(my_path)

import neurospaces.model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("legacy/networks/networksmall.ndf")

my_model_container.Query("printparameter /CerebellarCortex/Golgis/0/Golgi_soma/** Erev")

