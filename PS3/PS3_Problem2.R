
# discrete random walk
n <- 1000 #number of steps
x0 <- 0 #starting point
y0 <- 0 #y starting point
s <- 4; # number of possibilities
res <- 1 # enter 1 to return only the final point or enter 0 to return the positions
pt0 <- c(x0,y0)
pts <- matrix(data=NA, nrow = n, ncol = 2) # initialize points
pos <- matrix(data=NA, nrow = n, ncol = 2) # initialize positions
set.seed(1)


makeWalk <- function(n, res){
  
  for (i in 1:n) {
    ptnew <- c(sample(-1:1,1),sample(-1:1,1)) #random points
    pts[i,1] <- ptnew[1]
    pts[i,2] <- ptnew[2]
    pos[,1] <- cumsum(pts[1:n,1])
    pos[,2] <- cumsum(pts[1:n,2])
    ptfin <- pos[n,1:2]
  }
  
  if (res == 1) {
    return(ptfin)
  }
  else {
    return(pos)
  }
}

Rprof("makeWalk.prof")
Rprof(NULL)
summaryRprof("makeWalk.prof")


#faster way
makeWalk2 <- function(n, res){
  ptnew <- matrix(data=NA, nrow = n, ncol = 2) # positions
  ptnew[,1] <- sample(-1:1,n, replace=T) #random points
  ptnew[,2] <- sample(-1:1,n, replace=T)
  pos[,1] <- cumsum(ptnew[1:n,1])
  pos[,2] <- cumsum(ptnew[1:n,2])
  ptfin <- pos[n,1:2]
 
  if (res == 1) {
    return(ptfin)
  }
  else {
    return(pos)
  }
  
}

benchmark(out <- makeWalk(n,res),out2 <- makeWalk2(n,res), replications = 10)




