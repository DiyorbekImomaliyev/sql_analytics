-- Change Over Time Analysis
-- Purpose: Track monthly sales, customer count, and quantity trends using DATE_TRUNC.
-- Notes: Aggregates sales, customer count, and quantity by month using DATE_TRUNC for efficient grouping.

SELECT 
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);