# Problem 5

# a) 
#in bash
export OMP_NUM_THREADS=5


#in R
library(parallel)
set.seed(1)
p <- c(1:6) #number of threads
n <- 4000
mat <- matrix(rnorm(n^2), nrow = n, ncol = n) # positions
nSims <- 60

matMult <- function(mat){
  mn <- mat %*% mat
  return(mn)
}


time <- system.time(
  res <- matMult(mat)
)

#elapsed <- c()
elapsed[6] <- time[3]
save.image(file = "PS5.Rdata")

load(file = "C:/cygwin64/home/Michelle Newcomer/Stat242PSFiles/PS3_link/PS5.Rdata")

plot(p, elapsed, xlab = "Number of Threads", ylab = "Time in seconds")
lines(p, elapsed)


# b)

require(parallel) # one of the core R packages
require(doParallel)
# require(multicore); require(doMC) # alternative to parallel/doParallel
# require(Rmpi); require(doMPI) # when Rmpi is available as the back-end
require(foreach)
library(foreach)
library(iterators)

set.seed(1)
n <- 4000
nCores <- 8  
registerDoParallel(nCores) 
mat <- matrix(rnorm(n^2), nrow = n, ncol = n) # positions

mn <- matrix(data=NA, nrow = n, ncol = n) # initialize points

matMult <- function(mat,i, mn){
  for (j in 1:n){
  mult <- mat[i,] * mat[,j]
  mn[i,j] <<- sum(mult, na.exclude=TRUE)
  }
  return(mn[i,])
}

system.time(out <- foreach(i = 1:n, .combine = c) %dopar% {
  outSub <- matMult(mat, i, mn)
  outSub # this will become part of the out object
}
)

finalMat <- matrix(out,length(out)/n,byrow=T)

