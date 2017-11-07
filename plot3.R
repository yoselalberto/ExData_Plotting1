# code for create the third graph


# settings --------------------------------------------------------------------------

library(tidyverse) # useful packages for data science
library(lubridate) # make handling dates easy


# downloading data ------------------------------------------------------------------

# if the file does not exist, download it in the working directory
file_name <- "Electric_power_comsumption.zip"
origin <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists(file_name)) {
  download.file(origin, file_name)
}


# loading ---------------------------------------------------------------------------

# read_delim can read compressed files
data_raw <- read_delim(file_name, delim = ";", col_types = cols(Voltage = "d"), na = "?") 


# preprocessing ---------------------------------------------------------------------

# days selected 
days_selected <- ymd("2007-02-01", "2007-02-02")
# parsing Date column to date, and keeping days of interest
data_selected <- data_raw %>% 
  mutate(Date = lubridate::dmy(Date)) %>% 
  filter(Date %in% days_selected)
# paste Date and Time column, and coerse it to datetime class
data <- data_selected %>% 
  tidyr::unite(datetime, Date, Time, sep = " ") %>% 
  mutate(datetime = as_datetime(datetime))


# plot 3 ------------------------------------------------------------------

png("plot3.png", height = 480, width = 480)
par(bg = NA)
with(data, {
  plot(datetime, Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")  
  lines(datetime, Sub_metering_2, col = "red")
  lines(datetime, Sub_metering_3, col = "blue")
})
legend("topright", lty = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"))
dev.off()
