a <- 4
genFun1 <- function() rnorm(a)
wrapFun1 <- function(data) {
  a <- length(data)
  return(genFun1())
}
wrapFun1(5)

a <- 8
genFun2 <- function(x) rnorm(x)
wrapFun2 <- function(data) {
  a <- length(data)
  return(genFun2(x = a))
}
wrapFun2(1:10)

a <- 8
genFun3 <- function(x = a * 2) rnorm(x)
wrapFun3 <- function(data) {
  a <- length(data)
  return(genFun3())
}
wrapFun3(10)