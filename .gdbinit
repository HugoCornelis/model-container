set env NEUROSPACES_NMC_MODELS = /local_home/hugo/neurospaces_project/model-container/source/snapshots/0/library
set env NEUROSPACES_NMC_PROJECT_MODELS = /local_home/hugo/EM/models
set args -q cells/purkinje/edsjb1994.ndf
set args -q tests/networks/spiker3.ndf
file ./neurospacesparse
break parsererror
echo .gdbinit: Done .gdbinit\n

# set args
# file ./neurospacesparse
# directory ~/neurospaces_project/model-container/ 
# directory ~/neurospaces_project/model-container/neurospaces/
# directory ~/neurospaces_project/model-container/hierarchy/output/symbols/
# directory ~/neurospaces_project/heccer/
# directory ~/neurospaces_project/heccer/integrators/
# directory ~/neurospaces_project/heccer/integrators/heccer/
# directory ~/neurospaces_project/heccer/integrators/heccer/neurospaces/
# echo .gdbinit: Done .gdbinit in neurospacesparse dir\n
# set print pretty
