# Adidas Sales Performance & Revenue Optimization

> **SQL-based Sales & Commercial Analytics Case Study**  
> **Tools:** MySQL 8.0 · SQL · Window Functions · CTEs  
> **Dataset Period:** 2020–2021  
> **Role Simulation:** Data Analyst — Sales / Commercial Analytics

---

## Overview

This project is a **public-dataset sales and commercial analytics case study** built to demonstrate an end-to-end SQL analysis workflow using MySQL 8.0.

The analysis focuses on understanding how sales performance varies across **time, products, regions, retailers, and sales methods**, with particular attention to the relationship between **revenue scale and profitability**.

The project is designed from the perspective of a Data Analyst supporting commercial stakeholders who need to understand:

- How much revenue and operating profit were generated?
- How did performance change between 2020 and 2021?
- Which products, regions, retailers, and sales methods contributed most to revenue?
- Where do revenue scale and operating margin differ?
- Which product-region combinations deserve further investigation?
- What data-quality limitations should be considered before interpreting the results?

> **Important:** This is a public-dataset portfolio case study. It does **not** represent internal Adidas data, actual Adidas management decisions, or actual Adidas corporate outcomes.

---

## Business Context

Commercial teams typically need more than a headline revenue number. A useful sales analysis should explain **where revenue comes from, how profitable that revenue is, how performance differs across commercial dimensions, and where further investigation may be warranted**.

This project therefore approaches the dataset as a commercial analytics problem rather than as a simple SQL exercise.

The analysis follows a structured workflow:

**Business Problem → Data Validation → Data Cleaning → KPI Definition → Performance Analysis → Diagnostic Analysis → Opportunity Screening → Executive Reporting**

---

## Business Problem

Sales performance varies across products, regions, retailers, and sales methods. Stakeholders therefore need a structured and evidence-based view of:

1. overall revenue and profitability,
2. changes over time,
3. major commercial contributors,
4. differences between revenue scale and margin,
5. segments that deserve further investigation, and
6. limitations that may affect interpretation.

---

## Analytical Objectives

The project aims to:

- Establish a consistent KPI baseline for revenue and profitability.
- Measure annual revenue, operating profit, operating margin, and year-over-year growth.
- Identify the largest product revenue contributors and compare revenue with profitability.
- Evaluate regional revenue scale, contribution, and margin.
- Drill into state-level performance within regions.
- Compare retailer scale and profitability.
- Evaluate sales-method performance and year-over-year growth.
- Investigate price and reported volume descriptively while applying data-quality safeguards.
- Identify high-revenue / below-average-margin products.
- Screen product-region combinations using a transparent evidence-based rule.
- Translate SQL results into a business-facing executive report.

---

## Dataset

### Source

The project uses the uploaded **Adidas Sales Raw** public dataset.

### Dataset Scope

- **Raw records:** 9,652 rows
- **Completely blank rows:** 4
- **Analytical population after exclusion:** 9,648 records
- **Coverage:** 2020–2021
- **Geographic scope:** U.S. sales data represented by regions and states
- **Core dimensions:** Product, Region, State, Retailer, Sales Method
- **Core measures:** Total Sales, Operating Profit, Operating Margin, Price per Unit, Reported Units Sold

The raw dataset is preserved as the source layer, while a separate clean analytical table is created for analysis.

---

## Data Preparation & Quality Control

Data validation is performed before analytical queries are run.

### 1. Raw Data Validation

The raw table is checked for:

- row-count consistency,
- fully blank records,
- NULL / empty fields,
- categorical dimension values,
- formatting issues in numeric fields.

### 2. Data Cleaning

The project creates a separate clean analytical table rather than modifying the raw table directly.

Cleaning includes:

- trimming text fields,
- parsing dates,
- converting financial fields to numeric values,
- converting the supplied operating margin to a usable numeric form,
- excluding fully blank records.

### 3. Revenue and Margin Consistency

The aggregate operating margin is calculated as:

