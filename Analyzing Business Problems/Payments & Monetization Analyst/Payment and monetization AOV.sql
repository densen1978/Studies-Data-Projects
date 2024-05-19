--------------------------------------------------------------------------------------------------------------------------	
-- Payment and monetisation analyst project -Average order value by product category or payment method                  --	
-- Last edit: 2024/02/03                                                                                                --	
--------------------------------------------------------------------------------------------------------------------------	
	
SELECT	
translation.string_field_1 AS product_category,	
payments.payment_type AS payment_type,	
COUNT(DISTINCT orders.order_id) AS order_count,	
SUM(payments.payment_value) AS total_revenue,	
(SUM(payments.payment_value)/COUNT(orders.order_id)) AS aov	
FROM `tc-da-1.olist_db.olist_orders_dataset` AS orders	
INNER JOIN `tc-da-1.olist_db.olist_order_payments_dataset` AS payments	
ON orders.order_id = payments.order_id	
INNER JOIN `tc-da-1.olist_db.olist_order_items_dataset` AS items	
ON orders.order_id = items.order_id	
INNER JOIN `tc-da-1.olist_db.olist_products_dataset` AS products	
ON items.product_id = products.product_id	
INNER JOIN	
`tc-da-1.olist_db.product_category_name_translation` AS translation	
ON translation.string_field_0 = products.product_category_name	
GROUP BY	
product_category,	
payment_type	
ORDER BY aov DESC;	
	