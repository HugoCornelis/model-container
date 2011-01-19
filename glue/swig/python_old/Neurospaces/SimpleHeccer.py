#!/usr/bin/python

import Heccer
import SwiggableExperiment 


# import SwiggableNeurospaces

schedulees = []

our_dt = 1e-5

def compile():
    global schedulees
    for schedulee in schedulees:
        schedulee.compile()

def new(nmc, modelname, filename):
    heccer = Heccer.Heccer( { 'model_source': nmc, 'name': modelname } )
    global our_dt
    heccer.timestep(our_dt)
    global schedulees
    schedulees.append(heccer)
    schedulees.append(SwiggableExperiment.Output(filename))

def output(serial, field):
    global schedulees
    address = schedulees[0].Address(serial, field)
    if address == None:
        raise Heccer.AddressError("Cannot find the address of " + str(serial) + " -> " + field)
    schedulees[1].AddOutput("output", address)

def run(time):
    global schedulees
    global our_dt
    simulation_time = 0.0
    while simulation_time < time:
        for schedulee in schedulees:
            simulation_time += our_dt
            schedulee.advance(simulation_time)
    schedulee.finish()
