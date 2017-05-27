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
png('plot6.png', width=640, height=480)

##Get emission information for Baltimore and Los Angeles
baltimore.emissions<-summarise(group_by(filter(NEI, fips == "24510"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))
losangeles.emissions<-summarise(group_by(filter(NEI, fips == "06037"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))

##Add County field to emission data
baltimore.emissions$County <- "Baltimore City, MD"
losangeles.emissions$County <- "Los Angeles County, CA"

#Combine data for Baltimore and Los Angeles
both.emissions <- rbind(baltimore.emissions, losangeles.emissions)

##Make a graph of the data
g<-ggplot(both.emissions, aes(x=factor(year), y=Emissions, fill=County,label = round(Emissions,2))) +
  geom_bar(stat="identity") + 
  facet_grid(County~., scales="free") +
  ylab(expression("Total PM"[2.5]*" emissions in tons")) + 
  xlab("Year") +
  ggtitle(expression("Motor vehicle emission variation in Baltimore and Los Angeles in tons"))+
  geom_label(aes(fill = County),colour = "white", fontface = "bold")

print(g)

dev.off() 
