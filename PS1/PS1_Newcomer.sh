#! /bin/bash
cd ~/Documents/Stat242PSFiles/PS1_linked/
wget -O Apricots526.zip "http://data.un.org/Handlers/DownloadHandler.ashx?DataFilter=itemCode:526&DataMartId=FAO&Format=csv&s=countryName:asc,elementCode:asc,year:desc&c=2,3,4,5,6,7&"
unzip Apricots526.zip
sed ’s/, / /g’ UNdata_Export_20130908_182447415.csv > UN_No_Comma.csv
sed ’s/\"//g’ UN_No_Comma.csv > UN_No_Quote.csv
grep -i + UN_No_Quote.csv > UN_World_Regions.csv
