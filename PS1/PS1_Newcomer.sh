#! /bin/bash
cd ~/Documents/Stat242PSFiles/PS1_link/
IFS=: # internal field separator
type=526 # this specifies the type of crop

wget -O Data${type}.zip "http://data.un.org/Handlers/DownloadHandler.ashx?DataFilter=itemCode:"${type}"&DataMartId=FAO&Format=csv&s=countryName:asc,elementCode:asc,year:desc&c=2,3,4,5,6,7&" #this line downloads the data and renames the data to Apricots.zip

#this for loop extracts each zip file and appends .csv to the original zip file name
for i in *.zip #this line counts the number of zip files
do 
n=$(unzip -lqq $i | awk '{print $NF}')
e=${n#*.}
unzip $i && mv $n ${i%%_*}".$e"
rm $i
done

sed 's/, / /g' *.csv > UN_No_Comma.csv
sed 's/\"//g' UN_No_Comma.csv > UN_No_Quote.csv
grep -i + UN_No_Quote.csv > UN_World_Regions.csv
grep -i -v + UN_No_Quote.csv > UN_Countries.csv

yr=1965:1975:1985:1995:2005
grep -i -e ${yr} UN_Countries.csv > UN_Countries_${yr}a.csv
grep -i -v ${yr}.[0-9] UN_Countries_${yr}a.csv > UN_Countries_${yr}b.csv
rm UN_Countries_${yr}a.csv
grep -i -e Area -e Harvested UN_Countries_${yr}b.csv > UN_Countries_${yr}c.csv
rm UN_Countries_${yr}b.csv
sort -t',' -k6 -r UN_Countries_${yr}c.csv | head -5 > ${yr}_top5.txt
rm UN_Countries_${yr}c.csv
