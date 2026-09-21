# ============================================================
# 03. Data Cleaning & Analytical Table Preparation
# ============================================================
-- 3.1. Create the clean table
-- Why: Convert date and currency/percentage strings into usable MySQL data types. Drop the empty
-- helper column and blank rows.
-- Do: Run the full statement:

CREATE TABLE adidas_sales_clean AS
SELECT
 TRIM(retailer) AS retailer,
 CAST(NULLIF(TRIM(retailer_id),'') AS UNSIGNED) AS retailer_id,
 STR_TO_DATE(TRIM(invoice_date), '%d/%m/%Y') AS invoice_date,
 TRIM(region) AS region,
 TRIM(state) AS state,
 TRIM(city) AS city,
 TRIM(product) AS product,
 CAST(REPLACE(REPLACE(REPLACE(TRIM(price_per_unit), '$', ''), '.', ''), ',', '.') AS DECIMAL(12,2)) AS price_per_unit,
 CAST(NULLIF(TRIM(units_sold),'') AS DECIMAL(14,3)) AS units_sold,
 CAST(REPLACE(REPLACE(REPLACE(TRIM(total_sales), '$', ''), '.', ''), ',', '.') AS DECIMAL(16,2)) AS total_sales,
 CAST(REPLACE(REPLACE(REPLACE(TRIM(operating_profit), '$', ''), '.', ''), ',', '.') AS DECIMAL(16,2)) AS operating_profit,
 CAST(REPLACE(REPLACE(TRIM(operating_margin), '%', ''), ',', '.') AS DECIMAL(8,4)) / 100 AS operating_margin,
 TRIM(sales_method) AS sales_method
FROM adidas_sales_raw
WHERE COALESCE(TRIM(retailer),'') <> '';

SELECT Count(*) AS Clean_row_count
FROM adidas_sales_clean;

-- Expected output: 9,648 clean records should be created.
-- How to read it: The amount fields should become numeric; invoice_date should become DATE;
-- operating_margin should be stored as a decimal ratio (e.g., 0.50 for 50%).
-- Business interpretation: The raw table remains unchanged; the clean table is the one used for analysis.
-- Next question: Validate that the type conversions worked and that margin agrees with profit/sales

-- 3.2. Validate numeric conversions
-- Why: Catch parsing failures before they contaminate the analysis.

SELECT
 COUNT(*) AS rows_checked,
 SUM(CASE WHEN invoice_date IS NULL THEN 1 ELSE 0 END) AS bad_dates,
 SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS bad_price,
 SUM(CASE WHEN units_sold IS NULL THEN 1 ELSE 0 END) AS bad_units,
 SUM(CASE WHEN total_sales IS NULL THEN 1 ELSE 0 END) AS bad_sales,
 SUM(CASE WHEN operating_profit IS NULL THEN 1 ELSE 0 END) AS bad_profit,
 SUM(CASE WHEN operating_margin IS NULL THEN 1 ELSE 0 END) AS bad_margin
FROM adidas_sales_clean;

-- Expected output: You want 9,648 rows and zero unexpected conversion failures.
-- How to read it: If any bad count is non-zero, inspect the raw values before changing the parser.
-- Business interpretation: A clean analytical table should not contain silent conversion errors.

-- 3.3. Validate the business margin field
-- Why: Check whether Operating Margin equals Operating Profit / Total Sales

SELECT
 COUNT(*) AS checked_rows,
 SUM(CASE
 WHEN ABS((operating_profit / NULLIF(total_sales,0)) - operating_margin) > 0.01
 THEN 1 ELSE 0 END
 ) AS margin_mismatches,
 MAX(ABS((operating_profit / NULLIF(total_sales,0)) - operating_margin)) AS max_difference
FROM adidas_sales_clean;

-- Expected output: In the uploaded data, there are no meaningful >1 percentage-point mismatches; the
-- maximum difference is about 0.2 percentage points.
-- How to read it: This supports using total_sales, operating_profit, and operating_margin as core
-- commercial metrics.
-- Business interpretation: Margin is internally coherent after parsing.
-- Next question: Next, explicitly document the Units Sold issue instead of pretending the source is
-- perfectly clean.

-- 3.4. Flag the Units Sold anomaly
-- Why: The uploaded file mixes values such as 1.20/1.00 with values such as 850/900. Price x Units Sold
-- therefore does not consistently reconstruct Total Sales. Do not silently rescale it.

SELECT
 SUM(CASE WHEN units_sold = 0 THEN 1 ELSE 0 END) AS zero_units,
 SUM(CASE WHEN units_sold < 10 THEN 1 ELSE 0 END) AS very_low_units,
 MIN(units_sold) AS min_units,
 MAX(units_sold) AS max_units
FROM adidas_sales_clean;

SELECT
 invoice_date, product, price_per_unit, units_sold, total_sales
FROM adidas_sales_clean
WHERE units_sold < 10
ORDER BY invoice_date
LIMIT 20;

-- Expected output: In the uploaded file, 4 records have zero units and 68 records have Units Sold below 10.
-- How to read it: Treat Units Sold as a reported source field. For core revenue/profit conclusions, rely on
-- Total Sales and Operating Profit. You may still analyze reported units, but label the limitation.
-- Business interpretation: This is a real data-quality finding and a strong part of your portfolio story.
-- Next question: Now define the metrics used throughout the project.
