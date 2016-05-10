#**********Machine Learning with R************

#https://www.datacamp.com/community/tutorials/machine-learning-in-r
#Step 1: get the data
iris #type in the console


#Step 2:  Know your data, making some graphs, data range
head(iris)
str(iris)
table(iris$Species)
round(prop.table(table(iris$Species)) * 100, digits = 1)
summary(iris)
summary(iris[c("Petal.Width", "Sepal.Width")])


library(ggplot2)
flower <- ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width))
flower + geom_point(aes(colour=Species))

flower2 <- ggplot(iris, aes(x=Petal.Length, y=Petal.Width))
flower2 + geom_point(aes(colour=Species))


#Step 3: think about what your data set might teach you or what you think you can learn from your data. From there on, 
#you can think about what kind of algorithms you would be able to apply to your data set in order to get the results that 
#you think you can obtain.---classification problem here


#Step 4: Prepare the workspace, add libraries--KNN
#any(grepl("<name of your package>", installed.packages()))
library(class)

#Prepare the data: Normalization, training and test sets of data
#Normalization methods: rescaling, standadize, scale to unit length

#Normalization rescales the values from to a range of [0,1]. 
#This might useful in some cases where all parameters need to have the same positive scale, but outliers from data set are lost. 
#Xchanged = (X - Xmin)/(Xmax-Xmin)

#Standardization rescales data to have a mean of 0 and standard deviation of 1 (unit variance). 
#Xchanged = (x-mean)/sd #For most applications standardization is recommended.


normalize <- function(x) {
        num <- x - min(x)
        denom <- max(x) - min(x)
        return (num/denom)
}

class(iris)
iris_norm <- as.data.frame(lapply(iris[1:4], normalize))
#if not use as.data.frame, otherwise it's a list of lists
summary(iris_norm)

set.seed(1234) #split data into train and test sets
ind <- sample(2, nrow(iris), replace=TRUE, prob=c(0.67, 0.33))
iris.training <- iris[ind==1, 1:4]
iris.test <- iris[ind==2, 1:4]
iris.trainLabels <- iris[ind==1, 5]
iris.testLabels <- iris[ind==2, 5]


#Step 6: algorithms, here KNN # build the classifier
iris_pred <- knn(train = iris.training, test = iris.test, cl = iris.trainLabels, k=3) 
#The result of this function is a factor vector with the predicted classes for each row of the test data.

#method 2 SVM
#install.packages("kernlab")
#library(kernlab)
#iris_pred <- ksvm(x = iris.training, y = iris.trainLabels, type = "C-svc", kernel = 'vanilladot', C = 100, scaled = c()) 

iris_pred

#Step 7: evaluate your model
#Method 1 install.packages("gmodels")
library(gmodels)
CrossTable(x = iris.testLabels, y = iris_pred, prop.chisq=FALSE)

#Method 2 confusion matrix
confusion_matrix <- table(iris.testLabels, iris_pred)
confusion_matrix
accuracy <- sum(iris_pred==iris.testLabels)/length(iris.testLabels)
accuracy

#Method3 ROC curver
library(pROC)
roc_curve <- roc(c(iris.testLabels), c(iris_pred))
plot.roc(roc_curve, col="green", main="ROC curves, full dataset", lwd=8)
#legend("bottom", bty = 'n',legend=c("80/20","70/30","50/50","90/10"), col=c("green", "gold","orange","red"), lwd=8)




#Logistic model evaluation

logisticPseudoR2s <- function(LogModel) {
        dev <- LogModel$deviance 
        nullDev <- LogModel$null.deviance 
        modelN <-  length(LogModel$fitted.values)
        R.l <-  1 -  dev / nullDev
        R.cs <- 1- exp ( -(nullDev - dev) / modelN)
        R.n <- R.cs / ( 1 - ( exp (-(nullDev / modelN))))
        cat("Pseudo R^2 for logistic regression\n")
        cat("Hosmer and Lemeshow R^2  ", round(R.l, 3), "\n")
        cat("Cox and Snell R^2        ", round(R.cs, 3), "\n")
        cat("Nagelkerke R^2           ", round(R.n, 3),    "\n")
}







####***************Time Series
#time series  http://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html

#Reading Time Series Data
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
kings
#to store data into a time series object in R
kingstimeseries <- ts(kings)
kingstimeseries
births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
birthstimeseries <- ts(births, frequency=12, start=c(1946,1))
birthstimeseries


souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1))
souvenirtimeseries


#plot time series
plot.ts(kingstimeseries)
plot.ts(birthstimeseries)
plot.ts(souvenirtimeseries)
logsouvenirtimeseries <- log(souvenirtimeseries)
plot.ts(logsouvenirtimeseries)


#decompising time series:separate it into constituent components, 
#which are usually a trend component and an irregular component and if it is a seasonal time series, a seasonal component

#decoposing non-seasonal data (trend and irregular components)
#a smoothing method: simple moving average of the time series
library(TTR)

kingstimeseriesSMA3 <- SMA(kingstimeseries,n=3)
plot.ts(kingstimeseriesSMA3)

#decompose seasonal data
birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriescomponents$seasonal # get the estimated values of the seasonal component
plot(birthstimeseriescomponents)

#seasonally adjusting
birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriesseasonallyadjusted <- birthstimeseries - birthstimeseriescomponents$seasonal
plot(birthstimeseriesseasonallyadjusted)#only contain trend and irregular components


#forcasts using exponential smoothing, simple exponential smoothing: 
#If you have a time series that can be described using an additive model with constant level and no seasonality, 
#you can use simple exponential smoothing to make short-term forecasts.

rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
rainseries <- ts(rain,start=c(1813))
plot.ts(rainseries)
rainseriesforecasts <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts
rainseriesforecasts$fitted
plot(rainseriesforecasts)
rainseriesforecasts$SSE
HoltWinters(rainseries, beta=FALSE, gamma=FALSE, l.start=23.56)
#install.packages("forecast")
library(forecast)
rainseriesforecasts2 <- forecast.HoltWinters(rainseriesforecasts, h=8)
rainseriesforecasts2
plot.forecast(rainseriesforecasts2)
acf(rainseriesforecasts2$residuals, lag.max=20)
Box.test(rainseriesforecasts2$residuals, lag=20, type="Ljung-Box")
plot.ts(rainseriesforecasts2$residuals)

plotForecastErrors <- function(forecasterrors)
{
        # make a histogram of the forecast errors:
        mybinsize <- IQR(forecasterrors)/4
        mysd   <- sd(forecasterrors)
        mymin  <- min(forecasterrors) - mysd*5
        mymax  <- max(forecasterrors) + mysd*3
        # generate normally distributed data with mean 0 and standard deviation mysd
        mynorm <- rnorm(10000, mean=0, sd=mysd)
        mymin2 <- min(mynorm)
        mymax2 <- max(mynorm)
        if (mymin2 < mymin) { mymin <- mymin2 }
        if (mymax2 > mymax) { mymax <- mymax2 }
        # make a red histogram of the forecast errors, with the normally distributed data overlaid:
        mybins <- seq(mymin, mymax, mybinsize)
        hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
        # freq=FALSE ensures the area under the histogram = 1
        # generate normally distributed data with mean 0 and standard deviation mysd
        myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
        # plot the normal curve as a blue line on top of the histogram of forecast errors:
        points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}

plotForecastErrors(rainseriesforecasts2$residuals)
