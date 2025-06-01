#  E-Commerce Inventory Demand Forecasting using Time Series in R

This project focuses on forecasting weekly sales for an e-commerce inventory management system using time series techniques in R. It helps anticipate future demand and improve inventory planning accuracy based on historical trends and external factors like holidays, fuel prices, and unemployment rates.

---

##  Dataset Description

**File Name**: `walmart_sales_data.csv`

**Columns**:
- `Store`: Unique identifier for each store
- `Date`: Weekly timestamp
- `Weekly_Sales`: Total sales recorded in the week
- `Holiday_Flag`: Indicates if the week contains a major holiday (1 = Yes, 0 = No)
- `Temperature`: Local temperature
- `Fuel_Price`: Fuel cost in the region
- `CPI`: Consumer Price Index
- `Unemployment`: Unemployment rate

---

##  Objective

- Aggregate historical sales data weekly
- Apply time series forecasting to predict sales for the next 12 weeks
- Generate insights for inventory optimization
- Visualize trends, correlations, and forecasts

---

##  Techniques & Tools Used

### Time Series Modeling:
- `ts()` – converts data into time series format
- `auto.arima()` – automatically selects the best ARIMA model
- `forecast()` – projects future values

### Data Handling:
- Aggregation by `Date` using `dplyr`
- Conversion of date formats using `lubridate`

### Visualization:
- Forecast plot with confidence intervals
- Correlation heatmap
- Sales heatmap across stores and weeks

---

##  Visualizations Included

1. **12-week Forecast Plot**
   - Visualizes predicted sales with 80% and 95% confidence bands
2. **Correlation Plot**
   - Shows relationships between variables like sales, CPI, temperature, etc.
3. **Sales Heatmap**
   - Displays sales intensity by store and week

---

## Output

forecast_results.csv
A file containing 12 weeks of forecasted sales along with 80% and 95% confidence intervals.

---

##  R Libraries Used

```r
library(tidyverse)
library(lubridate)
library(forecast)
library(tseries)
library(ggthemes)
library(scales)
library(corrplot)
library(reshape2)

