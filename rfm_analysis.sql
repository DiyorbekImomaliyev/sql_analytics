-- RFM Analysis
-- Purpose: Segment customers by recency, frequency, and monetary value for targeting.

-- Calculate RFM metrics
WITH rfm AS (
    SELECT 
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATE_PART('month', AGE(CURRENT_DATE, MAX(f.order_date))) AS recency_months,
        COUNT(DISTINCT f.order_number) AS frequency, 
        SUM(f.sales_amount) AS monetary 
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL 
    GROUP BY c.customer_key, c.first_name, c.last_name
),
rfm_scores AS (
    SELECT 
        customer_key,
        customer_name,
        recency_months,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_months) AS recency_score, -- 1=most recent, 5=least recent
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score, -- 5=most frequent
        NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score -- 5=highest spend
    FROM rfm
)
-- Assign RFM segments
SELECT 
    customer_key,
    customer_name,
    recency_months,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    CASE 
        WHEN recency_score <= 2 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score <= 3 AND frequency_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score <= 2 THEN 'Recent Customers'
        WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'At Risk'
        ELSE 'Others'
    END AS rfm_segment 
FROM rfm_scores
ORDER BY monetary DESC; 