---
title: "Time Series"
author: "Emerson Amirhosein  Azarbakht"
output: pdf_document
---

# Time Series (TS)

#### Used in
- control of inventory, based on demand trends
- airline's decision to buy airplanes bc of passenger trends and decision to increase/maintain market share
- climate change decisions based on temperature change trends
- business/sales forecasting
- everyday operational decisions
- long-term effects of proposed water management policies by simulating daily rainfall and sea state time series
- understanding fluctuations in monthly sales
- basis for signal processing in telecommunications <?>
- disease incidence tracking, yearly rates
- census analysis

#### Used to
- to understand the past, and predict the future
- forcasting (predicting inference, a subset of statistical inference). assumes that present trends continue. This assumption cannot be checked empirically, but, when we identify the likely causes for a trend, we can justify the forecasting(extrapolating it) for a few time-steps at least
- anomaly detection
- clustering
- classification (assigning a time series pattern to a specific category: e.g. gesture recognition of hand movements in sign language videos)
- query by content<?>

#### Data: 
a variable measured sequentially in time, or at a fixed [sampling] interval 

#### serial dependence problem:
observations close together in time tend to be correlated (serially dependent)

TS tries to explain this correlation (serial dependence)
autocorrelation analysis examines this serial dependence <?>

#### conditions (assumptions of TS)
- stationary process ?
- Ergodic process ?

```{r}
plot(AirPassengers)
start(AirPassengers)
end(AirPassengers)
frequency(AirPassengers)
plot(AirPassengers)
summary(AirPassengers)
layout(1:2) 
plot(aggregate(AirPassengers))
boxplot(AirPassengers ~ cycle(AirPassengers))
```

plotting shows _patterns_, and _features_ of the data + *outliers* and *erroneous* values 


#### patterns
1. trend = a non-periodic systematic change in a TS
    can be modeled simply by a linear increase or decrease
2. seasonal variation = a repeating pattern within a fixed period (e.g. each year)
3. cycles = a non-fixed-period cycle (without a fixed period). example: El-Nino




