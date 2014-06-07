#calling the librarys needed
if(!require("data.table")){
    install.packages("data.table")
  }

require("data.table")

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
dt<-suppressWarnings(fread("./household_power_consumption.txt",na.strings="?"))

#Remove the columns that are not used in the analysis
dt[,4:9]<-list(NULL) 

#Changing the NA (na.strings in fread is bugged)
dt[dt == "?"]<-NA 

#Subsetting the dataset to the dates needed
dt<-dt[dt[[1]] == "1/2/2007" | dt[[1]] == "2/2/2007",]

#changing types of columns (fread called them as strings because of the na.strings bug, can't use colClasses as an argument for this)
dt[[1]]<-as.Date(dt[[1]], "%d/%m/%Y")
dt[[3]]<-as.numeric(dt[[3]])

#Making and exporting the plot
png("plot1.png",bg="transparent") #default size of png is 480x480 so there's no need to change them
#png("plot1.png") #if having troubles with the transparency, uncomment this and comment the other

hist(dt[[3]],col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")
dev.off()