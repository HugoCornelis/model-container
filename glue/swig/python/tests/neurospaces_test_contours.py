#!/usr/bin/python

import Neurospaces


nmc = Neurospaces.ModelContainer()

nmc.read("utilities/empty_model.ndf")

cg1 = Neurospaces.ContourGroup('section1')

nmc.insert("/", cg1)

emc = Neurospaces.EMContour('e0')

emc.parameter("THICKNESS", 0.07e-6 )

cg1.insert_child(emc)

nmc.query("expand /**")

