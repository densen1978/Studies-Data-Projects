WITH week_numbers AS -- CTE extracts the minimum and maximum dates of subscription for each user, truncating them to the beginning of the respective weeks.
(
SELECT
user_pseudo_id,
MIN(DATE_TRUNC(subscription_start, WEEK)) AS start_date,
MAX(DATE_TRUNC(subscription_end, WEEK)) AS end_date
FROM `turing_data_analytics.subscriptions`
GROUP BY user_pseudo_id
),

retention_cohort AS (
SELECT
week_numbers.start_date,
SUM(CASE WHEN week_numbers.start_date IS NOT NULL THEN 1 ELSE 0 END) as cohort_size,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 0 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_0,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 1 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_1,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 2 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_2,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 3 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_3,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 4 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_4,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 5 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_5,
SUM(CASE WHEN week_numbers.end_date > DATE_ADD(week_numbers.start_date, INTERVAL 6 week) OR week_numbers.end_date IS NULL THEN 1 ELSE 0 END) AS week_6
FROM week_numbers
GROUP BY week_numbers.start_date
), --CTE calculates cohort-based metrics. It aggregates the data from week_numbers for each cohort start date. It calculates the cohort size and the number of users retained in each subsequent week after the start date.

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
) --This CTE calculates retention rates by dividing the number of retained users in each week by the cohort size.

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