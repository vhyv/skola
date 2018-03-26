
library(car)
boxp = with(Davis, boxplot(height, subset = Davis[which.min(Davis$height),] col = 'lightblue' ))
boxplot(Davis$height[-which.min(Davis$height)], col = 'lightblue')

boxplot(height ~ sex, data = Davis, col = 'lightblue', subset = -which.min(Davis$height))

str(boxp)
which.min(Davis$height)
Davis[which.min(Davis$height),]


par(mfrow = c(2,2))
hist(Davis$weight, "sturges", col = 'lightblue', main = 'Sturgesovo pravidlo')
hist(Davis$weight, "scott", col = 'darkblue', main = 'Scottovo pravidlo')
hist(Davis$weight,"fd",col="lightblue",
     main="F-D pravidlo")
hist(Davis$weight,3,col="lightblue",
     main="rucne zvolené pravidlo")

histogram=hist(Davis$weight,"sturges",plot=FALSE)

sum(histogram$mids * histogram$counts) / sum(histogram$counts)

mean(Davis$weight)


?density
