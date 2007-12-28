#!/usr/bin/perl -w

use strict;

# print 'Content-type: text/html';
# print '';
# print '';
# print '<HTML><HEAD><TITLE>c.cgi</TITLE></HEAD>';
# print '<body></body>';
# print '</html>';

use IO::File;

my $log = IO::File->new(">>/tmp/persistent/neurospaces/log");

use Data::Dumper;

my $date = gmtime();

my $entry = $date . "\n" . Dumper(\%ENV);

print $log "------\n$entry";

use CGI ':standard';

print
  header(),
  start_html('c'),
  h1("e"),
#   `pwd`,
#   "\n",
#   "UID: $<, EUID: $>\n",
  "\n\n";


