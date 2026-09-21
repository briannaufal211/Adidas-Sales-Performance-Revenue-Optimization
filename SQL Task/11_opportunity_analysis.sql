# ============================================================
# 11. Commercial Opportunity Identification
# ============================================================

-- 11.1 High-revenue / below-average-margin segments

-- BUSINESS QUESTION
-- Which products generate high revenue but below-average margin?

-- WHY
-- Identify products with significant revenue scale but
-- comparatively lower profitability for further investigation.

-- ============================================================
-- SQL
-- ============================================================

WITH product_performance AS (
    SELECT
        product,
        SUM(total_sales) AS revenue,
        SUM(operating_profit) / NULLIF(SUM(total_sales), 0) AS margin
    FROM adidas_sales_clean
    GROUP BY product
),
benchmark AS (
    SELECT
        AVG(revenue) AS avg_revenue,
        SUM(revenue * margin) / NULLIF(SUM(revenue), 0) AS overall_margin
    FROM product_performance
)
SELECT
    p.product,
    p.revenue,
    p.margin,
    CASE
        WHEN p.revenue >= b.avg_revenue
             AND p.margin < b.overall_margin
        THEN 'High Revenue - Below Average Margin'
        ELSE 'Other'
    END AS segment_flag
FROM product_performance p
CROSS JOIN benchmark b
ORDER BY p.revenue DESC;

-- ============================================================
-- RESULT / INSIGHT
-- ============================================================
-- Result: Identifies products with revenue above the average
-- and margin below the overall portfolio margin.
-- Insight: Use the actual query result to identify products
-- requiring further investigation.

-- NEXT
-- Continue to product-region opportunity screening.

-- 11.2. OPPORTUNITY SCREEN
-- Why: Combine revenue scale, growth, and margin into a transparent shortlist.

WITH segment_year AS (
 SELECT
 product,
 region,
 YEAR(invoice_date) AS year,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS profit
 FROM adidas_sales_clean
 GROUP BY product, region, YEAR(invoice_date)
), growth AS (
 SELECT
 product,
 region,
 year,
 revenue,
 profit,
 LAG(revenue) OVER (
 PARTITION BY product, region
 ORDER BY year
 ) AS previous_revenue
 FROM segment_year
), scored AS (
 SELECT
 product,
 region,
 revenue,
 profit / NULLIF(revenue,0) AS margin,
 (revenue / NULLIF(previous_revenue,0)) - 1 AS yoy_growth
 FROM growth
 WHERE year = 2021
)
SELECT
 product,
 region,
 revenue,
 margin,
 yoy_growth,
 CASE
 WHEN revenue >= (SELECT AVG(revenue) FROM scored)
 AND margin >= (SELECT AVG(margin) FROM scored)
 AND yoy_growth > 0
 THEN 'Priority for Further Investigation'
 ELSE 'Monitor / Diagnose'
 END AS opportunity_flag
FROM scored
ORDER BY opportunity_flag DESC, revenue DESC;

-- Expected output: A shortlist of product-region combinations with above-average 2021 revenue, above-average margin, and positive YoY growth.
-- How to read it: This is a screening rule, not a mathematical “best segment” score. You must still inspect the underlying product, state, retailer, and channel mix.
-- Business interpretation: The strongest use of SQL here is narrowing a large dataset into a manageable investigation list.
-- Next question: Next translate findings into an executive narrative.
