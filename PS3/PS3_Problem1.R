## Binomial theorem for n = 1/2 ;
## sqrt(1+x) = (1+x)^(1/2) = sum_{k=0}^Inf  choose(1/2, k) * x^k :
k <- 0:10 # 10 is sufficient for ~ 9 digit precision:
sqrt(1.25)
sum(choose(1/2, k)* .25^k)


n <- 10
k <- matrix(1:n)
p <- 0.3
s <- 0.5

n <- log(n)
k <- log(k)
p <- log(p)
s <- log(s)

#problem 1 using apply

a <- (k^k)*(n-k)^(n-k)
b <- (n^n)
c <- p^(k*s)
d <- (1-p)
e <- (n-k)
  
pmf <- (a/b)*((b/a)^s)*(c)*(d^(e*s))

system.time(c_pmf1 <- apply(pmf,2,sum))


#problem 1 fast way

pmf <- ((k^k)*(n-k)^(n-k)/(n^n))*(((n^n)/((k^k)*(n-k)^(n-k)))^s)*(p^(k*s))*((1-p)^((n-k)*s))

system.time(c_pmf2 <- sum(pmf))

#look at benchmark
benchmark(c_pmf1 <- apply(pmf,2,sum),c_pmf2 <- sum(pmf), replications = 10)


#the fast way
y <- matrix(sample(1:10, 12, replace = TRUE), nrow = 3, ncol = 4)     
yidot <- rowSums(y)
ydotj <- colSums(y)
e <- outer(yidot, ydotj) / sum(y)
sum( (y - e)^2 / e)


# the slow way
vals <- 0
n <- 50000
system.time({
  for(i in 1:n)
    vals[i] <- i
})

#how to preallocate
vals <- list(); length(vals) <- n
head(vals)