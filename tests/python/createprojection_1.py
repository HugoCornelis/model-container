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


my_model_container.Read("cells/RScell-nolib2.ndf")

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



config = {'root' : '/RSNet',
          'projection' : { 'name' : '/RSNet',
                           'source': '../population',
                           'target' : '../population',
                           },
          'source' : { 'context' : '../population',
                       { 'include' : { 'type' : 'box',
                                       'coordinates' : [-1e10, -1e10, -1e10, 1e10, 1e10, 1e10],
                                       
                                       },
                         
                         
                       },

          'target' : { 'context' : '../population',
                       },

          'synapse' : { 'weight' : { 'weight_indicator' : 'weight',
                                     'weight' : syn_weight,
                                     }
                        }
          }


source_coords = 
destination_coords = [0, 0, 0, sep_x *1.2, sep_y * 1.2, sep_z * 0.5]

volume_params = dict(network='/RSNet',
                     projection='/RSNet/projection',
                     projection_source='../population',
                     projection_target='../population',
                     source='/RSNet/population',
                     target='/RSNet/population',
                     pre='spike',
                     post='Ex_channel',
                     source_type='box',
                     destination_type='ellipse',
                     weight_indicator='weight',
                     weight=syn_weight,
                     delay_indicator='delay',
                     delay_type='fixed',
                     delay=prop_delay,
                     velocity_indicator='velocity',
                     velocity='0.5',
                     destination_hole_flag='destination_hole',
                     destination_hole_type='box',
                     destination_hole_x1=-sep_x * 0.5,
                     destination_hole_y1=-sep_y * 0.5,
                     destination_hole_z1=-sep_z * 0.5,
                     destination_hole_x2=sep_x * 0.5,
                     destination_hole_y2=sep_y * 0.5,
                     destination_hole_z2=sep_z * 0.5,
                     probability='1.0',
                     random_seed='1212.0')

# use keyword expansion to pass dict as arguments
my_model_container.VolumeConnect(**volume_params)

print "Done!"
