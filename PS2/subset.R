#! /usr/bin/Rscript

args <- commandArgs(TRUE)

numericArg <- as.numeric(args[1])
charArg <- read.table('linesForR.txt', sep="\t",head = FALSE)
class(charArg)

# this set of code initializes the vectors
BEDRMS <- c(rep(NA,args[1]))
FINC <- c(rep(NA,args[1]))
NPF <- c(rep(NA,args[1]))
ROOMS <- c(rep(NA,args[1]))
HHT <- c(rep(NA,args[1]))
P18 <- c(rep(NA,args[1]))
P65 <- c(rep(NA,args[1]))


for (i in 1:args[1]) {

BEDRMS[i] <- as.numeric(substring(charArg[i,1], 124,124))
FINC[i] <- as.numeric(substring(charArg[i,1], 259, 266))
NPF[i] <- as.numeric(substring(charArg[i,1], 218, 219))
ROOMS[i] <- as.numeric(substring(charArg[i,1], 122, 122))
HHT[i] <- as.factor(substring(charArg[i,1], 213, 213))
P18[i] <- as.numeric(substring(charArg[i,1], 216, 217))
P65[i] <- as.numeric(substring(charArg[i,1], 214, 215))
}
 
subset <- data.frame(BEDRMS,FINC,NPF,ROOMS,HHT,P18,P65) 
subset

