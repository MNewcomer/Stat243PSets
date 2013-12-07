#Using the Newton-Raphson method
f <- function(beta,X,y) {
  #X<-cbind(1,X)
  t <- X %*% beta
  phi <- pnorm(t)
  pdf <- 1/sqrt(2*pi)*exp(-1/2*(t)^2)
  out <- return(sum(log(y*(phi))+(1-y)*(1-phi)))
}

fp <- function(beta,X,y) {
  #X<-cbind(1,X)
  t <- X %*% beta
  phi <- pnorm(t)
  pdf <- 1/sqrt(2*pi)*exp(-1/2*(t)^2)
  out <- return(rowSums((y*pdf/phi-(1-y)*pdf/(1-phi))*X))
  
}
fpp <- function(beta,X,y) {
  #X<-cbind(1,X)
  t <- X %*% beta
  phi <- pnorm(t)
  pdf <- 1/sqrt(2*pi)*exp(-1/2*(t)^2)
  term1 <- (pdf+t*phi)/(phi^2)
  term2 <- (pdf-t*(1-phi))/((1-phi)^2)
  out <- return(-sum(pdf*(y*term1+(1-y)*term2))*X*X)
}

solve(fpp(betat[,1],X,Y),fp(betat[,1],X,Y))


#different method
n=10
beta0=matrix(c(1,1,1,1),4,1)
X=matrix(rnorm(n*4),4,10)
Y<-t(X) %*% beta0
Y<-ifelse(Y<=0,0,1)

betat<-matrix(c(1,0,0,1),4,1)
diff=3

while (diff>0.05){
  t <- t(X) %*% betat
  phi <- pnorm(t)
  pdf <- 1/sqrt(2*pi)*exp(-1/2*(t)^2)
  mlltest<-(Y-phi)/(phi*(1-phi))*pdf
  model<-lm(mlltest~0+t(X))
  beta_new<-model[[1]]
  diff<-sum(abs(betat-beta_new))
  betat<-beta_new
}

