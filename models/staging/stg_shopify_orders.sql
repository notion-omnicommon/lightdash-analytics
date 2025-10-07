-- Staging model for Shopify orders
-- Filters for completed orders only

SELECT 
    id,
    order_id,
    customer_email,
    total_price,
    currency,
    order_date,
    status,
    DATE(order_date) as order_date_only,
    EXTRACT(YEAR FROM order_date) as order_year,
    EXTRACT(MONTH FROM order_date) as order_month,
    EXTRACT(DOW FROM order_date) as day_of_week,
    created_at
    
FROM {{ source('public', 'shopify_orders_raw') }}
WHERE status = 'completed'