```text
Operating Margin = SUM(Operating Profit) / SUM(Total Sales)
```

This weighted approach is used instead of averaging row-level margins so that the aggregate result reflects the economic mix of the sales.

### 4. Units Sold Limitation

The dataset contains an inconsistency in the apparent scale of `Units Sold`.

As a result:

- `Reported Units Sold` is treated as a descriptive field.
- `Price × Units Sold` is **not** used as an authoritative reconstruction of `Total Sales`.
- Price and reported volume analysis is therefore interpreted cautiously.

The project also performs an arithmetic consistency check to quantify the difference between reported `Total Sales` and `Price × Units Sold`.

---

## KPI Baseline

The project establishes a reusable KPI layer before performing deeper analysis.

| KPI | Definition |
|---|---|
| **Total Revenue** | `SUM(total_sales)` |
| **Total Operating Profit** | `SUM(operating_profit)` |
| **Operating Margin** | `SUM(operating_profit) / SUM(total_sales)` |
| **Reported Units Sold** | `SUM(units_sold)` |
| **Average Price per Unit** | `AVG(price_per_unit)` |

### Portfolio Baseline

- **Total Revenue:** $899.90M
- **Total Operating Profit:** $332.14M
- **Operating Margin:** 36.91%
- **Reported Units Sold:** 2.42M
- **Average Price per Unit:** $45.22

These KPIs form the baseline used throughout the commercial analysis.

---

# Analysis & Findings

## 1. Time Performance

### Annual Performance

| Year | Revenue | Operating Margin |
|---|---:|---:|
| 2020 | $182.08M | 34.81% |
| 2021 | $717.82M | 37.44% |

Revenue increased from **$182.08M in 2020 to $717.82M in 2021**, representing approximately **294.2% YoY growth**.

The project uses `LAG()` to calculate the previous year's revenue and quantify the year-over-year change.

### Interpretation

The 2021 increase is a significant observed pattern in this dataset. However, only two years are available, so the result represents a **single year-over-year comparison rather than a long-term trend**.

The analysis therefore treats the increase as a signal for further diagnostic analysis rather than evidence of a specific corporate event or cause.

### Recommended Follow-up

Investigate which products, regions, retailers, and sales methods contributed to the 2021 increase before assuming the growth pattern would repeat.

---

## 2. Product Performance

Six product categories are analyzed based on revenue, operating profit, operating margin, and revenue contribution.

### Product Revenue Performance

| Product | Revenue | Margin |
|---|---:|---:|
| Men's Street Footwear | $208.83M | 39.65% |
| Women's Apparel | $179.04M | 38.32% |
| Men's Athletic Footwear | $153.67M | 33.74% |
| Women's Street Footwear | $128.00M | 35.19% |
| Men's Apparel | $123.73M | 36.22% |
| Women's Athletic Footwear | $106.63M | 36.57% |

### Key Finding

**Men's Street Footwear** is the largest product contributor at approximately **$208.83M**, representing about **23.2% of total revenue**.

The product revenue ranking and profit ranking are aligned across all six products. However, **Men's Athletic Footwear** stands out on margin: it ranks third by revenue while carrying a **33.74% margin**, and it is separately flagged as **High Revenue – Below Average Margin**.

### Recommended Follow-up

Drill into Men's Athletic Footwear by **region, retailer, and sales method** before considering pricing or commercial-term discussions.

---

## 3. Regional Performance

Regional analysis compares revenue scale with operating margin.

| Region | Revenue | Margin |
|---|---:|---:|
| West | $269.94M | 33.20% |
| Northeast | $186.32M | 36.47% |
| Southeast | $163.17M | 37.08% |
| South | $144.66M | 42.26% |
| Midwest | $135.80M | 38.91% |

### Key Finding

**West** is the largest revenue region, contributing approximately **30.0% of total revenue**, while having the **lowest regional operating margin at 33.20%**.

This is best interpreted as a **scale-versus-margin trade-off**, not as evidence that West is simply a poor-performing region.

