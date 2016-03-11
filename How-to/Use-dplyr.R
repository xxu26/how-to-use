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
