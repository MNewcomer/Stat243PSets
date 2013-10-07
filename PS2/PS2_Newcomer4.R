library(stringr)
text <- scan("Shakespeare.txt", character(0), quote = NULL, sep = "\t") 

start <- as.integer(grep("^[[:digit:]]{4}", text, perl = TRUE))
end <- as.integer(grep("THE END", text, perl = TRUE))
len_s <- length(start)

#places each play into a list
plays <- list()

for (i in 2:(len_s-1)) {
  plays[[i-1]] <- text[start[i]:end[i]]
}

plays[[4]] <- NULL #this removes the fourth play which is problematic
len_p <-length(plays)

#places the year into a vector
year <- c()
for (i in 1:len_p) {
  year[i] <- as.integer(plays[[i]][[1]])
}

#places the title into a vector
title <- c()
for (i in 1:len_p) {
  title[i] <- as.character(plays[[i]][[2]])
}

#this function finds all of the acts and scenes
acts <- c()

findActs <- function(x) {
  numActsTmp <- (grep("^ACT", plays[[x]], perl = TRUE, ignore.case = TRUE)) 
  len_a <- length(numActsTmp)
  
  for (i in 1:len_a) { 
  acts[i] <- as.character(plays[[x]][[numActsTmp[i]]])
  }
  
  return(acts)
}

#count the number of acts and scenes for each play. Counting the number of times scene 1 
#occurs provides the number of Acts. Counting the number of time Act appears provides the 
#number of scenes
numScenes <- c()
numActs <- c()

for (i in 1:len_p) {
  tmp <- findActs(i)
  numActs[i] <- length(grep("Scene 1|Scene I|(?<=\\SC_)([1]$)",tmp, perl = TRUE, ignore.case = TRUE))
  numScenes[i] <- length(tmp)
}


#find their chunks of speech

tmp_chunks <- c()

findChunks <- function(x) {
   tmp_chunks <- grep("^([[:space:]]{2,}+[[:upper:]]{4,30}\\.)", plays[[x]], perl = TRUE, ignore.case = TRUE)
   return(tmp_chunks)
}

chunks <- list()
for (i in 1:length(plays)) {
  chunks[[i]] <- findChunks(i);
}

len_chunk <- as.integer(lapply(chunks, length))

#formatting chunks of dialogue and binding lines of speech together
lines <- c()
replace <- c()
aggregate <- c()

findPeople <- function (x) {
  for (i in 1:length(chunks[[x]])) {
    lines <- plays[[x]][chunks[[x]][[i]]:(chunks[[x]][[i]]-1)]
    replace <- str_replace_all(string=lines, pattern="  ", repl="")
    aggregate[[i]] <- paste(replace, collapse = ' ')
   }
  return(aggregate)
}

speech <- list()
for (i in 1:length(plays)) {
  speech[[i]] <- findPeople(i)
}

# finding the individual speakers and their chunks of text
#this function places each person into a list, and places each person's spoken text into a list.
unique_Speech <- list()
unique_lines <- list()
len_unique <- c()
len_numPeop <- c()
unique <- list()
unique_peop <- list()

uniqueSpeech <- function(x) {
  matches <- gregexpr("^([[:upper:]]{4,20}\\.)", speech[[x]])
  names <- regmatches(speech[[x]], matches)
  unique <- unique.default(sapply(names, unique))
  len_unique <- length(unique)
  
    for (i in 1:len_unique) {
      lines <- as.integer(grep(unique[i], speech[[x]], perl = TRUE, ignore.case = TRUE))
      unique_lines[[i]] <- speech[[x]][lines[]]
    }
  result = c(unique_lines,len_unique)
  return(result)
}


for (i in 1:length(speech)) {
  func <- uniqueSpeech(i)
  len_numPeop[i] <- as.integer(func[length(func)])
  unique_Speech[[i]] <- func[1:(length(func)-1)]
}

# count the number of words, find the average and standard deviation
word_count <- sapply(gregexpr("\\W+", unique_Speech), length) + 1

word_chunk <- c()
word_avg <- c()
word_sd <- c()

for (i in 1:length(unique_Speech)) {
  word_chunk <- sapply(gregexpr("\\W+", unique_Speech[[i]]), length) + 1
  word_avg[i] <- sum(word_chunk/length(unique_Speech[[i]]))
  word_sd[i] <- sd(word_chunk)
}

df <- data.frame(year,title,numActs,numScenes,len_chunk,len_numPeop, word_count,word_avg,word_sd)



