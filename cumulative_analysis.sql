-- Cumulative Analysis
-- Purpose: Calculate monthly sales and running totals over time.
-- Notes: Aggregates sales and average price by month, computing running total sales and sum of average prices.

SELECT 
    order_month,
    total_sales,
    SUM(total_sales) OVER (PARTITION BY order_month ORDER BY order_month) AS running_total_sales,
    SUM(avg_price) OVER (PARTITION BY order_month ORDER BY order_month) AS moving_avg_price
FROM (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS order_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY order_month
    ORDER BY order_month
);