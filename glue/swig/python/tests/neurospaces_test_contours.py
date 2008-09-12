#!/usr/bin/python

import Neurospaces


nmc = Neurospaces.ModelContainer()

nmc.read("utilities/empty_model.ndf")

emc = Neurospaces.EMContour('EMContour')

emc.parameter("THICKNESS", 0.07e-6 )

