# you might need to install some packages first:
# install.packages(c("ggplot2", "lubridate", "dplyr"))
library(ggplot2)
library(lubridate)
library(dplyr)

# big labels for lecture slides only
theme_set(theme_grey(base_size=18))

# === Temperature in Corvallis === #
# a function to get a years worth of daily weather data for KCVO (Corvallis airport)
get_year <- function(year){       
  read.csv(url(paste("http://www.wunderground.com/history/airport/KCVO/", 
    year, "/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=", year,
    "&format=1", sep = "")), stringsAsFactors = FALSE)
}

get_day <- function(day, month, year){
  read.csv(url(paste("http://www.wunderground.com/history/airport/KCVO",
    year, month, day, "DailyHistory.html?format=1", sep = "/")))
}

# get 14 years of data
corvallis <- data.frame(year = 2000:2015) %>% 
  group_by(year) %>%
  do(get_year(.$year))
head(corvallis)

# # save to put on the website for you to use later 
#  write.csv(corvallis, "../data/corvallis.csv", row.names = FALSE)

corvallis$date <- ymd(corvallis$PST)
qplot(date, Mean.TemperatureF, data = corvallis, geom = "line") +
  xlab("Year") +
  ylab("Mean Temperature F")

hot <- get_day(22, 07, 2006)
#  write.csv(hot, "../data/hot-day.csv", row.names = FALSE)

# === Global average temperature === #
# gtemp from S&S 1.2
load(url("http://www.stat.pitt.edu/stoffer/tsa3/tsa3.rda"))
str(gtemp)
# this is a ts (short for "time series") object
# ts objects have there own plotting method but it is inflexible
plot(gtemp)

# a peice of code to take a ts object and make it a data.frame
source(url("http://stat565.cwick.co.nz/code/fortify-ts.r"))
gtemp.df <- fortify(gtemp)
qplot(time, x, data = gtemp.df, geom ="line") + 
  ylab("Temperature Anomoly") +
  xlab("Year")


# === Johnson & Johnson quarterly earnings per share === #
# jj from S&S 1.?
load(url("http://www.stat.pitt.edu/stoffer/tsa3/tsa3.rda"))
jj.df <- fortify(jj)
qplot(time, x, data = jj.df, geom ="line") + 
  ylab("Earnings per share")  +
  xlab("Year")

# stock prices from yahoo
# replace "JNJ" with yout favourite stock ticker symbol
jnj <- read.csv(url("http://ichart.finance.yahoo.com/table.csv?s=JNJ&a=00&b=2&c=1970&d=02&e=30&f=2015&g=d&ignore=.csv"))
jnj$date <- ymd(jnj$Date)
qplot(date, Close, data = jnj, geom = "line") +
  ylab("Closing price") + xlab("Year")


# === an explosion and an earthquake === #
EQ5.df <- fortify(EQ5)
EQ5.df$type <- "earthquake"
EXP6.df <- fortify(EXP6)
EXP6.df$type <- "explosion"
qplot(time, x, data = rbind(EQ5.df, EXP6.df), geom = "line") + 
  facet_grid( type ~ .) +
  ylab("Displacement") +
  xlab("Time (secs?)")

# === Cardiovascular mortality & environmental variables === #
cmort.df <- fortify(cmort)
cmort.df$variable <- "Mortality"

tempr.df <- fortify(tempr)
tempr.df$variable <- "Temperature"

part.df <- fortify(part)
part.df$variable <- "Particulates"

so2.df <- fortify(so2)
so2.df$variable <- "Sulfur Dioxide"

qplot(time, x, data = rbind(cmort.df, part.df, tempr.df, so2.df), geom = "line") + 
  facet_grid( variable ~ ., scale = "free_y") +
  ylab("Value") + xlab("Year")
