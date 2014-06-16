# Exploratory Data Analysis
# June 2014
# Course Project 2
# Plot 3

# Question 3:
# 
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999–2008 for Baltimore City? Which have seen increases in
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot
# answer this question.


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

# Convert year & type column to factors
Baltimore$year <- factor(Baltimore$year)
Baltimore$type <- factor(Baltimore$type)

# Sum total pollution by this year factor
total_pollution = tapply(Baltimore$Emissions, Baltimore$year, sum)

# plot to PNG file
library(datasets)
library(ggplot2)
png("plot3.png", width = 480, height = 480)
# qplot(year, Emissions, data=Baltimore, geom="bar", stat='identity')           # ggplot2 version of Question 2
qplot(year, Emissions, data=Baltimore, geom="bar", stat='identity', facets=type~., 
      main="Total PM2.5 Emissions in Baltimore City, MD", ylab="PM2.5 Emissions in tons")
dev.off()