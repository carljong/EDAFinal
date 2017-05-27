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

##Make sure have ggplot2
require(ggplot2)

##Create output file with proper size
png('plot3.png', width=640, height=480)


##Summarize data
baltimore.emissions.byyear<-summarise(group_by(filter(NEI, fips == "24510"), year,type), Emissions=sum(Emissions))

##Graph data
g<-ggplot(baltimore.emissions.byyear, aes(x=factor(year), y=Emissions, fill=type,label = round(Emissions,0))) +
  geom_bar(stat="identity") +
  facet_grid(. ~ type) +
  xlab("Year") +
  ylab(expression("Total PM"[2.5]*" emission in tons")) +
  ggtitle(expression("PM"[2.5]*paste(" emissions in Baltimore ",
                                     "City by various source types", sep="")))+
  geom_label(aes(fill = type), colour = "white", fontface = "bold")

print(g)

dev.off() 
