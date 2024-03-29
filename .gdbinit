set env NEUROSPACES_NMC_MODELS = /home/hugo/projects/model-container/source/snapshots/master/library
set env NEUROSPACES_NMC_PROJECT_MODELS = /home/cornelis/EM/models
set args -q cells/purkinje/edsjb1994.ndf
set args -q tests/networks/spiker4.ndf
set args -q cells/RScell-nolib.ndf
set args -q legacy/networks/network.ndf
set args -q networks/RSNet-2x2.ndf
set args -q -v 1 cells/purkinje/edsjb1994.ndf
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
