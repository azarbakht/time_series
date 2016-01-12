install.packages("ggplot2")
install.packages("dplyr")
install.packages("lubridate")

library(ggplot2)
library(dplyr)
library(lubridate)

# generally a good idea in my book - stops character strings being converted to factors automatically
options(stringsAsFactors = FALSE)

# read in the daily weather data
corvallis <- read.csv(url("http://stat565.cwick.co.nz/data/corvallis.csv"))
# or read in the daily weather data locally
corvallis <- read.csv("corvallis.csv)")



head(corvallis)
tail(corvallis)

# just to make things simpler, get rid of other weather stuff
corv <- corvallis %>% 
  select(PST, Mean.TemperatureF, PrecipitationIn) %>%
  rename(temp = Mean.TemperatureF, precip = PrecipitationIn)

# and grab one particularly hot day
hot <- read.csv(url("http://stat565.cwick.co.nz/data/hot-day.csv"))
hot <- hot %>% 
  select(TimePDT, TemperatureF, PrecipitationIn, DateUTC.br...) %>%
  rename(temp = TemperatureF, precip = PrecipitationIn,
    dateUTC = DateUTC.br...)


######################
# === HERE! ===
######################

# PST is just a character string
# find out its structure
str(corv)
corv$PST[1]

# my preference is just to have a date/time column
corv$date <- ymd(corv$PST)

# and often add columns with time broken down long term and seasonal
corv <- mutate(corv, 
  year = year(date),
  month = month(date),
  yday = yday(date))

# some strings to practice converting 
A <- "1-7-14"
B <- "Jan 7 14"
C <- "1:15 AM 2014-01-07"
D <- "3:25 PM"
E <- "Tue Jan 7 2014"


# ASIDE: some missing days? which ones?
all_days <- seq(ymd("2000/01/01"), ymd("2011/12/31"),  by = "day")
all_days[!(all_days %in% corv$date)]

# ==== Graphical exploration: the fun stuff! ==== #
# A "time series" plot
qplot(date, temp, data = corv, geom = "line")
# gaps come from missing values "NA"
# straight lines come from ommitted records


#==== aggregation with plyr ====#
last_year <- filter(corv, year == 2013)

mutate(last_year, 
  avg_temp = mean(temp, na.rm = TRUE),
  n_temp = sum(!is.na(temp))
)

summarise(last_year, 
  avg_temp = mean(temp, na.rm = TRUE),
  n_temp = sum(!is.na(temp))
)

corv %>% group_by(year) %>%
  summarise(avg_temp = mean(temp, na.rm = TRUE))

corv %>% group_by(year) %>%
  mutate(avg_temp = mean(temp, na.rm = TRUE))

# summarise to annual level data
ann_temp <- corv %>% group_by(year) %>%
  summarise(
    avg_temp = mean(temp, na.rm = TRUE),
    n = sum(!is.na(temp)))

qplot(year, avg_temp, 
  data = ann_temp, geom = "line")
# but we lose all sense of scale

# An alternative, rather than summarise, mutate
corv <-  corv %>% 
  group_by(year) %>%
  mutate(
    avg_temp = mean(temp, na.rm = TRUE),
    n = sum(!is.na(temp)))

qplot(date, avg_temp, 
  data = corv, geom = "line", 
  size = I(2), colour = I("blue")) +
  geom_line(aes(y = temp))

# adding some labels etc.
qplot(date, avg_temp, 
    data = corv, geom = "line", 
    size = I(2), colour = I("blue")) +
  geom_line(aes(y = temp)) +
  xlab("Date") + ylab("Temperature (F)") +
  ggtitle("Corvallis (KCVO) Daily Average Temperature") 
  
  
# other plots 
# simple histogram
qplot(temp, data = corv)
# change the binwidth
qplot(temp, data = corv, binwidth = 1)
qplot(temp, data = corv, breaks=seq(10, 100, by=1))
# density plot instead
qplot(temp, data = corv, geom = "density")
# smaller bandwidth
qplot(temp, data = corv, geom = "density", adjust = 0.25, fill = I("grey20"))

