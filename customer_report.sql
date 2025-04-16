
---Creates a view with detailed customer metrics and segments.
CREATE OR REPLACE VIEW gold.report_customers AS
WITH base_query AS (
    SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATE_PART('year', AGE(CURRENT_DATE, c.birthdate)) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL 
),
customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders, 
        SUM(sales_amount) AS total_sales, 
        SUM(quantity) AS total_quantity, 
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        (DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 + 
         DATE_PART('month', AGE(MAX(order_date), MIN(order_date)))) AS lifespan_months
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    CASE 
        WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATE_PART('year', AGE(CURRENT_DATE, last_order_date)) * 12 +
    DATE_PART('month', AGE(CURRENT_DATE, last_order_date)) AS recency_months,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_months,
    COALESCE(total_sales / NULLIF(total_orders, 0), 0) AS avg_order_value,
    COALESCE(total_sales / NULLIF(lifespan_months, 0), total_sales) AS avg_monthly_spend 
FROM customer_aggregation
ORDER BY total_sales DESC;