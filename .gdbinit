set env NEUROSPACES_NMC_MODELS = /local_home/local_home/hugo/neurospaces_project/model-container/source/c/snapshots/0/library
set env NEUROSPACES_NMC_PROJECT_MODELS = /local_home/local_home/hugo/EM/models
set args -q networks/network.ndf
file ./neurospacesparse
break parsererror
echo .gdbinit: Done .gdbinit\n
