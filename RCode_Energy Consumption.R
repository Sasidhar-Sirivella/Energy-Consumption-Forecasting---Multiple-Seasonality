library(tidyverse)
library(IRdisplay)
library(ggplot2)
library(fpp2)
library(forecast)
library(xts)
library(forecast)
library(lubridate)
library(scales)
library(knitr)
library(data.table)

## Reading the data
duq_pc <- read.csv(file.choose(),stringsAsFactors = F)
head(duq_pc)
str(duq_pc)

## Visualizing the whole data
ggplot(data = duq_pc, aes(x = Datetime, y = DUQ_MW))+
  geom_line(color = "#FF0000", size = 0.5)+ ggtitle(' Duqnese-PowerConsumption from 2007-2017')+
  xlab('Date') + ylab('Consumption in MW')

## Now lets visualize for one particular year to better understand the data
# Lets look at 2006 & 2017

ggplot(data = duq_pc[duq_pc$Datetime >= '2006-01-01' & duq_pc$Datetime <= '2006-12-31',], aes(x = Datetime, y = DUQ_MW))+
  geom_line(color = "#FF0000", size = 0.5) + ggtitle('Duqunese-PowerConsumption in 2006')+
  xlab('Date') + ylab('Consumption in MW')

ggplot(data = duq_pc[duq_pc$Datetime >= '2017-01-01' & duq_pc$Datetime <= '2017-12-31',], aes(x = Datetime, y = DUQ_MW))+
  geom_line(color = "#FF0000", size = 0.5) + ggtitle('Duqunese-PowerConsumption in 2017')+
  xlab('Date') + ylab('Consumption in MW')

## Storing the data in a time series object
duq_pc$Datetime <- ymd_hms(duq_pc$Datetime) #datetime format
ts_train<-duq_pc$DUQ_MW %>% ts(freq= 24) #specifying the number of times that data was collected

## Estimating the trend component and seasonal component of our data
ts_train %>% 
  tail(24*7*5) %>% 
  decompose() %>% 
  autoplot()


##-----Modelling-------

#For ease of visualisation and minimising the processing time, we are restricting our 
#data to 2011-2017


duq_new <- duq_pc[duq_pc$Datetime >= '2013-01-01 00:00:00' & duq_pc$Datetime <= '2017-09-30 00:00:00',]
#Dividing our data into train and test

duq_train <- duq_new[duq_new$Datetime <= '2016-12-31',]
duq_test <- duq_new[duq_new$Datetime >= '2017-01-01',]
msts_power <- msts(duq_train$DUQ_MW, seasonal.periods = c(24,24*7,24*365.25), start = decimal_date(as.POSIXct("2013-01-01 00:00:00")))

#Decomposing our data using mstl
msts_power %>% mstl() %>% autoplot() #decomposing using mstl

#----Basic Forecasting----

#Mean forecasting
mean_baseline <- meanf(msts_power,h=24*7*40)
summary(mean_baseline)
autoplot(mean_baseline) + ggtitle('Mean- Forecast')+
  xlab('Year') + ylab('Consumption in MW')
accuracy(mean_baseline,duq_test$DUQ_MW)


#Predicting for h=7 using MSTL(STL+ETS)

fcast_mstl <- msts_power %>%  stlf() %>% forecast(h = 24*7*40) 
summary(fcast_mstl)

autoplot(fcast_mstl) + ggtitle('STL +  ETS(A,Ad,N)- MSTL Forecast')+
  xlab('Year') + ylab('Consumption in MW')
accuracy(fcast_mstl,duq_test$DUQ_MW)

checkresiduals(fcast_mstl)


#Naive Forecasts
fcast_naive <- naive(msts_power,h=24*7*40)
summary(fcast_naive)

autoplot(fcast_naive) +ggtitle('Naive- Forecast')+
  xlab('Date') + ylab('Consumption in MW')

accuracy(fcast_naive,duq_test$DUQ_MW)

#Snaive Forecasts
fcast_snaive <- snaive(msts_power,h=24*7*40)
summary(fcast_snaive)

autoplot(fcast_snaive) +ggtitle('SNaive- Forecast')+
  xlab('Date') + ylab('Consumption in MW')


#Dynamic Harmonic regression with Auto Arima

fourier_power <- auto.arima(msts_power, seasonal=FALSE, lambda=0,
                            xreg=fourier(msts_power, K=c(10,10,10)))


f_fourier <-  forecast(fourier_power, xreg=fourier(msts_power, K=c(10,10,10), h=24*7*40))
f_fourier
autoplot(f_fourier) +
  ylab("Power Consumption predicted") + xlab("Time")

accuracy(f_fourier, duq_test$DUQ_MW)

#TBATS
tbats_power <- tbats(msts_power)
f_tbats <- forecast(tbats_power, h = 24*7*40)
autoplot(f_tbats) +ggtitle('Duquesne Power - Forecast, 2016-17')+
  xlab('Date') + ylab('Consumption in MW')
accuracy(f_tbats,duq_test$DUQ_MW)
 

## Comparing the accuracies
mean_results <-accuracy(mean_baseline,duq_test$DUQ_MW)
naive_results <- accuracy(fcast_naive,duq_test$DUQ_MW)
rwf_results <- accuracy(fcast_rwf,duq_test$DUQ_MW)
snaive_results <- accuracy(fcast_snaive,duq_test$DUQ_MW)
stlm_model_results<- accuracy(fcast_mstl,duq_test$DUQ_MW)
arima_results<- accuracy(f_fourier, duq_test$DUQ_MW)
tbats_results<- accuracy(f_tbats,duq_test$DUQ_MW)


Summary_table= data.table(rbind(mean_results,naive_results,rwf_results,snaive_results,stlm_model_results,arima_results,tbats_results))
Summary_table[,Split:=c("Train","Test","Train","Test","Train","Test","Train","Test","Train","Test","Train","Test","Train","Test")]
Summary_table[,Method:=c(rep("Mean",2),rep("Naive",2),rep("Drift",2),rep("Snaive",2),rep("STLM",2),rep("ARIMA",2),rep("TBATS",2))]
kable(Summary_table)

## Comparing the models with help of plots

autoplot(msts_power, series = "Original data") +
  geom_line(size = 1) +
  autolayer(fcast_naive, PI = FALSE, size = 1,
            series = "naive") +
  autolayer(fcast_snaive, PI = FALSE, size = 1,
            series = "snaive") +
  autolayer(fcast_mstl, PI = FALSE, size = 1,
            series = "MSTL Model") +
  autolayer(mean_baseline, PI = FALSE, size = 1,
            series = "Mean") +
  autolayer(f_tbats, PI = FALSE, size = 1,
            series = "TBATS") +
  autolayer(f_fourier, PI = FALSE, size = 1,
            series = "ARIMA") +
  
  ggtitle("Forecast from naive, snaive,Mean, MSTL, ARIMA and TBATS methods")
  



