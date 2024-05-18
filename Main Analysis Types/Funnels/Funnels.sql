WITH unique_events AS               ---CTE extracts unique events for each user, including the first occurrence of each event.
(SELECT
user_pseudo_id,
event_name,
country,
MIN(event_timestamp) AS first_event
FROM `turing_data_analytics.raw_events`
GROUP BY user_pseudo_id, event_name, country
),
data_clean AS                        --- This CTE joins the unique events with the original raw_events table to retrieve additional data associated with the first occurrence of each event for each user.
(SELECT
unique_events.user_pseudo_id,
unique_events.event_name,
unique_events.first_event,
unique_events.country
FROM unique_events
INNER JOIN `turing_data_analytics.raw_events` AS raw_events
ON raw_events.user_pseudo_id = unique_events.user_pseudo_id
AND raw_events.event_name = unique_events.event_name
AND raw_events.event_timestamp = unique_events.first_event
AND raw_events.country=unique_events.country
ORDER BY unique_events.user_pseudo_id ASC
),
event_counts AS (                     ---CTE calculates the count of specific events for each country. It filters out selected for funnel event names and counts their occurrences. 
SELECT
data_clean.country,
event_name,
COUNT(user_pseudo_id) AS event_count
FROM data_clean
WHERE event_name IS NOT NULL AND event_name != '(not set)'
AND event_name IN 
(
'view_search_results', 
'add_to_cart', 
'begin_checkout',
'add_payment_info',
'purchase')
GROUP BY country, event_name
),
country_event_ranks AS                 ---CTE assigns a rank to each country based on the count of specific events.
(
SELECT
ROW_NUMBER() OVER (PARTITION BY country ORDER BY event_count DESC) AS event_order,
country,
event_name,
event_count,
DENSE_RANK() OVER(PARTITION BY event_name ORDER BY event_count DESC) AS country_rank
FROM event_counts
),
country_event_sums AS                  ---CTE aggregates event counts for the top three ranked countries for each event name. It takes the counts for the first, second, and third-ranked countries. 
(
SELECT
country_event_ranks.event_order AS order_id,
country_event_ranks.event_name AS events,
MAX(CASE WHEN top_countries.country_rank = 1 THEN country_event_ranks.event_count ELSE 0 END) AS first_country_events,
MAX(CASE WHEN top_countries.country_rank = 2 THEN country_event_ranks.event_count ELSE 0 END) AS second_country_events,
MAX(CASE WHEN top_countries.country_rank = 3 THEN country_event_ranks.event_count ELSE 0 END) AS third_country_events
FROM country_event_ranks
JOIN (
SELECT DISTINCT
event_order,
country,
country_rank,
event_count
FROM country_event_ranks
WHERE country_rank <= 3
) top_countries
ON country_event_ranks.country = top_countries.country
GROUP BY country_event_ranks.event_order, country_event_ranks.event_name
ORDER BY country_event_ranks.event_order ASC
)
SELECT                                  ---the query calculates the drop-off rates for the first, second, and third-ranked countries for each event.
country_event_sums.order_id,
country_event_sums.events,
country_event_sums.first_country_events,
ROUND((1 - (country_event_sums.first_country_events/LAG(country_event_sums.first_country_events, -1) OVER (ORDER BY country_event_sums.first_country_events))),3) AS first_country_drop_off,
country_event_sums.second_country_events,
ROUND((1 - (country_event_sums.second_country_events/LAG(country_event_sums.second_country_events, -1) OVER (ORDER BY country_event_sums.second_country_events))),3) AS second_country_drop_off,
country_event_sums.third_country_events,
ROUND((1 - (country_event_sums.third_country_events/LAG(country_event_sums.third_country_events, -1) OVER (ORDER BY country_event_sums.third_country_events))),3) AS third_country_drop_off,
FROM country_event_sums
ORDER BY country_event_sums.order_id ASC;