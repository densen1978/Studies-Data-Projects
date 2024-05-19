------------------------------------------------------------------------------------------------------------------------------------------
-- Payment and monetisation analyst project - Customers segmentation by recency, frequency and monetary                                 --
-- Last edit: 2024/02/03                                                                                                                --
------------------------------------------------------------------------------------------------------------------------------------------
--Compute for F & M - CTE calculates the following metrics for each customer who made a purchase between '2017-01-01' and '2018-12-31'
WITH t1 AS (
SELECT
customer_id,
orders.order_id,
MAX(order_purchase_timestamp) AS last_purchase_date,
COUNT(DISTINCT product_category_name) AS frequency,
SUM(payments.payment_value) AS monetary,
COUNT(items.product_id) AS num_products_per_order,
FROM
`tc-da-1.olist_db.olist_orders_dataset` AS orders
INNER JOIN
`tc-da-1.olist_db.olist_order_payments_dataset` AS payments
ON orders.order_id = payments.order_id
INNER JOIN
`tc-da-1.olist_db.olist_order_items_dataset` AS items
ON items.order_id = orders.order_id
INNER JOIN
`tc-da-1.olist_db.olist_products_dataset` AS products
ON
products.product_id = items.product_id
WHERE
order_purchase_timestamp BETWEEN '2017-01-01' AND '2018-12-31'
AND customer_id IS NOT NULL
GROUP BY
customer_id, orders.order_id
),
--Compute for R - CTE calculates the recency metric for each customer based on the difference between a reference_date and the last_purchase_date.
t2 AS (
SELECT *,
DATE_DIFF(CAST(reference_date AS DATE), CAST(last_purchase_date AS DATE), DAY) AS recency
FROM (
SELECT *,
DATE(MAX(last_purchase_date) OVER ()) + 1 AS reference_date
FROM t1
)
),
-- CTE assigns percentiles for monetary, frequency, and recency
t3 AS (
SELECT
a.*,
--All percentiles for MONETARY
b.percentiles[offset(25)] AS m25,
b.percentiles[offset(50)] AS m50,
b.percentiles[offset(75)] AS m75,
b.percentiles[offset(100)] AS m100,
--All percentiles for FREQUENCY
c.percentiles[offset(25)] AS f25,
c.percentiles[offset(50)] AS f50,
c.percentiles[offset(75)] AS f75,
c.percentiles[offset(100)] AS f100,
--All percentiles for RECENCY
d.percentiles[offset(25)] AS r25,
d.percentiles[offset(50)] AS r50,
d.percentiles[offset(75)] AS r75,
d.percentiles[offset(100)] AS r100
FROM
t2 a,
(SELECT APPROX_QUANTILES(monetary, 100) percentiles FROM
t2) b,
(SELECT APPROX_QUANTILES(frequency, 100) percentiles FROM
t2) c,
(SELECT APPROX_QUANTILES(recency, 100) percentiles FROM
t2) d
),
--CTE assigns review_scores (r_review_score, f_review_score, and m_review_score) to customers based on their RFM metrics
t4 AS (
SELECT *,
CAST(ROUND((f_review_score + m_review_score) / 2, 0) AS INT64) AS fm_review_score
FROM (
SELECT *,
CASE WHEN monetary <= m25 THEN 1
WHEN monetary <= m50 AND monetary > m25 THEN 2
WHEN monetary <= m75 AND monetary > m50 THEN 3
WHEN monetary <= m100 AND monetary > m75 THEN 4
END AS m_review_score,
CASE WHEN frequency <= f25 THEN 1
WHEN frequency <= f50 AND frequency > f25 THEN 2
WHEN frequency <= f75 AND frequency > f50 THEN 3
WHEN frequency <= f100 AND frequency > f75 THEN 4
END AS f_review_score,
--Recency scoring is reversed
CASE WHEN recency <= r25 THEN 4
WHEN recency <= r50 AND recency > r25 THEN 3
WHEN recency <= r75 AND recency > r50 THEN 2
WHEN recency <= r100 AND recency > r75 THEN 1
END AS r_review_score,
FROM t3
)
)
--The main query selects the final results from t4 and assigns RFM segments to each customer based on their RFM review_scores.
SELECT
customer_id,
recency,
frequency,
monetary,
r_review_score,
f_review_score,
m_review_score,
fm_review_score,
CASE WHEN (r_review_score = 4 AND fm_review_score = 4)
OR (r_review_score = 3 AND fm_review_score = 4)
THEN 'Best Customers'
WHEN (r_review_score = 4 AND fm_review_score = 2)
OR (r_review_score = 3 AND fm_review_score = 3)
OR (r_review_score = 4 AND fm_review_score = 3)
THEN 'Loyal Customers'
WHEN r_review_score = 4 AND fm_review_score = 1 THEN 'Recent Customers'
WHEN (r_review_score = 4 AND fm_review_score = 1)
OR (r_review_score = 3 AND fm_review_score = 1)
THEN 'Promising'
WHEN (r_review_score = 3 AND fm_review_score = 2)
OR (r_review_score = 2 AND fm_review_score = 3)
OR (r_review_score = 2 AND fm_review_score = 2)
THEN 'Customers Needing Attention'
WHEN r_review_score = 2 AND fm_review_score = 1 THEN 'About to Sleep'
WHEN (r_review_score = 2 AND fm_review_score = 4)
OR (r_review_score = 1 AND fm_review_score = 3)
THEN 'At Risk'
WHEN (r_review_score = 1 AND fm_review_score = 4)
THEN 'Cant Lose Them'
WHEN r_review_score = 1 AND fm_review_score = 2 THEN 'Hibernating'
WHEN r_review_score = 1 AND fm_review_score = 1 THEN 'Lost Customers'
END AS rfm_segment
FROM t4
WHERE monetary >= 0
ORDER BY customer_id
