# code for create the first graph


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


# plot 1 ------------------------------------------------------------------

png("plot1.png", height = 480, width = 480)
par(bg = NA)
hist(data$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.off()
