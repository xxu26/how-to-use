library(tcltk)
library(sqldf)

#list functions in a package
#https://www.simple-talk.com/sql/reporting-services/making-data-analytics-simpler-sql-server-and-r/
lsp <- function(package, all.names = FALSE, pattern) 
{
        package <- deparse(substitute(package))
        ls(
                pos = paste("package", package, sep = ":"), 
                all.names = all.names, 
                pattern = pattern
        )
}

lsp(RODBC)


# installing/loading the package:
if(!require(installr)) {
        install.packages("installr"); require(installr)} #load / install+load installr

# using the package:
updateR() # this will start the updating process of your R installation.  
#It will check for newer versions, and if one is available, will guide you through the decisions you'd need to make.

#example
myCO2 <- CO2
attributes(myCO2) <- attributes(CO2)[
        c("names", "row.names", "class")]
class(myCO2) <- "data.frame"
colnames(myCO2)
s01 <- sqldf("select Type, conc from myCO2")
s01
r01 <- myCO2[, c("Type", "conc")]
r01
all.equal(s01, r01)


#R connect to SQL server 3/11/2016
library(RODBC)
chanel <- odbcConnect("RConnect")
print(chanel)
sqlTables(chanel)

#Some drivers will return all visible table-like objects, not just those owned by you. 
#In that case you may want to restrict the scope by e.g
sqlTables(chanel, tableType = "TABLE")
sqlTables(chanel, schema = "dbo")
sqlTables(chanel, tableName = "tableName")
res <- sqlFetch(chanel, "tableName")
str(res)


k <-sqlTables(chanel, tableName = "anotherTableName")
str(k)
Kdata <- sqlFetch(chanel, "anotherTableName")
str(Kdata)
library(dplyr)
filter(Kdata, ZIP==94122)

#sqlColumns()
#sqlQuery()

odbcClose(chanel)
