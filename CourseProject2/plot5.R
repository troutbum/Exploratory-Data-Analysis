# Exploratory Data Analysis
# June 2014
# Course Project 2
# Plot 5

# Question 5:
# 
# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?

# create a data subdirectory if it does not exist
if (!file.exists("data")) {
        dir.create("data")
}

# download file if it isn't already there
filePath <- "./data/"
fileZipName <- "exdata-data-NEI_data.zip"
fileName1 <- "summarySCC_PM25.rds"
fileName2 <- "Source_Classification_Code.rds"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

ZipFile <- paste0(filePath, fileZipName)        # path to zipped data file
if (!file.exists(ZipFile)) {
        download.file(fileUrl, destfile = ZipFile, method ="curl")
        unzip(ZipFile, exdir=filePath)
        dateDownloaded <- date()
}

# PM2.5 Emissions Data & Source Classification Code Table
NEI <- readRDS(paste0(filePath, fileName1))  
Baltimore <- subset(NEI, fips == "24510")               # subset Baltimore data
BaltiVehicle <- subset(Baltimore, type == "ON-ROAD")    # subset Baltimore vehicle data
SCC <- readRDS(file=paste0(filePath, fileName2))

# join emissions data with SCC table subset 
library(plyr)
B = join(BaltiVehicle, SCC, by="SCC", type = "inner")
B$year <- factor(B$year)                                # Convert year column to a factor

# plot results
library(datasets)
library(ggplot2)
library(RColorBrewer)
png("plot5.png", width = 960, height = 480)
g <- ggplot(B, aes(SCC.Level.Three, Emissions, fill=SCC.Level.Three)) +
        geom_bar(stat="identity") + 
        facet_grid(. ~ year) +
        scale_x_discrete(breaks=NULL) +                              # suppress x-axis label
        labs(x="---total emission levels indicated by dashed lines---") +
        theme(axis.title.x = element_text(colour = "#990000"),
              axis.title.y = element_text(colour = "black")) +
        labs(y="PM2.5 Emissions (in tons)") +
        labs(title="Baltimore City, Maryland | Motor Vehicle PM2.5 Emissions") + 
        labs(fill = "Vehicle Type") +
        scale_fill_brewer(palette="Paired")
 
# add horizontal line for sum of emissions for each facet
B_total = tapply(B$Emissions, B$year, sum)
hline.data <- data.frame(z = B_total, year = names(B_total))
g + geom_hline(aes(yintercept = z), hline.data, colour="#990000", linetype="dashed")
dev.off()


# # 4 vertical facets by year, each column represents a vehicle type
# # (don't see all emissions effect)
# qplot(SCC.Level.Three, Emissions, data=B, geom="bar", stat='identity', 
#       facets=year~., fill=SCC.Level.Three, asp=0.5,
#       xlab="", ylab="Emissions in tons", main="Baltimore City, MD Vehicle Emissions")
# 
# # 2x2 facet grid
# # (can't compare years as readily)
# qplot(SCC.Level.Three, Emissions, data=B, geom="bar", stat='identity', 
#       facets=~year, fill=SCC.Level.Three, asp=0.5)
# 
# # stacked column by emission by year
# qplot(year, Emissions, data=B, geom="bar", stat='identity', fill=SCC.Level.Three)
# 
# 
# # just 2008 data
# data2008 <- subset(B, year == "2008") 
# data2008$SCC.Level.Three <- as.character(data2008$SCC.Level.Three) 
# data2008$SCC.Level.Three <- factor(data2008$SCC.Level.Three) 
# qplot(year, Emissions, data=data2008, geom="bar", stat='identity', fill=SCC.Level.Three)
# qplot(SCC.Level.Three, Emissions, data=data2008, geom="bar", stat='identity', 
#       facets=year~., fill=SCC.Level.Three, asp=.3)
# 
# # 12 facets by vehicle type, each with 4 columns representing a year
# qplot(year, Emissions, data=B, geom="bar", stat='identity', facets=.~SCC.Level.Three, fill=year)
# qplot(year, Emissions, data=B, geom="bar", stat='identity', facets=SCC.Level.Three~., fill=year)
# 
# # 4 year columns and color dots of vehicle type
# qplot(year, Emissions, data=B, fill="SCC.Level.Three", color=SCC.Level.Three, size = 20)
# 
# # library(RColorBrewer)
# # cols <- brewer.pal(12, "Paired")