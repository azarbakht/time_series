?arima.sim

y = arima.sim(n = 30, model = list(ar=c(0.2)))
plot(y)

best.order <- c(0, 0, 0)
best.aic <- Inf

for (i in 1:6){
  fit.aic <- AIC(arima(y, c(i,0,0)))
  if (fit.aic < best.aic) {
    best.order <- i
    best.aic <- fit.aic
  }
}

best.aic
best.order

