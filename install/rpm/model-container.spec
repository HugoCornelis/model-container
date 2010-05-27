# The _WORKING_DIRECTORY_ value will be replaced with the current working directory
%define _topdir	 	_WORKING_DIRECTORY_/RPM_BUILD
%define _bindir		/usr/local/bin
%define _mandir		/usr/local/share/man/man1

# $Format: "%define name	${package}"$
%define name	model-container


# $Format: "%define release	        ${label}"$
%define release	        alpha


# $Format: "%define version 	${major}.${minor}.${micro}"$
%define version 	0.0.0


%define buildroot 	%{_topdir}/%{name}-%{version}-%{release}-root

BuildRoot:		%{buildroot}
Summary: 		Neurospaces Model Container
License: 		GPL
Name: 			%{name}
Version: 		%{version}
Release: 		%{release}
Source: 		%{name}-%{version}-%{release}.tar.gz
Prefix: 		/usr/local
Group: 			Science
Vendor: 		Hugo Cornelis <hugo.cornelis@gmail.com>
Packager: 		Mando Rodriguez <mandorodriguez@gmail.com>
URL:			http://www.neurospaces.org
AutoReqProv:		no


%description
The Model Container is used as an abstraction layer on top of a simulator and deals with biological entities and end-user concepts instead of mathematical equations. It provides a solver independent internal storage format for models that allows user independent optimizations of the numerical core. By `containing' the biological model, the Model Container makes the implementation of the numerical core independent of software implementation. The Model Container API abstracts away all the mathematical and computational details of the simulator. Optimized to store large models in little memory--it stores neuronal models in a fraction of the memory that would be used by conventional simulators--and provides automatic partitioning of the model such that simulations can be run in parallel. From the modeler's perspective, the Model Container will be able to import and export NeuroML files to facilitate model exchange and ideas.

# %package developer
# Requires: perl
# Summary: Neurospaces Developer Package
# Group: Science
# Provides: developer

%prep
echo %_target
echo %_target_alias
echo %_target_cpu
echo %_target_os
echo %_target_vendor
echo Building %{name}-%{version}-%{release}
%setup -q -n %{name}-%{version}-%{release} 

%build
./configure 
make

%install
make install prefix=$RPM_BUILD_ROOT/usr/local

%clean
[ ${RPM_BUILD_ROOT} != "/" ] && rm -rf ${RPM_BUILD_ROOT}

# listing a directory name under files will include all files in the directory.
%files
%defattr(0755,root,root) 
/usr/local/
#/usr/share/


%doc %attr(0444,root,root) docs
#%doc %attr(0444,root,root) /usr/local/share/man/man1/wget.1
# need to put whatever docs to link to here.

%changelog
* Mon Apr  5 2010 Mando Rodriguez <mandorodriguez@gmail.com> - 
- Initial build.

