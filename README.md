# DataAnalytics-Assessment

## Overview
This repository contains SQL solutions to a four-part assessment aimed at evaluating SQL proficiency in data analysis scenarios.

## Questions & Explanations

### Q1 – High-Value Customers with Multiple Products
- **Goal:** Identify customers with both funded savings and investment plans.
- **Approach:** Used `COUNT(DISTINCT CASE...)` for product type tracking and joined `savings_savingsaccount` to ensure deposits exist.

### Q2 – Transaction Frequency Analysis
- **Goal:** Classify customers based on transaction frequency.
- **Approach:** Calculated transaction count and tenure, derived avg txns/month, then used `CASE` to bucket customers.

### Q3 – Account Inactivity Alert
- **Goal:** Flag accounts with no inflow in the last 365 days.
- **Approach:** Used latest transaction date and `DATEDIFF` against the dataset’s most recent date.

### Q4 – Customer Lifetime Value (CLV)
- **Goal:** Estimate CLV based on tenure and transaction value.
- **Approach:** Derived tenure from `date_joined`, calculated average transaction value, then applied CLV formula.

## Challenges
- Ensuring edge cases like:
  - Avoiding divide-by-zero with tenure.
  - Filtering valid "active" plans and successful transactions.
  - Dealing with currency in Kobo and converting to Naira.
- Formatting: Maintaining numeric formatting for clarity and calculation compatibility.

## Final Notes
All solutions are written using standard SQL and were tested for correctness, efficiency, and clarity.
