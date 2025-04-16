-- Part to Whole Analysis
-- Purpose: Calculate each product category's share of total sales.
-- Notes: Aggregates sales by category, computing total sales and percentage contribution.

WITH category_sales AS (
    SELECT 
        category,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER ()) * 100, 2), '%') AS sales_percentage
FROM category_sales;