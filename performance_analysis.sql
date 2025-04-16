-- Performance Analysis
-- Purpose: Analyze yearly product sales vs. average and prior year.
-- Notes: Aggregates sales by year and product, comparing to historical average and previous year's sales.

WITH yearly_product_sales AS (
    SELECT 
        EXTRACT(year FROM f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY EXTRACT(year FROM f.order_date), p.product_name
)
SELECT 
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name ORDER BY product_name),
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name ORDER BY product_name) AS diff_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name ORDER BY product_name) > 0 THEN 'Above'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name ORDER BY product_name) < 0 THEN 'Below'
        ELSE 'AVG'
    END AS avg_change,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;