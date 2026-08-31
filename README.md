# 2Market — Customer Demographics and Marketing Channel Performance

Where should a global supermarket spend next year's marketing budget? An analysis of customer demographics, regional spend, and channel conversion across nine markets, using Excel, PostgreSQL, and Tableau.

## Problem

2Market's marketing team had no clear view of which channels drove conversions or how different customer segments responded to them. Budget allocation was effectively being made blind. A 5 Whys analysis traced the surface problem — uncertainty over budget allocation — to a root cause: no linkage existed between customer demographics, channel performance, and purchasing behaviour.

The study set out to answer three questions:

- Do customer demographics influence spending behaviour?
- Do different marketing channels convert at meaningfully different rates?
- Do these patterns vary by region?

## Data

Two datasets: customer demographics with spend broken out by product category, and successful conversions by marketing channel per customer. No transactional data was available, so spend and conversion figures are treated as cumulative per-customer totals; a limitation that rules out any seasonal or temporal analysis.

## Method

**Cleaning (Excel).** No nulls found. 47 duplicate records removed. Date and income field formats corrected. Age derived from year of birth. Marital status labels standardised: "Absurd" and "YOLO" reclassified as Unknown, "Alone" folded into Single, "Married" and "Together" consolidated into Partnership.

Three implausible age records (birth years 1894, 1900, 1901) and one income outlier ($666,666) were replaced with group means rather than dropped, to preserve record completeness.

**Analysis (PostgreSQL / pgAdmin).** Two tables created from CSV and joined. Window functions used to compute percentage distributions alongside raw counts in a single pass — customers and total sales by country, sales by product category, and conversions by channel. Full syntax in `2Market_analysis.sql`.

**Visualisation (Tableau).** A three-dashboard Story: demographics, spending patterns, and channel performance. Interactive filters throughout. Nuriel Stone palette chosen for contrast and to avoid red–green combinations for colour-blind accessibility. Each dashboard capped at four visualisations to stay readable.

## Findings

**Spain dominates by volume, not by value.** Spain holds 48.6% of customers and generates 48.4% of sales — the sales concentration is purely a headcount effect, not a spending one. This mattered enough to change the analysis: sales by country were renormalised to average spend per customer, at which point Canada, then the US, Germany, and South Africa lead. Montenegro was excluded from that comparison — three customers is not a sample.

**Channel differences are smaller than expected.** Twitter, Instagram, and bulk email each account for roughly 25% of conversions, Facebook just over 20%. The only genuinely distinct result is brochures at around 5%.

**Household composition beats income as a spend signal.** Widowed customers show the highest average spend, then divorced, then partnerships — the reverse of the raw totals, which are driven by partnership customers simply being the largest group. Alcohol leads every country and every marital group, followed by meat.

**Conversion peaks around age 50** and correlates positively with total spend. Canada and Germany show the highest average conversion rates, particularly through Twitter and email.

## Recommendations

Reallocate budget away from India and Australia toward Canada and Germany, where average per-customer sales and conversion rates are strongest — this also reduces the concentration risk of drawing half of revenue from one market. Discontinue brochure advertising and redirect that spend to digital. Expand email campaigns in Canada specifically. Promote outside the alcohol and meat categories to broaden the revenue base.

## Limitations

The absence of transactional data is the binding constraint. Without dates on individual purchases, seasonality, campaign timing, and retention are all invisible, and every "spend" figure here is a lifetime total of unknown duration. The relationship between household children and spending was in the data but outside scope.

## Files

| File | Contents |
|---|---|
| `2Market_analysis.sql` | Table definitions and all analytical queries |
| `2Market_dashboard.twbx` | Packaged Tableau workbook — the three-dashboard Story |
| `2Market_report.pdf` | Full written report with figures |

## Stack

PostgreSQL · pgAdmin · Tableau · Excel

---

*Completed as part of the LSE Data Analytics Career Accelerator, 2026.*
