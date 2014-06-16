# Exploratory Data Analysis
# June 2014
# Course Project 2
# Plot 2

# Question 2:
# 
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == 24510) from 1999 to 2008? Use the base plotting system to make a plot
# answering this question.

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

# Convert year column to a factor
Baltimore$year <- factor(Baltimore$year)

# Sum total pollution by this year factor
total_pollution = tapply(Baltimore$Emissions, Baltimore$year, sum)

# plot to PNG file
library(datasets)
png("plot2.png", width = 480, height = 480)
barplot(total_pollution, main ="Total PM2.5 Emission in Baltimore City, MD", ylab = "PM2.5 in tons", col="blue")
dev.off()