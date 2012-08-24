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


nx=2 # number of cells nx*ny
ny=2

sep_x= 0.002 # 2mm
sep_y=0.002
sep_z=1.0e-6 # give it a tiny z range in case of round off errors

syn_weight=10
cond_vel=0.5
prop_delay=sep_x / cond_vel

my_model_container = nmc.ModelContainer(None)


my_model_container.Read("cells/RScell-nolib2.ndf", "rscell")


network = my_model_container.CreateNetwork('/RSNet')

my_model_container.CreateMap('::rscell::/cell', '/RSNet/population', nx, ny, sep_x, sep_y)

my_model_container.Query("expand /**")


print "Done!"
