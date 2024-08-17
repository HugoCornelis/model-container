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
##' Copyright (C) 1999-2008 Hugo Cornelis
##'
##' functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
##'
##' coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################

SUBDIRS = algorithms . glue/swig convertors


#add glue/swig convertors subdirs back after this works.

dist_bin_SCRIPTS = bin/model-container

#CC = g++
LEX_OUTPUT_ROOT = lex.parser
AM_LFLAGS=-i -l -Pparser
# LFLAGS=-i -l -Pparser

# note: automake does not recognize clustering on these options, -d -v is not equivalent to -dv
AM_YFLAGS=-d -v
YFLAGS=-p parser
# YACC=bison
AM_CFLAGS=-fdiagnostics-color=never -g3 -fPIC -Wmissing-prototypes -Wmissing-declarations -Wno-declaration-after-statement -include neurospaces/config.h -DPRE_PROTO_TRAVERSAL -I$(top_builddir) @PERL_CCOPTS@

pkglib_LIBRARIES = libneurospacesread.a

libneurospacesread_a_SOURCES = \
	algorithm.c \
	algorithmclass.c \
	algorithminstance.c \
	algorithmset.c \
	analyzer.l \
	biolevel.c \
	cachedconnection.c \
	cachedcoordinate.c \
	cachedparameter.c \
	cacheregistry.c \
	components/algorithmsymbol.c \
	components/attachment.c \
	components/axonhillock.c \
	components/biocomp.c \
	components/cell.c \
	components/channel.c \
	components/commentsimple.c \
	components/concentrationgatekinetic.c \
	components/connection.c \
	components/connectionsymbol.c \
	components/equationexponential.c \
	components/fiber.c \
	components/gatekinetic.c \
	components/group.c \
	components/groupedparameters.c \
	components/hhgate.c \
	components/iohier.c \
	components/iol.c \
	components/izhikevich.c \
	components/membraneleak.c \
	components/network.c \
	components/pool.c \
	components/population.c \
	components/projection.c \
	components/pulsegen.c \
	components/randomvalue.c \
	components/root.c \
	components/segment.c \
	components/segmenter.c \
	components/vector.c \
	components/vectorconnection.c \
	components/vectorconnectionsymbol.c \
	components/vectorsegment.c \
	connectioncache.c \
	coordinatecache.c \
	defsym.c \
	dependencyfile.c \
	exporter.c \
	function.c \
	hines_listlist.c \
	idin.c \
	importedfile.c \
	inputoutput.c \
	iocontainer.c \
	modelevent.c \
	namespace.c \
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
	positionD3.c \
	projectionquery.c \
	psymbolserialstack.c \
	psymbolstack.c \
	querymachine1.c \
	querymachine2a.c \
	querymachine2b.c \
	querymachine2c.c \
	querymachine3.c \
	querymachine4.c \
	querymachine5.c \
	querymachine6.c \
	querymachine7.c \
	querymachine8.c \
	querymachine9.c \
	querymachine10.c \
	selecttraversal.c \
	solverinfo.c \
	symbols.c \
	symboltable.c \
	traversablealgorithm.c \
	traversalinfo.c \
	treespacetraversal.c \
	workload.c \
	xs_initialize.c

#	components/contourpoint.c
#	components/emcontour.c
#	components/vectorcontour.c

neurospacesmodeldir=$(prefix)/neurospaces/models
nobase_dist_neurospacesmodel_DATA=@MODEL_DESCRIPTION_FILES@ @MODEL_SWC_MORPHOLOGYFILES@ @MODEL_XML_FILES@ @MODEL_NPY_FILES@ @MODEL_NPL_FILES@ @MODEL_PROJECTIONCACHES@ @MODEL_GENESIS_MORPHOLOGYFILES@ @MODEL_GENESIS_TABFILES@ @MODEL_TEXFILES@ @MODEL_YAMLFILES@ @ALGORITHM_DATA@

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
	release-expand model-container $(RELEASE_MAJOR) $(RELEASE_MINOR) $(RELEASE_MICRO) $(RELEASE_MAJOR).$(RELEASE_MINOR) hugo.cornelis@gmail.com --verbose
#	release-expand neurospacesread des 10 0 des-10 hugo.cornelis@gmail.com --verbose

# The file lexsupport.c is compiled as part of analyzer.l, but not as
# a plain source file.  It is needed in the distribution.
# Also the tests are copied overhere.
#
# The variable EXTRA_DIST could also be used here.

EXTRA_DIST = \
	doxygen.cfg 


am__tar = ${AMTAR} chf - --format=posix "$$tardir"

