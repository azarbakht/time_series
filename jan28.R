library(ggplot2)
load(url('http://stat565.cwick.co.nz/data/series-1.rda'))
qplot(1:length(x), x, geom = "line")

acf(x)
pacf(x)

fit <- arima(x, c(4, 0, 4))

fit
res <- residuals(fit)
acf(res)
pacf(res)
qplot(sample = res)


best.order <- c(0, 0, 0)
best.aic <- Inf

for (i in 0:20) for (j in 0:20) {
  fit.aic <- AIC(arima(x, order = c(i, 0,j)))
  if (fit.aic < best.aic) {
    best.order <- c(i, 0, j)
    best.arma <- arima(x, order = best.order)
    best.aic <- fit.aic
  }
}
# what's the best order found:

best.order

# correlogram
acf(resid(best.arma))
?arima
