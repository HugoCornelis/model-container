#! /bin/sh
# Get the requested urls
left=`echo $QUERY_STRING | sed -e 's/^.*left=\([^&]*\).*$/\1/g'`
right=`echo $QUERY_STRING | sed -e 's/^.*right=\([^&]*\).*$/\1/g'`
# Translate %23 to #
left=`echo $left | sed -e 's/%23/#/g'`
right=`echo $right | sed -e 's/%23/#/g'`
echo 'Content-type: text/html'
echo ''
echo ''
echo '<HTML><HEAD><TITLE>Neurospaces Hypersourcer</TITLE></HEAD>'
echo '<frameset cols="25%,75%">'
echo "<frame src=\"$left\" name=\"packageFrame\">"
echo "<frame src=\"$right\" name=\"classFrame\">"
echo '</frameset>'
echo '</html>'

