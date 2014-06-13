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

NEI <- readRDS(paste0(filePath, fileName1))     # PM2.5 Emissions Data
SCC <- readRDS(paste0(filePath, fileName2))     # Source Classification Code Table 







# sample data file to determine classes
sampleData <- read.csv(xFile, stringsAsFactors=FALSE,sep=";",na.strings="?", nrows = 5)
classes <- sapply(sampleData, class)
classes

# read all data and convert Date column from char
all_data <- read.csv(xFile, stringsAsFactors=FALSE,sep=";",na.strings="?", colClasses = classes)

# subset data
data <- subset(all_data, Date == "1/2/2007" | Date == "2/2/2007")

# plot to PNG file
library(datasets)
png("plot1.png", width = 480, height = 480)
hist(data$Global_active_power, xlab = "Global Active Power (kilowatts)", 
     col="red", bg="white", main = "Global Active Power")
dev.off()