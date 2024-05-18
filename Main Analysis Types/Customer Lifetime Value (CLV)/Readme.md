# Customer Lifetime Value Analysis (CLV)

Customer Lifetime Value (CLV) stands at the forefront of e-commerce analytics, serving as a crucial metric to gauge the long-term value of customer relationships. Recent scrutiny over Shopify's simplistic CLV formula has prompted a shift towards cohort analysis for more reliable insights. This adjustment responds to two key concerns raised by the manager: the need to include all website users, not just purchasers, and the preference for a 12-week cohort analysis to capture customer engagement dynamics more effectively. The ongoing refinement of CLV calculations underscores its indispensable role in shaping marketing strategies and business planning by providing a nuanced understanding of customer value over time.

## Main Analysis

### 1. Average Order Value (AOV) / Number of Customers

The first step is to write one or two queries to pull data of weekly revenue divided by registrations. Since this particular site has no concept of registration, we will simply use the first visit to our website as the registration date.

![Average Order Value by Cohort Week](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/Customer%20Lifetime%20Value%20(CLV)/clv-aov.png)

- From the data above, we can see that customers are more willing to buy in the first week, as in the longer period the average purchases are decreasing. This could indicate that people find the required products and just slowly replenish them as needed.
- We can see quite the same results in the first 7 weeks from 2020-11-01 till 2020-12-13, but in the longer period, starting week results are slowly decreasing.

### 2. Cumulative Sum of Revenue Growth by Number of Customers

In the upcoming chart, the revenue/registrations for a specific weekly cohort will be presented as a cumulative sum. To construct this chart, the revenue from the previous week was simply added to the current week’s revenue.

![Cumulative Sum of Revenue Growth](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/Customer%20Lifetime%20Value%20(CLV)/clv-cumulative.png)

- From the data above, we can see that during the period from 2020-11-01 till 2020-12-06, the cumulative revenue increases, which could indicate that this particular time period is when people tend to buy more seasonally.

### 3. Future Prediction of Possible Sales with Our Current Data

Next, the focus is on predicting the missing data. In this case, the missing data is the revenue we should expect from later acquired user cohorts. For example, for users whose first session happened in the week of 2021-01-24, we only have their first week revenue, which is 0.19 USD per user. Though we are not sure what will happen in the next 12 weeks, we will use previously calculated cumulative growth percentages (marked area in the chart above) to predict all 12 future weeks' values.

![Future Prediction of Possible Sales with Our Current Data](https://github.com/densen1978/Studies-Data-Projects/blob/main/Main%20Analysis%20Types/Customer%20Lifetime%20Value%20(CLV)/clv-forecast.png)

- As data analysts, we can predict possible sales for the future based on the data we have.
- From the data, we can see from our prediction of cumulative growth percentage and the following weeks that people are going to spend more in the period from 2020-11-01 to 2020-12-06. For the following period, the sales are decreasing.
- From the data, we can see that we need to increase our marketing efforts to better target customers in later periods and offer some promotions to increase potential spending in the future.

## Key Insights

1. Customers tend to spend more in the first weeks, as their average order value decreases over a longer period.
2. There are consistent results of spending from the weeks of 2020-11-01 till 2020-12-13 compared to following weeks, indicating strong seasonality.
3. The period mentioned before shows higher cumulative growth compared to other weeks.
4. Future predictions suggest the same tendency could occur again.
5. With the right marketing campaigns, we can address these inconsistencies in spending habits by creating better-suited campaigns or offering promotions to encourage more purchases.

## Additional Insights

### AOV Cohort
- **Declining AOV Over Time:** A general trend of declining AOV is observed as the weeks progress. The initial AOV in week 0 is the highest, gradually decreasing over subsequent weeks, which is common in many businesses.
- **Week 0 as Peak:** Week 0, representing the initial purchase, has the highest AOV, likely because customers make larger purchases when they first engage with a brand.
- **Stability After Initial Decline:** After the initial decline, AOV seems relatively stable from week 4 onwards, with slight fluctuations.
- **Week 12 AOV:** The AOV in week 12 is $0.01817910, significantly lower than in week 0, reflecting the decrease in average order value over the customer's lifecycle.

### Cumulative Revenue Cohort
- **Overall Revenue Growth:** The cumulative revenue for this cohort shows steady growth over time, with total cumulative revenue increasing as weeks progress.
- **Variance in Growth Rates:** Growth rates between weeks vary, with some weeks showing substantial growth in cumulative revenue and others showing smaller growth rates.
- **Stable Cumulative Revenue:** Despite weekly fluctuations, the cumulative revenue generally increases steadily week to week.

### Prediction
- **Consistent CLV Growth:** CLV predictions for each week within the cohorts generally show an upward trend, indicating that customers are expected to become more valuable over time.
- **Significant Variations:** There are variations in CLV estimates between weeks, with some weeks showing more substantial increases in CLV than others.
- **Week 12 Spike:** In several cohorts, there is a significant spike in CLV in week 12, suggesting some customers may exhibit a substantial increase in value at the end of their customer lifecycle.
- **Average CLV:** The average CLV across all weekly cohorts is $1.64, representing the expected value of a customer over their entire lifetime.
