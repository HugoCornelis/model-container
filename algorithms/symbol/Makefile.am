##
## Neurospaces: a library which implements a global typed symbol table to
## be used in neurobiological model maintenance and simulation.
##
## $Id: Makefile.am 1.26 Sun, 24 Jun 2007 21:50:17 -0500 hugo $
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

#t check what i386 etc do overhere.

AM_CFLAGS=-g3 -fPIC -Wmissing-prototypes -Wmissing-declarations -I$(srcdir)/../.. -DPRE_PROTO_TRAVERSAL @PERL_CCOPTS@ -I$(builddir)../..
#CFLAGS = -O0

pkglib_LIBRARIES = libsymbol_algorithms.a

libsymbol_algorithms_a_SOURCES = \
	connectionchecker.c \
	connectioncheckerinstance.c \
	connectionworkerinstance.c \
	contextworkerinstance.c \
	dendrogram.c \
	dendrograminstance.c \
	grid3d.c \
	grid3dinstance.c \
	inserter.c \
	inserterinstance.c \
	projectionvolume.c \
	projectionvolumeinstance.c \
	projectionrandomized.c \
	projectionrandomizedinstance.c \
	randomize.c \
	randomizeinstance.c \
	replacer.c \
	replacerinstance.c \
	spines.c \
	spinesinstance.c

pkginclude_HEADERS = \
	connectionchecker.h \
	connectioncheckerinstance.h \
	connectionworkerinstance.h \
	contextworkerinstance.h \
	dendrogram.h \
	dendrograminstance.h \
	grid3d.h \
	grid3dinstance.h \
	inserter.h \
	inserterinstance.h \
	projectionvolume.h \
	projectionvolumeinstance.h \
	projectionrandomized.h \
	projectionrandomizedinstance.h \
	randomize.h \
	randomizeinstance.h \
	replacer.h \
	replacerinstance.h \
	spines.h \
	spinesinstance.h
