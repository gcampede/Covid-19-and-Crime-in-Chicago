''' FIRST WAVE EXPORTATION'''

bur_expo = lapply(resultList_bur, "[[" , "summary")
ass_expo = lapply(resultList_ass, "[[" , "summary")
narco_expo = lapply(resultList_narco, "[[" , "summary")
rob_expo = lapply(resultList_rob, "[[" , "summary")

''' write results to csv '''


bur_y <- do.call(rbind, bur_expo)
write.csv(bur_y, 'burglary1705.csv', row.names=T, col.names=T)




ass_y<-do.call(rbind, ass_expo)
write.csv(ass_y, 'assault1705.csv', row.names=T, col.names=T)


narco_y<-do.call(rbind, narco_expo)
write.csv(narco_y, 'narcotics1705.csv', row.names=T, col.names=T)


rob_y<-do.call(rbind, rob_expo)
write.csv(rob_y, 'robbery1705.csv', row.names=T, col.names=T)

''' dataset creation for regression '''

# dataset creation
burglary1405 <- read.csv("C:/Users/dir/burglary1705.csv", header=TRUE)
assault1405<- read.csv("C:/Users/dir/assault1705.csv", header=TRUE)
narcotics1405 <- read.csv("C:/Users/dir/narcotics1705.csv", header=TRUE)
robbery1405 <- read.csv("C:/Users/dir/robbery1705.csv", header=TRUE) 


# reduction of cols

burglary1405<-burglary1405[, c(1, 11, 16)]
assault1405<-assault1405[, c(1, 11, 16)]
narcotics1405<-narcotics1405[, c(1, 11, 16)]
robbery1405<-robbery1405[, c(1, 11, 16)]

# reduction of rows 
burglary1405 <- burglary1405[grep("Cumulative", burglary1405$X),]
assault1405<-assault1405[grep("Cumulative", assault1405$X),]
narcotics1405<-narcotics1405[grep("Cumulative", narcotics1405$X),]
robbery1405<-robbery1405[grep("Cumulative", robbery1405$X),]

#rename cols (first one)
names(burglary1405)[1]<-"Community"
names(assault1405)[1]<-"Community"
names(narcotics1405)[1]<-"Community"
names(robbery1405)[1]<-"Community"

#rename cols (second one)
names(burglary1405)[2]<-"Burglary"
names(assault1405)[2]<-"Assault"
names(narcotics1405)[2]<-"Narcotics"
names(robbery1405)[2]<-"Robbery"

#rename cols (third)
names(burglary1405)[3]<-"Burglary p val"
names(assault1405)[3]<-"Assault p val"
names(narcotics1405)[3]<-"Narcotics p val"
names(robbery1405)[3]<-"Robbery p val"

#create p-val binary
burglary1405$Burglary_Sig <- ifelse(burglary1405$`Burglary p val`<=0.05, "1", "0")
assault1405$Assault_Sig <- ifelse(assault1405$`Assault p val`<=0.05, "1", "0")
narcotics1405$Narcotics_Sig <- ifelse(narcotics1405$`Narcotics p val`<=0.05, "1", "0")
robbery1405$Robbery_Sig <- ifelse(robbery1405$`Robbery p val`<=0.05, "1", "0")

# create p-vale REDUCTION binary
burglary1405$burglary_sig_drop<-ifelse((burglary1405$Burglary<0)&(burglary1405$Burglary_Sig==1),"1","0")
assault1405$assault_sig_drop<-ifelse((assault1405$Assault<0)&(assault1405$Assault_Sig==1),"1","0")
narcotics1405$narcotics_sig_drop<-ifelse((narcotics1405$Narcotics<0)&(narcotics1405$Narcotics_Sig==1),"1","0")
robbery1405$robbery_sig_drop<-ifelse((robbery1405$Robbery<0)&(robbery1405$Robbery_Sig==1),"1","0")

#merge them together
all_crimes <- Reduce(function(x,y) merge(x, y, all=TRUE), list(burglary1405, assault1405, narcotics1405, robbery1405))



#eliminate from census the useless strings
all_crimes$Community<-gsub("\\..*","",all_crimes$Community)

#import chicago dataset
chicago_df <- read.csv("C:/Users/.../chicago_dataset.csv", header=TRUE)

#merge two dataframes
chicago_db <- merge(chicago_df, all_crimes, by="Community")

#transform character vars in numeric
chicago_db$Burglary_Sig<-as.numeric(chicago_db$Burglary_Sig)
chicago_db$Assault_Sig<-as.numeric(chicago_db$Assault_Sig)
chicago_db$Narcotics_Sig<-as.numeric(chicago_db$Narcotics_Sig)
chicago_db$Robbery_Sig<-as.numeric(chicago_db$Robbery_Sig)
chicago_db$Total_Population_2018<-as.numeric(chicago_db$Total_Population_2018)
chicago_db$Mobility.Rate_2018<-as.numeric(chicago_db$Mobility.Rate_2018)
chicago_db$X65._._2018<-as.numeric(chicago_db$X65._._2018)

#add columns for significant drop 
chicago_db$Burglary_sig_drop <-ifelse((chicago_db$Burglary <0) & (chicago_db$Burglary_Sig ==1), "1", "0")
chicago_db$Assault_sig_drop <-ifelse((chicago_db$Assault <0) & (chicago_db$Assault_Sig ==1), "1", "0")
chicago_db$Narcotics_sig_drop <-ifelse((chicago_db$Narcotics <0) & (chicago_db$Narcotics_Sig ==1), "1", "0")
chicago_db$Robbery_sig_drop <-ifelse((chicago_db$Robbery <0) & (chicago_db$Robbery_Sig ==1), "1", "0")
