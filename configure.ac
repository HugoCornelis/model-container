dnl
dnl Neurospaces: a library which implements a global typed symbol table to
dnl be used in neurobiological model maintenance and simulation.
dnl
dnl $Id: configure.ac 1.40 Wed, 10 Oct 2007 16:57:00 -0500 hugo $
dnl

dnl //////////////////////////////////////////////////////////////////////////
dnl
dnl Neurospaces : testbed C implementation that integrates with genesis
dnl
dnl Copyright (C) 1999-2008 Hugo Cornelis
dnl
dnl functional ideas ..	Hugo Cornelis, hugo.cornelis@gmail.com
dnl
dnl coding ............	Hugo Cornelis, hugo.cornelis@gmail.com
dnl
dnl //////////////////////////////////////////////////////////////////////////

dnl Process this file with autoconf to produce a configure script.
# $Format: "AC_REVISION(${package}, ${label}, ${email})"$
AC_REVISION(model-container, 16e23f15d78f5309ea818389c3ceb50568e64313-0, hugo.cornelis@gmail.com)
dnl AC_REVISION($Id: configure.ac 1.40 Wed, 10 Oct 2007 16:57:00 -0500 hugo $)
AC_INIT
AC_CONFIG_SRCDIR([neurospaces.c])

AC_CONFIG_HEADERS([neurospaces/config.h])

dnl Obtain operating system information.
AC_CANONICAL_TARGET

dnl Determine whether symbols in prototypes have serial ID's lower or higher than in instances / references. 1 means lower (prototype symbols come first in regular traversals)

dnl this is the only variant present at the moment

AC_DEFINE(PRE_PROTO_TRAVERSAL)

# Checks for enablng subsets.
AC_ARG_ENABLE(subset_segment, AS_HELP_STRING([--with-subset-segment   enable the segment subset translator]) )

if test x"$with_subset_segment" == "xyes" ; then

    echo "segment subset is enabled"

    AC_DEFINE(TREESPACES_SUBSET_SEGMENT, 1, [enable the segment subset])

else

    echo "segment subset is disabled"

fi


AC_ARG_ENABLE(subset_mechanism, AS_HELP_STRING([--with-subset-mechanism   enable the mechanism subset translator]) )

if test x"$with_subset_mechanism" == "xyes" ; then

    echo "mechanism subset is enabled"

    AC_DEFINE(TREESPACES_SUBSET_MECHANISM, 1, [enable the mechanism subset])

else

    echo "mechanism subset is disabled"

fi


# Check for delete operation
AC_ARG_ENABLE(delete_operation, AS_HELP_STRING([--with-delete-operation   enable the delete operation]) )

if test x"$with_delete_operation" == "xyes" ; then

    echo "delete operation is enabled"

    AC_DEFINE(DELETE_OPERATION, 1, [enable the delete operation])

else

    echo "delete operation is disabled"

fi


# determine linker flags for perl embedding

PERL_CCOPTS=`perl -MExtUtils::Embed -e ccopts`
AC_SUBST(PERL_CCOPTS)

PERL_LDADD=`perl -MExtUtils::Embed -e ldopts`
AC_SUBST(PERL_LDADD)

PERL_LDFLAGS=`perl -MExtUtils::Embed -e ldopts`
AC_SUBST(PERL_LDFLAGS)

dnl all subdirs

AC_CONFIG_SUBDIRS(algorithms convertors glue/swig)

# $Format: "AM_INIT_AUTOMAKE(${package}, ${label}, ${email})"$
AM_INIT_AUTOMAKE(model-container, 16e23f15d78f5309ea818389c3ceb50568e64313-0,hugo.cornelis@gmail.com)



dnl Checks for programs.
AC_PROG_AWK
AC_PROG_YACC
AC_PROG_CC
AM_PROG_LEX
AC_ARG_PROGRAM
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_RANLIB


dnl Checks for libraries.
dnl Replace `main' with a function in -lcurses:
AC_CHECK_LIB(curses, main,[echo "Found! lib curses."],[
   echo "Error! lib curses is not installed."
   exit -1
])

dnl Replace `main' with a function in -lfl:
AC_CHECK_LIB(fl, main,[echo "Found! lib flex."],[
   echo "Error! lib flex is not installed."
   exit -1
])

dnl Replace `main' with a function in -lhistory:
dnl AC_CHECK_LIB(history, main,[echo "Found! lib history."],[
dnl    echo "Error! lib history is not installed."
dnl    exit -1
dnl ])

dnl Replace `main' with a function in -lm:
AC_CHECK_LIB(m, main,[echo "Found! lib m."],[
   echo "Error! lib math is not installed."
   exit -1
])

