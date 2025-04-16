-- Change Over Time Analysis
-- Purpose: Track sales, customer count, and quantity trends using TO_CHAR.
-- Notes: Aggregates sales, customer count, and quantity by individual order_date, formatted as YYYY-MM.

SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;