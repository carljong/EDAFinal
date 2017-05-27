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
png('plot5.png', width=640, height=480)

##Get emissions from vehicles in Baltimore
baltimore.emissions<-NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]

##Summarize emissions in Baltimore by year
baltimore.emissions.byyear <- summarize(group_by(baltimore.emissions, year), Emissions=sum(Emissions))

##Graph the data
g<-ggplot(baltimore.emissions.byyear, aes(x=factor(year), y=Emissions,fill=year, label = round(Emissions,0))) +
  geom_bar(stat="identity") +
  xlab("Year") +
  ylab(expression("Total PM"[2.5]*" emissions in tons")) +
  ggtitle("Emissions from motor vehicle sources in Baltimore City")+
  theme(plot.title = element_text(hjust = 0.5)) +  ## Move title from being left aligned +
  geom_label(aes(fill = year),colour = "white", fontface = "bold")

print(g)

dev.off() 
