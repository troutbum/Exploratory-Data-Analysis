# Exploratory Data Analysis
# June 2014
# Course Project 1
# Plot 4

# create a data subdirectory if it does not exist
if (!file.exists("data")) {
        dir.create("data")
}

# download file if it isn't already there
filePath <- "./data/"
fileZipName <- "exdata-data-household_power_consumption.zip"
fileName <- "household_power_consumption.txt"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

ZipFile <- paste0(filePath, fileZipName)        # path to zipped data file
xFile <- paste0(filePath, fileName)             # path to unzipped data file

if (!file.exists(xFile)) {
        download.file(fileUrl, destfile = ZipFile, method ="curl")
        unzip(ZipFile, exdir=filePath)
        dateDownloaded <- date()
}


# sample data file to determine classes
sampleData <- read.csv(xFile, stringsAsFactors=FALSE,sep=";",na.strings="?", nrows = 5)
classes <- sapply(sampleData, class)
classes

# read all data and convert Date column from char
all_data <- read.csv(xFile, stringsAsFactors=FALSE,sep=";",na.strings="?", colClasses = classes)

# subset data
data <- subset(all_data, Date == "1/2/2007" | Date == "2/2/2007")

# create column for datetime objects converted from character columns
data$datetime <- paste(data$Date, data$Time)
data$datetime <- strptime(data$datetime, format="%d/%m/%Y %H:%M:%S")

# plot to PNG file
library(datasets)
png("plot4.png", width = 480, height = 480)

## set graphics parameters
#       mfcol - matrix of sub plots (filled by column)
#       mar - margins
#       oma - outside margins
par(mfcol = c(2, 2), mar = c(4, 4, 2, 2), oma = c(0, 0, 0, 0))

# scale y-axis to accommodate all 3 measurements

# NW Plot (plot2) - use "with" to cleanup code
with( data, plot(datetime, Global_active_power, type="l",
     ylab = "Global Active Power", xlab=""))

# SW Plot (plot3)
ylim = range(c(data$Sub_metering_1, data$Sub_metering_2, data$Sub_metering_3))
with(data, {
        plot(datetime, Sub_metering_1, type="l", ylab = "Energy sub metering", xlab="")
        lines(datetime, Sub_metering_2, type="l", col="red")
        lines(datetime, Sub_metering_3, type="l", col="blue")
        legend("topright","",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
               bty="n", col=c("black","red","blue"), lwd=c(1,1,1))
})

# NE Plot
with( data, plot(datetime, Voltage, type="l",
                 ylab = "Voltage"))

# SE Plot
with( data, plot(datetime, Global_reactive_power, type="l"))

dev.off()
