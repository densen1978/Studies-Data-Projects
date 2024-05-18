# Cohorts, Retention and Churn

## Task Description 

You got a follow up task from your product manager to give stats on how subscriptions churn looks like from a weekly retention standpoint. Your PM argues that to view retention numbers on a monthly basis takes too long and important insights from data might be missed out.

You remember learning previously that cohorts analysis can be really helpful in such cases. You should provide weekly subscriptions data that shows how many subscribers started their subscription in a particular week and how many remain active in the following 6 weeks. Your end result should show weekly retention cohorts for each week of data available in the dataset and their retention from week 0 to week 6. Assume that you are doing this analysis on 2021-02-07.

You should use turing_data_analytics.subscriptions table to answer this question. Please write a SQL that would extract data from the BigQuery, make a visualisation using Google spreadsheets and briefly comment your findings.

## Overview
This project involves performing weekly subscription cohort analysis to comprehend retention over six weeks, utilizing BigQuery and Google Spreadsheets.

## Project Structure
The aim of this project is to perform weekly cohort analysis and study the retention rate of customers for six consecutive weeks based on their <kbd>subscription_start</kbd> and <kbd>subscription_end</kbd> dates.

## Tools used
Big Query & Google Spreadsheets

## Data Source
A single table <kbd>data_analytics.subscriptions</kbd> containing information about user subscriptions curated by an educational institute. This table includes user IDs, start and end dates of subscriptions, and additional customer-related information such as country and category (desktop, mobile, tablet).

## Data Processing
### SQL Code Snippets to Generate the Retention Cohort Analysis Chart
Extract the minimum and maximum dates of subscription for each user, truncating them to the beginning of the respective weeks:

```sql
WITH week_numbers AS 
(
SELECT
user_pseudo_id,
MIN(DATE_TRUNC(subscription_start, WEEK)) AS start_date,
MAX(DATE_TRUNC(subscription_end, WEEK)) AS end_date
FROM `turing_data_analytics.subscriptions`
GROUP BY user_pseudo_id
),
/*CTE extracts the minimum and maximum dates of subscription for each user, truncating them to the beginning of the respective weeks.*/
```
Calculate cohort-based metrics, including cohort size and the number of users retained in each subsequent week after the start date:
```sql
retention_cohort AS (
SELECT
week_numbers.start_date,
SUM(CASE WHEN week_numbers.start_date IS NOT NULL THEN 1 ELSE 0 END) as cohort_size,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 0 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_0,
/*indicates activity in the week the first time the subscription was made and if users unsubscribed in the same week as subscription then the retention in week_0 is less than 100%, can be replaced with logic start_date!= end_date*/
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 1 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_1,
/*values under this weekly retention column show subscriptions that are still active in that week(week1, 2...etc), so subscriptions that stayed 1, 2, 3,.. weeks after they initially subscribed*/
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 2 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_2,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 3 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_3,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 4 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_4,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 5 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_5,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 6 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_6
FROM week_numbers
GROUP BY week_numbers.start_date
), --CTE calculates cohort-based metrics. It aggregates the data from week_numbers for each cohort start date. It calculates the cohort size and the number of users retained in each subsequent week after the start date.
```
Calculate retention and churn rates by dividing the number of retained users in each week by the cohort size:
```sql
retention_rates AS (
SELECT
start_date,
cohort_size,
week_0,
week_1,
week_2,
week_3,
week_4,
week_5,
week_6,
(week_0 / cohort_size) AS retention_rate_0,
(week_1 / cohort_size) AS retention_rate_1,
(week_2 / cohort_size) AS retention_rate_2,
(week_3 / cohort_size) AS retention_rate_3,
(week_4 / cohort_size) AS retention_rate_4,
(week_5 / cohort_size) AS retention_rate_5,
(week_6 / cohort_size) AS retention_rate_6
FROM retention_cohort
) 
/*CTE extracts the minimum and maximum dates of subscription for each user, truncating them to the beginning of the respective weeks. This CTE calculates retention rates by dividing the number of retained users in each week by the cohort size.*/
```
Generate the final output including retention and churn rates:
```sql
SELECT
retention_cohort.start_date,
retention_cohort.cohort_size,
retention_cohort.week_0,
retention_cohort.week_1,
retention_cohort.week_2,
retention_cohort.week_3,
retention_cohort.week_4,
retention_cohort.week_5,
retention_cohort.week_6,
retention_rates.retention_rate_0,
retention_rates.retention_rate_1,
retention_rates.retention_rate_2,
retention_rates.retention_rate_3,
retention_rates.retention_rate_4,
retention_rates.retention_rate_5,
retention_rates.retention_rate_6,
1-retention_rates.retention_rate_0 AS churn_rate_0,
1-retention_rates.retention_rate_1 AS churn_rate_1,
1-retention_rates.retention_rate_2 AS churn_rate_2,
1-retention_rates.retention_rate_3 AS churn_rate_3,
1-retention_rates.retention_rate_4 AS churn_rate_4,
1-retention_rates.retention_rate_5 AS churn_rate_5,
1-retention_rates.retention_rate_6 AS churn_rate_6, --calculates churn rates for each week by subtracting the retention rates from 1
FROM retention_cohort
JOIN retention_rates ON retention_cohort.start_date = retention_rates.start_date;
```

## Analysis and Insights
### Parameters:
+ Period of Analysis: 01.11.2020 to 31.01.2021
+ No. of Subscribers: 270,154
+ No. of Subscribers (with more than 1 subscription): 4,182
+ No. of Subscriptions: 274,362
+ No. and Types of Categories: 3 (Desktop, Tablet, Mobile)
+ No. of Countries with Subscribers: 109

### Insights:
+ Initial User Engagement: The most significant drop in retention is between Week 0 and Week 1, indicating the importance of a strong onboarding experience.
+ Peak Subscription Week: The week of Dec 6, 2020 - Dec 12, 2020 had the maximum number of new subscriptions.
+ Retention Patterns: Retention rates decrease with each passing week, with the lowest retention occurring between Week 1 and Week 2. However, retention rates stabilize after Week 4.
+ Cohort Size: Larger cohorts generally have higher retention numbers, but cohort sizes decline over time, indicating user attrition.

### Recommendations:
+ Improve Initial Engagement: Focus on enhancing user engagement between Week 0 and Week 1 to reduce the significant drop.
+ Long-term Retention Strategies: Develop strategies to retain users beyond the first month, as retention rates stabilize after Week 4.
+ Segmented Engagement Strategies: Experiment with different engagement strategies for various user segments based on cohort sizes to maximize overall retention.

## Visualizations

### Retention Cohorts
![Retention Cohorts](https://github.com/densen1978/retention-churn-cohorts/blob/main/Retention-cohorts.png)

### Retention Rate
![Retention Rate](https://github.com/densen1978/retention-churn-cohorts/blob/main/Retention-rate.png)

### Churn Rate
![Churn Rate](https://github.com/densen1978/retention-churn-cohorts/blob/main/Churn-rate.png)


