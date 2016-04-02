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
# $Format: "AC_INIT(${package}, ${major}.${minor}.${micro}-${label}, ${email})"$
AC_INIT(model-container, 0.0.0-alpha, hugo.cornelis@gmail.com)
dnl AC_REVISION($Id: configure.ac 1.40 Wed, 10 Oct 2007 16:57:00 -0500 hugo $)

dnl Obtain operating system information.
AC_CANONICAL_TARGET


AC_CONFIG_SRCDIR([neurospaces.c])

AC_CONFIG_HEADERS([neurospaces/config.h])

# $Format: "AM_INIT_AUTOMAKE(${package}, ${major}.${minor}.${micro}-${label})"$
AM_INIT_AUTOMAKE(model-container, 0.0.0-alpha)


# see https://metacpan.org/source/ASPIERS/Stow-v2.1.2/configure.ac

dnl Check for perl on our system.
dnl Call to AC_SUBST(PERL) is implicit
dnl AC_PATH_PROGS([PERL], [perl] [perl5], [false])
dnl if test "x$PERL" = xfalse
dnl then
dnl   AC_MSG_ERROR([Perl not found; check your \$PATH.])
dnl fi
 
# N.B. ${var#pattern} will not work with some shells, such as
# Solaris 10's /bin/sh :-(
#
#   http://www.gnu.org/software/autoconf/manual/autoconf.html#Portable-Shell
#
#   eval `$PERL -V:siteprefix -V:installsitelib`
#   pmdir_relative_path="${installsitelib#$siteprefix/}"
#
# This will work:
#
#   pmdir_relative_path=`echo "${installsitelib}" | sed -e "s!^$siteprefix/!!"`
#
# but this is cleaner:
dnl pmdir_relative_path=`\
dnl   $PERL -MConfig \
dnl         -wle '($_ = $Config{installsitelib})
dnl               =~ s!^\Q$Config{siteprefix}/!!; \
dnl               print'`
 
dnl AC_ARG_WITH(
dnl     [pmdir],
dnl     AS_HELP_STRING(
dnl       [--with-pmdir=DIR],
dnl       [Install Perl modules in DIR]),
dnl     [PMDIR=${withval}],
dnl     [PMDIR='${prefix}'/"$pmdir_relative_path"])
dnl AC_CONFIG_COMMANDS_POST([[
dnl   eval pmdir="$PMDIR"
dnl   cat <<EOF
 
dnl # Perl modules will be installed to $PMDIR
dnl EOF
dnl   if [ "$pmdir" != "$PMDIR" ]; then
dnl     cat <<EOF
dnl # which will expand to
dnl #
dnl #   $pmdir
dnl #
dnl # unless you override the value of prefix at make-time.
dnl EOF
dnl     echo
dnl   fi
dnl ]])
dnl AC_SUBST([PMDIR])




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

AC_MSG_CHECKING(whether we build universal binaries.)
AC_ARG_WITH(universal,
[AS_HELP_STRING([--with-universal],
              [Build universal binaries on Mac OS X.])],
[ case "$val" in
  no)

    AC_MSG_RESULT(no)
    OSX_UNIVERSAL="no"

    ;;
  *)

    AC_MSG_RESULT(yes)
    MY_AUTOMAKE_OPTIONS=no-dependencies
    
    OSX_UNIVERSAL="yes"

    ;;
  esac ],
  AC_MSG_RESULT(no)
  OSX_UNIVERSAL="no"
)
AC_SUBST(OSX_UNIVERSAL)


dnl Checks for programs.
AC_PROG_AWK
AC_PROG_YACC
AC_PROG_CC
AM_PROG_LEX
#AC_ARG_PROGRAM
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_RANLIB


