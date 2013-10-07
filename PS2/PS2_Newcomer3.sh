#! /bin/bash
echo "Please enter the number of samples then press enter: "
read input_n
echo "You entered: $input_n. Please wait for approximately 3 minutes."
IFS=: # internal field separator
number=$input_n # this specifies the number of samples
set seed = 1

# this next line does many things. First it looks at the .bz2 files and grabs only the lines that start with H. Then it reads the lines and appends a random number to each line. 
# It sorts the lines and then cuts off the appended numbers and obtains only the first number of lines that was specified by the user.
 # this particular line takes about 3 minutes

bzcat PUMS5_06.TXT.bz2 | grep ^H | while IFS= read -r f; do printf "%05d %s\n" "$RANDOM" "$f"; done | sort -n | cut -c7- | head -n $number > linesForR.txt

./subset.R $number

