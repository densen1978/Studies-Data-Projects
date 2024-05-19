---------------------------------------------------------------------------------------
--      Marketing analyst project - Average weekday visit duration by campaigns      --
--      Last edit: 2023/11/11                                                         --
---------------------------------------------------------------------------------------

-- CTE extracts data from a table named turing_data_analytics.raw_events and calculates the time difference in minutes (inactivity_time) between consecutive events for each user_pseudo_id. This is done to identify sessions based on a 30-minute inactivity threshold
WITH events AS (
    SELECT
        user_pseudo_id,
        TIMESTAMP_MICROS(event_timestamp)                                                                            AS event_time,
        campaign,
        event_name,
        EXTRACT(dayofweek FROM DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY)) AS day_of_week,
        FORMAT_DATE('%A', DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY)) AS day_name,
        -- CASE 
        --   WHEN EXTRACT(dayofweek FROM DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY)) = 1 THEN 6
        --   ELSE EXTRACT(dayofweek FROM DATE_SUB(PARSE_DATE("%Y%m%d", event_date), INTERVAL 1 DAY))-2 END                           AS day_of_week,
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
)
-- -- Calculates the duration of each session in minutes by joining the "sessions" and "events" CTEs and grouping the results by session_id.
,session_duration AS (
    SELECT
        session_id,
        s.campaign,
        s.event_name,
        DATE_DIFF(MAX(e.event_time), MIN(e.event_time), minute)                                                        AS duration,
        day_of_week,
        day_name
    FROM sessions s
    LEFT JOIN events e ON e.user_pseudo_id = s.user_pseudo_id
        AND event_time >= s.session_start_at
        AND (event_time < s.next_session_start_at OR s.next_session_start_at IS NULL)
    GROUP BY session_id, 
    s.campaign,
    s.event_name, 
    day_of_week,
    day_name
   )
-- The query calculates the count and average session duration for each combination of campaign and day of the week.
SELECT
    day_of_week,
    day_name,
    campaign,
    event_name,
    COUNT(*)                                                                                                          AS sessions_count,
    APPROX_QUANTILES(duration, 2)[OFFSET(1)]                                                                          AS median_session_duration,
    -- AVG(duration)                                                                                                     AS avg_session_duration
FROM session_duration
GROUP BY   
day_of_week,
day_name,
campaign,
event_name, 
duration
-- HAVING campaign IN(
-- 'Data Share Promo'    
-- ,'Holiday_V1',
-- 'Holiday_V2',
-- 'NewYear_V1',
-- 'NewYear_V2',
-- 'BlackFriday_V1',
-- 'BlackFriday_V2'
-- )
ORDER BY 
campaign, 
day_of_week,
day_name