### State-Level Drill-Down

The analysis also drills from region to state to identify where regional revenue is concentrated.

**New York** is the largest state by revenue at approximately **$64.23M**, followed by California and Florida.

### Recommended Follow-up

Drill into West by **state, product, retailer, and sales method** to identify where the margin gap is concentrated.

---

## 4. Retailer Performance

Retailer analysis compares commercial scale and profitability.

| Retailer | Revenue | Margin |
|---|---:|---:|
| West Gear | $242.96M | 35.26% |
| Foot Locker | $220.09M | 36.70% |
| Sports Direct | $182.47M | 40.74% |
| Kohl's | $102.11M | 36.04% |
| Amazon | $77.70M | 37.13% |
| Walmart | $74.56M | 34.57% |

### Key Finding

**West Gear** is the largest retailer by revenue at approximately **$242.96M**, while **Sports Direct** has the highest aggregate retailer margin at **40.74%** on a smaller revenue base.

This demonstrates that **revenue scale and profitability are different dimensions of commercial performance**.

### Recommended Follow-up

Compare retailer performance by **product and sales method mix** before drawing conclusions about commercial terms, discounts, or resource allocation.

---

## 5. Sales Method / Channel Performance

| Sales Method | Revenue | Margin |
|---|---:|---:|
| In-store | $356.64M | 35.78% |
| Outlet | $295.59M | 36.53% |
| Online | $247.67M | 38.99% |

### Key Finding

**In-store** generates the largest sales-method revenue, while **Online** has the highest aggregate margin.

The Online channel also records very high YoY growth in 2021, but that percentage is strongly influenced by a very small 2020 starting base of approximately **$4.52M**.

### Interpretation

Channel scale and profitability do not point to exactly the same outcome.

The Online growth percentage should therefore be treated as a **base-effect finding**, not as a forecast or proof that Online has become the dominant sales method.

### Recommended Follow-up

Investigate **product mix and retailer mix within each sales method** to explain the observed profitability and growth differences.

---

# Opportunity Screening

## Purpose

The project uses an **opportunity screen** to narrow the dataset into product-region combinations that deserve closer investigation.

This is intentionally a **screening rule**, not a mathematical "best segment" score and not a predictive model.

### Screening Criteria

A 2021 product-region combination is flagged when it meets all three conditions:

1. **Above-average 2021 revenue**
2. **Above-average margin**
3. **Positive YoY growth**

### Result

The screen flags **8 product-region combinations** for further investigation.

| Product | Region | 2021 Revenue | Margin | YoY Growth |
|---|---|---:|---:|---:|
| Men's Street Footwear | Northeast | $42.58M | 40.29% | +404.0% |
| Men's Street Footwear | Midwest | $35.82M | 39.35% | +1,333.7% |
| Women's Apparel | Northeast | $29.53M | 38.79% | +268.3% |
| Men's Street Footwear | Southeast | $29.08M | 39.53% | +319.0% |
| Women's Apparel | Midwest | $26.73M | 43.61% | +1,710.9% |
| Women's Apparel | Southeast | $25.20M | 42.51% | +300.8% |
| Women's Apparel | South | $24.64M | 49.31% | +395.5% |
| Men's Street Footwear | South | $24.21M | 41.34% | +471.3% |

### Interpretation

All eight flagged combinations sit outside the West region.

The result should not be interpreted as proof that these combinations are guaranteed growth opportunities. Instead, the screen reduces the broader dataset into a **manageable investigation list**.

At the product level, **Men's Athletic Footwear** is separately flagged as **High Revenue – Below Average Margin**, making it another useful diagnostic candidate.

### Recommended Follow-up

For each flagged combination, validate the underlying:

- state mix,
- retailer mix,
- sales-method mix, and
- product mix

before drawing any commercial conclusion.

---

# Key Business Takeaways

### 01 — Growth was highly concentrated in the 2021 comparison

