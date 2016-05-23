#http://www.statsblogs.com/2014/02/10/how-dplyr-replaced-my-most-common-r-idioms/
#https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
#ggplot is all about layer after layer

library(dplyr)
crime.by.state <- read.csv("CrimeStatebyState.csv", header=T)
str(crime.by.state)
head(crime.by.state)
# base R
crime.by.state <- read.csv("CrimeStatebyState.csv")
crime.ny.2005 <- crime.by.state[crime.by.state$Year==2005 & crime.by.state$State=="New York", c("Type.of.Crime", "Count")]
crime.ny.2005 <- crime.ny.2005[order(crime.ny.2005$Count, decreasing=TRUE), ]
crime.ny.2005$Proportion <- crime.ny.2005$Count/sum(crime.ny.2005$Count)
summary1 <- aggregate(Count ~ Type.of.Crime, data=crime.ny.2005, FUN=sum)
summary2 <- aggregate(Count ~ Type.of.Crime, data=crime.ny.2005, FUN=length)
final <- merge(summary1, summary2, by="Type.of.Crime")


# dplyr
crime.by.state <- read.csv("CrimeStatebyState.csv")
final <- crime.by.state %>%
        filter(State=="New York", Year==2005) %>%
        arrange(desc(Count)) %>%
        select(Type.of.Crime, Count) %>%
        mutate(Proportion=Count/sum(Count)) %>%
        group_by(Type.of.Crime) %>%
        summarise(num.types = n(), counts = sum(Count))
final
str(crime.by.state)
select(crime.by.state, Type.of.Crime, Count)
filter(crime.by.state, State=="New York", Year==2005)


#Filtering rows
# base R
crime.ny.2005 <- crime.by.state[crime.by.state$Year==2005 &
                                        crime.by.state$State=="New York", ]
# dplyr
crime.ny.2005 <- filter(crime.by.state, State=="New York", Year==2005)

#Arranging and ordering
# base R
crime.ny.2005 <- crime.ny.2005[order(crime.ny.2005$Count, decreasing=TRUE), ]
# dplyr
crime.ny.2005 <- arrange(crime.ny.2005, desc(Count))


#Selecting columns
# base R
crime.ny.2005 <- crime.ny.2005[, c("Type.of.Crime", "Count")]
# dplyr
crime.ny.2005 <- select(crime.ny.2005, Type.of.Crime, Count)


#Creating new columns
# base R
crime.ny.2005$Proportion <- crime.ny.2005$Count/sum(crime.ny.2005$Count)
# dplyr
crime.ny.2005 <- mutate(crime.ny.2005, Proportion=Count/sum(Count))

#Aggregation and summarization
# base R
summary1 <- aggregate(Count ~ Type.of.Crime,data=crime.ny.2005,FUN=sum)
summary2 <- aggregate(Count ~ Type.of.Crime, data=crime.ny.2005,FUN=length)
summary.crime.ny.2005 <- merge(summary1, summary2,by="Type.of.Crime")
# dplyr
by.type <- group_by(crime.ny.2005, Type.of.Crime)
summary.crime.ny.2005 <- summarise(by.type,num.types = n(),counts = sum(Count))


#Roger Peng book page60--pipeline  first(x) %>% second %>% third, dataset is chicago
#group_by and summarize can be used with functions from other packages
mutate(chicago, pm25.quint = cut(pm25, qq)) %>%
      group_by(pm25.quint) %>%
      summarize(o3 = mean(o3tmean2, na.rm = TRUE), 
                no2 = mean(no2tmean2, na.rm = TRUE))

filter(
  summarise(
    select(
      group_by(flights, year, month, day),
      arr_delay, dep_delay
    ),
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ),
  arr > 30 | dep > 30
)


###UCLA
#http://www.ats.ucla.edu/stat/r/seminars/intro.R



opts_chunk$set(fig.path='figures/intro-')


#install.packages("foreign")
#install.packages("xlsx")
#install.packages("dplyr")
#install.packages("reshape2")
#install.packages("ggplot2")
#install.packages("GGally")
#install.packages("vcd")



library(foreign)
library(xlsx)
library(dplyr)
library(reshape2)
require(ggplot2)
require(GGally)
require(vcd)



# foreign ships with R so no need to install
require(xlsx) || {install.packages("xlsx"); require(xlsx)}
require(reshape2) || {install.packages("reshape2"); require(reshape2)}
require(ggplot2) || {install.packages("ggplot2"); require(ggplot2)}
require(GGally) || {install.packages("GGally"); require(GGally)}
require(vcd) || {install.packages("vcd"); require(vcd)}



