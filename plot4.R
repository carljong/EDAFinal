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
png('plot4.png', width=640, height=480)


#Find coal combustion sources
combustion.coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
combustion.coal.sources <- SCC[combustion.coal,]

# Get emissions from coal combustion
emissions.coal.combustion <- NEI[(NEI$SCC %in% combustion.coal.sources$SCC), ]


#Summarize the data
emissions.coal.related <- summarise(group_by(emissions.coal.combustion, year), Emissions=sum(Emissions))

##Plot the data
g<-ggplot(emissions.coal.related, aes(x=factor(year), y=Emissions/1000,fill=year, label = round(Emissions/1000,2))) +
  geom_bar(stat="identity") +
  xlab("Year") +
  theme(plot.title = element_text(hjust = 0.5)) +  ## Move title from being left aligned
  ylab(expression("Total PM"[2.5]*" emissions in kilotons")) +
  ggtitle("Emissions from coal combustion-related sources in kilotons")+
  geom_label(aes(fill = year),colour = "white", fontface = "bold")

print(g)

dev.off() 
