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
	cp $(srcdir)/neurospaces.i $(distdir)
	$(INSTALL) -d $(distdir)/tests
	cp $(srcdir)/tests/*.py $(distdir)/tests

pythondir = $(prefix)/glue/swig/python

nobase_python_HEADERS = Neurospaces/__init__.py Neurospaces/SimpleModelContainer.py Neurospaces/SimpleHeccer.py

python_DATA = $(srcdir)/neurospaces.i SwiggableNeurospaces.py _SwiggableNeurospaces.so tests/neurospaces_test.py

BUILT_SOURCES = \
	SwiggableNeurospaces.py \
	swiggable_neurospaces_wrap.c

SwiggableNeurospaces.py swiggable_neurospaces_wrap.c: $(swig_DATA)
	swig -DPRE_PROTO_TRAVERSAL -I$(builddir)../../.. -I$(srcdir)/../../.. -python -makedefault -module SwiggableNeurospaces -o swiggable_neurospaces_wrap.c $(srcdir)/neurospaces.i

swiggable_neurospaces_wrap.o: swiggable_neurospaces_wrap.c
	gcc -g -DPRE_PROTO_TRAVERSAL -I/usr/include/python2.4 -I$(builddir)../../.. -I$(srcdir)/../../.. -I$(builddir)../../../hierarchy/output/symbols -I$(srcdir)/../../../hierarchy/output/symbols/ -c swiggable_neurospaces_wrap.c -fPIC -Xlinker -export-dynamic

#t this line needs -f PIC for some architectures, and -lncurses for some architectures

_SwiggableNeurospaces.so: swiggable_neurospaces_wrap.o
	gcc -g -shared swiggable_neurospaces_wrap.o -L../../.. -lneurospacesread -L../../../algorithms/event -levent_algorithms -L../../../algorithms/symbol -lsymbol_algorithms -lncurses -lhistory -lreadline -fPIC -o _SwiggableNeurospaces.so -Xlinker -export-dynamic

all: _SwiggableNeurospaces.so

CLEANFILES = \
	SwiggableNeurospaces.py \
	swiggable_neurospaces_wrap.c \
	swiggable_neurospaces_wrap.o \
	_SwiggableNeurospaces.so


