library(rbenchmark)
Rprof(tf <- "rprof.log", memory.profiling=TRUE)

n=1e7
xvar <- sample(c(seq(1, 20, by = 1), NA), n, replace = TRUE)
yvar <- sample(c(seq(1, 20, by = 1), NA), n, replace = TRUE)

#fastcount with a dummy function for res
fastcount <- function(xvar, yvar) {
  nalineX <- is.na(xvar)
  nalineY <- is.na(yvar)
  xvar[nalineX | nalineY] <- 0
  yvar[nalineX | nalineY] <- 0
  useline <- !(nalineX | nalineY)
  # Table must be initialized for -1's
  tablex <- numeric(max(xvar) + 1)
  tabley <- numeric(max(yvar) + 1)
  stopifnot(length(xvar) == length(yvar))
  pf <- parent.frame()
  ls(sys.frame(-1))
  gc(pf)
  res <- function(){
    tablex <<- as.integer(tablex)
    tabley <<- as.integer(tabley)
    as.integer(xvar)
    as.integer(yvar)
    as.integer(useline)
    as.integer(length(xvar))
  }

  xuse <- which(tablex > 0)
  xnames <- xuse - 1
  resb <- rbind(tablex[xuse],tabley[xuse])
  colnames(resb) <- xnames
  gc()
  ls.sizes()
  return(resb)
}

ls.sizes <- function(howMany = 10, minSize = 1) {
  pf <- parent.frame()
  obj <- ls(pf) # or ls(sys.frame(-1))
  objSizes <- sapply(obj, function(x) {
    object.size(get(x, pf))
  })
  # or sys.frame(-4) to get out of FUN, lapply(), sapply() and sizes()
  objNames <- names(objSizes)
  howmany <- min(howMany, length(objSizes))
  ord <- order(objSizes, decreasing = TRUE)
  objSizes <- objSizes[ord][1:howMany]
  objSizes <- objSizes[objSizes > minSize]
  objSizes <- matrix(objSizes, ncol = 1)
  rownames(objSizes) <- objNames[ord][1:length(objSizes)]
  colnames(objSizes) <- "bytes"
  cat("object")
  print(format(objSizes, justify = "right", width = 11), quote = FALSE)
}

out <- fastcount(xvar,yvar)
summaryRprof(tf)


# c) rewrite the function to use less memory

fastcount2 <- function(xvar, yvar) {
  nalineX <- which(is.na(xvar))
  nalineY <- which(is.na(yvar))
  xvar[nalineX] <- 0
  yvar[nalineY] <- 0
  useline <- !(nalineX | nalineY)
  # Table must be initialized for -1's
  tablex <- numeric(max(xvar) + 1)
  tabley <- numeric(max(yvar) + 1)
  stopifnot(length(xvar) == length(yvar))
  pf <- parent.frame()
  ls(sys.frame(-1))
  gc(pf)
  res <- function(){
    tablex <<- as.integer(tablex)
    tabley <<- as.integer(tabley)
    as.integer(xvar)
    as.integer(yvar)
    as.integer(useline)
    as.integer(length(xvar))
  }
  
  xuse <- which(tablex > 0)
  xnames <- xuse - 1
  resb <- rbind(tablex[xuse],tabley[xuse])
  colnames(resb) <- xnames
  gc()
  ls.sizes()
  return(resb)
}

out2 <- fastcount2(xvar,yvar)
summaryRprof(tf)