dist-hook:
	if test -n "$$NEUROSPACES_RELEASE" ; then cd $(srcdir) && if test -n "`mtn ls changed `" ; then false ; else true ; fi ; else true ; fi
	$(RM) -fr hierarchy/output
	cp $(srcdir)/neurospaces.prj $(distdir)
	cp $(srcdir)/abstract.txt $(distdir)
	cp $(srcdir)/license.txt $(distdir)
	cp $(srcdir)/lexsupport.c $(distdir)
	cp -pR $(srcdir)/docs $(distdir)
	rm -rf $(distdir)/docs/html
	rm -rf $(distdir)/docs/latex
	rm -rf $(distdir)/docs/man
	rm -rf $(distdir)/docs/html
	rm -rf $(distdir)/docs/rtf
	$(RM) -fr $(distdir)/docs/paper.*
	$(srcdir)/install-sh -d $(distdir)/tests
	$(srcdir)/install-sh -d $(distdir)/tests/html
	$(srcdir)/install-sh -d $(distdir)/tests/html/algorithms
	$(srcdir)/install-sh -d $(distdir)/tests/html/code
	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications
	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/algorithms
	$(srcdir)/install-sh -d $(distdir)/tests/html/specifications/code
	cp -pR $(srcdir)/tests/command_extractor $(distdir)/tests
	cp -pR $(srcdir)/tests/command_extractor.ptkdb $(distdir)/tests
	cp -pR $(srcdir)/tests/tests.config $(distdir)/tests
	cp -pR $(srcdir)/tests.config $(distdir)
# get the logos right
	cp -pR $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/ns-main-logo-dark2-notext-32x32.jpg
	cp -pR $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/algorithms/ns-main-logo-dark2-notext-32x32.jpg
	cp -pR $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/code/ns-main-logo-dark2-notext-32x32.jpg
	cp -pR $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/specifications/ns-main-logo-dark2-notext-32x32.jpg
	cp -pR $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/specifications/algorithms/ns-main-logo-dark2-notext-32x32.jpg
	cp -pR $(srcdir)/docs/logos/ns-main-logo-dark2-notext-32x32.jpg $(distdir)/tests/html/specifications/code/ns-main-logo-dark2-notext-32x32.jpg
	cp -pR $(srcdir)/hierarchy $(distdir)
	rm -fr $(distdir)/hierarchy/output
# prcs diff -k neurospaces.prj `prcs 2>/dev/null execute --not ".*\(directory\|symlink\)" neurospaces.prj | grep -v "neurospaces\.prj" | grep -v "purkinjespine" `
# $Format: "	( cd $(distdir)/tests && chmod -R u+w . && neurospaces_harness_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd $(distdir)/tests && chmod -R u+w . && neurospaces_harness_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> neurospaces 0.1675 Thu, 27 Dec 2007 15:58:18 -0600 hugo<hr>' --introduction introduction.html )

#! this one breaks the distcheck, because automake makes dist dirs read-only
#	cd $(distdir)/tests && neurospaces_harness_2_html

#	find $(srcdir)/hierarchy -type f -regex '.*[^~]$$' -exec cp {} $(distdir) \;

bin_PROGRAMS = neurospacesparse

