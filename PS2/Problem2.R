
# original
sapply(0:3, function(x) {
  ls(envir = sys.frame(x))
}
)

# break this down into different parts
fun <- function(x) {
  ls(envir = sys.frame(x))
  print(sys.frame(x))
}


#try to reproduce the behavior
#use sapply with each number
a <- sapply(0, fun)
b <- sapply(1, fun)
d <- sapply(2, fun)
e <- sapply(3, fun)

#look at other environments
x <- environment(fun)
parent.env(x)

x <- environment(sys.frame(0))
parent.env(x)



