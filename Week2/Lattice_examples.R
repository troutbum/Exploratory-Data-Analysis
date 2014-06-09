library(lattice)
library(datasets)

# test data
str(airquality)
class(airquality)

# simple Lattice Plot
xyplot(Ozone ~ Wind, data = airquality )

## Convert 'Month' to a factor variable
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5, 1))


p <- xyplot(Ozone ~ Wind, data = airquality) ## Nothing happens!
print(p) ## Plot appears


# Lattice Panel Functions
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1)) ## Plot with 2 panels

## Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...) ## First call the default panel function for 'xyplot'
        panel.abline(h = median(y), lty = 2) ## Add a horizontal line at the median
})

## Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...) ## First call default panel function
        panel.lmline(x, y, col = 2) ## Overlay a simple linear regression line
})


library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)

summary(BodyWeight)
str(BodyWeight)

xyplot(weight ~ Time, BodyWeight)
panel.lmline(time, weight, col=2) ## Overlay a simple linear regression line
