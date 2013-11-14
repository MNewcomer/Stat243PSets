# Problem 1--------------------------------------------------------------

#Please see the attached pages for the calculations
options(digits=22)
x <- 2^53
class(x)
as.integer(x)

y <- (2^53)-1
class(y)
as.integer(y)

z <- (2^53)+1
class(z)
as.integer(z)

a <- (2^53)+2
class(a)
as.integer(a)


# Problem 2-------------------------------------------------------------
# 2.a
d<-1.000000000001
d

# 2.b
b<-1+10000*(1e-16)
b

c<-1+1e-12
c

x<-c(1,rep(1e-16,10000))
y<-sum(x)
y

# 2.c python section
import decimal
import numpy as np 

from decimal import *

getcontext().prec = 22

v = np.r_[1,[1e-16]*10000]
vsum = sum(v)

# end of python section

# 2.d begin R part
e<-0
x<-c(1,rep(1e-16,10000)) # for loop with the 1 first
for (i in 1:(length(x)-1)){
  e[1]<-x[1]
  e[i+1]<-x[i+1]+e[i]
}
e[length(e)]

e<-0
x<-c(rep(1e-16,10000),1) #for loop with the 1 value last
for (i in 1:(length(x)-1)){
  e[1]<-x[1]
  e[i+1]<-x[i+1]+e[i]
}
e[length(e)]

#python section
import decimal
import numpy as np 

from decimal import *
  
getcontext().prec = 22


# the section below places the 1 first
v = np.r_[1,[1e-16]*10000]

e = [0]*len(v)
n=len(v)-1
for i in range(n):
  e[0] = v[0]
  e[i+1]=v[i+1]+e[i]

e[len(e)-1]

# the section below places the 1 last
v = np.r_[[1e-16]*10000,1]

e = [0]*len(v)
n=len(v)-1
for i in range(n):
  e[0] = v[0]
  e[i+1]=v[i+1]+e[i]

e[len(e)-1]

# end of python section



# Problem 3--------------------------------

n<-c(20,200,2000,3000,4000,5000,6000)
times<-0
max.size<-0
size<-0

j=0
for (i in n){
  j=j+1
  X <- crossprod(matrix(rnorm(i^2), i))
  mem1<-gc()
  time<-system.time(U <- chol(X)) # U is upper-triangular
  mem2<-gc()
  times[j]<-time[3]
  max.size[j]<-mem2[10]*8/1e6
  size[j]<-i
}

plot(max.size, times, xlab = "Size of U (MB)", ylab = "Time in seconds")
lines(max.size, times)

#Problem 4----------------------------------------------

# a) using solve()%*%y, solve(X,y), and the Cholesky decomposition
n<-5000
set.seed(1)
X <- crossprod(matrix(rnorm(n^2), nr=n)) #This does t(X)*X producing a p.d. matrix
set.seed(2)
y <- c(rnorm(n))
kappa(X, exact = TRUE) 

#part 1 using solve()%*%y

system.time(b1 <- solve(X) %*% y)

#part 2 using solve(X,y)

system.time(b2 <- solve(X,y))

#part 3 using the Cholesky decomposition

system.time(U <- chol(X)) #produces U which is upper triangular
system.time(b3<-backsolve(U, backsolve(U, y, transpose = TRUE)))

b1[1:5]
b2[1:5]
b3[1:5]

#Problem 5------------------------------------------------
#solved using the Cholesky decomposition
options(digits=3)


cholDecomp<-function(n) {
  set.seed(1)
  X <- crossprod(matrix(rnorm(n^2), nr=n)) #This does t(X)*X producing a p.d. matrix
  set.seed(2)
  Y <- c(rnorm(n))
  
  U <- chol(X) #produces U which is upper triangular
  Q<-t(U) %*% U
  
  b1<-backsolve(U, backsolve(U, Y, transpose = TRUE))
  b2<-solve(Q,Y)
  return(b1)
}

n=100
b1<-cholDecomp(n)

b1[1:5]

#solved using eigendecomposition

eigDecomp<-function(n){
  set.seed(1)
  X <- crossprod(matrix(rnorm(n^2), nr=n)) #This does t(X)*X producing a p.d. matrix
  set.seed(2)
  Y <- c(rnorm(n))
  E<-eigen(X)
  S<-E$vectors
  L<-matrix(rep(E$values,n),nr=n)
  
  #(S*sqrt(t(L)))%*%(sqrt((L))*t(S))
  P<-S*sqrt(t(L))
  C<- t(X)%*%P%*%t(P)%*%X
  D<- t(X)%*%P%*%t(P)%*%Y
  b3<-solve(C,D)
  return(b3)
}

b3<-eigDecomp(n)
b3[1:5]

#Problem 6------------------------------------------------

#Approach A
require(parallel) 
require(doParallel)
library(foreach)
library(iterators)

n <- 400
p <- 8  
registerDoParallel(p) 
times<-0
max.size<-0
size<-0


mat1 <- matrix(rnorm(n*n),n)
mat2 <- matrix(rnorm(n*n),n)

mat3 <- foreach(i = 1:p, .inorder=TRUE, .combine=cbind) %dopar% {
  mat1 %*% mat2[,(n*(i-1)/p+1):(n*i/p)]
}


#Approach B

require(parallel) 
require(doParallel)
library(foreach)
library(iterators)

n <- 400
p <- 8  
registerDoParallel(p) 

mat1 <- matrix(rnorm(n*n),n)
mat2 <- matrix(rnorm(n*n),n)
mat3 <- c()

matMult <- for(i in 1:p) {
  a <- mat1[(n*(i-1)/p+1):(n*i/p),] 
  c <- foreach(j = 1:p, .inorder=TRUE, .combine=cbind) %dopar% {
    a %*% mat2[,(n*(j-1)/p+1):(n*j/p)]
  }
  mat3 <-rbind(c,mat3)
}

