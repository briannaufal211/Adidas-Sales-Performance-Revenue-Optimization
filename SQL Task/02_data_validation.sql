# ============================================================
# 02. Raw Data Validation & Data Quality Assessment
# ============================================================

# BUSINESS PURPOSE
# Verify completeness, structure, and quality of raw data
# before converting data types.

-- 2.1. Confirm row count
SELECT COUNT(*) AS raw_row_count
FROM adidas_sales_raw;
-- Source CSV: 9,652 rows

-- 2.2. Find blank rows
SELECT COUNT(*) AS blank_rows
FROM adidas_sales_raw
WHERE COALESCE(TRIM(retailer),'') = ''
 AND COALESCE(TRIM(retailer_id),'') = ''
 AND COALESCE(TRIM(invoice_date),'') = ''
 AND COALESCE(TRIM(region),'') = ''
 AND COALESCE(TRIM(state),'') = ''
 AND COALESCE(TRIM(city),'') = ''
 AND COALESCE(TRIM(product),'') = ''
 AND COALESCE(TRIM(price_per_unit),'') = ''
 AND COALESCE(TRIM(units_sold),'') = ''
 AND COALESCE(TRIM(total_sales),'') = ''
 AND COALESCE(TRIM(operating_profit),'') = ''
 AND COALESCE(TRIM(operating_margin),'') = ''
 AND COALESCE(TRIM(sales_method),'') = '';

-- Expected output: 4 blank rows in the uploaded file.
-- How to read it: Those four rows are safe to exclude from business analysis because they contain no
-- usable record-level information.
-- Business interpretation: The analytical population becomes 9,648 rows.
-- Next question: Now inspect missingness in non-blank records.

-- 2.3. Audit NULL/empty values by column
-- Why: Know which fields need cleaning before converting types.

SELECT
 SUM(CASE WHEN TRIM(retailer) = '' OR retailer IS NULL THEN 1 ELSE 0 END) AS missing_retailer,
 SUM(CASE WHEN TRIM(retailer_id) = '' OR retailer_id IS NULL THEN 1 ELSE 0 END) AS missing_retailer_id,
 SUM(CASE WHEN TRIM(invoice_date) = '' OR invoice_date IS NULL THEN 1 ELSE 0 END) AS missing_date,
 SUM(CASE WHEN TRIM(region) = '' OR region IS NULL THEN 1 ELSE 0 END) AS missing_region,
 SUM(CASE WHEN TRIM(state) = '' OR state IS NULL THEN 1 ELSE 0 END) AS missing_state,
 SUM(CASE WHEN TRIM(city) = '' OR city IS NULL THEN 1 ELSE 0 END) AS missing_city,
 SUM(CASE WHEN TRIM(product) = '' OR product IS NULL THEN 1 ELSE 0 END) AS missing_product,
 SUM(CASE WHEN TRIM(price_per_unit) = '' OR price_per_unit IS NULL THEN 1 ELSE 0 END) AS missing_price,
 SUM(CASE WHEN TRIM(units_sold) = '' OR units_sold IS NULL THEN 1 ELSE 0 END) AS missing_units,
 SUM(CASE WHEN TRIM(total_sales) = '' OR total_sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
 SUM(CASE WHEN TRIM(operating_profit) = '' OR operating_profit IS NULL THEN 1 ELSE 0 END) AS missing_profit,
 SUM(CASE WHEN TRIM(operating_margin) = '' OR operating_margin IS NULL THEN 1 ELSE 0 END) AS missing_margin,
 SUM(CASE WHEN TRIM(sales_method) = '' OR sales_method IS NULL THEN 1 ELSE 0 END) AS missing_sales_method
FROM adidas_sales_raw;

-- Expected output: After excluding the 4 blank rows, the business fields are populated in the source file.
-- How to read it: A non-zero count outside the blank rows requires review before proceeding.
-- Business interpretation: This establishes data completeness

-- 2.4. Profile categorical dimensions
-- Why: Understand the business dimensions available for slicing the analysis.

SELECT DISTINCT retailer FROM adidas_sales_raw WHERE TRIM(retailer) <> '' ORDER BY retailer;
SELECT DISTINCT region FROM adidas_sales_raw WHERE TRIM(region) <> '' ORDER BY region;
SELECT DISTINCT product FROM adidas_sales_raw WHERE TRIM(product) <> '' ORDER BY product;
SELECT DISTINCT sales_method FROM adidas_sales_raw WHERE TRIM(sales_method) <> '' ORDER BY sales_method;
-- Expected output: 6 retailers, 5 regions, 6 products, and 3 sales methods are present.
-- How to read it: These dimensions define the core analytical cuts used later.
-- Business interpretation: Now profile the date range and numeric text formats.