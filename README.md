# Retail Customer Behavior Analysis
**Tools:** BigQuery (SQL) · Google Sheets  
**Dataset:** 5,050 customer transactions · 17 variables

---

## Business Problem

A retail company has collected transaction-level data across thousands of customers but lacks clarity on three key questions:

1. Which customers drive the most revenue, and how are they segmented?
2. How does purchase behavior vary by category, season, and demographics?
3. What behaviors distinguish repeat buyers from one-time customers?

---

## Data Cleaning

All cleaning was performed in BigQuery. Key findings:

- 5,050 rows confirmed loaded correctly
- 556 nulls in purchase_amount_usd (~11% of data)
- 548 nulls in previous_purchases (~11% of data)
- Decision: Nulls excluded at query time — raw table left intact
- 10 duplicate customer IDs confirmed as legitimate repeat transactions
- Data quality fix: "Autumn" and "Fall" were inconsistent season labels — corrected with a CASE statement

---

## Findings

### Finding 1 — Clothing dominates volume, Electronics dominates value
Clothing generates the highest transaction volume across all seasons, peaking in Fall ($68,703) and Winter ($66,713). Electronics has far fewer transactions (41–53 per season) but achieves average order values of $695–$773 — the highest per-transaction value by a significant margin.

**Business implication:** Electronics customers are rare but extremely valuable. A targeted retention strategy for this segment could yield disproportionate revenue impact.

### Finding 2 — 85% of customers are Mid Value, creating a retention imperative

| Segment | Customers | Avg Spend | Avg Prior Purchases |
|---|---|---|---|
| High Value | 45 (1%) | $1,234.60 | 36 |
| Mid Value | 3,441 (85%) | $98.93 | 29.5 |
| Low Value | 745 (18%) | $66.66 | 4.8 |

The Mid Value segment is the revenue backbone of the business — loyal customers (29.5 prior purchases) spending modestly per transaction. Retaining this group is the single most important factor in sustaining revenue.

### Finding 3 — High-spend subscribers are the least satisfied customers

| Group | Customers | Avg Spend | Avg Rating |
|---|---|---|---|
| Subscribed, No Discount | 65 | $762.42 | 2.89 |
| Subscribed, With Discount | 1,124 | $96.08 | 3.73 |
| Not Subscribed, With Discount | 712 | $137.63 | 3.69 |
| Not Subscribed, No Discount | 2,330 | $81.58 | 3.75 |

Subscribed customers who receive no discounts spend 8x more than any other group but carry the lowest satisfaction rating (2.89/5). These are simultaneously the highest-value and highest churn-risk customers.

**Business implication:** Urgent action needed to address dissatisfaction in this segment before they churn.

### Finding 4 — 72% of repeat buyers have never subscribed
Of 4,223 repeat buyers, only 28.1% hold a subscription. This represents a large untapped audience for subscription conversion campaigns.

---

## Recommendations

| Priority | Recommendation | Target Segment |
|---|---|---|
| High | Investigate dissatisfaction among high-spend subscribers | Subscribed, No Discount |
| High | Launch subscription conversion campaign for loyal unsubscribed buyers | Repeat buyers, 10+ purchases |
| Medium | Electronics-specific retention offers | Electronics buyers |
| Medium | Align inventory with seasonal peaks | All customers |
| Low | Re-engagement campaign for Low Value customers with purchase history | Low Value segment |

---

## Repository Structure

retail-customer-analysis/
├── README.md
├── sql/
│   ├── data_cleaning.sql
│   └── analysis.sql
├── data/
│   ├── 3a_revenue_by_category_season.csv
│   ├── 3b_top_customers.csv
│   ├── 3c_customer_segments.csv
│   ├── 3d_repeat_vs_firsttime.csv
│   └── 3e_discount_subscription_impact.csv
└── charts/
    ├── chart_1_revenue_by_category_season.png
    ├── chart_2_customer_segments.png
    ├── chart_3_discount_subscription.png
    └── chart_4_repeat_buyer_behavior.png

---

## Key Skills Demonstrated
- SQL: Aggregations, GROUP BY, CASE statements, COUNTIF, null handling
- Data cleaning: Nulls, duplicates, inconsistent categorical values
- Customer segmentation: RFM-based tiering
- Business thinking: Translating findings into prioritized recommendations
- Data visualization: Google Sheets chart building
