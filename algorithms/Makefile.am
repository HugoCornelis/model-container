##
## Neurospaces: a library which implements a global typed symbol table to
## be used in neurobiological model maintenance and simulation.
##
## $Id: Makefile.am 1.6 Sun, 18 Feb 2007 15:53:33 -0600 hugo $
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

SUBDIRS = event symbol

noinst_LIBRARIES = libalgorithms.a


libalgorithms_a_DEPENDENCIES = event/libevent_algorithms.a symbol/libsymbol_algorithms.a

libalgorithms_a_SOURCES = main.c

libalgorithms_a_LIBADD = event/libevent_algorithms.a symbol/libsymbol_algorithms.a

