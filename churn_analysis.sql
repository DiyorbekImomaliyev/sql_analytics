-- Churn Analysis
-- Purpose: Identify churned customers based on inactivity (>6 months).

-- Calculate last purchase and total spend
WITH last_purchase AS (
    SELECT 
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        MAX(f.order_date) AS last_order_date, 
        SUM(f.sales_amount) AS total_spending 
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL 
    GROUP BY c.customer_key, c.first_name, c.last_name
)

SELECT 
    customer_key,
    customer_name,
    last_order_date,
    total_spending,
    CASE 
        WHEN DATE_PART('month', AGE(CURRENT_DATE, last_order_date)) > 6 THEN 'Churned'
        ELSE 'Active'
    END AS churn_status 
FROM last_purchase
ORDER BY last_order_date DESC; 