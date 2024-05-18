WITH MarketingData AS (
  SELECT
    ad.campaign,
    MAX(ad.impressions) AS total_impressions,
    COUNT(DISTINCT CASE WHEN events.event_name = 'page_view' THEN events.user_pseudo_id ELSE NULL END) AS unique_users
  FROM
    `tc-da-1.turing_data_analytics.adsense_monthly` AS ad
  INNER JOIN
    `tc-da-1.turing_data_analytics.raw_events` AS events
  ON
    ad.campaign = events.campaign
  WHERE
    ad.campaign IN ('NewYear_V1','NewYear_V2', 'BlackFriday_V1','BlackFriday_V2')
  GROUP BY
    ad.campaign
)

SELECT
  campaign,
  total_impressions,
  unique_users,
  ROUND(100*SAFE_DIVIDE(unique_users, total_impressions),2) AS estimated_clickthrough_rate
FROM
  MarketingData
ORDER BY campaign ASC;
