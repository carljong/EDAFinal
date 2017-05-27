datazipname <- "../poldata.zip"

## Download, create the data:
if (!file.exists(datazipname)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip "
  download.file(fileURL, datazipname, method="curl")
}

datafile<-"../poldata/summarySCC_PM25.rds"
specfile <-"../poldata/Source_Classification_Code.rds"

##If data is not unzipped, unzip it
if (!file.exists(datafile)) {
  unzip(datazipname)
}

## This first line will likely take a few seconds. Be patient!
## If files are open, no need to open again
if(!exists("NEI")){
  NEI <- readRDS(datafile)
}
if(!exists("SCC")){
  SCC <- readRDS(specfile)
}

##Use summarize, so make sure have dplyr
require(dplyr)
png('plot2.png')

##Summarize the data
baltimore.emissions<-summarise(group_by(filter(NEI, fips == "24510"), year), Emissions=sum(Emissions))

##Pick the colors
clrs <- c("red",  "blue", "yellow", "green")

##Assign graph to variable
x2<-barplot(height=baltimore.emissions$Emissions/1000, names.arg=baltimore.emissions$year,
            xlab="Years", ylab=expression('Total PM'[2.5]*' emission in kilotons'),ylim=c(0,4),
            main=expression('Total PM'[2.5]*' emissions in Baltimore City, MD in kilotons'),col=clrs)

## Add text at top of bars
text(x = x2, y = round(baltimore.emissions$Emissions/1000,2), label = round(baltimore.emissions$Emissions/1000,2), pos = 3, cex = 0.8, col = "black")
dev.off() 