dnl Checks for libraries.
dnl Replace `main' with a function in -lcurses:
AC_CHECK_LIB(curses, main,[],[
   echo "Error! lib curses is not installed."
   exit -1
])

dnl see here for why this was commented out:
dnl http://stackoverflow.com/questions/26064096/using-flex-the-lexical-analizer-on-os-x

dnl dnl Replace `main' with a function in -lfl:
dnl AC_CHECK_LIB(fl, main,[],[
dnl    echo "Error! lib flex is not installed."
dnl    exit -1
dnl ])

dnl Replace `main' with a function in -lhistory:
dnl AC_CHECK_LIB(history, main,[echo "Found! lib history."],[
dnl    echo "Error! lib history is not installed."
dnl    exit -1
dnl ])

dnl Replace `main' with a function in -lm:
AC_CHECK_LIB(m, main,[],[
   echo "Error! lib math is not installed."
   exit -1
])

dnl AC_DEFINE(HAVE_READLINE_LIB, [1])
dnl Replace `main' with a function in -lreadline:
dnl the second command on failure should be an 'exit -1'
dnl AC_CHECK_LIB(readline, main,[echo "Found! lib readline."],[
dnl   echo "Error! lib readline is not installed."
dnl   AC_DEFINE(HAVE_READLINE_LIB, 0)
dnl ])


dnl Checks for header files.
AC_HEADER_STDC
AC_HEADER_STDBOOL
AC_CHECK_HEADERS([limits.h sys/time.h unistd.h float.h stddef.h ],[],[
   echo "Error! Header not found."
   exit -1
])

dnl
dnl There is no clause to make the configure script stop because
dnl on red hat machines (others?) readline is built into stdio. This
dnl causes detection of the readline library to fail. 
dnl Additions to the case statement for earlier and newer versions of redhat
dnl need to be added to accomodate this discrepancy. 
dnl
AC_CHECK_HEADERS([readline/readline.h],[],[])

dnl Check for Python and it's headers
AM_PATH_PYTHON(,[],[
   echo "Python is not installed."
   exit -1
])

dnl AC_MSG_CHECKING([Python prefix is ])
dnl   AC_MSG_RESULT(['$PYTHON_PREFIX'])

dnl dnl
dnl dnl This is a forced fix to make sure a mac installation gets the proper
dnl dnl python executable. Unless the macpython installer was run, the autotools
dnl dnl python macro won't look for python in the proper path. 
dnl dnl 
dnl case "$host_os" in
dnl   darwin*)

dnl     PYTHON_PREFIX='/Library/Frameworks/Python.framework/Versions/Current'
dnl     AC_SUBST(PYTHON_PREFIX)
    
dnl     PYTHON=$PYTHON_PREFIX/bin/python
dnl     AC_SUBST(PYTHON)

dnl     AC_CHECK_PROG(HAVE_PYTHON_CONFIG, python-config, "yes", "no",[$PYTHON_PREFIX/bin])
dnl     AC_MSG_CHECKING([python-config present])
dnl     AC_MSG_RESULT([$HAVE_PYTHON_CONFIG])
dnl   ;;
dnl   *)

dnl     AC_CHECK_PROG(HAVE_PYTHON_CONFIG, python-config, "yes", "no")
dnl     AC_MSG_CHECKING([python-config present])
dnl     AC_MSG_RESULT([$HAVE_PYTHON_CONFIG])

dnl   ;;
dnl esac




dnl if test "$HAVE_PYTHON_CONFIG" == "yes"; then

dnl   # This is to set the proper python-config for getting the 
dnl   # proper flags and prefixes

  
dnl   AC_MSG_CHECKING([Python config location])
dnl   PYTHON_CONFIG=$PYTHON-config
dnl   AC_SUBST(PYTHON_CONFIG)
dnl   AC_MSG_RESULT([$PYTHON_CONFIG])


dnl   AC_MSG_CHECKING([Python prefix is])
dnl   PYTHON_PREFIX=`$PYTHON_CONFIG --prefix`
dnl   AC_SUBST(PYTHON_PREFIX)
dnl   AC_MSG_RESULT([$PYTHON_PREFIX])


dnl   AC_MSG_CHECKING([Python includes are])
dnl   PYTHON_INCLUDE=`$PYTHON_CONFIG --include`
dnl   AC_SUBST(PYTHON_INCLUDE)
dnl   AC_MSG_RESULT([$PYTHON_INCLUDE])


dnl   AC_MSG_CHECKING([Python libs are])
dnl   PYTHON_LIBS=`$PYTHON_CONFIG --libs`
dnl   AC_SUBST(PYTHON_LIBS)
dnl   AC_MSG_RESULT([$PYTHON_LIBS])


dnl   AC_MSG_CHECKING([Python cflags are])
dnl   PYTHON_CFLAGS=`$PYTHON_CONFIG --cflags`
dnl   AC_SUBST(PYTHON_CFLAGS)
dnl   AC_MSG_RESULT([$PYTHON_CFLAGS])


dnl   AC_MSG_CHECKING([Python ldflags are])
dnl   PYTHON_LDFLAGS=`$PYTHON_CONFIG --ldflags`
dnl   AC_SUBST(PYTHON_LDFLAGS)
dnl   AC_MSG_RESULT([$PYTHON_LDFLAGS])

dnl   AC_MSG_CHECKING([Python executable is])
dnl   PYTHON_EXE=$PYTHON_PREFIX/bin/python
dnl   AC_SUBST(PYTHON_EXE)
dnl   AC_MSG_RESULT([$PYTHON_EXE])


dnl else

dnl   # This is legacy to make sure that systems with python
dnl   # that do not have python-config can get the python info
dnl   # This has always been a bit error prone, particularly if the 
dnl   # user has more than one python version installed.

dnl   PYTHON_PREFIX=`echo $PYTHON | sed -e "s,[[^/]]*$,,;s,/$,,;s,^$,.,"`
dnl   PYTHON_PREFIX=`echo $PYTHON_PREFIX | sed -e "s,[[^/]]*$,,;s,/$,,;s,^$,.,"`
dnl   AC_SUBST(PYTHON_PREFIX)


dnl   AC_MSG_CHECKING([Python prefix is])
dnl   AC_MSG_RESULT([$PYTHON_PREFIX])


dnl   PYTHON_HEADERS='$(PYTHON_PREFIX)/include/python$(PYTHON_VERSION)'
dnl   AC_SUBST(PYTHON_HEADERS)

dnl   AC_MSG_CHECKING([Python includes are])
dnl   PYTHON_INCLUDE='-I$(PYTHON_HEADERS)'
dnl   AC_SUBST(PYTHON_INCLUDE)
dnl   AC_MSG_RESULT([$PYTHON_INCLUDE])

dnl   AC_MSG_CHECKING([Python ldflags are])
dnl   PYTHON_LIBS='-L$(pyexecdir)/../config'
dnl   AC_SUBST(PYTHON_LIBS)
dnl   AC_MSG_RESULT([$PYTHON_LIBS])
				


dnl   PYTHON_EXE='$(PYTHON_PREFIX)/bin/python'
dnl   AC_SUBST(PYTHON_EXE)
dnl fi



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


AC_PATH_PROGS(DOXYGEN,doxygen,[NULL])
AC_PATH_PROGS(DOT,dot)
AC_PATH_PROGS(SOURCE_HIGHLIGHT,source-highlight)

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

MODEL_NPY_FILES=`find library -iname "*.npy" | perl -pe 's/\n/ /g' | perl -pe 's(library/gates/kdr\S* )()g' | perl -pe 's(library/gates/kh\S* )()g' | perl -pe 's(library/gates/km\S* )()g'`
AC_SUBST(MODEL_NPY_FILES)

MODEL_NPL_FILES=`find library -iname "*.npl" | perl -pe 's/\n/ /g' | perl -pe 's(library/gates/kdr\S* )()g' | perl -pe 's(library/gates/kh\S* )()g' | perl -pe 's(library/gates/km\S* )()g'`
AC_SUBST(MODEL_NPL_FILES)

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

TEST_SPECIFICATION_FILES=`/bin/echo -n "tests/introduction.html " && find tests/specifications -iname "*.t" | perl -pe 's/\n/ /g'`
AC_SUBST(TEST_SPECIFICATION_FILES)



dnl This does macro substitutions for certain operating systems and 
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


    # Check for libtool to make executables
    AC_MSG_CHECKING([Using libtool for MAC OS X.])
    AC_CHECK_PROG(LIBTOOL_PRESENT, libtool, yes, no)

    case $LIBTOOL_PRESENT in
      yes*)

        AR=libtool
        ARFLAGS='-static -c -o'
        AC_SUBST(AR)
        AC_SUBST(ARFLAGS)
        dnl AC_MSG_RESULT([$AR $ARFLAGS])

      ;;
      no*)

        AC_ERROR([libtool for Mac OSX is not found. It's needed to make executables.])

      ;;
    esac

    
    dnl On the MAC we will only look for perl in the standard location for the Apple
    dnl native perl. 
    dnl OLD LINE: AC_CHECK_PROG(PERL, perl, NULL, [/usr/bin/perl],[/usr/local/bin/perl /opt/local/bin/perl /sw/bin/perl])
    dnl AC_CHECK_PROG(PERL_PRESENT, perl,yes, no, [/usr/bin], [/usr/local/bin/perl /opt/local/bin/perl /sw/bin/perl])
    dnl AC_SUBST(PERL_PRESENT)

    dnl Going to restrict the search for perl to use the mac standard location
    AC_CHECK_PROGS(PERL, perl, [NULL], [/usr/bin])

    dnl AC_MSG_CHECKING([Checking the perl installation])
    case $PERL in
      NULL*)
        echo ""
        echo "Error, the standard version of perl for Mac OSX is not found."
        echo "Non standard versions of perl are known to cause problems."
        AC_ERROR([Perl for Mac OSX is not found.])
        ;;
        *)
        dnl Ensure that ONLY the standard mac perl is used throughout.
	PERL='/usr/bin/perl'
        AC_SUBST(PERL)
        ;;
dnl       *)

dnl         AC_MSG_RESULT([ $PERL ])

dnl         ;;
    esac



    #-- Here we determine the install path for perl modules --
    AC_MSG_CHECKING([Checking the perl module installation path])	
    pmdir_relative_path=`\
      $PERL -MConfig \
        -wle '($_ = $Config{installsitelib})
              =~ s!^\Q$Config{siteprefix}/!!; \
              print'`
 
    AC_ARG_WITH(
      [pmdir],
    AS_HELP_STRING(
      [--with-pmdir=DIR],
      [Install Perl modules in DIR]),
      [PMDIR=${withval}],
      [PMDIR="$pmdir_relative_path"])

    AC_SUBST([PMDIR])
    AC_MSG_RESULT([ $PMDIR ])
    # --- End perl module directory selection --------------



    
    # This is to get rid of the annoying error that occurs when
    # you use two arch flags.occur By default these commands produce a -arch for both
    # architectures. If now differentiates between OSX lion, which rejects the -fstack-protector
    # flag on the standard build environment.

    echo "This is host_os: $host_os"

    case "$host_os" in

	darwin11*|darwin12*) dnl This is Max OSX lion or OSX mountain lion

          if test "$OSX_UNIVERSAL" == "yes"; then

            PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts | perl -pe 's/\-fstack\-protector//g'`
      
            PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-fstack\-protector//g'`

            # When using libtool, you can't use arch arguments.
            PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g' | perl -pe 's/\-fstack\-protector//g'`

          else

            PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts | perl -pe 's/\-arch\s\S+\s//g' | perl -pe 's/\-fstack\-protector//g'`
    
            PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g' | perl -pe 's/\-fstack\-protector//g'`

            PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g' | perl -pe 's/\-fstack\-protector//g'`

          fi
        ;;
	
	*) dnl all other Mac OSX versions

          if test "$OSX_UNIVERSAL" == "yes"; then

            PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts`
      
            PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts`

            # When using libtool, you can't use arch arguments.
            PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g'`

          else

            PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts | perl -pe 's/\-arch\s\S+\s//g'`
    
            PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g'`

            PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g'`

          fi
        ;;

    esac

    AC_SUBST(PERL_CCOPTS)
    AC_SUBST(PERL_LDADD)
    AC_SUBST(PERL_LDFLAGS)



    dnl OLD LINE:
    dnl AC_CHECK_PROG(SWIG, swig, [NULL, [/usr/bin/swig],[/usr/local/bin/swig /opt/local/bin/swig])
    dnl AC_SUBST(SWIG)

    AC_CHECK_PROGS(SWIG, swig, [NULL], [/usr/bin /usr/local/bin])

    dnl AC_MSG_CHECKING([Checking for swig])
    case $SWIG in
      NULL*)
        echo ""
        echo "Error, the standard version of swig for Mac OSX is not found."
        echo "Non standard versions of swig are known to cause problems."
        AC_ERROR([Swig for Mac OSX is not found.])
        ;;
