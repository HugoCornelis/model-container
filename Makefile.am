##
## Neurospaces: a library which implements a global typed symbol table to
## be used in neurobiological model maintenance and simulation.
##
## $Id: Makefile.am 1.185 Thu, 27 Dec 2007 15:58:18 -0600 hugo $
##

##############################################################################
##'
##' Neurospaces : testbed C implementation that integrates with genesis
##'
##' Copyright (C) 1999-2007 Hugo Cornelis
##'
##' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
##'
##' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################

SUBDIRS = algorithms convertors . glue/swig

#CC = g++
LEX_OUTPUT_ROOT = lex.parser
LFLAGS=-i -l -Pparser
YFLAGS=-dv -p parser
AM_CFLAGS=-g3 -fPIC -Wmissing-prototypes -Wmissing-declarations -include config.h -DPRE_PROTO_TRAVERSAL @PERL_CCOPTS@ -I$(top_builddir)
CFLAGS = -O0

pkglib_LIBRARIES = libneurospacesread.a

libneurospacesread_a_SOURCES = \
	algorithm.c \
	algorithmclass.c \
	algorithminstance.c \
	algorithmset.c \
	algorithmsymbol.c \
	analyzer.l \
	attachment.c \
	axonhillock.c \
	biocomp.c \
	biolevel.c \
	cachedconnection.c \
	cachedcoordinate.c \
	cachedparameter.c \
	cacheregistry.c \
	cell.c \
	channel.c \
	concentrationgatekinetic.c \
	hhgate.c \
	connection.c \
	connectionsymbol.c \
	connectioncache.c \
	coordinatecache.c \
	contourpoint.c \
	defsym.c \
	dependencyfile.c \
	description.tokens \
	emcontour.c \
	equation.c \
	fiber.c \
	function.c \
	gatekinetic.c \
	group.c \
	hines_listlist.c \
	idin.c \
	importedfile.c \
	inputoutput.c \
	iocontainer.c \
	iohier.c \
	iol.c \
	modelevent.c \
	namespace.c \
	network.c \
	neurospaces.c \
	orderedconnectioncache.c \
	parametercache.c \
	parameters.c \
	parcontainer.c \
	parser.additions \
	parser.decl \
	parser.rules \
	parser.y \
	parsersupport.c \
	pidinstack.c \
	pool.c \
	population.c \
	positionD3.c \
	projection.c \
	projectionquery.c \
	psymbolserialstack.c \
	psymbolstack.c \
	querymachine.c \
	randomvalue.c \
	root.c \
	segment.c \
	segmenter.c \
	solverinfo.c \
	symbols.c \
	symboltable.c \
	traversalinfo.c \
	traversablealgorithm.c \
	treespacetraversal.c \
	vector.c \
	vectorconnection.c \
	vectorconnectionsymbol.c \
	vectorcontour.c \
	vectorsegment.c \
	workload.c \
	xs_initialize.c

neurospacesmodeldir=$(prefix)/neurospaces/models
nobase_dist_neurospacesmodel_DATA=@MODEL_DESCRIPTION_FILES@ @MODEL_SWC_MORPHOLOGYFILES@ @MODEL_XML_FILES@ @MODEL_PROJECTIONCACHES@ @MODEL_GENESIS_MORPHOLOGYFILES@ @MODEL_GENESIS_TABFILES@ @MODEL_TEXFILES@ @MODEL_YAMLFILES@ @ALGORITHM_DATA@

neurospacestestdir=$(prefix)/neurospaces
nobase_dist_neurospacestest_DATA=@TEST_SPECIFICATION_FILES@

dist_lisp_DATA = \
	emacs/neurospaces-mode/neurospaces-mode.el \
	emacs/neurospaces-mode/neurospaces-langs.el \
	emacs/neurospaces-mode/neurospaces-files.el \
	emacs/neurospaces-mode/neurospaces-vars.el

RELEASE_MAJOR=`release-extract --major`
RELEASE_MINOR=`release-extract --minor`
RELEASE_MICRO=`release-extract --micro`

show-release-labels:
	echo "Release information (major-minor-micro): $(RELEASE_MAJOR)-$(RELEASE_MINOR)-$(RELEASE_MICRO)"

dist-keywords:
	release-expand neurospacesread $(RELEASE_MAJOR) $(RELEASE_MINOR) $(RELEASE_MICRO) $(RELEASE_MAJOR)-$(RELEASE_MINOR) hugo.cornelis@gmail.com --verbose
