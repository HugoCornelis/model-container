##
## Neurospaces: a library which implements a global typed symbol table to
## be used in neurobiological model maintenance and simulation.
##
## $Id: Makefile.am 1.1 Wed, 26 Sep 2007 13:50:02 -0500 hugo $
##

##############################################################################
##'
##' Neurospaces : testbed C implementation that integrates with genesis
##'
##' Copyright (C) 1999-2008 Hugo Cornelis
##'
##' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
##'
##' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################


EXTRA_DIST = \
	clean.py \
	setup.py \
	uninstall.py 

SUBDIRS = 

setup: setup.py
	$(PYTHON) setup.py build
	$(PYTHON) setup.py build_py

install-exec-hook:
	$(PYTHON) setup.py install

uninstall-hook:
	$(PYTHON) uninstall.py

all: setup

clean-local:
	$(RM) `find . -name "*.pyc"`
	$(PYTHON) clean.py

CLEANFILES = \
	$(srcdir)/model_container_wrap.c \
	$(srcdir)/model_container_wrap.o \
	$(srcdir)/model_container/_model_container_base.so \
	$(srcdir)/model_container/model_container_base.py \
	$(srcdir)/model_container_base.py 



#dist-hook:
#	$(INSTALL) -d $(distdir)/tests
#	cp $(srcdir)/tests/*.py $(distdir)/tests

# The neurospaces/model_container module is installed under the g3 module from the developer
# package. Since it comes first in the user workflow, it should 
# be installed first.
# pythondir = $(prefix)/glue/swig/python/

# nobase_python_HEADERS = \
# 	neurospaces/model_container/__cbi__.py \
# 	neurospaces/model_container/__init__.py \
# 	neurospaces/model_container/errors.py \
# 	neurospaces/model_container/symbols.py

# nobase_python_DATA = \
# 	neurospaces/model_container/model_container_base.py \
# 	neurospaces/model_container/_model_container_base.so

# EXTRA_DIST = \
# 	$(srcdir)/model_container.i \
# 	$(srcdir)/traversal.i

# BUILT_SOURCES = \
# 	$(srcdir)/model_container_wrap.c \
# 	$(srcdir)/neurospaces/model_container/model_container_base.py 


# #---------------------------------------------------------
# #----------- Rules for building the neurospaces/model_container swig binding -----

# model_container_wrap.o: model_container_wrap.c
# 	gcc $(SWIGCOMPILELINKSFORPYTHON) -c $(srcdir)/model_container_wrap.c

# model_container_wrap.c ./neurospaces/model_container/model_container_base.py: 
# 	$(SWIG) -DPRE_PROTO_TRAVERSAL -I$(top_builddir) -python -outdir $(srcdir)/neurospaces/model_container -o model_container_wrap.c $(srcdir)/model_container.i

# neurospaces/model_container/_model_container_base.so: model_container_wrap.o
# 	$(MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON)

# #--------------------- End rules for neurospaces/model_container swig ------------
# #---------------------------------------------------------


# all: neurospaces/model_container/_model_container_base.so


# clean-local:
# 	$(RM) -rf $(srcdir)/docs/html
# 	echo "Removing all compiled byte code files"
# 	$(RM) `find . -name "*.pyc"`
# 	$(RM) -rf $(srcdir)/build
# 	$(RM) -rf $(srcdir)/dist/


