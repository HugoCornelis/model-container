##
## Neurospaces: a library which implements a global typed symbol table to
## be used in neurobiological model maintenance and simulation.
##
## $Id: Makefile.am 1.24 Mon, 11 Jun 2007 12:53:18 -0500 hugo $
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

AM_CFLAGS=-fdiagnostics-color=never -g3 -fPIC -Wmissing-prototypes -Wmissing-declarations -I$(srcdir)/../.. -DPRE_PROTO_TRAVERSAL @PERL_CCOPTS@ -I$(builddir)../..

noinst_LIBRARIES = libevent_algorithms.a

#! note : does not include purkinje spine, that was coded with the
#! obsoleted API.

libevent_algorithms_a_SOURCES = cerebellum.c serialcell.c serialsegment.c serialconnection.c serialnetwork.c serialpopulation.c serialprojection.c

noinst_HEADERS = cerebellum.h serialcell.h serialsegment.h serialconnection.h serializers.h serialnetwork.h serialpopulation.h serialprojection.h
