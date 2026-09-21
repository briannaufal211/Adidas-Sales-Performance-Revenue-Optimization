# ============================================================
# 10. Price, Volume & Data Quality Diagnostics
# ============================================================

-- 10.1. Average price by product
-- Why: Use price as a descriptive metric, not as proof of price elasticity.

SELECT
 product,
 AVG(price_per_unit) AS avg_price,
 MIN(price_per_unit) AS min_price,
 MAX(price_per_unit) AS max_price,
 SUM(total_sales) AS revenue
FROM adidas_sales_clean
GROUP BY product
ORDER BY revenue DESC;
-- Expected output: A product-level price range and average.
-- How to read it: Price differences can contextualize revenue and margin differences. They do not establish customer willingness-to-pay or causality.
-- Business interpretation: This is useful for descriptive commercial diagnostics.

-- 10.2. Reported volume by product
-- Why: Show the field, but label it clearly.

SELECT
 product,
 SUM(units_sold) AS reported_units_sold,
 SUM(total_sales) AS revenue
FROM adidas_sales_clean
GROUP BY product
ORDER BY reported_units_sold DESC;

-- Expected output: A ranked list of reported Units Sold.
-- How to read it: Because of the mixed scale issue, use this only as a supporting field.
-- Business interpretation: Do not use it to claim exact volume productivity without resolving the source definition.

-- 10.3. Check arithmetic consistency
-- Why: Use this only as a quality diagnostic.

SELECT
 COUNT(*) AS rows_checked,
 SUM(CASE
 WHEN ABS(total_sales - (price_per_unit * units_sold)) > 1
 THEN 1 ELSE 0 END
 ) AS inconsistent_rows
FROM adidas_sales_clean;

-- Expected output: You should find many inconsistencies because the source field scales are mixed.
-- How to read it: This confirms that Price x Units Sold cannot be treated as a reliable reconstruction formula for this file.
-- Business interpretation: The correct portfolio behavior is to document the limitation and pivot core analysis to the fields that are internally coherent.