dnl       *)
dnl         AC_MSG_RESULT([ yes ])
dnl         ;;
    esac


    PERLLIB_EXTENSION='dylib'
    AC_SUBST(PERLLIB_EXTENSION)

    SWIGCOMPILELINKSFORPERL='-g -Wno-declaration-after-statement -DPRE_PROTO_TRAVERSAL -I$(top_builddir) -I$(top_builddir)/hierarchy/output/symbols -fPIC -dynamic $(PERL_CCOPTS)'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGCOMPILECOMMAND_PERL='gcc -Wno-declaration-after-statement $(SWIGCOMPILELINKSFORPERL) -c swiggable_neurospaces_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)


    # Mando: If building universal binaries we need different flags for libtool
    # can possibly use libtool for both builds but not going to replace
    # the working one just yet.    
    if test "$OSX_UNIVERSAL" == "yes"; then 

      SWIGLDLINKSFORPERL='-dynamic -undefined suppress -flat_namespace -L$(top_builddir) -lneurospacesread -L$(top_builddir)/algorithms/event -levent_algorithms -L$(top_builddir)/algorithms/symbol -lsymbol_algorithms $(PERL_LDFLAGS)'

    else

      SWIGLDLINKSFORPERL='-L$(top_builddir) -lneurospacesread -L$(top_builddir)/algorithms/event -levent_algorithms -L$(top_builddir)/algorithms/symbol -lsymbol_algorithms -lncurses -dylib -undefined suppress -flat_namespace $(PERL_LDFLAGS)'

    fi

    AC_SUBST(SWIGLDLINKSFORPERL)

    dnl Here we check for specific versions of mac osx since flags are different for each version
    dnl probably need to make this section neater sometime. 
    case "$host_os" in

	darwin10*)

          if test "$OSX_UNIVERSAL" == "yes"; then
  
            SWIGLINKCOMMAND_PERL='$(AR) $(SWIGLDLINKSFORPERL) -o SwiggableNeurospaces.$(PERLLIB_EXTENSION) swiggable_neurospaces_wrap.o'
          
          else

            SWIGLINKCOMMAND_PERL='ld $(SWIGLDLINKSFORPERL) -o SwiggableNeurospaces.$(PERLLIB_EXTENSION) /usr/lib/bundle1.o  swiggable_neurospaces_wrap.o'

          fi

          AC_SUBST(SWIGLINKCOMMAND_PERL)

	;;


	*)
	    dnl This probably needs to be patitioned into leopard, tiger, panther. etc

          SWIGLINKCOMMAND_PERL='ld $(SWIGLDLINKSFORPERL) -o SwiggableNeurospaces.$(PERLLIB_EXTENSION) swiggable_neurospaces_wrap.o'
            AC_SUBST(SWIGLINKCOMMAND_PERL)
	;;
    esac 


    PYTHONLIB_EXTENSION='so'
    AC_SUBST(PYTHONLIB_EXTENSION)
    
    SWIGCOMPILELINKSFORPYTHON='-g -DPRE_PROTO_TRAVERSAL $(PYTHON_INCLUDE) -I${top_builddir} -I${top_builddir}/hierarchy/output/symbols -fPIC'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)


    SWIGCOMPILECOMMAND_PYTHON='gcc -Wno-declaration-after-statement $(SWIGCOMPILELINKSFORPYTHON) -c swiggable_neurospaces_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PYTHON)


    if test "$OSX_UNIVERSAL" == "yes"; then 

      SWIGLDLINKSFORPYTHON='-dynamic -undefined suppress -flat_namespace -L$(top_builddir) -lneurospacesread -L$(top_builddir)/algorithms/event -levent_algorithms -L$(top_builddir)/algorithms/symbol -lsymbol_algorithms -lncurses $(PYTHON_LDFLAGS)'

    else

      SWIGLDLINKSFORPYTHON='$(PYTHON_LDFLAGS) -L$(top_builddir) -lneurospacesread -L$(top_builddir)/algorithms/event -levent_algorithms -L$(top_builddir)/algorithms/symbol -lsymbol_algorithms -lncurses -lreadline -flat_namespace -undefined suppress -bundle -bundle_loader $(PYTHON_EXE)'

    fi

    
    AC_SUBST(SWIGLDLINKSFORPYTHON)


    case "$host_os" in
	darwin10*)

          if test "$OSX_UNIVERSAL" == "yes"; then 

            SWIGLINKCOMMAND_PYTHON='$(AR) $(SWIGLDLINKSFORPYTHON) -o _SwiggableNeurospaces.$(PYTHONLIB_EXTENSION) swiggable_neurospaces_wrap.o'

	    MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON='$(AR) $(SWIGLDLINKSFORPYTHON) -o $(srcdir)/neurospaces/model_container/_model_container_base.so model_container_wrap.o'

          else

            SWIGLINKCOMMAND_PYTHON='ld $(SWIGLDLINKSFORPYTHON) -o _SwiggableNeurospaces.$(PYTHONLIB_EXTENSION) /usr/lib/bundle1.o swiggable_neurospaces_wrap.o'


	    MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON='ld $(SWIGLDLINKSFORPYTHON) -o $(srcdir)/neurospaces/model_container/_model_container_base.so /usr/lib/bundle1.o model_container_wrap.o'
 
          fi
            
          AC_SUBST(SWIGLINKCOMMAND_PYTHON)
          AC_SUBST(MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON)

	;;

	*)


            SWIGLINKCOMMAND_PYTHON='ld $(SWIGLDLINKSFORPYTHON) -o _SwiggableNeurospaces.$(PYTHONLIB_EXTENSION) swiggable_neurospaces_wrap.o'
            AC_SUBST(SWIGLINKCOMMAND_PYTHON)

	    MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON='ld $(SWIGLDLINKSFORPYTHON) -o $(srcdir)/neurospaces/model_container/_nmc_base.so nmc_wrap.o'
            AC_SUBST(MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON)

            
	;;
    esac 


    AC_MSG_RESULT([done setting Mac OSX settings.])
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

    dnl Check for some needed programs.
    AC_CHECK_PROGS(PERL, perl5 perl)
    AC_SUBST(PERL)

    #-- Here we determine the install path for perl modules --
    AC_MSG_CHECKING([Checking the perl module installation path])	
    pmdir_relative_path=`\
      $PERL -MConfig \
        -wle '($_ = $Config{installsitelib})
              =~ s!^\Q$Config{siteprefix}/!!; \
              print'`
 
    AC_ARG_WITH(
      [pmdir],
    AS_HELP_STRING(
      [--with-pmdir=DIR],
      [Install Perl modules in DIR]),
      [PMDIR=${withval}],
      [PMDIR='${prefix}'/"$pmdir_relative_path"])

    AC_SUBST([PMDIR])
    AC_MSG_RESULT([ $PMDIR ])
    # --- End perl module directory selection --------------

    dnl Need to have the compilation fail if swig and perl are not found at all.
    AC_CHECK_PROGS(SWIG, swig)
    AC_SUBST(SWIG)

    # determine linker flags for perl embedding

    PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts`
    AC_SUBST(PERL_CCOPTS)

    PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts`
    AC_SUBST(PERL_LDADD)

    PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts`
    AC_SUBST(PERL_LDFLAGS)



    PERLLIB_EXTENSION='so'
    AC_SUBST(PERLLIB_EXTENSION)

    SWIGCOMPILELINKSFORPERL='-g -DPRE_PROTO_TRAVERSAL -I$(top_builddir) -I$(top_builddir)/hierarchy/output/symbols 	-I$(top_builddir)/hierarchy/output/symbols/ -fPIC $(PERL_CCOPTS)'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGCOMPILECOMMAND_PERL='gcc -Wno-declaration-after-statement        $(SWIGCOMPILELINKSFORPERL) -c swiggable_neurospaces_wrap.c' 
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)

    SWIGLDLINKSFORPERL='-g -shared swiggable_neurospaces_wrap.o 	-L$(top_builddir) -lneurospacesread -L$(top_builddir)/algorithms/event -levent_algorithms 	-L$(top_builddir)/algorithms/symbol 	-lsymbol_algorithms 	-lncurses 	-lhistory 	-lreadline'
    AC_SUBST(SWIGLDLINKSFORPERL)

    SWIGLINKCOMMAND_PERL='gcc -Wno-declaration-after-statement        $(SWIGLDLINKSFORPERL)         -o SwiggableNeurospaces.$(PERLLIB_EXTENSION)'
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)





    PYTHONLIB_EXTENSION='so'
    AC_SUBST(PYTHONLIB_EXTENSION)

    SWIGCOMPILELINKSFORPYTHON='-g -Wno-declaration-after-statement -DPRE_PROTO_TRAVERSAL $(PYTHON_INCLUDE) -I${top_builddir} -I${top_builddir}/hierarchy/output/symbols -fPIC -Xlinker -export-dynamic'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)
   
    SWIGCOMPILECOMMAND_PYTHON='gcc $(SWIGCOMPILELINKSFORPYTHON) -c swiggable_neurospaces_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PYTHON)

    SWIGLDLINKSFORPYTHON='-L${top_builddir} -lneurospacesread -L${top_builddir}/algorithms/event -levent_algorithms -L${top_builddir}/algorithms/symbol 	-lsymbol_algorithms 	-lncurses 	-lhistory 	-lreadline 	-fPIC -Xlinker -export-dynamic $(PYTHON_LDFLAGS)'
    AC_SUBST(SWIGLDLINKSFORPYTHON)
  
    SWIGLINKCOMMAND_PYTHON='gcc -shared swiggable_neurospaces_wrap.o $(SWIGLDLINKSFORPYTHON)  -o _SwiggableNeurospaces.$(PYTHONLIB_EXTENSION)'
    AC_SUBST(SWIGLINKCOMMAND_PYTHON)

    # note: Must remember that the "-shared objectfile.o" part must be FIRST, otherwise it will silently
    # not link the symbols but give the appearance that it has completed successully. 
    MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON='gcc -shared model_container_wrap.o $(SWIGLDLINKSFORPYTHON) -o $(srcdir)/neurospaces/model_container/_model_container_base.so'
    AC_SUBST(MODEL_CONTAINER_SWIGLINKCOMMAND_PYTHON)

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

