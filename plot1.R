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
png('plot1.png')

##Total data
total.emissions <- summarize(group_by(NEI,year), Emissions=sum(Emissions))

##Pick the colors
clrs <- c("red",  "blue", "yellow", "green")

##Assign bar graph to variable
x1<-barplot(height=total.emissions$Emissions/1000, names.arg=total.emissions$year,
            xlab="Years", ylab=expression('Total PM'[2.5]*' emission in kilotons'),ylim=c(0,8000),
            main=expression('Total PM'[2.5]*' emissions at various years in kilotons'),col=clrs)

## Put values at top of bars
text(x = x1, y = round(total.emissions$Emissions/1000,2), label = round(total.emissions$Emissions/1000,2), pos = 3, cex = 0.8, col = "black")

dev.off() 
