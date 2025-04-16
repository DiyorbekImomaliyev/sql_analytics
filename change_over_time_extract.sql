-- Change Over Time Analysis
-- Purpose: Track monthly sales, customer count, and quantity trends using EXTRACT.
-- Notes: Aggregates sales, customer count, and quantity by year and month extracted from order_date.

SELECT 
    EXTRACT(year FROM order_date) AS order_year,
    EXTRACT(month FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(month FROM order_date), EXTRACT(year FROM order_date)
ORDER BY EXTRACT(month FROM order_date), EXTRACT(year FROM order_date);