check_SCRIPTS = $(srcdir)/glue/swig/perl/tests/neurospaces_test.pm $(srcdir)/glue/swig/perl/tests/neurospaces_test_traversal.pm $(srcdir)/glue/swig/perl/tests/neurospaces_test_algorithm.pm $(srcdir)/glue/swig/perl/tests/neurospaces_test_neuromorpho.pm

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
	neurospaces/biolevel.h \
	neurospaces/cachedconnection.h \
	neurospaces/cachedcoordinate.h \
	neurospaces/cachedparameter.h \
	neurospaces/cacheregistry.h \
	neurospaces/components/algorithmsymbol.h \
	neurospaces/components/attachment.h \
	neurospaces/components/axonhillock.h \
	neurospaces/components/biocomp.h \
	neurospaces/components/cell.h \
	neurospaces/components/channel.h \
	neurospaces/components/commentsimple.h \
	neurospaces/components/concentrationgatekinetic.h \
	neurospaces/components/connection.h \
	neurospaces/components/connectionsymbol.h \
	neurospaces/components/equationexponential.h \
	neurospaces/components/fiber.h \
	neurospaces/components/gatekinetic.h \
	neurospaces/components/group.h \
	neurospaces/components/groupedparameters.h \
	neurospaces/components/hhgate.h \
	neurospaces/components/iohier.h \
	neurospaces/components/iol.h \
	neurospaces/components/izhikevich.h \
	neurospaces/components/membraneleak.h \
	neurospaces/components/network.h \
	neurospaces/components/pool.h \
	neurospaces/components/population.h \
	neurospaces/components/projection.h \
	neurospaces/components/pulsegen.h \
	neurospaces/components/randomvalue.h \
	neurospaces/components/root.h \
	neurospaces/components/segment.h \
	neurospaces/components/segmenter.h \
	neurospaces/components/vector.h \
	neurospaces/components/vectorconnection.h \
	neurospaces/components/vectorconnectionsymbol.h \
	neurospaces/components/vectorsegment.h \
	neurospaces/config.h \
	neurospaces/connectioncache.h \
	neurospaces/coordinatecache.h \
	neurospaces/defsym.h \
	neurospaces/dependencyfile.h \
	neurospaces/exporter.h \
	neurospaces/function.h \
	neurospaces/genesis/olf/olf_defs.h \
	neurospaces/genesis/olf/olf_struct.h \
	neurospaces/genesis/sim/sim_struct.h \
	neurospaces/hines_list.h \
	neurospaces/hines_listlist.h \
	neurospaces/idin.h \
	neurospaces/importedfile.h \
	neurospaces/inputoutput.h \
	neurospaces/iocontainer.h \
	neurospaces/lexsupport.h \
	neurospaces/modelevent.h \
	neurospaces/namespace.h \
	neurospaces/neurospaces.h \
	neurospaces/orderedconnectioncache.h \
	neurospaces/parametercache.h \
	neurospaces/parameters.h \
	neurospaces/parcontainer.h \
	neurospaces/parsersupport.h \
	neurospaces/pidinstack.h \
	neurospaces/positionD3.h \
	neurospaces/projectionquery.h \
	neurospaces/psymbolserialstack.h \
	neurospaces/psymbolstack.h \
	neurospaces/querymachine.h \
	neurospaces/solverinfo.h \
	neurospaces/solvermapper.h \
	neurospaces/symbols.h \
	neurospaces/symboltable.h \
	neurospaces/symbolvirtual_protos.h \
	neurospaces/traversablealgorithm.h \
	neurospaces/traversalinfo.h \
	neurospaces/treespacetraversal.h \
	neurospaces/vtable.h \
	neurospaces/workload.h

#	neurospaces/components/contourpoint.h
#	neurospaces/components/emcontour.h
#	neurospaces/components/vectorcontour.h

BUILT_SOURCES = \
	hierarchy/output/algorithm_instances/.sentinel \
	hierarchy/output/algorithmclasses/.sentinel \
	hierarchy/output/symbols/.sentinel \
	parser.c \
	parser.h \
	parser.y \
	xs_initialize.c

CLEANFILES = \
	analyzer.c \
	analyzer.l \
	docs/doxygen.tag \
	hierarchy/output/algorithm_instances/.sentinel \
	hierarchy/output/algorithmclasses/.sentinel \
	hierarchy/output/symbols/.sentinel \
	parser.c \
	parser.h \
	parser.output \
	parser.rules \
	parser.rules.numbered \
	parser.y \
	xs_initialize.c

#! things below are obsoleted, but left here as a memo of how to do this kind of thing.

# clean-local : make sure that all directories, including the ones
# from previous dist builds are writable, such that we can remove
# _Inline directories from previous builds.

clean-local:
	find $(srcdir) -type d -exec chmod -R u+w \{\} \;
	$(RM) -fr $(srcdir)/hierarchy/output
	$(RM) -rf $(top_srcdir)/docs/html
	$(RM) -rf $(top_srcdir)/docs/model-container
	$(RM) -rf $(top_srcdir)/*.deb
	$(RM) -f $(top_srcdir)/*.changes
	$(RM) -f $(top_srcdir)/*.dsc
	$(RM) -rf $(top_srcdir)/*_BUILD
	$(RM) -f $(top_srcdir)/build_*.log
	$(RM) $(top_srcdir)/model-container*.tar.gz
	$(RM) -rf $(top_srcdir)/model-container-*

hierarchy/output/symbols/.sentinel: $(srcdir)/hierarchy/symbols $(srcdir)/hierarchy/instrumentor neurospaces/config.h
	$(srcdir)/hierarchy/instrumentor --null-checks $(srcdir)/hierarchy/symbols --output hierarchy/output

hierarchy/output/algorithm_instances/.sentinel: $(srcdir)/hierarchy/algorithminstances $(srcdir)/hierarchy/instrumentor neurospaces/config.h
	$(srcdir)/hierarchy/instrumentor --null-checks $(srcdir)/hierarchy/algorithminstances --output hierarchy/output

hierarchy/output/algorithmclasses/.sentinel: $(srcdir)/hierarchy/algorithmclasses $(srcdir)/hierarchy/instrumentor neurospaces/config.h
	$(srcdir)/hierarchy/instrumentor --null-checks $(srcdir)/hierarchy/algorithmclasses --output hierarchy/output

instrumentordir = $(prefix)/neurospaces/instrumentor
nobase_instrumentor_DATA = $(shell find $(srcdir)/hierarchy -type f)

parser.y: $(srcdir)/parser.decl hierarchy/output/symbols/.sentinel parser.rules.numbered $(srcdir)/parser.additions
	cat >parser.y $(srcdir)/parser.decl hierarchy/output/symbols/description.tokens parser.rules.numbered $(srcdir)/parser.additions
parser.rules.numbered: $(srcdir)/parser.rules
	perl -ne 'BEGIN { $$filename = shift @ARGV ; $$line++ } $$line++ ; s/^#line.*/#line $$line "$$filename"/; print' <$(srcdir)/parser.rules >parser.rules.numbered $(srcdir)/parser.rules
