# Analytics Repository

This repository contains SQL-based analytics for sales, customer, and product data in the gold schema. Each analysis is stored in a separate file with clear comments and optimized queries for PostgreSQL.

## Analyses

| File Name | Purpose | Key Metrics |
| --- | --- | --- |
| change_over_time.sql | Track monthly sales and customer trends | Total sales, unique customers, total quantity |
| cumulative_analysis.sql | Calculate running totals and moving averages | Running total sales, 3-month moving average price |
| performance_analysis.sql | Compare product sales to average and prior year | Current sales, difference from average, year-over-year change |
| part_to_whole.sql | Measure category contribution to total sales | Category sales, percentage of total |
| data_segmentation.sql | Segment products by cost and customers by spend/tenure | Product count by cost range, customer count by segment |
| customer_report.sql | Create a view with customer metrics | Age group, customer segment, average order value, monthly spend |
| rfm_analysis.sql | Segment customers by recency, frequency, monetary value | RFM scores, customer segments (e.g., Champions) |
| churn_analysis.sql | Identify churned customers (>6 months inactive) | Last order date, total spending, churn status |

## Setup

- **Database**: PostgreSQL
- **Schema**: gold (tables: fact_sales, dim_products, dim_customers)
- **Execution**: Run each .sql file in your PostgreSQL client (e.g., psql, pgAdmin).

## Usage

- Use these queries for reporting, dashboards, or further analysis in BI tools (e.g., Tableau, Power BI).
- Extend with Python/R for predictive modeling or visualization.