sessionInfo()

?require

# assign the number 3 to object called abc
abc <- 3
# list all objects in current session
ls()



# comma separated values
dat.csv <- read.csv("http://www.ats.ucla.edu/stat/data/hsb2.csv")
# tab separated values
dat.tab <- read.table("http://www.ats.ucla.edu/stat/data/hsb2.txt",
  header=TRUE, sep = "\t")

?read.csv

require(foreign)
# SPSS files
dat.spss <- read.spss("http://www.ats.ucla.edu/stat/data/hsb2.sav",
  to.data.frame=TRUE)
# Stata files
dat.dta <- read.dta("http://www.ats.ucla.edu/stat/data/hsb2.dta")



# these two steps only needed to read excel files from the internet
f <- tempfile("hsb2", fileext=".xls")

download.file("http://www.ats.ucla.edu/stat/data/hsb2.xls", f, mode="wb")

dat.xls <- read.xlsx(f, sheetIndex=1)



# first few rows
head(dat.csv)
# last few rows
tail(dat.csv)
# variable names
colnames(dat.csv)
# pop-up view of entire data set (uncomment to run)
# View(dat.csv)



# single cell value
dat.csv[2,3]
# omitting row value implies all rows; here all rows in column 3
dat.csv[,3]
# omitting column values implies all columns; here all columns in row 2
dat.csv[2,]
# can also use ranges - rows 2 and 3, columns 2 and 3
dat.csv[2:3, 2:3]



# get first 10 rows of variable female using two methods
dat.csv[1:10, "female"]
dat.csv$female[1:10]



# get column 1 for rows 1, 3 and 5
dat.csv[c(1,3,5), 1]
# get row 1 values for variables female, prog and socst
dat.csv[1,c("female", "prog", "socst")]



colnames(dat.csv) <- c("ID", "Sex", "Ethnicity", "SES", "SchoolType",
  "Program", "Reading", "Writing", "Math", "Science", "SocialStudies")

# to change one variable name, just use indexing
colnames(dat.csv)[1] <- "ID2"



#write.csv(dat.csv, file = "path/to/save/filename.csv")

#write.table(dat.csv, file = "path/to/save/filename.txt", sep = "\t", na=".")

#write.dta(dat.csv, file = "path/to/save/filename.dta")

#write.xlsx(dat.csv, file = "path/to/save/filename.xlsx", sheetName="hsb2")

# save to binary R format (can save multiple datasets and R objects)
#save(dat.csv, dat.dta, dat.spss, dat.txt, file = "path/to/save/filename.RData")



d <- read.csv("http://www.ats.ucla.edu/stat/data/hsb2.csv")



dim(d)
str(d)



summary(d)



summary(filter(d, read >= 60))



by(d[, 7:11], d$prog, colMeans)



ggplot(d, aes(x = write)) + geom_histogram()



ggplot(d, aes(x = write)) + geom_density()



ggplot(d, aes(x = 1, y = math)) + geom_boxplot()



# density plots by program type
ggplot(d, aes(x = write)) + geom_density() + facet_wrap(~ prog)



ggplot(d, aes(x = factor(prog), y = math)) + geom_boxplot()



ggplot(melt(d[, 7:11]), aes(x = variable, y = value)) + geom_boxplot()



ggplot(melt(d[, 6:11], id.vars = "prog"),
       aes(x = variable, y = value, fill = factor(prog))) +
  geom_boxplot()



# load lattice
require(lattice)

# simple scatter plot
xyplot(read ~ write, data = d)

# conditioned scatter plot
xyplot(read ~ write | prog, data = d)

# conditioning on two variables
xyplot(read ~ write | prog * schtyp, data = d)

# box and whisker plots
bwplot(read ~ factor(prog), data = d)



xtabs( ~ female, data = d)
xtabs( ~ race, data = d)
xtabs( ~ prog, data = d)



xtabs( ~ ses + schtyp, data = d)



(tab3 <- xtabs( ~ ses + prog + schtyp, data = d))



(tab2 <- xtabs( ~ ses + schtyp, data = d))
set.seed(10)
(testtab2 <- coindep_test(tab2, n = 5000))



# simple mosaic plot
mosaic(tab2)