Revenue increased by approximately **294.2% YoY**, from $182.08M to $717.82M. Because the dataset only covers 2020–2021, this should be treated as a single-period comparison rather than a long-term trend.

### 02 — Revenue scale does not always equal margin strength

West is the largest region by revenue but has the lowest regional margin, while West Gear leads retailer revenue but Sports Direct has the highest retailer margin. The same scale-versus-margin trade-off appears at the sales-method level.

### 03 — Men's Street Footwear is the largest product contributor

Men's Street Footwear contributes approximately **23.2% of total revenue** and generates the highest revenue among the six products.

### 04 — Men's Athletic Footwear warrants margin-focused diagnosis

Men's Athletic Footwear ranks third by revenue but has a **33.74% margin** and is flagged as **High Revenue – Below Average Margin**.

### 05 — The opportunity screen narrows investigation areas

The transparent 2021 product-region screen identifies **8 combinations** meeting the project's revenue, margin, and positive-growth criteria. These should be treated as investigation candidates rather than definitive commercial winners.

---

# Data Quality & Limitations

Several limitations are explicitly incorporated into the analytical design.

| Issue | Treatment |
|---|---|
| 4 completely blank rows | Excluded from the analytical population |
| `Unnamed: 13` | Empty field not used in analysis |
| Numeric fields stored as text | Explicitly parsed during cleaning |
| Operating Margin | Validated against Profit ÷ Sales |
| `Units Sold` scale inconsistency | Treated as descriptive only |
| `Price × Units Sold` inconsistency | Not used as authoritative revenue reconstruction |
| Dataset period | Limited to 2020–2021 |
| Causality | No causal claims made |
| Opportunity screen | Investigation aid, not predictive model |

### Units Sold Quality Check

The arithmetic consistency analysis reports **3,886 of 9,648 records (approximately 40.3%)** with a difference greater than $1 between `Total Sales` and `Price × Units Sold`.

This reinforces the decision to avoid using `Price × Units Sold` as a hard revenue reconstruction.

---

# SQL Analysis Structure

The project is organized into focused SQL scripts so that each stage of the analytical workflow can be reviewed independently.

| File | Purpose |
|---|---|
| `01_setup_and_import.sql` | Database and raw-table setup / import workflow |
| `02_data_validation.sql` | Row count, blank rows, missingness, and raw-data profiling |
| `03_data_cleaning.sql` | Create the clean analytical table and parse fields |
| `04_kpi_analysis.sql` | Executive baseline KPIs |
| `05_time_analysis.sql` | Annual performance and YoY growth |
| `06_product_analysis.sql` | Product revenue, profitability, and product-region diagnostics |
| `07_region_analysis.sql` | Regional, state-level, and regional growth analysis |
| `08_retailer_analysis.sql` | Retailer scorecard and retailer × sales-method analysis |
| `09_sales_method_analysis.sql` | Sales-method performance and YoY growth |
| `10_price_volume_quality.sql` | Price / reported-volume analysis and consistency checks |
| `11_opportunity_analysis.sql` | High-revenue / below-average-margin diagnostic and opportunity screen |

---

# SQL Techniques Demonstrated

This project intentionally demonstrates commonly used analyst SQL patterns, including:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `CASE`
- `NULLIF`
- `COALESCE`
- `CAST`
- Date functions such as `YEAR()`
- Common Table Expressions (`WITH`)
- Window functions
- `LAG()`
- `ROW_NUMBER()`
- `RANK()`
- Window-based revenue contribution calculations
- Aggregation and weighted-margin logic
- Cross-joins for benchmark comparisons

The project is not intended to demonstrate syntax memorization. The focus is on applying SQL patterns to business questions.

---

# Repository Structure

