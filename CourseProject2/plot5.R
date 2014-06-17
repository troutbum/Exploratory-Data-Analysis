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

# PM2.5 Emissions Data
NEI <- readRDS(paste0(filePath, fileName1))  
# subset Baltimore data
Baltimore <- subset(NEI, fips == "24510")
# subset Baltimore vehicle data
BaltiVehicle <- subset(Baltimore, type == "ON-ROAD")

# Source Classification Code Table:
SCC <- readRDS(file=paste0(filePath, fileName2))

# join emissions data with SCC table subset 
library(plyr)
X = join(BaltiVehicle, SCC, by="SCC", type = "inner")

# Convert year column to a factor
X$year <- factor(X$year)


library(datasets)
library(ggplot2)
qplot(SCC.Level.Three, Emissions, data=X, geom="bar", stat='identity', 
      facets=year~., fill=SCC.Level.Three, asp=.3)

# stacked column?

qplot(SCC.Level.Three, Emissions, data=X, geom="bar", stat='identity', 
      facets=year~., fill=SCC.Level.Three, asp=0.5)

qplot(SCC.Level.Three, Emissions, data=X, geom="bar", stat='identity', 
      facets=~year, fill=SCC.Level.Three)

qplot(year, Emissions, data=X, geom="bar", stat='identity', facets=.~SCC.Level.Three, fill=year)
qplot(year, Emissions, data=X, geom="bar", stat='identity', facets=SCC.Level.Three~., fill=year)



qplot(EI.Sector, Emissions, data=X, geom="bar", stat='identity', facets=year~.)

qplot(Emi, EI.Sector, data=X, geom="bar", stat='identity', facets=year~.)


qplot(year, Emissions, data=X, fill="SCC.Level.Three")

# plot to PNG file
png("plot5.png", width = 480, height = 480)
barplot(total_pollution, main ="Total PM2.5 Emission in Baltimore City, MD", ylab = "PM2.5 in tons", col="blue")
dev.off()