dnl Replace `main' with a function in -lreadline:
dnl the second command on failure should be an 'exit -1'
AC_CHECK_LIB(readline, main,[echo "Found! lib readline."],[
   echo "Error! lib readline is not installed."
])


dnl Checks for header files.
AC_HEADER_STDC
AC_HEADER_STDBOOL
AC_CHECK_HEADERS([limits.h sys/time.h unistd.h float.h stddef.h ],[],[
   echo "Error! Header not found."
   exit -1
])



dnl Check for Python
AM_PATH_PYTHON(,[],[
   echo "Python is not installed."
   exit -1
])


case $PYTHON_PREFIX in
  *)   
    PYTHON_PREFIX=`echo $PYTHON | sed -e "s,[[^/]]*$,,;s,/$,,;s,^$,.,"`
    PYTHON_PREFIX=`echo $PYTHON_PREFIX | sed -e "s,[[^/]]*$,,;s,/$,,;s,^$,.,"`
    PYTHONHOME=$PYTHON_PREFIX
    AC_SUBST(PYTHON_PREFIX)
    AC_SUBST(PYTHONHOME)

    AC_MSG_CHECKING([Python header location])
    PYTHON_HEADERS='$(PYTHON_PREFIX)/include/python$(PYTHON_VERSION)'
    AC_SUBST(PYTHON_HEADERS)
    AC_MSG_RESULT([$PYTHON_PREFIX/include/python$PYTHON_VERSION])

    PYTHON_EXE='$(PYTHON_PREFIX)/bin/python'
    AC_SUBST(PYTHON_EXE)
  ;;
esac



dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_SIZE_T
AC_HEADER_TIME

dnl Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_FUNC_STRTOD
AC_FUNC_STRFTIME
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([floor getrusage gettimeofday strcspn strspn strtod strtol memset memmove sqrt strcasecmp strpbrk strrchr])
AC_CHECK_FUNCS(getcwd strtol,
,
echo "Could not find needed functions : getcwd or strtol"
WARNED=yes

# this is only a test of autoconf's functionality

)


dnl Check for some needed programs.
AC_CHECK_PROGS(PERL, perl5 perl)

AC_PATH_PROGS(DOXYGEN,doxygen,[NULL])



# search lisp dir for installing the emacs major mode

AM_PATH_LISPDIR

if test -n "${CXXFLAGS}"; then
  user_set_cxxflags=yes
fi
AC_PROG_CXX
if test X$user_set_cxxflags != Xyes; then
  CXXFLAGS="-g"
fi

dnl below checks for libgc.

dnl dnl Handle possible dlopen requirement for libgc
dnl dnl Isn't this internal to something in autoconf?  Couldn't find it...
dnl AC_CHECK_LIB([dld], [shl_load], [lt_cv_dlopen="shl_load" lt_cv_dlopen_libs="-dld"], [AC_CHECK_FUNC([dlopen],
dnl           [lt_cv_dlopen="dlopen"],
dnl       [AC_CHECK_LIB([dl], [dlopen],
dnl             [lt_cv_dlopen="dlopen" lt_cv_dlopen_libs="-ldl"],
dnl         [AC_CHECK_LIB([svld], [dlopen],
dnl               [lt_cv_dlopen="dlopen" lt_cv_dlopen_libs="-lsvld"],
dnl           [AC_CHECK_LIB([dld], [dld_link],
dnl                 [lt_cv_dlopen="dld_link" lt_cv_dlopen_libs="-dld"])
dnl           ])
dnl         ])
dnl       ])
dnl     ])

dnl AC_CHECK_HEADERS([gc.h gc/gc.h],
dnl                  [
dnl 		    # To test for the different required libs, I have to
dnl 		    # overcome autoconf's caching system, so I change the
dnl 		    # desired function name.  They're all in libgc.
dnl 		    # The "break" will exit from the top level
dnl                     # AC_CHECK_HEADERS.
dnl 		    gc_libs=""
dnl 		    AC_CHECK_LIB(gc, GC_init,
dnl                                  [gc_ok=yes;
dnl 				  LIBS="-lgc $gc_libs $LIBS";
dnl 				  break], [gc_ok=no], [$gc_libs])
dnl 		    gc_libs="-lpthread"
dnl 		    AC_CHECK_LIB(gc, GC_malloc,
dnl                                  [gc_ok=yes;
dnl 				  LIBS="-lgc $gc_libs $LIBS";
dnl                                   break], [gc_ok=no], [$gc_libs])
dnl 		    gc_libs="$lt_cv_dlopen_libs"
dnl 		    AC_CHECK_LIB(gc, GC_realloc,
dnl                                  [gc_ok=yes;
dnl 				  LIBS="-lgc $gc_libs $LIBS";
dnl                                   break], [gc_ok=no], [$gc_libs])
dnl 		    gc_libs="-lpthread $lt_cv_dlopen_libs"
dnl 		    AC_CHECK_LIB(gc, GC_free,
dnl                                  [gc_ok=yes;
dnl 				  LIBS="-lgc $gc_libs $LIBS";
dnl 				  break], [gc_ok=no], [$gc_libs])
dnl 		    break],
dnl                  [gc_ok=no])
dnl if test "x$gc_ok" = "xyes"; then
dnl 	AC_MSG_CHECKING([libgc version 6.4+])
dnl 	AC_RUN_IFELSE(
dnl 		[AC_LANG_SOURCE([[
dnl 			#ifdef HAVE_GC_GC_H
dnl 			# include <gc/gc.h>
dnl 			#else
dnl 			# include <gc.h>
dnl 			#endif
dnl 			#include <stdio.h>
dnl 			extern unsigned GC_version;
dnl 			int main(void){
dnl 				unsigned min = ((6 << 16) | (4 << 8) | 0);
dnl 				printf("%d.%d.%d ",GC_version >> 16, (GC_version >> 8) & 0xFF, GC_version & 0xFF);
dnl 				if (GC_version>=min) return 0;
dnl 				return 1;
dnl 			}]])],
dnl 		[gc_ok=yes],
dnl 		[gc_ok=no]
dnl 	)
dnl 	AC_MSG_RESULT([$gc_ok])
dnl fi
dnl if test "x$gc_ok" != "xyes"; then
dnl 	AC_MSG_ERROR([libgc (the Boehm Conservative Collector) 6.4+, is needed to compile neurospaces -- http://www.hpl.hp.com/personal/Hans_Boehm/gc])
dnl fi


# determine the model library to install

#! it seems to be impossible to specify this using regex ranges

dnl MODEL_DESCRIPTION_FILES=`find library -iname "*.ndf" | perl -pe 's/\n/ /g' | perl -pe 's(library/gates/kdr\S* )()g' | perl -pe 's(library/gates/kh\S* )()g' | perl -pe 's(library/gates/km\S* )()g'`
dnl MODEL_DESCRIPTION_FILES=`find library -iname "*.ndf" | perl -pe 's/\n/ /g' | perl -pe 's(library/gates/kdr\S* )()g' | perl -pe 's(library/gates/kh\S* )()g' | perl -pe 's(library/gates/km\S* )()g'`
MODEL_DESCRIPTION_FILES=`find library -iname "*.ndf" | perl -pe 's/\n/ /g'`
AC_SUBST(MODEL_DESCRIPTION_FILES)

MODEL_XML_FILES=`find library -iname "*.xml" | perl -pe 's/\n/ /g' | perl -pe 's(library/gates/kdr\S* )()g' | perl -pe 's(library/gates/kh\S* )()g' | perl -pe 's(library/gates/km\S* )()g'`
AC_SUBST(MODEL_XML_FILES)

MODEL_PROJECTIONCACHES=`find library/projectionqueries -type f | perl -pe 's/\n/ /g'`
AC_SUBST(MODEL_PROJECTIONCACHES)

MODEL_GENESIS_TABFILES=`find library -iname "*.tab" | perl -pe 's/\n/ /g'`
AC_SUBST(MODEL_GENESIS_TABFILES)

MODEL_GENESIS_MORPHOLOGYFILES=`find library -iname "*.p" | perl -pe 's/\n/ /g'`
AC_SUBST(MODEL_GENESIS_MORPHOLOGYFILES)

MODEL_SWC_MORPHOLOGYFILES=`find library -iname "*.swc" | perl -pe 's/\n/ /g' | perl -pe 's(library/gates/kdr\S* )()g' | perl -pe 's(library/gates/kh\S* )()g' | perl -pe 's(library/gates/km\S* )()g'`
AC_SUBST(MODEL_SWC_MORPHOLOGYFILES)

MODEL_TEXFILES=`find library -iname "*.tex" | perl -pe 's/\n/ /g'`
AC_SUBST(MODEL_TEXFILES)

MODEL_YAMLFILES=`find library -iname "*.yml" | perl -pe 's/\n/ /g'`
AC_SUBST(MODEL_YAMLFILES)

ALGORITHM_DATA=`find library/algorithm_data -type f | perl -pe 's/\n/ /g'`
AC_SUBST(ALGORITHM_DATA)


# determine the test library to install

TEST_SPECIFICATION_FILES=`/bin/echo -n "tests/introduction.html " && find tests/specifications -iname "*.t" | perl -pe 's/\n/ /g' && find tests/specifications/strings -iname "*.txt" | perl -pe 's/\n/ /g'`
AC_SUBST(TEST_SPECIFICATION_FILES)



dnl This does macro substitutions for certain opertaing systems and 
dnl architectures 
AC_MSG_CHECKING([OS specifics...])
AC_MSG_RESULT([Host is running $host_os.])
dnl {{{
case "$host_os" in
  darwin*)
    #
    # These are settings specific to MAC OS X.
    #
    dnl {{{{
    AC_MSG_CHECKING([Using libtool for MAC OS X.])
    AR=libtool
    ARFLAGS='-static -c -o'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)

    PERLLIB_EXTENSION='dylib'
    AC_SUBST(PERLLIB_EXTENSION)

    SWIGCOMPILELINKSFORPERL='-g \
	-DPRE_PROTO_TRAVERSAL \
	-I$(builddir)../../.. \
	-I$(srcdir)/../../.. \
	-I$(builddir)../../../hierarchy/output/symbols \
	-I$(srcdir)/../../../hierarchy/output/symbols/ \
	-fPIC \
	-dynamic \
	`perl -MExtUtils::Embed -e ccopts`'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGLDLINKSFORPERL='-L../../.. \
	-lneurospacesread \
	-L../../../algorithms/event \
	-levent_algorithms \
	-L../../../algorithms/symbol \
	-lsymbol_algorithms \
	-lncurses \
	-fPIC \
	-bundle \
	-undefined suppress \
	-flat_namespace'
    AC_SUBST(SWIGLDLINKSFORPERL)

    SWIGCOMPILELINKSFORPYTHON='-g \
	-DPRE_PROTO_TRAVERSAL \
	-I$(PYTHON_HEADERS) \
	-I$(builddir)../../.. \
	-I$(srcdir)/../../.. \
	-I$(builddir)../../../hierarchy/output/symbols \
	-I$(srcdir)/../../../hierarchy/output/symbols \
	-fPIC'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)

    SWIGLDLINKSFORPYTHON='-g \
	-shared swiggable_neurospaces_wrap.o \
	-L../../.. \
	-lneurospacesread \
	-L../../../algorithms/event \
	-levent_algorithms \
	-L../../../algorithms/symbol \
	-lsymbol_algorithms \
	-lncurses \
	-lreadline \
	-fPIC \
	-framework Python \
	-bundle \
	-bundle_loader $(PYTHON_EXE)'
    AC_SUBST(SWIGLDLINKSFORPYTHON)

    AC_MSG_RESULT([done.])
    dnl }}} end MAC OS X settings
    ;;
  *)
    dnl {{{ Default settings (Linux 2.6)
    AR='ar'
    ARFLAGS='cru'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)
    AC_MSG_CHECKING([ranlib invocation ])
    AC_MSG_RESULT([$AR $ARFLAGS])

    PERLLIB_EXTENSION='so'
    AC_SUBST(PERLLIB_EXTENSION)

    SWIGCOMPILELINKSFORPERL='-I/usr/local/neurospaces/instrumentor \
	-I$(srcdir)/../../.. \
	-I$(top_builddir) \
	-ffloat-store \
	-I../../.. \
	-include heccer/config.h \
	-g \
	-O0 \
	-fPIC \
	`perl -MExtUtils::Embed -e ccopts`'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGLDLINKSFORPERL='-g \
	-shared swiggable_heccer_wrap.o \
	-L../../.. \
	-lheccer \
	-L../../../integrators \
	-lhneurospaces \
	-L/usr/local/lib/model-container \
	-lneurospacesread \
	-L/usr/local/lib/neurospaces/algorithms/symbol \
	-lsymbol_algorithms \
	-lncurses \
	-lreadline \
	-lhistory \
	-fPIC'
    AC_SUBST(SWIGLDLINKSFORPERL)

    SWIGCOMPILELINKSFORPYTHON='-g \
	-DPRE_PROTO_TRAVERSAL \
	-I$(PYTHON_HEADERS) \
	-I/usr/local/neurospaces/instrumentor \
	-I$(builddir)../../.. \
	-I$(srcdir)/../../.. \
	-I$(builddir)../../../hierarchy/output/symbols \
	-I$(srcdir)/../../../hierarchy/output/symbols/ \
	-fPIC \
	-Xlinker \
	-export-dynamic'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)

    SWIGLDLINKSFORPYTHON='-g \
	-shared swiggable_heccer_wrap.o \
	-L../../.. \
	-lheccer \
	-L../../../integrators \
	-lhneurospaces \
	-L/usr/local/lib/model-container \
	-lneurospacesread \
	-L/usr/local/lib/neurospaces/algorithms/symbol \
	-lsymbol_algorithms \
	-lncurses \
	-lreadline \
	-lhistory \
	-Xlinker \
	-export-dynamic'
    AC_SUBST(SWIGLDLINKSFORPYTHON)
    dnl }}} End of General Settings
  
  ;;
esac
dnl }}}


AC_OUTPUT(Makefile \
	algorithms/Makefile \
	algorithms/event/Makefile \
	algorithms/symbol/Makefile \
	convertors/Makefile \
	glue/swig/Makefile \
	glue/swig/perl/Makefile \
	glue/swig/python/Makefile 
)

