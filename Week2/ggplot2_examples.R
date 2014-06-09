
library(ggplot2)
library(datasets)
data(airquality)

airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)


str(mpg)
qplot(displ, hwy, data=mpg)
qplot(displ, hwy, data=mpg, color=drv)  # color aesthetic

# Adding a geom
qplot(displ, hwy, data=mpg, geom=c("point","smooth"))

# Histogram
qplot(hwy, data=mpg, fill=drv)

# Facets
qplot(displ,hwy, data=mpg,facets=.~drv)	
qplot(hwy, data=mpg,facets=drv~., binwidth=2)        


# Movie DB
str(movies)
qplot(votes, rating, data=movies)

# Add Loess Smoother
qplot(votes, rating, data = movies) + geom_smooth()
