---------------------------------------------------------------------------------------
-- Product analyst project - Dynamic duratition from visit to purchase --
-- Last edit: 2024/01/17 --
---------------------------------------------------------------------------------------

-- CTE extracts data from a table named turing_data_analytics.raw_events and calculates first visit for each user_pseudo_id.
WITH first_visit AS (
SELECT
user_pseudo_id,
MIN(TIMESTAMP_MICROS(event_timestamp)) AS visit_time,
-- campaign,
-- event_name,
PARSE_DATE('%Y%m%d', event_date) AS visit_date,
EXTRACT(dayofweek FROM DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY)) AS day_of_week,
FORMAT_DATE('%A', DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY)) AS day_name,
FROM `turing_data_analytics.raw_events`
GROUP BY user_pseudo_id,
-- campaign,
-- event_name,
visit_date,
day_of_week,
day_name
),

-- CTE extracts purchase date and timestamp.
purchases AS (
SELECT
user_pseudo_id,
-- campaign,
-- event_name,
TIMESTAMP_MICROS(event_timestamp) AS purchase_time,
PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
FROM
`tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
)
-- -- Calculates the duration from visit to purchase.
,dynamic_duration AS (
SELECT
-- fv.campaign,
-- fv.event_name,
DATE_DIFF(p.purchase_time, fv.visit_time, minute) AS duration,
day_of_week,
day_name
FROM first_visit fv
JOIN purchases p ON p.user_pseudo_id = fv.user_pseudo_id
AND fv.visit_date = p.purchase_date
GROUP BY
-- fv.campaign,
-- fv.event_name,
duration,
day_of_week,
day_name
)
-- The query calculates the count and dynamic duration for each day of the week.
SELECT
day_of_week,
day_name,
-- campaign,
-- event_name,
COUNT(1) AS purchases_count,
APPROX_QUANTILES(duration, 2)[OFFSET(1)] AS median_duration,
ROUND(AVG(duration),2) AS avg_duration
FROM dynamic_duration
GROUP BY
day_of_week,
day_name
ORDER BY
day_of_week,
day_name