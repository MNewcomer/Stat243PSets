#make an Reference class for the random walk

rw <- setRefClass("rw",
  fields = list(
    n = "numeric", 
    x0 = "numeric",
    y0 = "numeric",
    s = "numeric",
    res = "numeric",
    pt0 = "numeric",
    pts = "matrix",
    pos = "matrix",
    ptnew = "matrix",
    ptfin = "numeric"),
                      
  methods = list(
    initialize = function(n,x0,y0,s,res){
      n <<- n #number of steps
      x0 <<- x0 #starting point
      y0 <<- y0 #y starting point
      s <<- s; # number of possibilities
      res <<- res # enter 1 to return only the final point or enter 0 to return the positions
      pts <<- matrix(data=NA, nrow = n, ncol = 2) # initialize points
      pos <<- matrix(data=NA, nrow = n, ncol = 2) # positions
      makeWalk2(n,res)
    },
    
    makeWalk2 = function(n, res){
      set.seed(1)
      pt0 <<- c(x0,y0)
      ptnew <- matrix(data=NA, nrow = n, ncol = 2) # local only 
      ptnew[,1] <- sample(-1:1,n, replace=T) #random points
      ptnew[,2] <- sample(-1:1,n, replace=T)
      pos[,1] <<- cumsum(ptnew[1:n,1])+pt0[1]
      pos[,2] <<- cumsum(ptnew[1:n,2])+pt0[2]
      ptfin <<- pos[n,1:2]
      
      if (res == 1) {
        return(ptfin)
      }
      else {
        return(pos)
      }
      
    },
    
    changeStart = function(newx,newy){
      x0 <<- newx
      y0 <<- newy
      makeWalk2(n,res)
    }
      
    )
)

# n <- 1000 #number of steps
# x0 <- 0 #starting point
# y0 <- 0 #y starting point
# s <- 4; # number of possibilities
# res <- 1 # enter 1 to return only the final point or enter 0 to return the positions


master <- rw$new(30,0,0,4,1)
head(master$field('pos'))
head(master$field('ptfin'))

master$changeStart(5,7)
head(master$field('pos'))
tail(master$field('pos'))
head(master$field('ptfin'))

plot(master$field('pos')[,1], master$field('pos')[,2], type = 'l',xlab='x', ylab='y')




