#!/usr/bin/perl -w
##
## Neurospaces: a library which implements a global typed symbol table to
## be used in neurobiological model maintenance and simulation.
##
## $Id: des2xml.pl 1.12 Fri, 24 Aug 2007 12:25:50 -0500 hugo $
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


=head1 INTERNAL FUNCTIONALITY

This section describes internals of this file.  It may or may not be
correct.


=cut

=head2 C<$ARGV[0]>

file to convert to neurospaces-xml, if not supplied or only '-', reads
from stdin.

=cut

# read file

$_ = $ARGV[0] ;

if (defined and /^[^-]\b/)
  {
    $_ = `cat $_` ;
  }
else
  {
    $_ = `cat` ;
  }


# preamble

print "<?xml version=\"1.0\"?>\n" ;
print "<!-- -*- NEUROSPACES-XML -*- -->\n" ;
print "<neurospaces-xml version=\"0.2\"\n" ;
print "\txmlns:xsi='http://www.w3.org/1999/XMLSchema-instance'\n" ;
print "\t>\n" ;


# convert, mostly alphabetical on keyword.

# start of file is part of grammar, so let's process it here.
s{\A(\#![^\n]*)\n}{<!-- $1 -->\n}ig ;

# comment are removed during lexical analysis, not processed overhere.
# s{//([^\n]*)\n}{<!-- $1 -->\n}ig ;
# s{(/\*[^\*]*\*/)}{<!-- $1 -->\n}ig ;

s{end alias}{</alias>}ig ;
# public models : without namespace
s{alias\s+(\w+)(?!\S*:)\s+(\S+)}{<alias source=\"$1\" name=\"$2\">}ig ;
# private models : with namespace
s{alias\s+([^:]+)::(\S+)\s+(\S+)}{<alias namespace=\"$1\" source=\"$2\" name=\"$3\">}ig ;

s{end axon_hillock}{</axon-hillock>}ig ;
s{axon_hillock\s}{<axon-hillock>\n}ig ;

s{end bindables}{</bindables>}ig ;
s{bindables\s}{<bindables>\n}ig ;

s{end bindings}{</bindings>}ig ;
s{bindings\s}{<bindings>\n}ig ;

s{end cell}{</cell>}ig ;
s{cell\s+(\S+)}{<cell name=\"$1\">}ig ;

s{end channel}{</channel>}ig ;
s{channel\s+(\S+)}{<channel name=\"$1\">}ig ;

s{end child}{</child>}ig ;
s{child\s+(\S+)\s+(\S+)}{<child source=\"$1\" name=\"$2\">}ig ;

s{end hh_gate}{</hh-gate>}ig ;
s{hh_gate\s}{<hh-gate>\n}ig ;

s{end exponential_equation}{</exponential-equation>}ig ;
s{exponential_equation\s+(\S+)}{<exponential-equation name=\"$1\">}ig ;

s{end fiber}{</fiber>}ig ;
s{fiber\s}{<fiber>\n}ig ;

s{file\s+(\S+)\s+(\S+)\s+(\S+)}{<file namespace=\"$1\" name=$2 />}ig ;

s{end gate_kinetic_forward}{</gate-kinetic-forward>}ig ;
s{gate_kinetic_forward\s}{<gate-kinetic-forward>\n}ig ;

s{end group}{</group>}ig ;
s{(?<![-_])group\s+(\S+)}{<group name=\"$1\">}ig ;

s{end import}{</import>}ig ;
s{import\s}{<import>\n}ig ;

s{input\s+(\S+)}{<input name=\"$1\" />}ig ;

s{end algorithm}{</description-algorithm>}ig ;
s{algorithm\s+(\S+)\s+algorithm_instance\s+(\S+)[^\{]+([^\}]+)\}}{<description-algorithm xsi:type="description-algorithm" lookup=\"$1\" name=\"$2\">\n\t<description-algorithm-parameter xsi:type="description-algorithm-parameter" value=\"$3\}\" />}ig ;

s{end network}{</network>}ig ;
s{network\s+(\S+)}{<network name=\"$1\">}ig ;

s{(neurospaces)(\s+)(\S+)(\s+)(ndf|nnd|ncd)}{<!-- $1 $2 $3 $4 $5 -->}ig ;

s{output\s+(\S+)}{<output name=\"$1\">}ig ;

# non-function parameter
s{parameter\s*\(\s*(\S+)\s*=\s*(\S+)\s*\),?}{<parameter name=\"$1\" value=\"$2\" />}ig ;

s{end parameters}{</parameter-set>}ig ;
s{parameters\s}{<parameter-set>\n}ig ;

s{end pool}{</pool>}ig ;
s{pool\s+(\S+)}{<pool name=\"$1\">}ig ;

s{end population}{</population>}ig ;
s{population\s+(\S+)}{<population name=\"$1\">}ig ;

s{end private_models}{</private-models>}ig ;
s{private_models\s}{<private-models>\n}ig ;

s{end public_models}{</public-models>}ig ;
s{public_models\s}{<public-models>\n}ig ;

s{end randomvalue}{</randomvalue>}ig ;
s{randomvalue\s+(\S+)}{<randomvalue name=\"$1\">}ig ;

s{end segment(?>![-_])}{</segment>}ig ;
s{segment\s+(\S+)}{<segment name=\"$1\">}ig ;

s{end segment_group}{</segment-group>}ig ;
s{segment_group\s+(\S+)}{<segment-group name=\"$1\">}ig ;

s{(units)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)}{<!-- $1 $2 $3 $4 $5 $6 $7 $8 $9 -->}ig ;

s{(version)(\s+)(\S+)}{<!-- $1 $2 $3 -->}ig ;


# output file

print $_ ;


# end neurospaces-xml

print "</neurospaces-xml>" ;


