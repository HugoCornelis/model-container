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


#t the following rules are crap complete, would be good if a auto
#t expert takes a look at it.

dist-hook:
	$(INSTALL) -d $(distdir)/tests
	cp $(srcdir)/tests/*.py $(distdir)/tests

pythondir = $(prefix)/glue/swig/python

nobase_python_HEADERS = Neurospaces/__init__.py Neurospaces/SingleCellContainer.py Neurospaces/SimpleHeccer.py 

python_DATA = SwiggableNeurospaces.py _SwiggableNeurospaces.$(PYTHONLIB_EXTENSION) tests/neurospaces_test.py  

BUILT_SOURCES = \
	SwiggableNeurospaces.py \
	swiggable_neurospaces_wrap.c

SwiggableNeurospaces.py swiggable_neurospaces_wrap.c: $(swig_DATA)
	$(SWIG) -DPRE_PROTO_TRAVERSAL -I$(builddir)../../.. -I$(srcdir)/../../.. -python -makedefault -module SwiggableNeurospaces -o swiggable_neurospaces_wrap.c $(srcdir)/neurospaces.i

swiggable_neurospaces_wrap.o: swiggable_neurospaces_wrap.c
	$(SWIGCOMPILECOMMAND_PYTHON)

#t this line needs -f PIC for some architectures, and -lncurses for some architectures

_SwiggableNeurospaces.$(PYTHONLIB_EXTENSION): swiggable_neurospaces_wrap.o
	$(SWIGLINKCOMMAND_PYTHON)


all: _SwiggableNeurospaces.$(PYTHONLIB_EXTENSION) 

CLEANFILES = \
	$(srcdir)/SwiggableNeurospaces.py \
	$(srcdir)/swiggable_neurospaces_wrap.c \
	$(srcdir)/swiggable_neurospaces_wrap.o \
	$(srcdir)/_SwiggableNeurospaces.$(PYTHONLIB_EXTENSION)