mosaic(tab2, gp = shading_hsv,
  gp_args = list(p.value = testtab2$p.value, interpolate = -1:2))



cotabplot(~ ses + prog | schtyp, data = d, panel = cotab_coindep, n = 5000)



cor(d[, 7:11])



cor(d[, 7:11], use = "complete.obs")



cor(d[, 7:11], use = "pairwise.complete.obs")



ggpairs(d[, 7:11])



# read data in and store in an easy to use name to save typing
d <- read.csv("http://www.ats.ucla.edu/stat/data/hsb2.csv")



library(dplyr)
d <- arrange(d, female, math)
head(d)




#library(dplyr)
str(d)
d <- mutate(d,
            id = factor(id),
            female = factor(female, levels = 0:1, labels = c("male", "female")),
            race = factor(race, levels = 1:4, labels = c("Hispanic", "Asian", "African American", "White")),
            schtyp = factor(schtyp, levels = 1:2, labels = c("public", "private")),
            prog = factor(prog, levels = 1:3, labels = c("general", "academic", "vocational"))
)



str(d)
summary(d)



d <- mutate(d,
            total = read+write+math+science,
            grade = cut(total,
                        breaks = c(0, 140, 180, 210, 234, 300),
                        labels = c("F", "D", "C", "B", "A"))
            )

# view results
summary(d[, c("total", "grade")])



#library(dplyr)
d <- mutate(d, 
            zread = as.numeric(scale(read)),
            readmean = ave(read, ses, FUN = mean)
)

head(d[, c("read", "zread", "readmean")])



d$rowmean <- rowMeans(d[, 7:10], na.rm=TRUE)



getwd()
list.files()
#setwd("/path/to/directory")



dfemale <- filter(d, female == "female")
dmale <- filter(d, female == "male")



# note that select is special, so we do not need to quote the variable names
duse <- select(d, id, female, read, write)
# note the - preceding c(female... , which means drop these variables
ddropped <- select(d, -c(female, read, write))



dboth <- rbind(dfemale, dmale)
dim(dfemale)
dim(dmale)
dim(dboth)



dall <- merge(duse, ddropped, by = "id", all = TRUE)
dim(duse)
dim(ddropped)
dim(dall)



(tab <- xtabs(~ ses + schtyp, data = d))
chisq.test(tab)



chisq.test(tab, simulate.p.value=TRUE, B = 90000)



t.test(d$write, mu = 50)
with(d, t.test(write, read, paired = TRUE))



t.test(write ~ female, data = d, var.equal=TRUE)
t.test(write ~ female, data = d)



m <- lm(write ~ prog * female, data = d)
anova(m)
summary(m)



summary(m2 <- update(m, . ~ . + read))



par(mfrow = c(2, 2))
plot(m2)



plot(density(resid(m2)))



summary(m3 <- lm(write ~ prog * read, data = d))



m3b <- update(m3, . ~ . - prog:read)
anova(m3b, m3)



newdat <- with(d, expand.grid(prog = levels(prog), female = levels(female)))
(newdat <- cbind(newdat, predict(m, newdat, se=TRUE)))



ggplot(newdat, aes(x = prog, y = fit, colour = female)) +
  geom_errorbar(aes(ymin = fit - se.fit, ymax = fit + se.fit), width=.25) +
  geom_point(size=3)



colnames(newdat)[1:3] <- c("Program", "Sex", "Write")

ggplot(newdat, aes(x = Program, y = Write, colour = Sex)) +
  geom_errorbar(aes(ymin = Write - se.fit, ymax = Write + se.fit), width=.25) +
  geom_point(size=3)



m4 <- glm(schtyp ~ ses + read, data = d, family = binomial)
summary(m4)



exp(coef(m4))



confint(m4)
exp(confint(m4))



newdat <- expand.grid(ses = unique(d$ses), read = seq(min(d$read), max(d$read)))
newdat$PredictedProbability <- predict(m4, newdat, type = "response")



ggplot(newdat, aes(x = read, y = PredictedProbability, colour = factor(ses))) +
  geom_line()



# equivalent of one sampe t-test
wilcox.test(d$write, mu = 50)

# Wilcoxon sign-ranked test, equivalent of paired samples t-test
with(d, wilcox.test(write, read, paired=TRUE))



# Wilcoxon test, equivalent of indepdent samples t-test
wilcox.test(write ~ female, data = d)


# Kruskal-Wallis test, equivalent of one-way ANOVA
kruskal.test(write ~ prog, data = d)
