load("ps5prob5.RData")

names(meanpts) <- c("time", "value")
# this creates the function, meanfunc()
meanfunc <- with(list(spf = splinefun(meanpts$time, meanpts$value, method = "natural"), 
                 minday = min(meanpts$time), 
                 maxday = max(meanpts$time)),
function(theta, times){
  j=1:nrow(times)
  rescaled[j,1] <- times[j,1]/theta$lambda
  if(any(rescaled < minday | rescaled > maxday))
    warning("Extrapolating beyond the range of the template data")
  mean[j,1] <- theta$kappa * spf(rescaled[j,1])
  return(mean)
})

# now you can evaluate the mean function as "meanfunc(theta, time)" where
# theta should be a named vector of parameters, and
# time should be a vector of time values at which you want to evaluate the mean

# if you want theta to be a list or to be referred to by number you can modify the code in the function body above

theta <- data.frame(0,0)
theta[1,]<- c(1,3)
names(theta) <- c("lambda","kappa")
times <- data.frame(unique(data$time))
rescaled <- matrix(NA,nrow=nrow(times))
mean <- matrix(NA,nrow=nrow(times))

mean_pts <- meanfunc(theta,times)