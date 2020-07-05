# Energy-Consumption-Forecasting---Multiple-Seasonality
We seek to analyze the electricity consumption data and present the performance of basic forecasting models, STL (Seasonal and Trend decomposition using Loess) with multiple seasonal periods, ETS, ARIMA, TBATS and compare them.

INTRODUCTION
Machine learning models like Time series produce accurate energy consumption forecasts and they can be used by facilities managers, utility companies and building commissioning projects to implement energy-saving policies. We believe that efforts towards estimating energy consumption and developing tools for researchers to advance their research in energy consumption are necessary for a more scalable and sustainable future.
DATA OVERVIEW
The dataset is obtained from PJM Interconnection which is a regional transmission organization in the United States. PJM is part of the Eastern Interconnection grid operating an electric transmission system serving all or parts of Delaware, Illinois, Indiana, Kentucky, Maryland, Michigan, New Jersey, North Carolina, Ohio, Pennsylvania, Tennessee, Virginia, West Virginia and the District of Columbia. The hourly power consumption data are in megawatt. Here, we are just selecting the power consumption for the Duquesne Light Company, which operates primarily in Pittsburgh and surrounding areas for our project.
DATA DESCRIPTION
Data set contains complete power consumption hourly data through 2005 Dec – 2018 Jan. The file has 119069 observations (hourly data) with two variables as shown below:
Date (type time): time frame at which energy was consumed.
Megawatt Energy consumption (type integer): Energy consumption of a particular region.

EXPLORATORY ANALYSIS
Our data set has complete hourly power consumption data of Duquesne Electric Company from 2005 to 2018. It has 119068 observations of 2 variables (Datetime and DUQ_MW).
However, higher frequency time series often exhibit more complicated seasonal patterns. Hourly data usually has three types of seasonality: a daily pattern, a weekly pattern, and an annual pattern. To deal with such series, we will use the msts class which handles multiple seasonality time series which will be discussed later. This allows us to specify all of the frequencies that might be relevant. It is also flexible enough to handle non-integer frequencies.
Before we start exploring the data, we are going to read the data, manipulate it and then visualize our data. Overall, there is a clear trend and strong seasonality in the data set and can be seen in below graph. Now let’s visualize for one particular year to better understand the data, its trend and seasonality. Let’s consider the power consumption in 2017.
2 | P a g e
Power consumption peaks during summer months from Mid-June to October and reduces from September and again increased slightly from December. This shows that people use electricity more in summers and winters for cooling and heating.
Next, for the ease of visualization and minimizing the processing time, we are restricting our data to 2013-2017. We then, estimated the trend component and seasonal component of our subset data using decompose() function. Trend, seasonal, and irregular components of our data can be estimated using this function.
Decomposition:
• The first row shows our original time series.
• The second panel shows the seasonal component, with the figure being computed by taking the average for each time unit over all periods and then centering it around the mean.
• The third panel plots the trend component and we see a clear trend pattern. This might be sourced from uncaptured extra seasonality from higher natural period in this case and with our huge data. Hence it can be considered as multi-seasonal data. To deal with such series, we will use the msts class which handles multiple seasonality time series. This allows us to specify all of the
3 | P a g e
frequencies that might be relevant. Additionally, using msts instead of ts allows us to specify multiple seasons/cycles, for instance hourly as well as daily: c(24, 24*7,24*365.25)
• The last panel shows the remainder component, which is left over data after removing the trend and seasonal components.
Converting to time series:
The next step is to store the data in a time series object, so that we can use many R functions for analyzing our time series data. To store the data in a time series object, we can use the ts() function in R. Sometimes the time series data set that you have, may have been collected at regular intervals that were less than one year, for example, monthly or quarterly. In this case, you can specify the number of times that data was collected per hour by using the frequency parameter in the ts() function. Because each row representing a data within hourly interval, we can set frequency=24, and we will only use Duquesne Electric Company provider.
Now we see a clearer trend in the below graph after decomposing using mstl() and could confirm the daily, weekly and yearly seasonality for our data. Seasonal 168 panel shows the weekly seasonality and seasonal 24 shows the daily seasonality.
MODELLING – FORECASTING
We first split our data into test and train sets. Train data set includes the data from 2013 -2016 and test data contains data from Jan 2017 -Sept 2017 (around 20 % of data). To deal with multiple seasonality’s, we plan to use ARIMA, TBATS, STLM along with few simple basic forecasting models. Before we jump into ARIMA, STLM and TBATS we will first establish baseline forecasting using simple models like Mean, Naïve, and Seasonal Naïve.
Mean & Naïve Forecasts:
The easiest rough estimate for any forecast would be simply the mean or naïve models. So, after training the models with train data, we have established the mean & naïve baseline forecasts for the test data set.
Naïve model has very high prediction intervals which makes it a worse model for our data. Although, mean forecasts has low intervals it failed to consider the high seasonality in the data.
4 | P a g e
SNaive & MSTL (STL + ETS) Forecasts:
SNaive method is useful for highly seasonal data. In this case, we set each forecast to be equal to the last observed value from the same season of the year.
The mstl() function is a variation on stl() designed to deal with multiple seasonality. It will return multiple seasonal components, as well as a trend and remainder component and here’s how it works.
ARIMA & TBATS Forecasts:
With multiple seasonality’s, we can use Fourier terms and will fit a dynamic harmonic regression model with ARIMA. The only drawback here is that it assumes the frequencies stays constant.
A TBATS model differs from dynamic harmonic regression in that the seasonality is allowed to change slowly over time in a TBATS model, while harmonic regression terms force the seasonal patterns to repeat periodically without changing. One drawback of TBATS models, however, is that they can be slow to estimate, especially with long time series. One advantage of the TBATS model is the seasonality is allowed to change slowly over time.
Here the prediction intervals appear to be much too wide – something that seems to happen quite often with TBATS models unfortunately.
5 | P a g e
CONCLUSION
Judgement Criteria: We are going to use the RMSE, MAE & size of the prediction intervals as the metrics to compare different models.
Forecast Metrics Comparison:
Looking at forecast from all the models, the forecast from mstl() or stlm is showing a better performance (lower RMSE & smaller prediction intervals) and is definitely our winner here
