# Exploratory Data Analysis
# June 2014
# Course Project 2
# Plot 1

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
#       This table provides a mapping from the SCC digit strings in the Emissions
#       table to the actual name of the PM2.5 source.
SCC <- readRDS(file=paste0(filePath, fileName2))

# Convert year column to a factor
NEI$year <- factor(NEI$year)

# Sum total pollution by this year factor
total_pollution = tapply(NEI$Emissions, NEI$year, sum)

# plot to PNG file
library(datasets)
png("plot1.png", width = 480, height = 480)
barplot(total_pollution, main ="Total PM2.5 Emission", ylab = "PM2.5 in tons", col="red")
dev.off()