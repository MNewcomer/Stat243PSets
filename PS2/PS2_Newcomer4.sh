#! /bin/bash
wget -O index.txt http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/
grep -no 'a href="[^"]*.txt"' index.txt > names.txt #this looks for the pattern a href = textfile name
sed 's/\"//g' names.txt > names_no_quote.txt #this removes the extra " in the name
awk -F '=' '{print $2}' names_no_quote.txt > names_only.txt #save only the text after the = sign