#	release-expand neurospacesread des 10 0 des-10 hugo.cornelis@gmail.com --verbose

# The file lexsupport.c is compiled as part of analyzer.l, but not as
# a plain source file.  It is needed in the distribution.
# Also the tests are copied overhere.
#
# The variable EXTRA_DIST could also be used here.

dist-hook: dist-keywords
	cd $(srcdir) && if test -n "`mtn ls changed `" ; then false ; else true ; fi
	find $(distdir) -name _Inline -exec chmod -R u+w \{\} \;
	$(RM) -fr `find $(distdir) -name _Inline`
	$(RM) -fr hierarchy/output
	cp $(srcdir)/neurospaces.prj $(distdir)
	cp $(srcdir)/abstract.txt $(distdir)
	cp $(srcdir)/license.txt $(distdir)
	cp $(srcdir)/lexsupport.c $(distdir)
	cp -a $(srcdir)/docs $(distdir)
	$(RM) -fr $(distdir)/docs/paper.*
	$(srcdir)/install-sh -d $(distdir)/tests
	$(srcdir)/install-sh -d $(distdir)/tests/html
	$(srcdir)/install-sh -d $(distdir)/tests/html/algorithms
	$(srcdir)/install-sh -d $(distdir)/tests/html/code
	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications
	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/algorithms
	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/code
	cp -dp $(srcdir)/tests/{neurospaces_harness,neurospaces_harness.ptkdb,command_extractor,command_extractor.ptkdb,tests_2_html,tests_2_html.ptkdb,tests.config} $(distdir)/tests
	cp -a $(srcdir)/tests.config $(distdir)
# get the logos right
	cp -a $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/ns-main-logo-dark2-notext-32x32.jpg
	cp -a $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/algorithms/ns-main-logo-dark2-notext-32x32.jpg
	cp -a $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/code/ns-main-logo-dark2-notext-32x32.jpg
	cp -a $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/specifications/ns-main-logo-dark2-notext-32x32.jpg
	cp -a $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/specifications/algorithms/ns-main-logo-dark2-notext-32x32.jpg
	cp -a $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/specifications/code/ns-main-logo-dark2-notext-32x32.jpg
	cp -a $(srcdir)/hierarchy $(distdir)
	rm -fr $(distdir)/hierarchy/output
# prcs diff -k neurospaces.prj `prcs 2>/dev/null execute --not ".*\(directory\|symlink\)" neurospaces.prj | grep -v "neurospaces\.prj" | grep -v "purkinjespine" `
# $Format: "	( cd $(distdir)/tests && chmod -R u+w . && ./tests_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd $(distdir)/tests && chmod -R u+w . && ./tests_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> neurospaces 0.1675 Thu, 27 Dec 2007 15:58:18 -0600 hugo<hr>' --introduction introduction.html )

#! this one breaks the distcheck, because automake makes dist dirs read-only
#	cd $(distdir)/tests && ./tests_2_html

#	find $(srcdir)/hierarchy -type f -regex '.*[^~]$$' -exec cp {} $(distdir) \;

bin_PROGRAMS = neurospacesparse

check_SCRIPTS = $(srcdir)/glue/swig/perl/tests/neurospaces_test.pm $(srcdir)/glue/swig/perl/tests/neurospaces_test_traversal.pm $(srcdir)/glue/swig/perl/tests/neurospaces_test_algorithm.pm $(srcdir)/glue/swig/perl/tests/neurospaces_test_neuromorpho.pm $(srcdir)/tests/neurospaces_harness

#EXTRA_DIST = `find hierarchy -type f -regex '.*[^~]$'` `find library -type f -regex '.*[^~]$'`

neurospacesparse_LDADD = -L. -lneurospacesread -L./algorithms/event -levent_algorithms -L./algorithms/symbol -lsymbol_algorithms @PERL_LDADD@

neurospacesparse_SOURCES = main.c

neurospacesparse_DEPENDENCIES = $(neurospacesparse_SOURCES) algorithms/libalgorithms.a libneurospacesread.a

#! extract non-archives from perl linkage options

neurospacesparse_LDFLAGS=-lm @PERL_LDFLAGS@
# neurospacesparse_LDFLAGS=-lm -lreadline -lhistory `perl -MExtUtils::Embed -e ldopts | perl -pe 's/(\s|^)[^-]\S+//g'`
# neurospacesparse_LDFLAGS=-lm -lreadline -lhistory algorithms/libalgorithms.a

