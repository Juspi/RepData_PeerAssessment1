---
title: "Reproducible Research Project 1"
author: "Juuso Viljanen"
date: "Thursday, February 12, 2015"
output: html_document
---

##Loading and preprocessing the data  

Show any code that is needed to

1.Load the data (i.e. read.csv())

2.Process/transform the data (if necessary) into a format suitable for your analysis

```{r}
library(ggplot2)
setwd("~/Coursera/Reproducible Research/Viikko 2/Tehtävä 1")
unzip("repdata_data_activity.zip")
data<- read.csv("activity.csv")
```

##What is mean total number of steps taken per day?  

For this part of the assignment, you can ignore the missing values in the dataset.

1. Calculate the total number of steps taken per day

```{r}
sum(data1$steps)
```

2. If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day

```{r}
dataaggr<-aggregate(steps~date,data1, FUN="sum")
hist(dataaggr$steps, breaks=30, xlab="Steps", main="Steps taken per day")
```

3. Calculate and report the mean and median of the total number of steps taken per day

```{r}
mean(dataaggr$steps)
```
```{r}
median(dataaggr$steps)
```

##What is the average daily activity pattern?  

1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```{r}
dataaggr1<-aggregate(steps~interval,data1, FUN="mean")
plot(dataaggr1, type = "l", xlab="Interval", main="Average Steps per Interval",
     ylab="Steps")
```

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```{r}
dataaggr1$interval[which.max(dataaggr1$steps)]
```

##Imputing missing values  

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```{r}
sum(!complete.cases(data))
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
```{r}
data2<-data
data2$steps[is.na(data2$steps)]<-mean(data1$steps)
```

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r}
mean(dataaggr2$steps)
```

```{r}
median(dataaggr2$steps)
```

```{r}
dataaggr2<-aggregate(steps~date,data2, FUN="sum")
hist(dataaggr2$steps, breaks=30, xlab="Steps", main="Steps taken per day with mean values")
```

Yes it does. Histogram is more evenly distributed, although one aggregated value stands out more.

##Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```{r}
data3<-data
data3$steps[is.na(data3$steps)]<-mean(data1$steps)
data3$factor[(!weekdays(as.Date(data3$date)) %in% c("lauantai", "sunnuntai"))]<-"weekday"
data3$factor[(weekdays(as.Date(data3$date)) %in% c("lauantai", "sunnuntai"))]<-"weekend"


```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

```{r}
dataaggr3<-aggregate(steps~interval + factor,data3, FUN="mean")
ggplot(dataaggr3, aes(x=interval, y=steps, group=1)) + geom_line(colour="blue") +
  facet_wrap(~ factor, ncol=1) + xlab("Interval") + ylab("Steps")
```