# Define your report 
system("RMDFILE=Newcomer_PS2") 
# Knit the Rmd to an Md file 
# Convert the MD file to Html 
system("Rscript -e 'require(knitr);require(markdown);knit('$RMDFILE.rmd', '$RMDFILE.md'); 
markdownToHTML('$RMDFILE.md', '$RMDFILE.html', options=c(\"use_xhml\"))'") 
require(knitr) 
require(markdown) 
knit("Newcomer_PS2.Rmd") 
markdownToHTML('Newcomer_PS2.md','Newcomer_PS2.html', options=c("use_xhml")) 
#pandoc -s Newcomer_PS2.html -o Newcomer_PS2.pdf --highlight-style=tango


system("pandoc -s Newcomer_PS2.md -o Newcomer_PS2.pdf --highlight-style=tango -S") #this command inbetween the quotes needs to be run in the command prompt.

#this code worked pretty well
# Load packages
require(knitr)
require(markdown)

setwd("D:/Users/Michelle Newcomer/Documents/GitHub/Stat243PSets/PS2")

# Create .md and .pdf files
filen <- "Newcomer_PS2"
knit(paste0(filen,".md"))
system(paste0("pandoc -s ", paste0(filen,".md"), " -t latex -o ", paste0(filen,".pdf"), "--highlight-style=tango -S"))

system("pandoc -s Newcomer_PS2.md -t latex -o Newcomer_PS2.pdf --highlight-style=tango -S")
