# ============================================================
# 8. Retailer Performance & Commercial Partner Analysis 
# ============================================================

-- 8.1. Retailer scorecard
-- Why: Compare retailer scale and profitability together.

SELECT
 retailer,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS revenue_contribution
FROM adidas_sales_clean
GROUP BY retailer
ORDER BY revenue DESC;

-- Expected output: West Gear is the largest retailer by revenue at about $243.0M; Sports Direct has the highest retailer margin at about 40.74%.
-- How to read it: Compare revenue contribution with margin.
-- Business interpretation: A high-revenue retailer with lower margin can become a commercial-term or mix
-- investigation candidate. A high-margin retailer may indicate a favorable mix, but the dataset alone does not establish why.
-- Next question: Next test retailer performance by sales method.

-- ADVANCED SQL PATTERN:
-- Revenue Contribution is calculated using a window function:
-- SUM(total_sales) / SUM(SUM(total_sales)) OVER ()
--
-- This shows the percentage of total revenue contributed
-- by each retailer.

-- 8.2. Retailer x Sales Method
-- Why: See whether retailer economics vary by channel.

SELECT
 retailer,
 sales_method,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin
FROM adidas_sales_clean
GROUP BY retailer, sales_method
ORDER BY retailer, revenue DESC;

-- Expected output: You will get one row for each retailer x sales method combination represented in the data.
-- How to read it: Look for retailers whose mix is concentrated in one method and whose margin differs materially by method.
-- Business interpretation: This supports a more specific commercial conversation than retailer ranking alone.
-- Next question: Next compare the three sales methods overall.
