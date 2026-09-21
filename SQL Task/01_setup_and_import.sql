# ============================================================
# 1. Database Setup & Raw Data Import
# ============================================================

# Business purpose
# Set up the MySQL database and raw landing table while preserving the source data structure.

-- 1.1. Create the database
CREATE DATABASE IF NOT EXISTS adidas_sales_analysis;
USE adidas_sales_analysis;

-- 1.2. Create the raw landing table
CREATE TABLE adidas_sales_raw (
 retailer VARCHAR(100),
 retailer_id VARCHAR(50),
 invoice_date VARCHAR(20),
 region VARCHAR(50),
 state VARCHAR(80),
 city VARCHAR(80),
 product VARCHAR(100),
 price_per_unit VARCHAR(30),
 units_sold VARCHAR(30),
 total_sales VARCHAR(30),
 operating_profit VARCHAR(30),
 operating_margin VARCHAR(30),
 sales_method VARCHAR(30),
 unnamed_13 VARCHAR(30)
);

-- CSV delimiter: ;
-- Source file: Adidas_Sales_Raw.csv
-- Target table: adidas_sales_raw
