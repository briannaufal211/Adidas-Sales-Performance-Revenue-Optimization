# ============================================================
# 04. KPI ANALYSIS
# Adidas Sales Performance & Revenue Optimization
# ============================================================

-- BUSINESS PURPOSE
-- Establish consistent KPI definitions before performing
-- product, regional, retailer, and sales-method analysis.
--
-- IMPORTANT:
-- The KPI definitions below will be reused throughout
-- the project to ensure consistent business calculations.


-- ============================================================
-- KPI DEFINITIONS
-- ============================================================

-- 1. TOTAL REVENUE
-- Formula: SUM(total_sales)
-- Purpose: Measures overall commercial sales performance.

-- 2. TOTAL OPERATING PROFIT
-- Formula: SUM(operating_profit)
-- Purpose: Measures operating profit captured by the dataset.

-- 3. OPERATING MARGIN
-- Formula: SUM(operating_profit) / SUM(total_sales)
-- Purpose: Measures aggregate profitability.

-- 4. REVENUE GROWTH %
-- Formula: (Current Revenue / Previous Revenue) - 1
-- Purpose: Measures change in revenue over time.

-- 5. REVENUE CONTRIBUTION %
-- Formula: Segment Revenue / Total Revenue
-- Purpose: Measures the importance of a segment to total revenue.

-- 6. AVERAGE PRICE PER UNIT
-- Formula: AVG(price_per_unit)
-- Purpose: Describes the observed price level.
-- Note: This does NOT establish price elasticity or causality.

-- 7. REPORTED UNITS SOLD
-- Formula: SUM(units_sold)
-- Purpose: Provides a reported volume indicator.
-- Note: Source-quality limitation exists for this field.


-- ============================================================
-- KPI DESIGN RULE
-- ============================================================

-- For aggregate operating margin, use:
--
-- SUM(operating_profit) / SUM(total_sales)
--
-- Do NOT use:
--
-- AVG(operating_margin)
--
-- because aggregate margin should reflect the total revenue/profit
-- mix.

-- ============================================================
-- BASELINE EXECUTIVE KPI
-- ============================================================

-- BUSINESS QUESTION
-- What is the overall commercial performance?

SELECT
 SUM(total_sales) AS total_revenue,
 SUM(operating_profit) AS total_operating_profit,
 SUM(operating_profit) / NULLIF(SUM(total_sales),0) AS operating_margin,
 SUM(units_sold) AS reported_units_sold,
 AVG(price_per_unit) AS avg_price_per_unit
FROM adidas_sales_clean;

-- ============================================================
-- EXPECTED OUTPUT
-- ============================================================
-- Based on the uploaded dataset, the baseline analysis is expected
-- to show approximately $899.9M in total revenue, $332.1M in total
-- operating profit, and an aggregate operating margin of 36.91%.
-- The exact displayed values may vary slightly depending on
-- number formatting.

-- ============================================================
-- BUSINESS INTERPRETATION
-- ============================================================
-- These KPIs provide the overall commercial baseline for the
-- Adidas sales dataset. They establish the starting point for
-- evaluating how revenue and profitability vary across different
-- business dimensions, including product, region, retailer,
-- and sales method.

-- ============================================================
-- NEXT QUESTION
-- ============================================================
-- After establishing the overall commercial baseline, the next
-- business question is: "When did the sales performance change?"
-- This question will be addressed in the time-based analysis,
-- where revenue and profitability will be compared across years.
