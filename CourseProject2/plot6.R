# Exploratory Data Analysis
# June 2014
# Course Project 2
# Plot 6

# Question 6:
# 
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?

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
LosAngeles <- subset(NEI, fips == "06037")              # subset LA data
BaltiVehicle <- subset(Baltimore, type == "ON-ROAD")    # subset Baltimore vehicle data
LAVehicle <- subset(LosAngeles, type == "ON-ROAD")      # subset LA vehicle data
SCC <- readRDS(file=paste0(filePath, fileName2))

# join emissions data with SCC table subset 
library(plyr)
B = join(BaltiVehicle, SCC, by="SCC", type = "inner")
LA = join(LAVehicle, SCC, by="SCC", type = "inner")
B$year <- factor(B$year)                                # Convert year column to a factor
LA$year <- factor(LA$year)

# Multiple plot function
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
        require(grid)
        
        # Make a list from the ... arguments and plotlist
        plots <- c(list(...), plotlist)
        
        numPlots = length(plots)
        
        # If layout is NULL, then use 'cols' to determine layout
        if (is.null(layout)) {
                # Make the panel
                # ncol: Number of columns of plots
                # nrow: Number of rows needed, calculated from # of cols
                layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                                 ncol = cols, nrow = ceiling(numPlots/cols))
        }
        
        if (numPlots==1) {
                print(plots[[1]])
                
        } else {
                # Set up the page
                grid.newpage()
                pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
                
                # Make each plot, in the correct location
                for (i in 1:numPlots) {
                        # Get the i,j matrix positions of the regions that contain this subplot
                        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
                        
                        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                                        layout.pos.col = matchidx$col))
                }
        }
}

# plot results
library(datasets)
library(ggplot2)
png("plot6.png", width = 960, height = 960)

gB <- ggplot(B, aes(SCC.Level.Three, Emissions, fill=SCC.Level.Three)) +
        geom_bar(stat="identity") + 
        facet_grid(. ~ year) +
        scale_x_discrete(breaks=NULL) +                              # suppress x-axis label
        labs(x="---total emission levels indicated by dashed lines---") +
        theme(axis.title.x = element_text(colour = "#990000"),
              axis.title.y = element_text(colour = "black")) +
        labs(y="PM2.5 Emissions (in tons)") +
        labs(title="Baltimore City, Maryland | Motor Vehicle PM2.5 Emissions") + 
        labs(fill = "Vehicle Type")

gLA <- ggplot(LA, aes(SCC.Level.Three, Emissions, fill=SCC.Level.Three)) +
        geom_bar(stat="identity") + 
        facet_grid(. ~ year) +
        scale_x_discrete(breaks=NULL) +                              # suppress x-axis label
        labs(x="---total emission levels indicated by dashed lines---") +
        theme(axis.title.x = element_text(colour = "#990000"),
              axis.title.y = element_text(colour = "black")) +
        labs(y="PM2.5 Emissions (in tons)") +
        labs(title="Los Angeles County, California | Motor Vehicle PM2.5 Emissions") + 
        labs(fill = "Vehicle Type")

# add horizontal line for sum of emissions for each facet
B_total = tapply(B$Emissions, B$year, sum)
B_hline.data <- data.frame(z = B_total, year = names(B_total))
gB <- gB + geom_hline(aes(yintercept = z), B_hline.data, colour="#990000", linetype="dashed")

LA_total = tapply(LA$Emissions, LA$year, sum)
LA_hline.data <- data.frame(z = LA_total, year = names(LA_total))
gLA <- gLA + geom_hline(aes(yintercept = z), LA_hline.data, colour="#990000", linetype="dashed")

multiplot(gB, gLA, cols=1)
dev.off()
