#! /usr/bin/env python
"""

"""
import os
import pdb
import pprint
import sys


from test_library import add_package_path

add_package_path('model-container')

import model_container as nmc

my_model_container = nmc.ModelContainer(None)


my_model_container.Read(filename="cells/RScell-nolib2.ndf", namespace="rscell")

nx= 2 # number of cells nx*ny
ny=2

sep_x= 0.002 # 2mm
sep_y=0.002
sep_z=1.0e-6 # give it a tiny z range in case of round off errors

syn_weight=10
cond_vel=0.5
prop_delay=sep_x / cond_vel

my_model_container.CreateNetwork('/RSNet')

my_model_container.CreateMap('::rscell::/cell', '/RSNet/population', nx, ny, sep_x, sep_y)



my_model_container.CreateProjection(network='/RSNet',
                                    probability=1.0,
                                    random_seed=1212.0,
                                    source=('/RSNet/population', 'box', -1e10, -1e10, -1e10, 1e10, 1e10, 1e10),
                                    target=('/RSNet/population', 'Ex_channel', 0, 0, 0, sep_x * 1.2, sep_y * 1.2, sep_z * 0.5),
                                    target_hole=('box', sep_x *0.5, sep_y * 0.5, sep_z * 0.5, sep_x * 05, sep_y * 0.5, sep_z * 0.5),
                                    synapse=('fixed', prop_delay, syn_weight, 0.5, 'spike', 'Ex_channel')
                                    )



print "Done!"
