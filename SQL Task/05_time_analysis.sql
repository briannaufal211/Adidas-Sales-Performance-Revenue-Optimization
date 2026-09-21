# ============================================================
# 05. Time-Based Sales Performance & Growth Analysis
# ============================================================
-- 5.1. Annual revenue and profit
-- Why: Establish the overall trend before drilling into products or regions.

SELECT
 YEAR(invoice_date) AS year,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin
FROM adidas_sales_clean
GROUP BY YEAR(invoice_date)
ORDER BY year;

-- Expected output: The uploaded data covers 2020-2021. Revenue is about $182.1M in 2020 and $717.8M in 2021.
-- How to read it: Compare year-over-year revenue and margin, but do not assume the change is caused by a specific initiative.
-- Business interpretation: The dataset shows a very large 2021 revenue increase; because this is a public case dataset, treat it as a pattern to investigate, not proof of a real Adidas corporate event.
-- Next question: Next quantify the growth with LAG().

-- 5.2. Calculate YoY growth with LAG
-- Why: Demonstrate a core analyst SQL skill and create a reusable trend metric.

WITH yearly AS (
 SELECT
 YEAR(invoice_date) AS year,
 SUM(total_sales) AS revenue
 FROM adidas_sales_clean
 GROUP BY YEAR(invoice_date)
)
SELECT
year,
 revenue,
 LAG(revenue) OVER (ORDER BY year) AS previous_year_revenue,
 (revenue / NULLIF(LAG(revenue) OVER (ORDER BY year),0)) - 1 AS yoy_growth
FROM yearly
ORDER BY year;

-- Expected output: 2021 growth is approximately 294.2% versus 2020 in the uploaded file.
-- How to read it: The first year has NULL growth because no prior period exists.
-- Business interpretation: This tells management that 2021 deserves diagnostic analysis by product, region, retailer, and channel.
-- Next question: Now ask which dimensions explain the aggregate change.
