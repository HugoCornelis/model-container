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


SUBDIRS = 

dist-hook:
	$(INSTALL) -d $(distdir)/tests
	cp $(srcdir)/tests/*.py $(distdir)/tests

pythondir = $(prefix)/glue/swig/python/g3

nobase_python_HEADERS = \
	nmc/__cbi__.py \
	nmc/__init__.py \
	nmc/errors.py

python_DATA = \
	nmc/nmc_base.py \
	nmc/_nmc_base.so

EXTRA_DIST = \
	$(srcdir)/nmc.i 

BUILT_SOURCES = \
	$(srcdir)/nmc_wrap.c \
	$(srcdir)/nmc/nmc_base.py 


#---------------------------------------------------------
#----------- Rules for building the nmc swig binding -----

nmc_wrap.o: nmc_wrap.c
	gcc $(SWIGCOMPILELINKSFORPYTHON) -c $(srcdir)/nmc_wrap.c

nmc_wrap.c ./nmc/nmc_base.py: 
	$(SWIG) -DPRE_PROTO_TRAVERSAL -I$(top_builddir) -python -outdir $(srcdir)/nmc -o nmc_wrap.c $(srcdir)/nmc.i

_nmc_base.so: nmc_wrap.o
	$(NMC_SWIGLINKCOMMAND_PYTHON)

#--------------------- End rules for nmc swig ------------
#---------------------------------------------------------


all: _nmc_base.so

CLEANFILES = \
	$(srcdir)/nmc_wrap.c \
	$(srcdir)/nmc_wrap.o \
	$(srcdir)/nmc/_nmc_base.so \
	$(srcdir)/nmc/nmc_base.py 


