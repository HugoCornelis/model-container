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
	cp $(srcdir)/tests/*.pm $(distdir)/tests

perldir = $(prefix)/glue/swig/perl

nobase_perl_HEADERS = Neurospaces.pm Neurospaces/Query.pm Neurospaces/Traversal.pm

perl_DATA = $(srcdir)/neurospaces.i SwiggableNeurospaces.pm SwiggableNeurospaces.so # neurospaces_test.pm

BUILT_SOURCES = \
	SwiggableNeurospaces.pm \
	swiggable_neurospaces_wrap.c

SwiggableNeurospaces.pm swiggable_neurospaces_wrap.c: $(swig_DATA)
	swig -DPRE_PROTO_TRAVERSAL -I$(builddir)../../.. -I$(srcdir)/../../.. -perl5 -makedefault -module SwiggableNeurospaces -o swiggable_neurospaces_wrap.c $(srcdir)/neurospaces.i

swiggable_neurospaces_wrap.o: swiggable_neurospaces_wrap.c
	gcc -g -DPRE_PROTO_TRAVERSAL -I$(builddir)../../.. -I$(srcdir)/../../.. -I$(builddir)../../../hierarchy/output/symbols -I$(srcdir)/../../../hierarchy/output/symbols/ -c swiggable_neurospaces_wrap.c -fPIC `perl -MExtUtils::Embed -e ccopts`

#t this line needs -f PIC for some architectures, and -lncurses for some architectures

SwiggableNeurospaces.so: swiggable_neurospaces_wrap.o
	gcc -g -shared swiggable_neurospaces_wrap.o -L../../.. -lneurospacesread -L../../../algorithms/event -levent_algorithms -L../../../algorithms/symbol -lsymbol_algorithms -lncurses -lhistory -lreadline -fPIC -o SwiggableNeurospaces.so

all: SwiggableNeurospaces.so

CLEANFILES = \
	SwiggableNeurospaces.pm \
	swiggable_neurospaces_wrap.c \
	swiggable_neurospaces_wrap.o \
	SwiggableNeurospaces.so

## following http://www.geocities.com/foetsch/python/swig_linux.htm

#BUILT_SOURCES = $(srcdir)/neurospaces_wrap.c
#SWIG_SOURCES = neurospaces.i

## other sources
##
## http://sourceware.org/ml/automake/2001-03/msg00395.html
## http://autoconf-archive.cryp.to/macros-by-category.html
## http://sources.redhat.com/ml/automake/2005-02/msg00058.html
## https://www.desy.de/~salvaire/root_wrapper.html

