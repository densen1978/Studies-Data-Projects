-------------------------------------------------------------------------------------------------------------	
-- Payment and monetisation analyst project - Best performing product category by revenue--	
-- Last edit: 2024/02/03                                                                                   --	
-------------------------------------------------------------------------------------------------------------	
WITH CategoryRevenue AS (	
SELECT	
translation.string_field_1 AS product_category,	
COUNT(DISTINCT orders.order_id) AS order_count,	
SUM(payments.payment_value) AS revenue,	
FROM	
`tc-da-1.olist_db.olist_orders_dataset` AS orders	
INNER JOIN `tc-da-1.olist_db.olist_order_payments_dataset` AS payments	
ON orders.order_id = payments.order_id	
INNER JOIN	
`tc-da-1.olist_db.olist_order_items_dataset` AS items	
ON	
items.order_id = orders.order_id	
INNER JOIN	
`tc-da-1.olist_db.olist_products_dataset` AS products	
ON	
products.product_id = items.product_id	
INNER JOIN	
`tc-da-1.olist_db.product_category_name_translation` AS translation	
ON	
translation.string_field_0 = products.product_category_name	
GROUP BY	
translation.string_field_1	
),	
	
ParetoData AS (	
SELECT	
product_category,	
revenue,	
order_count,	
SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,	
SUM(revenue) OVER () AS total_revenue	
FROM	
CategoryRevenue	
)	
	
SELECT	
product_category,	
revenue,	
order_count,	
running_total,	
total_revenue,	
ROUND((running_total / total_revenue) * 100, 2) AS percent_of_total_revenue	
FROM	
ParetoData	
ORDER BY revenue;	


-------------------------------------------------------------------------------------------------------------
-- Payment and monetisation analyst project - Best performing product category by revenue and margin--
-- Last edit: 2024/02/03                                                                                   --
-------------------------------------------------------------------------------------------------------------
WITH CategoryRevenue AS (
SELECT
translation.string_field_1 AS product_category,
SUM(payments.payment_value) AS revenue,
COUNT(DISTINCT orders.order_id) AS order_count,
SUM(items.price) AS cost,
(SUM(payments.payment_value) - SUM(items.price)) / SUM(items.price) AS margin
FROM
`tc-da-1.olist_db.olist_orders_dataset` AS orders
INNER JOIN
`tc-da-1.olist_db.olist_order_payments_dataset` AS payments
ON
payments.order_id = orders.order_id
INNER JOIN
`tc-da-1.olist_db.olist_order_items_dataset` AS items
ON
items.order_id = payments.order_id
INNER JOIN
`tc-da-1.olist_db.olist_products_dataset` AS products
ON
products.product_id = items.product_id
INNER JOIN
`tc-da-1.olist_db.product_category_name_translation` AS translation
ON
translation.string_field_0 = products.product_category_name
GROUP BY
translation.string_field_1
)

SELECT
product_category,
revenue,
order_count,
margin,
SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,
SUM(revenue) OVER () AS total_revenue,
(SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER ()) * 100 AS cumulative_percentage
FROM
CategoryRevenue

	
	