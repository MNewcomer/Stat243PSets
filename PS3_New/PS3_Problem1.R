#! /usr/bin/Rscript

require(rbenchmark)
library(rbenchmark)

n <- 2000
k <- matrix(0:n)
p <- 0.3
s <- 0.5


#problem 1 using the log transform

pmfFunc1 <- function(n,k,p,s) {
  logpmf <- lfactorial(n)-lfactorial(k)-lfactorial(n-k)+k*log(k)+(n-k)*log(n-k)-n*log(n)+n*s*log(n)-s*k*log(k)-s*(n-k)*log(n-k)+s*k*log(p)+(n-k)*s*log(1-p)
  
  if (k[1] == 0){
    logpmf[k==0]<-0
  }
  
  if (k[n+1] == n){
    logpmf[k==n]<-0
  }
  
  expon <- exp(logpmf)
  pmf <- apply(expon,2,sum)
  return(pmf)
}


# this function below uses a vectorized version of sum
pmfFunc2 <- function(n,k,p,s) {
  logpmf <- lfactorial(n)-lfactorial(k)-lfactorial(n-k)+k*log(k)+(n-k)*log(n-k)-n*log(n)+n*s*log(n)-s*k*log(k)-s*(n-k)*log(n-k)+s*k*log(p)+(n-k)*s*log(1-p)
  
  if (k[1] == 0){
    logpmf[k==0]<-0
  }
  
  if (k[n+1] == n){
    logpmf[k==n]<-0
  }
  
  expon <- exp(logpmf)
  pmf <- sum(expon)
  return(pmf)
}

#problem 1 without log transforming
pmf <- (factorial(n)/(factorial(k)*factorial(n-k)))*((k^k)*(n-k)^(n-k)/(n^n))*(((n^n)/((k^k)*(n-k)^(n-k)))^s)*(p^(k*s))*((1-p)^((n-k)*s))
warnings(last.warning)

# b) look at benchmark 2 using the 2 different methods
benchmark(cpmf1 <- pmfFunc1(n,k,p,s),cpmf2 <- pmfFunc2(n,k,p,s), replications = 100)


#c) use RProf to assess where the code take the longest

Rprof("pmfFunc2.prof")
out <- pmfFunc2(n,k,p,s)
Rprof(NULL)
summaryRprof("pmfFunc2.prof")


