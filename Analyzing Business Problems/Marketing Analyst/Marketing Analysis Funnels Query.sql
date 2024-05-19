---------------------------------------------------------------------------------------
--      Marketing analyst project - Average weekday visit duration by campaigns      --
--      Last edit: 2023/11/9                                                         --
---------------------------------------------------------------------------------------

-- CTE extracts data from a table named turing_data_analytics.raw_events and calculates the time difference in minutes (inactivity_time) between consecutive events for each user_pseudo_id. This is done to identify sessions based on a 30-minute inactivity threshold
WITH events AS (
    SELECT
        user_pseudo_id,
        TIMESTAMP_MICROS(event_timestamp)                                                                            AS event_time,
        campaign,
        event_name,
        EXTRACT(dayofweek FROM DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY))                           AS day_of_week,
        DATE_DIFF(TIMESTAMP_MICROS(event_timestamp),LAG(TIMESTAMP_MICROS(event_timestamp)) OVER (PARTITION BY user_pseudo_id ORDER BY TIMESTAMP_MICROS(event_timestamp)), minute) AS inactivity_time

    FROM `turing_data_analytics.raw_events`
),

-- Takes the data from the "events" CTE and creates sessions by concatenating user_pseudo_id with a session number. It also extracts the session start time, the next session's start time, and campaign. Sessions are defined based on the inactivity threshold of 30 minutes.
sessions AS (
    SELECT
        user_pseudo_id,
        campaign,
        event_name,
        event_time AS session_start_at,
        CONCAT(user_pseudo_id, '-', ROW_NUMBER() OVER (PARTITION BY user_pseudo_id ORDER BY event_time))            AS session_id,
        LEAD(event_time) OVER (PARTITION BY user_pseudo_id ORDER BY event_time)                                     AS next_session_start_at
    FROM events
    WHERE (inactivity_time > 30 OR inactivity_time IS NULL)
    GROUP BY user_pseudo_id, 
    campaign,
    event_name, 
    event_time
),
-- Calculates the duration of each session in minutes by joining the "sessions" and "events" CTEs and grouping the results by session_id.
session_duration AS (
    SELECT
        session_id,
        s.campaign,
        s.event_name,
        MIN(event_time)                                                                                                AS first_event_time,
        DATE_DIFF(MAX(e.event_time), MIN(e.event_time), minute)                                                        AS duration,
        day_of_week,
    FROM sessions s
    LEFT JOIN events e ON e.user_pseudo_id = s.user_pseudo_id
        AND event_time >= s.session_start_at
        AND (event_time < s.next_session_start_at OR s.next_session_start_at IS NULL)
    GROUP BY session_id, 
    s.campaign,
    s.event_name, 
    day_of_week
   ),
-- Calculates the count and average session duration for each combination of campaign, day_of_week, and event_name.
average_duration AS (
SELECT
    day_of_week,
    campaign,
    event_name,
    COUNT(session_id)                                                                                   AS sessions_count,
    AVG(duration)                                                                                       AS avg_session_duration
FROM session_duration
WHERE campaign IN(
'Holiday_V1',
'Holiday_V2',
'NewYear_V1',
'NewYear_V2',
'BlackFriday_V1',
'BlackFriday_V2',
'Data Share Promo'
)
GROUP BY 
day_of_week,
campaign,
event_name

ORDER BY 
campaign
),
--Filters out rows where event_name is null or '(not set)' and includes only specific event names ('first_visit', 'user_engagement', 'view_item', 'add_to_cart').
sessions_counting AS(
SELECT
day_of_week,
event_name,
sessions_count AS sessions_count,
avg_session_duration
FROM average_duration
GROUP BY day_of_week, event_name, sessions_count, avg_session_duration
HAVING 
event_name IS NOT NULL AND event_name != '(not set)' AND 
event_name IN 
(
'page_view', 
'user_engagement', 
'scroll',
'view_item')    
)
--Transforms the data to present a summary table with columns for each day of the week (Monday_sessions_count, Monday_avg_session_duration, etc.).
SELECT
    event_name AS events,
    SUM(CASE WHEN day_of_week = 1 THEN sessions_count ELSE 0 END) AS Monday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 1 THEN avg_session_duration ELSE 0 END), 2) AS Monday_avg_session_duration,
    SUM(CASE WHEN day_of_week = 2 THEN sessions_count ELSE 0 END) AS Tuesday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 2 THEN avg_session_duration ELSE 0 END), 2) AS Tuesday_avg_session_duration,
    SUM(CASE WHEN day_of_week = 3 THEN sessions_count ELSE 0 END) AS Wednesday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 3 THEN avg_session_duration ELSE 0 END), 2) AS Wednesday_avg_session_duration,
    SUM(CASE WHEN day_of_week = 4 THEN sessions_count ELSE 0 END) AS Thursday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 4 THEN avg_session_duration ELSE 0 END), 2) AS Thursday_avg_session_duration,
    SUM(CASE WHEN day_of_week = 5 THEN sessions_count ELSE 0 END) AS Friday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 5 THEN avg_session_duration ELSE 0 END), 2) AS Friday_avg_session_duration,
    SUM(CASE WHEN day_of_week = 6 THEN sessions_count ELSE 0 END) AS Saturday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 6 THEN avg_session_duration ELSE 0 END), 2) AS Saturday_avg_session_duration,
    SUM(CASE WHEN day_of_week = 7 THEN sessions_count ELSE 0 END) AS Sunday_sessions_count,
    ROUND(AVG(CASE WHEN day_of_week = 7 THEN avg_session_duration ELSE 0 END), 2) AS Sunday_avg_session_duration
FROM sessions_counting
GROUP BY event_name
