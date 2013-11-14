
require(parallel) 
require(doParallel)
library(foreach)
library(iterators)
taskFun <- function(a.sub,b){
  c.sub <- a.sub %*% b
  return(c.sub)
}

p <- 8  
registerDoParallel(p) 

n <- 40
a <- matrix(rnorm(n*n),n)
b <- matrix(rnorm(n*n),n)

c3 <- foreach(i = 1:p, .inorder=TRUE, .combine=rbind) %dopar% {
  c.sub <- taskFun(a[(n*(i-1)/p+1):(n*i/p),],b)
  c.sub
}

