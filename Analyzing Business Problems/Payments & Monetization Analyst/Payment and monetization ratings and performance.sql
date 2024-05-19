------------------------------------------------------------------------------------------------------------------------------------------
-- Payment and monetisation analyst project - Distribution of ratings and sales performance                                            --
-- Last edit: 2024/02/03                                                                                                               --
------------------------------------------------------------------------------------------------------------------------------------------
SELECT
CASE
WHEN reviews.review_score = 5 THEN 'Excellent'
WHEN reviews.review_score = 4 THEN 'Very Good'
WHEN reviews.review_score = 3 THEN 'Good'
WHEN reviews.review_score = 2 THEN 'Bad'
WHEN reviews.review_score = 1 THEN 'Very Bad'
END AS rating,
reviews.review_score AS score,
COUNT(DISTINCT orders.order_id) AS order_count,
SUM(payments.payment_value) AS revenue,
ROUND(SUM(payments.payment_value) / COUNT(DISTINCT orders.order_id), 2) AS avg_revenue,
ROUND(AVG(TIMESTAMP_DIFF(orders.order_delivered_customer_date, orders.order_approved_at, DAY)), 2) AS avg_delivery_time_days
FROM `tc-da-1.olist_db.olist_orders_dataset` AS orders
INNER JOIN `tc-da-1.olist_db.olist_order_reviews_dataset` AS reviews
ON orders.order_id = reviews.order_id
INNER JOIN `tc-da-1.olist_db.olist_order_payments_dataset` AS payments
ON orders.order_id = payments.order_id
INNER JOIN `tc-da-1.olist_db.olist_order_items_dataset` AS items
ON items.order_id = orders.order_id
WHERE
order_status <> 'canceled'
AND orders.order_approved_at IS NOT NULL
GROUP BY rating, score
ORDER BY score DESC;
