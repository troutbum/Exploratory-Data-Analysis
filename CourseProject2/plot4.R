# Exploratory Data Analysis
# June 2014
# Course Project 2
# Plot 4

# Question 4:
# 
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
#
# (reference:  Getting-and-Cleaning-Data / Week4 / Quiz4-4.R for coding example)
#

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
# Source Classification Code Table:
SCC <- readRDS(file=paste0(filePath, fileName2))

# find SCC rows that contain "coal"
# note that SCC$Short.Name finds more than any other column
containsCoal <- grep("*[Cc][Oo][Aa][Ll]",SCC$Short.Name)
subSCC <- SCC[containsCoal,c(1,2,3)]

# join emissions data with SCC table subset 
library(plyr)
coaldata = join(NEI, subSCC, by="SCC", type = "inner")                                         

# Convert year column to a factor
coaldata$year <- factor(coaldata$year)

# Sum total pollution by this year factor
total_pollution = tapply(coaldata$Emissions, coaldata$year, sum)

# plot to PNG file
library(datasets)
png("plot4.png", width = 480, height = 480)
barplot(total_pollution, main ="Total United States PM2.5 Emissions from Coal", 
        ylab = "PM2.5 in tons", col="black")
dev.off()