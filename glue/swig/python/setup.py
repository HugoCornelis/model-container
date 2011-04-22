import imp
import os
import pdb
import sys

from distutils import log
from distutils.core import setup, Extension
from distutils.command.install_data import install_data

# import the cbi module. We use this since the check
# for the compiled swig nmc_base gives an error
# if we import from nmc.__cbi__
cbi = imp.load_source('__cbi__', './nmc/__cbi__.py')

#
# API for the platform class http://docs.python.org/library/platform.html
#

#-------------------------------------------------------------------------------

#
# This is borrowed from django's setup tools
# taken from here http://code.djangoproject.com/browser/django/trunk/setup.py
#
class osx_install_data(install_data):
    # On MacOS, the platform-specific lib dir is /System/Library/Framework/Python/.../
    # which is wrong. Python 2.5 supplied with MacOS 10.5 has an Apple-specific fix
    # for this in distutils.command.install_data#306. It fixes install_lib but not
    # install_data, which is why we roll our own install_data class.
	
    def finalize_options(self):
        # By the time finalize_options is called, install.install_lib is set to the
        # fixed directory, so we set the installdir to install_lib. The
        # install_data class uses ('install_data', 'install_dir') instead.
        self.set_undefined_options('install', ('install_lib', 'install_dir'))
        install_data.finalize_options(self)


#-------------------------------------------------------------------------------

"""
Function for reading in a file and outputting it as a string. 
"""
def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

#-------------------------------------------------------------------------------


# This is borrowed from django's setup tools
def fullsplit(path, result=None):
    """
    Split a pathname into components (the opposite of os.path.join) in a
    platform-neutral way.
    """
    if result is None:
        result = []
    head, tail = os.path.split(path)
    if head == '':
        return [tail] + result
    if head == path:
        return result
    return fullsplit(head, [tail] + result)

#-------------------------------------------------------------------------------

# borrowed from Pysco's setup.py

class ProcessorAutodetectError(Exception):
     pass
def autodetect():
     platform = sys.platform.lower()
     if platform.startswith('win'):   # assume an Intel Windows
         return 'i386'
     # assume we have 'uname'
     mach = os.popen('uname -m', 'r').read().strip()
     if not mach:
         raise ProcessorAutodetectError, "cannot run 'uname -m'"
     try:
         return {'i386': 'i386',
                 'i486': 'i386',
                 'i586': 'i386',
                 'i686': 'i386',
                 'i86pc': 'i386',    # Solaris/Intel
                 'x86':   'i386',    # Apple
                 }[mach]
     except KeyError:
         raise ProcessorAutodetectError, "unsupported processor '%s'" % mach

#-------------------------------------------------------------------------------


"""
Returns a list of all files matching the given file types.
"""
_file_types = ['.py']

def find_files(root_directory, file_types=_file_types):

    package_files = []

    for path, directories, files in os.walk( root_directory ):
        
        for f in files:
            
            path_parts = fullsplit( os.path.join(path, f) )

            path_parts.pop(0)

            this_file = '/'.join(path_parts)

            basename, extension = os.path.splitext( this_file )
            
            if extension in file_types:

                package_files.append(this_file)

    return package_files


#-------------------------------------------------------------------------------
NAME = cbi.GetPackageName()
VERSION = cbi.GetVersion()
AUTHOR = cbi.__author__
AUTHOR_EMAIL = cbi.__email__
LICENSE = cbi.__license__
URL = cbi.__url__
DOWNLOAD_URL = cbi.__download_url__
DESCRIPTION="The Model Container is a data structure used as an abstration for a model used in a simulation."
LONG_DESCRIPTION=cbi.__description__

KEYWORDS="neuroscience neurosimulator simulator modeling GENESIS"

# Get strings from http://pypi.python.org/pypi?%3Aaction=list_classifiers
CLASSIFIERS = [
    'Development Status :: 0 - Alpha',
    'Environment :: Console',
    'Environment :: Desktop Application',
    'Intended Audience :: End Users/Desktop',
    'Intended Audience :: Developers',
    'Intended Audience :: Research',
    'Intended Audience :: Science',        
    'License :: OSI Approved :: GPL License',
    'Operating System :: MacOS :: MacOS X',
    'Operating System :: POSIX',
    'Programming Language :: Python',
    'Topic :: Research :: Neuroscience',
]

PACKAGE_FILES=find_files('heccer')

OPTIONS={
    'sdist': {
        'formats': ['gztar','zip'],
        'force_manifest': True,
        },
    }

PLATFORMS=["Unix", "Lunix", "MacOS X"]

PY_MODULES=['heccer']


