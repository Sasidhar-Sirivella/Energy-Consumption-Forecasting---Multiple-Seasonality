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

