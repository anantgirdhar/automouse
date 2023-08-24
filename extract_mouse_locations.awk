#!/usr/bin/awk -f

BEGIN {X = 0; Y = 0}
/^motion a\[0\] = [0-9]+ a\[1\] = [0-9]+/ {X = $4; Y = $7}
/^motion a\[0\] = [0-9]+/ {X = $4}
/^motion a\[1\] = [0-9]+/ {Y = $4}
/^button press/ {print "button " $3 " " X " " Y}
{fflush()}
# {print $0}
