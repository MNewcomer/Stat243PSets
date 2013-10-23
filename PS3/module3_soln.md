% R bootcamp, Module 3: Breakout solutions
% August 2013, UC Berkeley
% Chris Paciorek




# Problem 1

**To see this problem with the equations below rendered correctly, see module3_calc.html (the non-slide version).**

Suppose we have two categorical variables and we conduct a hypothesis test of independence. The chi-square statistic is: 

\[
\chi^2 = \sum_{i=1}^{n}\sum_{j=1}^{m} \frac{(y_{ij} - e_{ij})^2}{e_{ij}}, 
\] 

where $e_{ij} = \frac{y_{i\cdot} y_{\cdot j}}{y_{\cdot \cdot}}$, with $y_{i\cdot}$ the sum of the values in the i'th row, $y_{\cdot j}$ the sum of values in the j'th column, and $y_{\cdot\cdot}$ the sum of all the values. Suppose I give you a matrix in R with the $y_{ij}$ values. Compute the statistics without *any* loops.

You can generate a test matrix as: `y <- matrix(sample(1:10, 12, replace = TRUE), nrow = 3, ncol = 4)`.

1. Assume you have the *e* matrix. How do you compute the statistic without loops?
2. How can you construct the *e* matrix? Hint: the numerator of *e* is just an *outer product* for which the `outer()` function can be used.



```r
y <- matrix(sample(1:10, 12, replace = TRUE), nrow = 3, ncol = 4)
yidot <- rowSums(y)
ydotj <- colSums(y)
e <- outer(yidot, ydotj)/sum(y)
sum((y - e)^2/e)
```

```
## [1] 5.432
```



# Problem 2

For each combination of sex and education level, find the *second* largest value of earnings amongst the people in the group without any looping.



```r
results <- by(earnings, list(earnings$sex, earnings$ed), function(x) {
    tmp <- sort(x$earn, decreasing = TRUE)
    tmp[2]
})
```

```
## Error: object 'earnings' not found
```


Hmm, that format is awkward. We can play around a bit and see what the underlying structure is...


```r
dim(results)
```

```
## Error: object 'results' not found
```

```r
results[1, ]
```

```
## Error: object 'results' not found
```

```r
as.matrix(results)
```

```
## Error: object 'results' not found
```

```r
attributes(results)
```

```
## Error: object 'results' not found
```

```r
class(results) <- "matrix"
```

```
## Error: object 'results' not found
```

```r
results
```

```
## Error: object 'results' not found
```


Are there other ways to go about this? 
