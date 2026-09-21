# ============================================================
# 06. Product Performance & Revenue Driver Analysis
# ============================================================

-- 6.1. Rank products by revenue
-- Why: Identify the largest product revenue contributors.

SELECT
 product,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS revenue_contribution
FROM adidas_sales_clean
GROUP BY product
ORDER BY revenue DESC;

-- Expected output: Men's Street Footwear is the largest product contributor in the uploaded data, at about 23.2% of total revenue.
-- How to read it: Look at revenue contribution and margin together.
-- Business interpretation: A top-revenue product is a major commercial driver, but its strategic importance should be evaluated with profitability too.
-- Next question: Next ask whether the revenue ranking matches the profitability ranking.

-- 6.2. Compare revenue and profitability
-- Why: Find products that create different trade-offs between scale and margin.

SELECT
 product,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 RANK() OVER (ORDER BY SUM(total_sales) DESC) AS revenue_rank,
 RANK() OVER (ORDER BY SUM(operating_profit) DESC) AS profit_rank
FROM adidas_sales_clean
GROUP BY product
ORDER BY revenue_rank;

-- Expected output: You should see products with different revenue and profit ranks.
-- How to read it: Look for segments where revenue_rank is much better than profit_rank or vice versa.
-- Business interpretation: This reveals whether scale and profitability are aligned.
-- Next question: Next diagnose whether geography is associated with product performance.

-- 6.3. Product x Region diagnostic
-- Why: Find product-region combinations that are material enough to investigate.

SELECT
 product,
 region,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS revenue_contribution
FROM adidas_sales_clean
GROUP BY product, region
ORDER BY revenue DESC
LIMIT 15;

-- Expected output: The largest combination in the uploaded data is Men's Street Footwear x West, about $55.0M revenue.
-- How to read it: Use this as diagnostic evidence, not as proof that the region causes product performance.
-- Business interpretation: A large combination becomes an opportunity candidate only after checking margin and growth.
-- Next question: Next move to regional performance overall.
