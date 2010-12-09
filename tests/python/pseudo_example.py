#-----------------------------------------------------------------------------
import ModelContainer

# user creates a model container to create a basic model.
nmc = ModelContainer(None)

neutral = nmc.CreateNeutral("/base")

print "neutral is %s" % neutral.GetName() # would print out "neutral is /base"

comp1 = nmc.CreateCompartment("/base/c1")

# We know what parameters a compartment needs to we have Get/Set methods for them.

comp1.SetCm(4.57537e-11)
comp1.SetEm(-0.08)
comp1.SetInitVm(-0.068)
comp1.SetRa(360502)
comp1.SetRm(3.58441e8)
comp1.SetInject(1e-8)

# The user also has a generic SetParameter method since the model container can set parameters of any type anywhere.

nmc.SetParameter(name="/base", parameter="Test", value=100)

#------------------------------------------------------------------
# At this point the user is done playing with the model, now they want to
# hook it up to a solver
#------------------------------------------------------------------

from Heccer import Heccer

# currently what it looks like
# heccer = Heccer( { 'model_source': nmc, 'name': "My Model" } )
# should probably enhance this so that a user can do something like

heccer = Heccer("My Simulation")

heccer.SetModelSource(nmc)   # set our model container otherwise there's nothing to solve
heccer.SetOutputFile("/tmp/out")

heccer.timestep(1e-5)

time = 100
simulation_time = 0.0

while simulation_time < time:

  heccer.advance(simulation_time)

heccer.finish()

# Then here someone can use something like dave's G3plot to plot the results.
#----------------------------------------------------------------------------- 
