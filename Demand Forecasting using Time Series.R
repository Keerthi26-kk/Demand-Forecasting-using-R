library(tidyverse)
library(lubridate)
library(forecast)
library(tseries)
library(ggthemes)
library(corrplot)
library(reshape2)
library(scales)

data <- read.csv("wm.csv")
data$Date <- as.Date(date$Date, format="%Y-%m-%d")

add_data <- data %>%
  group_by(Date) %>%
  summarise(Weekly_Sales = sum (Weekly_Sales, na.rm = TRUE)) %>%
  arrange(Date)

ggplot(agg_data, aes(x= Date, y= Weekly_Sales))+
  geom_line(color="darkblue", size=1)+
  labs(title = " Weekly Sales Over Time", x="Date", y="Total Weekly Sales")+
  theme_minimal()

agg_data <- agg_data %>%
  mutate (Year=year(Date), Week = week(Date))

ggplot(agg_data, aes(x=Week, Y=Weekly_Sales,group=Year,color=factor(Year)))+
  geom_line()+
  labs(title = "Seasonality plot: Weekly Sales by Year", x= "Week of Year",y="Sales",color="Year")+
  theme_light()

num_cols <- data %>%
  select(Weekly_Sales,Temperature, Fuel_Price, CPI,Unemployment)

cor_matrix <- cor(num_cols, use="complete.obs")

corrplot(cor_matrix, method = "color",addCoef.col= "black", t1.col="black",
         title = "Correlation Heatmap", mar = c(0,0,2,0))

start_year <- year(min(agg_data$Date))
start_week <- week(min(agg_data$Date))
ts_sales <- ts(agg_data$Weekly_Sales, frequency=52, strat= c(start_year, start_week))

decomp <- decompose(ts_sales)
autoplot(decomp) + ggtitle("Decomposition of Time Series") + theme_minimal()

adf.test(ts_sales)

diff_sales <- diff(ts_sales)
adf.test(diff_sales)

fit <- auto.arima(ts_sales)
summary(fit)

forecast_sales <- forecast(fit, h= 12)

autoplot(forecast_sales)+
  labs(title="12-week Sales Forecast", x= "Week",y="Forecasted Sales")+
  scale_y_continuous(labels=dollar_format())+
  theme_economist()

forecast_df <- data.frame(
  Date = seq(max(agg_data$Date)+7,by="week",length.out=12),
  Forecasted_Sales = as.numeric(forecast_sales$mean),
  Lower_80 = forecast_sales$lower[,1],
  Upper_80 = forecast_sales$upper[,1],
  Lower_95 = forecast_sales$lower[,2],
  Upper_95 = forecast_sales$upper[,2]
)

ggplot(forecast_df, aes(x=Date))+
  geom_line(aes(y=Forecasted_Sales),color="darkgreen",size=1.2)+
  geom_ribbon(aes(ymin=Lower_95, ymax= Upper_95),fill = "lightgreen",alpha=0.4)+
  geom_ribbon(aes(ymin=Lower_80, ymax=Upper_80),fill="darkseagreen2",alpha=0.5)+
  labs(title="Forecast with 80% and 95% Confidence Intervals",y = "Sales", x ="Date")+
  theme_classic()

write.csv(forecast_df, "forecast_results.csv",row.names=FALSE)

