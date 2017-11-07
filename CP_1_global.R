#


# configuracion ----------------------------------------------------------

library(magrittr)
library(tidyverse)
library(janitor)
library(lubridate)
library(stringr)


# cargado -----------------------------------------------------------------

datos_crudos <- read_delim("Data/household_power_consumption.txt", delim = ";",
                          col_types = cols(Voltage = "d"), na = "?") %>% clean_names()


# filter dates ------------------------------------------------------------

# conservo la actividad de los dos días seleccionado
datos_periodo <- datos_crudos %>% 
  mutate(date = dmy(date)) %>% 
  filter(date %in% ymd("2007-02-01", "2007-02-02"))

# create datetime
datos <- datos_periodo %>% 
  mutate(datetime = as_datetime(str_c(date, time, sep = "")))


# plot 1 ------------------------------------------------------------------

datos$global_active_power %>% 
  hist(col = "red", main = "Global Active Power",
       xlab = "Global Active Power (kilowatts)")

# plot 2 ------------------------------------------------------------------

datos %$% 
  plot(datetime, global_active_power, type = "l", xlab = "",
       ylab = "Global Active Power (kilowatts)")


# plot3 -------------------------------------------------------------------

with(datos, {
  plot(datetime, sub_metering_1, type = "l", col = "black", xlab = "",
       ylab = "Energy sub metering")  
  lines(datetime, sub_metering_2, col = "red")
  lines(datetime, sub_metering_3, col = "blue")
})
legend("topright", lty = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"))

# plot 4 ------------------------------------------------------------------

par(mfcol = c(2, 2))
# 1, 1
datos %$% 
  plot(datetime, global_active_power, type = "l", xlab = "",
       ylab = "Global Active Power")
# 2, 1
with(datos, {
  plot(datetime, sub_metering_1, type = "l", col = "black", xlab = "",
       ylab = "Energy sub metering")  
  lines(datetime, sub_metering_2, col = "red")
  lines(datetime, sub_metering_3, col = "blue")
})
legend("topright", lty = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"))
# 1, 2
datos %$% plot(datetime, voltage, ylab = "Voltage", type = "l") 
# 2, 2
datos %$% plot(datetime, global_reactive_power, type = "l",
               ylab = "Global_reactive_power")


