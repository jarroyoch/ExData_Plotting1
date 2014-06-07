#calling the librarys needed
if(!require("data.table")){
  install.packages("data.table")
}

require("data.table")

#My machine is in spanish so I need to change it the language in order to attain the same graphics as everyone else
#You can ignore this
Sys.setlocale("LC_TIME", "English")

#Locating and calling the file needed
if(!file.exists("household_power_consumption.txt")){
  if(!file.exists("./exdata-data-household_power_consumption.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="./exdata-data-household_power_consumption.zip")
    print("Data files had been downloaded")
    unzip("./exdata-data-household_power_consumption.zip")
    print("Data files had been unzipped")
  }
  else{
    unzip("./exdata-data-household_power_consumption.zip")
    print("Data files had been unzipped")
  }   
}

#Fast reading of the entire set
dt<-suppressWarnings(fread("./household_power_consumption.txt",sep=";",na.strings="?"))

#Remove the columns that are not used in the analysis
dt[,6]<-list(NULL) 

#Changing the NA (na.strings in fread is bugged)
dt[dt == "?"]<-NA 

#Subsetting the dataset to the dates needed
dt<-dt[dt[[1]] == "1/2/2007" | dt[[1]] == "2/2/2007",]

#changing types of columns (fread called them as strings because of the na.strings bug, can't use colClasses as an argument for this)
for(i in 3:8){
  dt[[i]]<-as.numeric(dt[[i]])  
}


#Making and exporting the plot
png("plot4.png",bg="transparent") #default size of png is 480x480 so there's no need to change them
#png("plot4.png") #if having troubles with the transparency, uncomment this and comment the other

par(mfrow=c(2,2))

plot(strptime(paste(dt[[1]],dt[[2]]),"%d/%m/%Y %H:%M:%S"),dt[[3]],type="l",xlab="",ylab="Global Active Power")

plot(strptime(paste(dt[[1]],dt[[2]]),"%d/%m/%Y %H:%M:%S"),dt[[5]],type="l",xlab="datetime",ylab="Voltage")

plot(strptime(paste(dt[[1]],dt[[2]]),"%d/%m/%Y %H:%M:%S"),dt[[6]],type="l",xlab="",ylab="Energy sub metering")
lines(strptime(paste(dt[[1]],dt[[2]]),"%d/%m/%Y %H:%M:%S"),dt[[7]],col="red")
lines(strptime(paste(dt[[1]],dt[[2]]),"%d/%m/%Y %H:%M:%S"),dt[[8]],col="blue")
legend(x="topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("Black","Red","Blue"),lwd=1, bty="n")

plot(strptime(paste(dt[[1]],dt[[2]]),"%d/%m/%Y %H:%M:%S"),dt[[4]],type="l",xlab="datetime",ylab="Global_reactive_power")

dev.off()