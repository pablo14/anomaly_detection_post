install.packages("devtools")
devtools::install_github("petermeissner/wikipediatrend")
devtools::install_github("twitter/AnomalyDetection")
install.packages("Rcpp")

library(wikipediatrend) ## Library containing API wikipedia access   
library(AnomalyDetection)
library(ggplot2)

## Download wiki webpage "fifa" 
fifa_data = wp_trend("fifa", from="2013-03-18", lang = "en")

## Plotting data
ggplot(fifa_data, aes(x=date, y=count, color=count)) + geom_line()

## Convert date variable
fifa_data$date = as.POSIXct(fifa_data$date)

## Keep only desiered variables (date & page views)
fifa_data=fifa_data[,c(1,2)]

## Apply anomaly detection
data_anomaly = AnomalyDetectionTs(fifa_data, max_anoms=0.01, direction="pos", plot=TRUE, e_value = T)


jpeg("03_fifa_wikipedia_term_page_views_anomaly_detection.jpg", width= 8.25, height= 5.25, units="in", res=500, pointsize = 4)
## Plot original data + anomalies points
data_anomaly$plot
dev.off()


## Calculate deviation percentage from the expected value 
data_anomaly$anoms$perc_diff=round(100*(data_anomaly$anoms$expected_value-data_anomaly$anoms$anoms)/data_anomaly$anoms$expected_value)

## Plot anomalies table
anomaly_table=data_anomaly$anoms




