#! /usr/bin/env python
"""
Basic test showing how to execute some commands via the query
command.
"""
import os
import sys


from test_library import add_package_path

add_package_path('model-container')

import neurospaces.model_container as nmc

my_model_container = nmc.ModelContainer(None)

my_model_container.Read("cells/purkinje/edsjb1994.ndf")

my_model_container.Query("segmentersetbase /Purkinje")

my_model_container.Query("segmentertips /Purkinje")

my_model_container.Query("printparameter /Purkinje/segments/b1s06[144] SOMATOPETAL_BRANCHPOINTS")

#my_model_container.Query("setparameterconcept spine::/Purk_spine/head/par FREQUENCY number 25")

#my_model_container.Query("setparameterconcept thickd::gaba::/Purk_GABA FREQUENCY number 1")

print "Done!"