nobase_include_HEADERS = \
	neurospaces/algorithm.h \
	neurospaces/algorithmclass.h \
	neurospaces/algorithminstance.h \
	neurospaces/algorithminstance_vtable.h \
	neurospaces/algorithmset.h \
	neurospaces/algorithmsymbol.h \
	neurospaces/attachment.h \
	neurospaces/axonhillock.h \
	neurospaces/biocomp.h \
	neurospaces/biolevel.h \
	neurospaces/cachedconnection.h \
	neurospaces/cachedcoordinate.h \
	neurospaces/cachedparameter.h \
	neurospaces/cacheregistry.h \
	neurospaces/cell.h \
	neurospaces/channel.h \
	neurospaces/concentrationgatekinetic.h \
	neurospaces/hhgate.h \
	neurospaces/connection.h \
	neurospaces/connectionsymbol.h \
	neurospaces/connectioncache.h \
	neurospaces/coordinatecache.h \
	neurospaces/contourpoint.h \
	neurospaces/defsym.h \
	neurospaces/dependencyfile.h \
	neurospaces/double.h \
	neurospaces/emcontour.h \
	neurospaces/equation.h \
	neurospaces/fiber.h \
	neurospaces/function.h \
	neurospaces/gatekinetic.h \
	neurospaces/genesis/olf/olf_defs.h \
	neurospaces/genesis/olf/olf_struct.h \
	neurospaces/genesis/sim/sim_struct.h \
	neurospaces/group.h \
	neurospaces/hines_list.h \
	neurospaces/hines_listlist.h \
	neurospaces/idin.h \
	neurospaces/importedfile.h \
	neurospaces/inputoutput.h \
	neurospaces/iocontainer.h \
	neurospaces/iohier.h \
	neurospaces/iol.h \
	neurospaces/lexsupport.h \
	neurospaces/modelevent.h \
	neurospaces/namespace.h \
	neurospaces/network.h \
	neurospaces/neurospaces.h \
	neurospaces/orderedconnectioncache.h \
	neurospaces/parametercache.h \
	neurospaces/parameters.h \
	neurospaces/parcontainer.h \
	neurospaces/parsersupport.h \
	neurospaces/pidinstack.h \
	neurospaces/pool.h \
	neurospaces/population.h \
	neurospaces/positionD3.h \
	neurospaces/projection.h \
	neurospaces/projectionquery.h \
	neurospaces/psymbolserialstack.h \
	neurospaces/psymbolstack.h \
	neurospaces/querymachine.h \
	neurospaces/randomvalue.h \
	neurospaces/root.h \
	neurospaces/segment.h \
	neurospaces/segmenter.h \
	neurospaces/solverinfo.h \
	neurospaces/solvermapper.h \
	neurospaces/traversablealgorithm.h \
	neurospaces/treespacetraversal.h \
	neurospaces/symbols.h \
	neurospaces/symboltable.h \
	neurospaces/symbolvirtual_protos.h \
	neurospaces/traversalinfo.h \
	neurospaces/vector.h \
	neurospaces/vectorconnection.h \
	neurospaces/vectorconnectionsymbol.h \
	neurospaces/vectorcontour.h \
	neurospaces/vectorsegment.h \
	neurospaces/vtable.h \
	neurospaces/workload.h

BUILT_SOURCES = \
	hierarchy/output/algorithm_instances/.sentinel \
	hierarchy/output/algorithmclasses/.sentinel \
	hierarchy/output/symbols/.sentinel \
	parser.c \
	parser.h \
	parser.y \
	xs_initialize.c

CLEANFILES = \
	hierarchy/output/algorithm_instances/.sentinel \
	hierarchy/output/algorithmclasses/.sentinel \
	hierarchy/output/symbols/.sentinel \
	analyzer.c \
	parser.c \
	parser.h \
	parser.output \
	parser.rules.numbered \
	parser.y \
	xs_initialize.c

#! things below are obsoleted, but left here as a memo of how to do this kind of thing.

# clean-local : make sure that all directories, including the ones
# from previous dist builds are writable, such that we can remove
# _Inline directories from previous builds.

clean-local:
	find $(srcdir) -type d -exec chmod -R u+w \{\} \;
	$(RM) -fr `find $(srcdir) -name _Inline`
	$(RM) -fr $(srcdir)/hierarchy/output

TESTS = $(srcdir)/tests/neurospaces_harness

hierarchy/output/symbols/.sentinel: $(srcdir)/hierarchy/symbols $(srcdir)/hierarchy/instrumentor config.h
	$(srcdir)/hierarchy/instrumentor --null-checks $(srcdir)/hierarchy/symbols --output hierarchy/output

