cd ../..
set env NEUROSPACES_NMC_MODELS = /home/hugo/neurospaces_project/model-container/source/snapshots/0/library
set env NEUROSPACES_NMC_PROJECT_MODELS = /home/cornelis/EM/models
set args -q cells/purkinje/edsjb1994.ndf
set args -q tests/networks/spiker4.ndf
set args -q cells/RScell-nolib.ndf
set args -q legacy/networks/network.ndf
set args -q networks/RSNet-2x2.ndf
set args tests/python/createprojection_2.py
file /usr/bin/python
# break parsererror
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
