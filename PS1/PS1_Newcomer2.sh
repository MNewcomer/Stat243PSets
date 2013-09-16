#! /bin/bash
wget -O index.txt http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/
grep -no 'a href="[^"]*.txt"' index.txt > names.txt #this looks for the pattern a href = textfile name
sed 's/\"//g' names.txt > names_no_quote.txt #this removes the extra " in the name
awk -F '=' '{print $2}' names_no_quote.txt > names_only.txt #save only the text after the = sign

i=$(wc -l names_only.txt) #this gathers the number of lines	  
i=${i% *} #this gets just the number from the output of wc
lines=$(seq 1 ${i}) #this creates a vector from 1 to i

for num in $lines; #this for loop looks at the first line and download the first text file and tells the use wich file is downloading then iterates.
do
	c=$(sed -n ${num}p names_only.txt)
	wget -q ${c} http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/${c}
	echo "Downloading the" ${c}" file"
done