parser.rules: hierarchy/output/symbols/.sentinel analyzer.l
	cat hierarchy/output/symbols/grammar/*.types >hierarchy/output/symbols/grammar/02_defined_types.rules
	cat hierarchy/output/symbols/grammar/*.rules >parser.rules
analyzer.l: hierarchy/output/symbols/.sentinel
	cat hierarchy/output/symbols/grammar/*.l >analyzer.l
analyzer.o: parser.h analyzer.l
parser.c: parser.y
parser.h: parser.y
xs_initialize.c:
	$(PERL) -MExtUtils::Embed -e xsinit -- -o - >xs_initialize.c

test: check

TESTS = run_harness.sh

html-upload-prepare:
	rm -fr html/htdocs/neurospaces_project/neurospaces
	mkdir -p html/htdocs/neurospaces_project/neurospaces
# $Format: "	( cd tests && neurospaces_harness_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd tests && neurospaces_harness_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> neurospaces 0.1675 Thu, 27 Dec 2007 15:58:18 -0600 hugo<hr>' --introduction introduction.html )
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/neurospaces && tar vxf - )
	hierarchy/types_2_html >html/htdocs/neurospaces_project/neurospaces/algorithminstances.html hierarchy/output/algorithm_instances//dump_annotated_class_hierarchy
	hierarchy/types_2_html >html/htdocs/neurospaces_project/neurospaces/symbols.html hierarchy/output/symbols/dump_annotated_class_hierarchy

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis,neurospaces@web.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/

html-upload-index:
	scp -pr html/htdocs/index.html hcornelis,neurospaces@web.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/

internal-library:
# $Format: "	tar cfz library-${package}-${label}.tar.gz library/"$
	tar cfz library-model-container-alpha.tar.gz library/

libneurospacesread.so: libneurospacesread.a
	$(CC) \
	-fdiagnostics-color=never \
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
	commentsimple.o \
	concentrationgatekinetic.o \
	hhgate.o \
	connection.o \
	connectionsymbol.o \
	connectioncache.o \
	defsym.o \
	dependencyfile.o \
	exporter.o \
	equationexponential.o \
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
	izhikevich.o \
	membraneleak.o \
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
	pulsegen.o \
	querymachine1.o \
	querymachine2a.o \
	querymachine2b.o \
	querymachine2c.o \
	querymachine3.o \
	querymachine4.o \
	querymachine5.o \
	querymachine6.o \
	querymachine7.o \
	querymachine8.o \
	querymachine9.o \
	querymachine10.o \
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
	vectorsegment.o \
	workload.o \
	xs_initialize.o \
	-o libneurospacesread.so

#	contourpoint.o
#	emcontour.o
# 	vectorcontour.o

TMP_DIR = tmp


# Create a deb package
pkg-deb: dist
	nspkg-deb $(PACKAGE) $(VERSION)


pkg-rpm: dist
	nspkg-rpm $(PACKAGE) $(VERSION)

pkg-osx: 
	nspkg-osx 


#perldir = @PMDIR@

#nobase_perl_DATA = @PERL_EMBED_DATA@

doxygen: doxygen.cfg
	$(DOXYGEN) doxygen.cfg

docs-level1:

docs-level2:

docs-level3: html-upload-prepare
	echo "Converted the regression tests to HTML"

# the following commented out code breaks the cron job: because
# neurospacesparse is removed by a make clean, it cannot produce its
# help pages anymore.  So we can only generate docs-level4 after a
# successful compilation.  Note that this holds for other software
# components too.

docs-level4:
#	mkdir -p html/htdocs/neurospaces_project/neurospaces/docs-level4
#	( echo 'help' && echo 'quit' ) | neurospacesparse -q >html/htdocs/neurospaces_project/neurospaces/docs-level4/neurospacesparse.txt
#	convertors/morphology2ndf --help >html/htdocs/neurospaces_project/neurospaces/docs-level4/morpohology2ndf.txt

docs-level5:

docs-level6: doxygen
	echo "Doxygenized source code"

docs-level7:

docs: docs-level1 docs-level2 docs-level3 docs-level4 docs-level5 docs-level6 docs-level7