hierarchy/output/algorithm_instances/.sentinel: $(srcdir)/hierarchy/algorithminstances $(srcdir)/hierarchy/instrumentor config.h
	$(srcdir)/hierarchy/instrumentor --null-checks $(srcdir)/hierarchy/algorithminstances --output hierarchy/output

hierarchy/output/algorithmclasses/.sentinel: $(srcdir)/hierarchy/algorithmclasses $(srcdir)/hierarchy/instrumentor config.h
	$(srcdir)/hierarchy/instrumentor --null-checks $(srcdir)/hierarchy/algorithmclasses --output hierarchy/output

instrumentordir = $(prefix)/neurospaces/instrumentor
nobase_instrumentor_DATA = $(shell find $(srcdir)/hierarchy -type f)

parser.y: $(srcdir)/parser.decl $(srcdir)/description.tokens parser.rules.numbered $(srcdir)/parser.additions
	cat >parser.y $(srcdir)/parser.decl $(srcdir)/description.tokens parser.rules.numbered $(srcdir)/parser.additions
parser.rules.numbered: $(srcdir)/parser.rules
	perl -ne 'BEGIN { $$filename = shift @ARGV ; $$line++ } $$line++ ; s/^#line.*/#line $$line "$$filename"/; print' <$(srcdir)/parser.rules >parser.rules.numbered $(srcdir)/parser.rules
analyzer.o: parser.h
parser.c: parser.y
parser.h: parser.y
xs_initialize.c:
	perl -MExtUtils::Embed -e xsinit -- -o - >xs_initialize.c

test: check

html-upload-prepare:
	rm -fr html/htdocs/neurospaces_project/neurospaces
	mkdir --parents html/htdocs/neurospaces_project/neurospaces
# $Format: "	( cd tests && ./tests_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd tests && ./tests_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> neurospaces 0.1675 Thu, 27 Dec 2007 15:58:18 -0600 hugo<hr>' --introduction introduction.html )
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/neurospaces && tar vxf - )
	hierarchy/types_2_html >html/htdocs/neurospaces_project/neurospaces/algorithminstances.html hierarchy/algorithminstances
	hierarchy/types_2_html >html/htdocs/neurospaces_project/neurospaces/symbols.html hierarchy/symbols

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis@shell.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/

internal-library:
# $Format: "	tar cfz library-${package}-${label}.tar.gz library/"$
	tar cfz library-neurospacesread-des-10.tar.gz library/

libneurospacesread.so: libneurospacesread.a
	$(CC) \
	-shared \
	-fPIC \
	`find algorithms -name "*.o" ` \
	algorithm.o \
	algorithmclass.o \
	algorithminstance.o \
	algorithmset.o \
	algorithmsymbol.o \
	analyzer.o \
	attachment.o \
	axonhillock.o \
	biocomp.o \
	biolevel.o \
	cachedconnection.o \
	cachedcoordinate.o \
	cachedparameter.o \
	cacheregistry.o \
	cell.o \
	channel.o \
	concentrationgatekinetic.o \
	hhgate.o \
	connection.o \
	connectionsymbol.o \
	connectioncache.o \
	defsym.o \
	dependencyfile.o \
	equation.o \
	fiber.o \
	function.o \
	gatekinetic.o \
	group.o \
	hines_listlist.o \
	idin.o \
	importedfile.o \
	inputoutput.o \
	iocontainer.o \
	iohier.o \
	iol.o \
	modelevent.o \
	namespace.o \
	network.o \
	neurospaces.o \
	orderedconnectioncache.o \
	parametercache.o \
	parameters.o \
	parcontainer.o \
	parser.o \
	parsersupport.o \
	pidinstack.o \
	pool.o \
	population.o \
	positionD3.o \
	projection.o \
	projectionquery.o \
	psymbolserialstack.o \
	psymbolstack.o \
	querymachine.o \
	randomvalue.o \
	root.o \
	segment.o \
	segmenter.o \
	solverinfo.o \
	symbols.o \
	symboltable.o \
	traversalinfo.o \
	traversablealgorithm.o \
	treespacetraversal.o \
	vector.o \
	vectorconnection.o \
	vectorconnectionsymbol.o \
	vectorcontour.o \
	vectorsegment.o \
	workload.o \
	xs_initialize.o \
	-o libneurospacesread.so

#perldir = $(prefix)/glue/swig/perl

#nobase_perl_DATA = @PERL_EMBED_DATA@