CMDCLASS = None
if sys.platform == "darwin": 
    CMDCLASS = {'install_data': osx_install_data} 
else: 
    CMDCLASS = {'install_data': install_data}


# swig: /usr/bin/swig -DPRE_PROTO_TRAVERSAL -I../../.. -python -outdir ./nmc -o nmc_wrap.c ./nmc.i
#
# compile: gcc -g -DPRE_PROTO_TRAVERSAL -I/Library/Frameworks/Python.framework/Versions/2.6/include/python2.6
# -I/Library/Frameworks/Python.framework/Versions/2.6/include/python2.6 -I../../.. -I../../../hierarchy/output/symbols
# -fPIC -c ./nmc_wrap.c
#
# linking: -L/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6/config -ldl -framework CoreFoundation
#  -lpython2.6 -L../../.. -lneurospacesread -L../../../algorithms/event -levent_algorithms -L../../../algorithms/symbol
#   -lsymbol_algorithms -lncurses -lreadline -flat_namespace -undefined suppress -bundle -bundle_loader
#   /Library/Frameworks/Python.framework/Versions/2.6/bin/python -o ./nmc/_nmc_base.so /usr/lib/bundle1.o nmc_wrap.o
#
# Extension API http://pydoc.org/2.5.1/distutils.extension.html
#
# commands for determining library arch on mac osx:
#    lipo -info
#    otool -hv
#

class NMCModule(Extension):
    """
    A class that abstracts methods that detect flags and paths
    for the target machine in a machine independent way. 
    """
    def __init__(self):

        self.name = "_nmc_base"
        self.sources = ["nmc_wrap.c", "nmc.i"]
        self.swig_opts = self.get_swig_opts()
        self.extra_compile_args = self.get_extra_compile_args()
        self.libraries = self.get_libraries()
        
        Extension.__init__(self,
                           self.name,
                           swig_opts=self.swig_opts,
                           extra_compile_args=self.extra_compile_args,
                           library_dirs=self.library_dirs,
                           include_dirs=self.include_dirs,
                           libraries=self.libraries
                           )

    def get_extra_compile_args(self):

        return ["-DPRE_PROTO_TRAVERSAL"]

    def get_swig_opts(self):

        return ["-DPRE_PROTO_TRAVERSAL", "-I../../.."]

    def get_library_dirs(self):

        return ["../../..", "../../../algorithms/event", "../../../algorithms/symbol"]

    def get_include_dirs(self):

        return ["../../..", "../../../hierarchy/output/symbols", ]

    def get_libraries(self):

        return ["neurospacesread", "event_algorithms", "symbol_algorithms", "ncurses", "readline"]

# Apperently it is trying to link the same file twice, and libtool is complaining about the
# duplicate symbol. 
# 
# gcc-4.2 -Wl,-F. -bundle -undefined dynamic_lookup -arch i386 -arch ppc -arch x86_64 build/temp.macosx-10.6-universal-2.6/nmc_wrap.o build/temp.macosx-10.6-universal-2.6/nmc_wrap.o -L../../.. -L../../../algorithms/event -L../../../algorithms/symbol -lneurospacesread -levent_algorithms -lsymbol_algorithms -lncurses -lreadline -o build/lib.macosx-10.6-universal-2.6/_nmc_base.so
#
EXT_MODULES=[
    
    Extension("_nmc_base",
              sources=["nmc_wrap.c", "nmc.i"],
              swig_opts=["-DPRE_PROTO_TRAVERSAL", "-I../../.."],
              extra_compile_args=["-DPRE_PROTO_TRAVERSAL"],
              library_dirs=["../../..", "../../../algorithms/event", "../../../algorithms/symbol"],
              include_dirs=["../../..", "../../../hierarchy/output/symbols", ],
              libraries=["neurospacesread", "event_algorithms", "symbol_algorithms", "ncurses", "readline"],
              ),
    ]
#pdb.set_trace()
#-------------------------------------------------------------------------------

setup(
    name=NAME,
    version=VERSION,
    author=AUTHOR,
    author_email=AUTHOR_EMAIL,
    cmdclass=CMDCLASS,
#    data_files=DATA_FILES,
    description=DESCRIPTION,
    ext_modules=EXT_MODULES,
    long_description=LONG_DESCRIPTION,
    license=LICENSE,
    keywords=KEYWORDS,
    url=URL,
    packages=['nmc'],
    package_data={'nmc' : PACKAGE_FILES},
#     package_dir={'' : ''},
    classifiers=CLASSIFIERS,
    options=OPTIONS,
    platforms=PLATFORMS,
    setup_requires=['g3'],
)

