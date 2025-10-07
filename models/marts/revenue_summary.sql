-- Daily revenue and order metrics from Shopify

SELECT 
    order_date_only as date,
    COUNT(*) as total_orders,
    ROUND(SUM(total_price), 2) as total_revenue,
    ROUND(AVG(total_price), 2) as avg_order_value,
    COUNT(DISTINCT customer_email) as unique_customers,
    ROUND(SUM(total_price) / COUNT(DISTINCT customer_email), 2) as revenue_per_customer
FROM {{ ref('stg_shopify_orders') }}
GROUP BY order_date_only
ORDER BY date DESC
