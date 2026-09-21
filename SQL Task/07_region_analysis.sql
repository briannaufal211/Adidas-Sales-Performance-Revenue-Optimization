# ============================================================
# 07. Regional & Geographic Sales Performance
# ============================================================

-- 7.1. Regional revenue, profit, and margin
-- Why: Establish regional scale and profitability side-by-side.

SELECT
 region,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS revenue_contribution
FROM adidas_sales_clean
GROUP BY region
ORDER BY revenue DESC;

-- Expected output: West contributes about 30.0% of total revenue but has the lowest regional aggregate margin at about 33.20% in the uploaded data.
-- How to read it: Do not call West “bad”: it is the largest revenue region. The business question is the trade-off between scale and margin.
-- Business interpretation: This is a classic high-scale / lower-margin segment worth diagnostic attention.
-- Next question: Next drill from region to state.

-- 7.2. Top states by revenue
-- Why: Find the state-level contributors inside the regions.

SELECT
 state,
 region,
 SUM(total_sales) AS revenue,
 SUM(operating_profit) AS operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin
FROM adidas_sales_clean
GROUP BY state, region
ORDER BY revenue DESC
LIMIT 15;

-- Expected output: New York is the largest state by revenue at about $64.2M, followed by California and
-- Florida in the uploaded data.
-- How to read it: Use state results to locate where a region's revenue is concentrated.
-- Business interpretation: This creates a more actionable geographic diagnostic than region-level ranking alone.
-- Next question: Next examine retailer performance.


-- 7.3. Advanced Analysis — Top 3 States Within Each Region

-- BUSINESS QUESTION
-- ============================================================
-- Which three states generate the highest revenue within each region?

-- WHY
-- Drill down from region to state to identify where revenue
-- is concentrated within each geographic market.


WITH state_sales AS (
    SELECT
        region,
        state,
        SUM(total_sales) AS revenue
    FROM adidas_sales_clean
    GROUP BY region, state
),
ranked AS (
    SELECT
        region,
        state,
        revenue,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY revenue DESC
        ) AS state_rank
    FROM state_sales
)
SELECT
    region,
    state,
    revenue,
    state_rank
FROM ranked
WHERE state_rank <= 3
ORDER BY region, state_rank;

-- Result: Returns the top 3 revenue-generating states in each region.
-- Insight: After running the query, identify the leading states
-- and note where regional revenue is concentrated.

-- NEXT
-- Compare revenue growth across regions.

-- 7.4. Year-over-year regional growth
-- Why: Identify which regions contributed to the annual change.


WITH regional_year AS (
 SELECT
 region,
 YEAR(invoice_date) AS year,
 SUM(total_sales) AS revenue
 FROM adidas_sales_clean
 GROUP BY region, YEAR(invoice_date)
), ranked AS (
 SELECT
 region,
 year,
 revenue,
 LAG(revenue) OVER (PARTITION BY region ORDER BY year) AS previous_revenue
 FROM regional_year
)
SELECT
 region,
 year,
 revenue,
 previous_revenue,
 (revenue / NULLIF(previous_revenue,0)) - 1 AS yoy_growth
FROM ranked
WHERE year = 2021
ORDER BY yoy_growth DESC;

-- Expected output: Each region will have a 2021 growth rate.
-- How to read it: Because only two years exist, this is a single year-on-year comparison, not a long-term trend.
-- Business interpretation: It helps identify whether the aggregate increase was broad-based or concentrated.
-- Next question: Next evaluate retailers, another major commercial driver.