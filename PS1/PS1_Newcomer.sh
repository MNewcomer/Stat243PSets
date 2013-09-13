#! /bin/bash
echo "Please enter the code # of the type of crop then press enter: "
read input_variable
echo "You entered: $input_variable"
IFS=: # internal field separator
type=$input_variable # this specifies the type of crop

# the wget grabs the zip file and the -O allows the name to be changed
wget -O Data${type}.zip "http://data.un.org/Handlers/DownloadHandler.ashx?DataFilter=itemCode:"${type}"&DataMartId=FAO&Format=csv&s=countryName:asc,elementCode:asc,year:desc&c=2,3,4,5,6,7&" #this line downloads the data and renames the data to Apricots.zip

# this for loop extracts each zip file and appends .csv to the original zip file name
for i in *.zip #this line counts the number of zip files
do 
	n=$(unzip -lqq $i | awk '{print $NF}') #-l unzips the files names and -qq does it quietly while only giving the file names inside the zip to the screen. This then pipes the information to awk with searches the output to find the name of the fields
	e=${n#*.} # this line looks at the file name inside of the zip file and removes everything in front of the . and saves the csv portion
	unzip $i && mv $n ${i%%.*}".$e" #this line unzips the file and renames the unzipped file to be the original portion plux csv
	rm $i #Thi then removes the original zip file because it has already been extracted
done

sed 's/, / /g' *.csv > UN_No_Comma.csv #this removes the comma
sed 's/\"//g' UN_No_Comma.csv > UN_No_Quote.csv #this removes the extra " in the country name
grep -i + UN_No_Quote.csv > UN_World_Regions.csv #this separates the regions from the countries and save the regions 
grep -i -v + UN_No_Quote.csv > UN_Countries.csv #this separates the countries and saves countries

yrs=1965:1975:1985:1995:2005

for yr in $yrs
do
	grep -i -e ${yr} UN_Countries.csv > UN_Countries_${yr}a.csv #this grabs entries that have the year pattern
	grep -i -v ${yr}.[0-9] UN_Countries_${yr}a.csv > UN_Countries_${yr}b.csv #grabs the countries that do no have the pattern year. because that means it is a double and represents the acreage
	rm UN_Countries_${yr}a.csv
	grep -i -e Area -e Harvested UN_Countries_${yr}b.csv > UN_Countries_${yr}c.csv #grabs only the entries with words area and harvested
	rm UN_Countries_${yr}b.csv
	sort -t',' -k6 -r UN_Countries_${yr}c.csv | head -5 > ${yr}_top5.txt #sorts the 6th column, puts it in reverse order, then pipes the output to a text file
	rm UN_Countries_${yr}c.csv
	cat ${yr}_top5.txt
done
