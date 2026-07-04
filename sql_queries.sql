-- ========================================================
-- ADVANCED SALES & CUSTOMER WORKLOAD VALIDATION
-- ========================================================

-- 1. Validating Page 3: Top Customer Spenders using DENSE_RANK()
SELECT 
    customer_unique_id,
    SUM(price) AS total_customer_spend,
    DENSE_RANK() OVER (ORDER BY SUM(price) DESC) AS customer_spending_rank
FROM orders_data
GROUP BY customer_unique_id;

-- 2. Validating Page 2: Month-on-Month Performance Lag Analysis
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS sales_month,
        SUM(price) AS current_month_revenue
    FROM orders_data
    GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
)
SELECT 
    sales_month,
    current_month_revenue,
    LAG(current_month_revenue, 1) OVER (ORDER BY sales_month) AS previous_month_revenue,
    ROUND(current_month_revenue - LAG(current_month_revenue, 1) OVER (ORDER BY sales_month), 2) AS mom_revenue_change
FROM MonthlySales;

-- 3. Validating Page 2: Day of the Week Order Volume Distribution
SELECT 
    DAYNAME(order_purchase_timestamp) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_data
GROUP BY order_day
ORDER BY total_orders DESC;