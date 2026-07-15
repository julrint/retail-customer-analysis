-- Check 1: Row count
-- Confirmed all 5,050 rows loaded correctly into BigQuery
SELECT COUNT(*) AS total_rows
FROM `retail-customer-analysis.shopping.transactions`;

-- Check 2: Null values
-- Found 556 nulls in purchase_amount_usd and 548 in previous_purchases (~11% each)
SELECT
  COUNTIF(customer_id IS NULL)            AS null_customer_id,
  COUNTIF(age IS NULL)                    AS null_age,
  COUNTIF(gender IS NULL)                 AS null_gender,
  COUNTIF(purchase_amount_usd IS NULL)    AS null_purchase_amount,
  COUNTIF(category IS NULL)              AS null_category,
  COUNTIF(season IS NULL)                AS null_season,
  COUNTIF(previous_purchases IS NULL)    AS null_previous_purchases,
  COUNTIF(subscription_status IS NULL)   AS null_subscription_status,
  COUNTIF(frequency_of_purchases IS NULL) AS null_frequency
FROM `retail-customer-analysis.shopping.transactions`;

-- Check 3: Duplicate customers
-- Found 10 customer IDs appearing twice, confirmed as legitimate repeat transactions
SELECT
  customer_id,
  COUNT(*) AS occurrences
FROM `retail-customer-analysis.shopping.transactions`
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10;

-- Check 4: Numeric sanity check
-- All numeric columns returned realistic ranges, no outliers found
SELECT
  MIN(purchase_amount_usd)   AS min_purchase,
  MAX(purchase_amount_usd)   AS max_purchase,
  AVG(purchase_amount_usd)   AS avg_purchase,
  MIN(age)                   AS min_age,
  MAX(age)                   AS max_age,
  MIN(review_rating)         AS min_rating,
  MAX(review_rating)         AS max_rating,
  MIN(previous_purchases)    AS min_prev_purchases,
  MAX(previous_purchases)    AS max_prev_purchases
FROM `retail-customer-analysis.shopping.transactions`;

-- Null handling decision:
-- 556 rows missing purchase_amount_usd (~11% of data)
-- 548 rows missing previous_purchases (~11% of data)
-- Decision: exclude nulls at query time using WHERE IS NOT NULL
-- Raw table left intact to preserve original data