```text
adidas-sales-performance-sql/
│
├── README.md
│
├── data/
│   └── Adidas_Sales_Raw.csv
│
├── sql/
│   ├── 01_setup_and_import.sql
│   ├── 02_data_validation.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_kpi_analysis.sql
│   ├── 05_time_analysis.sql
│   ├── 06_product_analysis.sql
│   ├── 07_region_analysis.sql
│   ├── 08_retailer_analysis.sql
│   ├── 09_sales_method_analysis.sql
│   ├── 10_price_volume_quality.sql
│   └── 11_opportunity_analysis.sql
│
├── results/
│   ├── revenue_trend.png
│   ├── product_performance.png
│   ├── regional_performance.png
│   ├── retailer_performance.png
│   └── channel_performance.png
│
└── report/
    └── Adidas_Executive_Report.pdf
```

---

# Results & Visuals

The `results/` folder contains the main visual outputs used to communicate the SQL analysis:

### Annual Revenue Performance

![Annual Revenue Performance](results/revenue_trend.png)

### Product Revenue Performance

![Product Revenue Performance](results/product_performance.png)

### Regional Revenue & Margin

![Regional Revenue & Margin](results/regional_performance.png)

### Retailer Revenue Performance

![Retailer Revenue Performance](results/retailer_performance.png)

### Sales Method Revenue & Margin

![Sales Method Revenue & Margin](results/channel_performance.png)

---

# Executive Report

A business-facing executive report summarizes the analysis for non-technical stakeholders.

**Report:** [`Adidas_Executive_Report.pdf`](report/Adidas_Executive_Report.pdf)

The report follows the project structure:

1. **Executive Summary**
2. **Revenue & Profitability**
3. **Commercial Drivers**
4. **Opportunity Areas**
5. **Data Quality & Limitations**

The report is designed to communicate the business story without requiring the reader to inspect the underlying SQL first.

---

# How to Reproduce

## 1. Requirements

- MySQL 8.0+
- MySQL Workbench
- The raw Adidas CSV file

## 2. Run the Project in Sequence

Execute the SQL files in this order:

```text
01_setup_and_import.sql
02_data_validation.sql
03_data_cleaning.sql
04_kpi_analysis.sql
05_time_analysis.sql
06_product_analysis.sql
07_region_analysis.sql
08_retailer_analysis.sql
09_sales_method_analysis.sql
10_price_volume_quality.sql
11_opportunity_analysis.sql
```

## 3. Analytical Flow

```text
Raw CSV
   ↓
Raw MySQL Table
   ↓
Validation
   ↓
Clean Analytical Table
   ↓
KPI Baseline
   ↓
Time Analysis
   ↓
Product Analysis
   ↓
Regional Analysis
   ↓
Retailer Analysis
   ↓
Sales Method Analysis
   ↓
Price / Volume Quality
   ↓
Opportunity Screening
   ↓
Executive Report
```

---

# Business Insight Framework

The project converts important SQL findings into a business-facing narrative using four layers:

### Finding
What does the data show?

### Evidence
Which metric, comparison, or ranking supports the finding?

### Business Implication
Why does the finding matter to the commercial stakeholder?

### Recommended Next Action
What bounded follow-up analysis should be performed?

This framework is intentionally designed to avoid overclaiming causality and to keep recommendations tied to evidence.

---

# Project Positioning

This project demonstrates the ability to move beyond writing SQL queries and perform a complete analytical workflow:

**Business Question → Data Quality → SQL Analysis → Evidence → Business Insight → Executive Communication**

The portfolio therefore showcases both:

- **Technical capability:** MySQL, data cleaning, aggregations, CTEs, and window functions.
- **Analytical capability:** KPI design, performance comparison, diagnostic analysis, opportunity screening, and business communication.

---

## Final Note

The strongest conclusions from this case study are **descriptive and diagnostic**.

Revenue, operating profit, and operating margin are internally consistent across the analytical cuts used in the project. However, `Units Sold`, price-based volume reconstruction, and single-period YoY growth should be interpreted cautiously.

Every identified opportunity is framed as an **area for further investigation**, not as a guaranteed business outcome.

---

**Prepared as a public-dataset portfolio case study**  
*Data Analyst — Sales / Commercial Analytics*
