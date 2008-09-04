#!/usr/bin/python

import Heccer

# import SwiggableNeurospaces

schedulees = []

our_dt = 1e-5

class Output:
    def __init__(self, filename):
        self.backend = Heccer.Output(filename)

    def AddOutput(self, nmc, component, field):
        global schedulees
#         context = SwiggableNeurospaces.PidinStackParse(component)
#         SwiggableNeurospaces.PidinStackLookupTopSymbol(context)
#         serial = SwiggableNeurospaces.PidinStackToSerial(context)
        address = schedulees[0].Address(serial, field)
        self.backend.AddOutput(component, address)

def compile():
    global schedulees
    for schedulee in schedulees:
        schedulee.compile()

def new(nmc, filename):
    heccer = Heccer.Heccer( { 'model_source': nmc, 'name': '/cell' } )
    global our_dt
    heccer.timestep(our_dt)
    global schedulees
    schedulees.append(heccer)
    schedulees.append(Heccer.Output(filename))

def output(serial, field):
    global schedulees
    address = schedulees[0].Address(serial, field)
    schedulees[1].AddOutput("output", address)

def run(time):
    global schedulees
    global our_dt
    simulation_time = 0.0
    while simulation_time < time:
        for schedulee in schedulees:
            schedulee.backend.advance(simulation_time)
        simulation_time += our_dt
