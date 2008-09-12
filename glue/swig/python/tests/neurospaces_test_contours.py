#!/usr/bin/python

import Neurospaces


nmc = Neurospaces.ModelContainer()

nmc.read("utilities/empty_model.ndf")

cg1 = Neurospaces.ContourGroup('section1')

nmc.insert("/", cg1)

emc1 = Neurospaces.EMContour('e0')

emc1.parameter("THICKNESS", 0.07e-6 )

cg1.insert_child(emc1)

p1 = Neurospaces.ContourPoint('e0_0')

p1.parameter("X", 0.000e-6)
p1.parameter("Y", 0.000e-6)

emc1.insert_child(p1)

p2 = Neurospaces.ContourPoint('e0_1')

p2.parameter("X", 1.000e-6)
p2.parameter("Y", 0.000e-6)

emc1.insert_child(p2)

p3 = Neurospaces.ContourPoint('e0_2')

p3.parameter("X", 1.000e-6)
p3.parameter("Y", 1.000e-6)

emc1.insert_child(p3)

p4 = Neurospaces.ContourPoint('e0_3')

p4.parameter("X", 0.000e-6)
p4.parameter("Y", 1.000e-6)

emc1.insert_child(p4)


emc2 = Neurospaces.EMContour('e1')

cg1.insert_child(emc2)

p1 = Neurospaces.ContourPoint('e1_0')

p1.parameter("X", 0.000e-6)
p1.parameter("Y", 0.000e-6)

emc2.insert_child(p1)

p2 = Neurospaces.ContourPoint('e1_1')

p2.parameter("X", 1.000e-6)
p2.parameter("Y", 0.000e-6)

emc2.insert_child(p2)

p3 = Neurospaces.ContourPoint('e1_2')

p3.parameter("X", 1.000e-6)
p3.parameter("Y", 1.000e-6)

emc2.insert_child(p3)

p4 = Neurospaces.ContourPoint('e1_3')

p4.parameter("X", 0.000e-6)
p4.parameter("Y", 1.000e-6)

emc2.insert_child(p4)

nmc.query("expand /**")

