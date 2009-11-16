set env NEUROSPACES_NMC_MODELS = /local_home/local_home/hugo/neurospaces_project/model-container/source/snapshots/0/library
set env NEUROSPACES_NMC_PROJECT_MODELS = /local_home/local_home/hugo/EM/models
set env PYTHONPATH = ./glue/swig/python:/usr/local/glue/swig/python
cd ../../..
set args glue/swig/python/tests/neurospaces_test.py
file /usr/bin/python
break parsererror
echo .gdbinit: Done .gdbinit\n

