
####----------------------####
## -- Lab 1 Matt Kearney 
## -- Updated Dec 2012 
## -- Alex Hughes
####----------------------####


##-- Remove Objects 
rm(list=ls())

##-- Create Array
data<-array(NA,dim=c(1000,4)) # No Data, 1000 rows, 4 columns


##-- Demonstration 1:
##-- Simulating a Probit Model
##-- Generate Data Based on Assumptions
#for(i in 1:1000){
n<-1000
e<-rnorm(n)
x<-rnorm(n)
a<-0.5
b<-0.4
y<-a+b*x+e
y<-ifelse(y<=0,0,1)

##-- Demonstration 2:
##-- Estimating a Probit Model with Optim

#help(optim)

##-- Write a log-likelihood function.  The errors
##-- are normal in this case, so we use the probit
##-- function. Note that the command we used to
##-- optimize wants a function to optimize, so we
##-- write a function in R.

probit <- function(beta,X,y)
{
  X<-cbind(1,X)
  phi <- pnorm(X %*% beta)
  return(sum(y * log(phi) + (1-y) * log(1-phi)))
}

##-- Plug our data and the log-likelihood function into the optim command.

out <- optim(
  par = c(0,1),
  fn = probit,
  y = y,
  X = x,
  method="BFGS",
  control=list(fnscale = -1),
  hessian = TRUE
)
out

##-- Note what we have: parameter estimtes;
##-- LLikelihood; iterations; convergence
##-- error?; miscelaneous messages; the
##-- hessian matrix

##-- Recall: The Hessian
browseURL("http://en.wikipedia.org/wiki/Hessian_matrix")

##-- Landscape of local Likelihood; Used to caalculate
##-- VCOV Matrix, which is in turn used to calc
##-- standard errors

vcov<-solve(-out$hessian)
vcov
se<-diag(sqrt(vcov))

##-- t-statistics
z.score<-out$par/se

##-- Hypothesis Test
hypo.test <- function(point.estimate = NULL, se.estimate = NULL, alpha = 0.05)
{
  Coef <- NULL; Std.err <- NULL; Z <- NULL; p.val <- NULL; test <- NULL
  Coef <- round(point.estimate,2)
  Std.err <- round(se.estimate,3)
  Z <- round(point.estimate/se.estimate,2)
  p.val <- round(2*(1-pnorm(point.estimate/se.estimate)),3)
  test <- ifelse(2*(1-pnorm(point.estimate/se.estimate))<alpha,"Reject","Fail2Rej")
  result <- data.frame(Coef,Std.err,Z,p.val,test)
  colnames(result) <- c("Coef", "Std.err", "Z-value", "P-value", "Hyp-test")
  print(result)
}

##-- Demonstration 2:
##-- Estimating a Probit Model with glm

est.glm <- glm(y ~ x, family=binomial(link="probit"))
summary(est.glm)

##-- Demonstration 3:
##-- A race!

time <- proc.time()
out <- optim(
  par = c(0,1),
  fn = probit,
  y = y,
  X = x,
  method="BFGS",
  control=list(fnscale = -1),
  hessian = TRUE
)
y1 <- proc.time()-time

time <- proc.time()
est.glm <- glm(y ~ x, family=binomial(link="probit"))
y2 <- proc.time()-time

cbind(y1,y2)

####-----------------------------------------------####
##-- Workshop 1: Estimating a Logit Model with glm --##
####-----------------------------------------------####

##-- Fit an Approprite model to the following data --##

dat <- read.csv(file = "http://polisci2.ucsd.edu/dhughes/cars.csv")

##-- Now that you have the code to estimate a probit,
##-- what if we mistakenly assumed the error term was
##-- actually a logit?  Estimate beta-hat for the same
##-- data, but now see what happens if you estimate a
##-- logit error term.

##-- How would you do this if you wanted to pass it
##-- through optim to mechanically optimize? 

#	data[i,3:4]<-round(result,4)[2,1:2]

#Marginal Effects

#pnorm(t(as.matrix(out$par))%*%c(1,mean(x)))*t(as.matrix(out$par))%*%c(1,mean(x))


####----------------------------------------####
##-- Workshop 2: Comparing Logit and Probit --##
####----------------------------------------####


