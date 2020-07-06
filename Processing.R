library("RSocrata")
library(lubridate)
library(tidyverse)
library(magrittr)
library(dplyr)
library(CausalImpact)
library(GGally)
library(skimr)
library(hrbrthemes)
library(fpp)
library(lattice)
library(padr)
library(Hmisc)






# Read-in 2010-2019 dataset from LA Open Data API
setwd("C:/Users/")


df18 <- read.socrata(
  "https://data.cityofchicago.org/resource/crimes.json",
  app_token = "",
  email     = "",
  password  = ""
)

df18<-df18 %>%
  dplyr::filter(date>=as.POSIXct("2018-01-01"))

df18$date<-round(df18$date, "days")
df18$date<-as.POSIXct(df18$date)
count(df18, 'primary_type')


# write dataset to csv for easier upload - and avoid continuous updates in the website in case of subsequent analyses
write.csv(df18, 'chicagodf.csv', row.names=T, col.names=T)


# create datasets by crime type

burglary <- df18[df18$primary_type==
                    "BURGLARY",]

assault <- df18[df18$primary_type==
              "ASSAULT",]

narcotics <- df18[df18$primary_type==
                    "NARCOTICS",]

robbery <- df18[df18$primary_type==
                  "ROBBERY",]
                  
                  
                  

#aggregate dataset - city wide
burglary_city <- aggregate(burglary, by=list(burglary$date), length)
assault_city <- aggregate(assault, by=list(assault$date), length)
narcotics_city <- aggregate(narcotics, by=list(narcotics$date), length)
robbery_city <- aggregate(robbery, by=list(robbery$date), length)


#reduce
burglary<-burglary[, c(1, 3, 6, 14)]
assault<-assault[,c(1,3,6,14)]
narcotics<-narcotics[,c(1,3,6,14)]
robbery<-robbery[,c(1,3,6,14)]

#create lists divided by communities
burglary_list <- split(burglary, burglary$community_area)
assault_list<-split(assault, assault$community_area)
narco_list<-split(narcotics, narcotics$community_area)
robbery_list<-split(robbery, robbery$community_area)
# aggregate by date
burglary_agg <- lapply(burglary_list, function(x) {aggregate(x, by=list(x$date), length)})
assault_agg <- lapply(assault_list, function(x) {aggregate(x, by=list(x$date), length)})
narco_agg <- lapply(narco_list, function(x) {aggregate(x, by=list(x$date), length)})
robbery_agg <- lapply(robbery_list, function(x) {aggregate(x, by=list(x$date), length)})


# datelist to fill in missing values
datelist <- read.csv("C:/Users/Gian Maria/Desktop/coronavirus/Chicago/datelist.csv", header=FALSE)
datelist<-as.POSIXct(datelist$V1, format = "%Y-%m-%d")
date_f <- as.data.frame(datelist, stringsAsFactors=FALSE)
names(date_f)[1] <- "Group.1"



# join
burglary_agg<-lapply(burglary_agg, function(x){full_join(x, date_f)})
assault_agg<-lapply(assault_agg, function(x){full_join(x, date_f)})
narco_agg<-lapply(narco_agg, function(x){full_join(x, date_f)})
robbery_agg<-lapply(robbery_agg, function(x){full_join(x, date_f)})

#order ascending
burglary_agg<-lapply(burglary_agg, function(x) {x[ order(x$Group.1 , decreasing = FALSE ),]})
assault_agg<-lapply(assault_agg, function(x) {x[ order(x$Group.1 , decreasing = FALSE ),]})
narco_agg<-lapply(narco_agg, function(x) {x[ order(x$Group.1 , decreasing = FALSE ),]})
robbery_agg<-lapply(robbery_agg, function(x) {x[ order(x$Group.1 , decreasing = FALSE ),]})


# remove unused cols
burglary_agg<-lapply(burglary_agg, function(x){x[,c(1,2)]})
assault_agg<-lapply(assault_agg, function(x){x[,c(1,2)]})
narco_agg<-lapply(narco_agg, function(x){x[,c(1,2)]})
robbery_agg<-lapply(robbery_agg, function(x){x[,c(1,2)]})

# transform nas in 0s
burglary_agg<-lapply(burglary_agg, function(x) {x$id[is.na(x$id)]<-0
x})

assault_agg<-lapply(assault_agg, function(x) {x$id[is.na(x$id)]<-0
x})

narco_agg<-lapply(narco_agg, function(x) {x$id[is.na(x$id)]<-0
x})

robbery_agg<- lapply(robbery_agg, function(x) {x$id[is.na(x$id)]<-0
x})



# zoo transformation 
burglary_zoo<-lapply(burglary_agg, function (x) {read.zoo(x, index.column = 1, sep = ",", format = "%Y-%m-%d")})
assault_zoo<-lapply(assault_agg, function (x) {read.zoo(x, index.column = 1, sep = ",", format = "%Y-%m-%d")})
narco_zoo<-lapply(narco_agg, function (x) {read.zoo(x, index.column = 1, sep = ",", format = "%Y-%m-%d")})
robbery_zoo<-lapply(robbery_agg, function (x) {read.zoo(x, index.column = 1, sep = ",", format = "%Y-%m-%d")})



