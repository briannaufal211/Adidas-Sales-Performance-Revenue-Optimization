# ============================================================
# 9. Sales Method / Channel Performance Analysis
# ============================================================

-- 9.1. Channel scorecard
-- Why: Measure revenue, profit, margin, and reported units by sales method.

SELECT
 sales_method,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 SUM(units_sold) AS reported_units
FROM adidas_sales_clean
GROUP BY sales_method
ORDER BY revenue DESC;

-- Expected output: In the uploaded data, In-store has the largest revenue share (~39.6%), while Online has the highest aggregate margin (~39.0%).
-- How to read it: Reported units should be interpreted cautiously because of the source anomaly.
-- Business interpretation: Channel performance is a trade-off: scale and margin do not necessarily point to the same method.
-- Next question: Next test whether channel growth differs across years.

-- 9.2. Channel YoY growth
-- Why: Identify which sales methods changed most from 2020 to 2021.

WITH channel_year AS (
 SELECT
 sales_method,
 YEAR(invoice_date) AS year,
 SUM(total_sales) AS revenue
 FROM adidas_sales_clean
 GROUP BY sales_method, YEAR(invoice_date)
), x AS (
 SELECT
 sales_method,
 year,
 revenue,
 LAG(revenue) OVER (PARTITION BY sales_method ORDER BY year) AS previous_revenue
 FROM channel_year
)
SELECT
 sales_method,
 year,
 revenue,
 previous_revenue,
 (revenue / NULLIF(previous_revenue,0)) - 1 AS yoy_growth
FROM x
WHERE year = 2021
ORDER BY yoy_growth DESC;

-- Expected output: Each sales method receives a 2021 growth rate.
-- How to read it: Do not interpret a high growth percentage without considering starting base size and the dataset coverage.
-- Business interpretation: This helps explain whether overall growth was channel-specific.
-- Next question: Next investigate price and volume carefully.