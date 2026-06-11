# AdventureWorks Sales Analysis

## Overview
A SQL-based analysis of enterprise sales performance using the AdventureWorks dataset,
modelled on real-world Sales Performance Management (SPM) workflows. The analysis covers
rep performance ranking, quota attainment tiering, revenue trends, anomaly detection,
and territory breakdowns — the same categories of analysis used in production
compensation and sales operations environments.

**Tools used:** Databricks (Spark SQL), Python (pandas), GitHub

---

## Dataset
Microsoft's AdventureWorks sample database — a fictional enterprise with a
multi-territory sales org, quota-carrying reps, and 3+ years of order history.

| Table | Rows | Description |
|---|---|---|
| SalesOrderHeader | 31,465 | Orders with dates, totals, territory |
| SalesOrderDetail | 121,317 | Line items, products, quantities |
| SalesPerson | 17 | Reps with quotas, YTD, commissions |
| SalesTerritory | 10 | Regions and group hierarchies |
| Employee | 290 | Job titles, org structure |
| Person | 19,972 | Names linked to reps and customers |

---

## Key Findings

### 1. Quota Setting is Broken
Every quota-carrying rep achieved 500%+ attainment. The highest was Linda Mitchell
at 1,700% ($4.25M vs $250K quota). This indicates quotas are severely underset
across the board — a classic SPM design issue with real implications for comp
plan fairness and budget forecasting.

### 2. Business Model Shift in Mid-2024
Order volume exploded from ~400/month to ~2,000/month between June and July 2024,
but average order value dropped from ~$10K to ~$2-3K in the same period. Total
revenue stayed relatively flat. This suggests the business shifted from a
low-volume enterprise model to a high-volume SMB or self-serve model — a structural
change that wouldn't be visible from revenue alone.

### 3. Anomaly Detection Flagged Incomplete Periods
Z-score analysis flagged June 2025 as a statistical anomaly (z = -2.21, revenue
$52K vs monthly mean of $3.2M). This was identified as a data extraction artifact
— the dataset was pulled mid-month — rather than a true business anomaly. This
distinction matters in production environments where false positives waste
investigation time.

### 4. North America Drives 83% of Revenue
Southwest and Northwest territories alone account for 53% of total revenue.
Canada has the highest average order value ($4,524) despite fewer customers,
suggesting an enterprise-heavy customer mix. European territories are consistent
but collectively represent only ~11% of revenue.

---

## SQL Queries

| File | Description | Concepts Used |
|---|---|---|
| 01_rep_performance.sql | Rep rankings by YTD revenue and attainment | JOINs, RANK(), NULLIF() |
| 02_quota_attainment.sql | Performance tier bucketing | CASE WHEN, window functions |
| 03_revenue_trends.sql | Monthly revenue with MoM change and running total | LAG(), SUM() OVER(), DATE_FORMAT() |
| 04_anomaly_detection.sql | Z-score based anomaly flagging | CTEs, STDDEV(), ABS() |
| 05_territory_analysis.sql | Regional breakdown with revenue share | PARTITION BY, revenue share % |

---

## How to Run
1. Load the AdventureWorks CSVs into Databricks (or any SQL environment)
2. Run queries in order from the `sql/` folder
3. Each file is self-contained and independently executable

---

## About
Built as a portfolio project to demonstrate SQL analytics in a sales performance
context. Mirrors real workflows from 2+ years working in SPM and compensation
analytics at an enterprise SaaS company.