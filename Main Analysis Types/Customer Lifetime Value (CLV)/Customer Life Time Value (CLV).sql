--CTE transforms raw event data, extracting relevant information and converts event_date into a truncated week format
WITH transformed_data AS
(SELECT
    user_pseudo_id,
    country,
    page_title,
    purchase_revenue_in_usd,                                                                           
    event_name,
    DATE_TRUNC(PARSE_DATE("%Y%m%d", event_date), week)                       AS transformed_event_date
FROM `turing_data_analytics.raw_events`

),
--CTE calculates the start date for each user cohort
registration AS  
( 
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(MIN(transformed_event_date)), WEEK)                                               AS start_date 
  FROM transformed_data
  GROUP BY user_pseudo_id
),
--CTE aggregates purchase revenue and extract end date with purchase
purchase AS 
( 
SELECT
user_pseudo_id,
SUM(purchase_revenue_in_usd)                                                                 AS purchase_revenue_usd,
DATE_TRUNC(DATE(transformed_event_date), WEEK)                                               AS end_date
FROM transformed_data
WHERE event_name='purchase'
GROUP BY user_pseudo_id, transformed_event_date
),
--calculates average order values by week
clv_cohort AS (
  SELECT
    registration.start_date,
    SUM(CASE WHEN registration.start_date IS NOT NULL THEN 1 ELSE 0 END) as new_customers,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 0 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_0,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 1 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_1,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 2 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_2,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 3 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_3,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 4 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_4,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 5 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_5,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 6 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_6,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 7 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_7,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 8 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_8,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 9 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_9,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 10 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_10,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 11 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_11,
    SUM(CASE WHEN purchase.end_date = DATE_ADD(registration.start_date,INTERVAL 12 week) THEN purchase_revenue_usd ELSE 0 END)/(COUNT (DISTINCT registration.user_pseudo_id)) AS week_12
  FROM registration
  LEFT JOIN purchase
  ON purchase.user_pseudo_id=registration.user_pseudo_id
  GROUP BY registration.start_date
)
SELECT
    start_date,
    new_customers,
    week_0,
    week_1,
    week_2, 
    week_3, 
    week_4, 
    week_5, 
    week_6,
    week_7,
    week_8, 
    week_9, 
    week_10, 
    week_11, 
    week_12
  FROM clv_cohort
  ORDER BY start_date;
