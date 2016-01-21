library(ggplot2)
library(dplyr)
library(lubridate)
options(stringsAsFactors = FALSE)
# for slides
big_font <- theme_grey(base_size =  24)

# == read in and tidy data == #
load(url("http://stat565.cwick.co.nz/data/corv.rda"))
# read in the daily weather data
# clean up our data so that is has all the dates and is in order.
all_days <- data.frame(date = seq(ymd("2000/01/01"), ymd("2013/12/31"),  by = "day"))
# merge them together
corv <- join(corv, all_days, type = "full")

# redo years, months and ydays
corv$year <- year(corv$date)
corv$month <- month(corv$date)
corv$yday <- yday(corv$date)

# force it to be in order
corv <- corv[order(corv$date), ]

# fit the seasonal model in preparation for subtraction
lo_fit <- loess(temp ~ yday, data = corv, na.action = na.exclude)
corv$seasonal_smooth <- fitted(lo_fit)
# subtract off pattern
corv$deseasonalised <- corv$temp - corv$seasonal_smooth

# fit the trend model in preparation for subtraction
lo_fit_trend <- loess(deseasonalised ~ as.numeric(date), data = corv, na.action = na.exclude,
                      span = 0.4)
corv$trend_smooth <- fitted(lo_fit_trend)
corv$residual <- corv$deseasonalised - corv$trend_smooth

# == examine time plot == #
qplot(date, residual, data = corv, geom = "line") +
  big_font

# is there a trend in variance?
qplot(date, residual^2, data = corv) +
  geom_smooth(method = "loess", size = 1) +
  big_font 

# is there seasonality?
qplot(yday, residual^2, data = corv) +
  geom_smooth(method = "loess", size = 1) +
  big_font

# check for mean variance relationship, 
qplot(temp - residual, residual^2, data = corv) +
  geom_smooth(method = "loess", size = 1) +
  big_font

# === autocorrelation === #
# residuals versus residual on previous day (lag 1 residual)
corv$residual_lag1 <- c(NA, corv$residual[-nrow(corv)])
head(corv)
tail(corv)

qplot(residual, residual_lag1, data = corv)
with(corv, cor(residual, residual_lag1, 
  use = "pairwise.complete.obs"))

corv$residual_lag2 <- c(NA, corv$residual_lag1[-nrow(corv)])
qplot(residual, residual_lag2, data = corv)
with(corv, cor(residual, residual_lag2, 
  use = "pairwise.complete.obs"))

# silently converts to a ts object, usual cautions apply
acf(corv$residual, na.action = na.pass)
# check higher lags too
acf(corv$residual, lag.max = 400, na.action = na.pass)
abline(v = 365)

# we could do it on the raw series too....
acf(corv$temp, lag.max = 400, na.action = na.pass)


