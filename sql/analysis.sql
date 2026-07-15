-- Analysis 3A: Revenue by category and season
-- Note: 'Autumn' corrected to 'Fall' due to inconsistent data entry
SELECT
  category,
  CASE WHEN season = 'Autumn' THEN 'Fall' ELSE season END AS season,
  COUNT(*)                                    AS total_transactions,
  ROUND(SUM(purchase_amount_usd), 2)          AS total_revenue,
  ROUND(AVG(purchase_amount_usd), 2)          AS avg_order_value
FROM `retail-customer-analysis.shopping.transactions`
WHERE purchase_amount_usd IS NOT NULL
GROUP BY category, season
ORDER BY category, total_revenue DESC;


-- Analysis 3B: Top spending customers
-- Identifies the highest value customers by total revenue contributed
SELECT
  customer_id,
  COUNT(*)                                  AS total_transactions,
  ROUND(SUM(purchase_amount_usd), 2)        AS total_spent,
  ROUND(AVG(purchase_amount_usd), 2)        AS avg_order_value,
  MAX(previous_purchases)                   AS previous_purchases,
  MAX(subscription_status)                  AS subscription_status
FROM `retail-customer-analysis.shopping.transactions`
WHERE purchase_amount_usd IS NOT NULL
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 20;


-- Analysis 3C: Customer segmentation by value tier
-- Segments customers into High, Mid, and Low value based on spend and purchase history
-- Note: dataset is a snapshot, so previous_purchases is used as frequency proxy
SELECT
  customer_id,
  subscription_status,
  frequency_of_purchases,
  previous_purchases,
  ROUND(purchase_amount_usd, 2)                           AS purchase_amount,
  CASE
    WHEN purchase_amount_usd >= 1000
      AND previous_purchases >= 20  THEN 'High Value'
    WHEN purchase_amount_usd >= 500
      OR  previous_purchases >= 10  THEN 'Mid Value'
    ELSE                                 'Low Value'
  END                                                     AS customer_segment
FROM `retail-customer-analysis.shopping.transactions`
WHERE purchase_amount_usd IS NOT NULL
  AND previous_purchases  IS NOT NULL
ORDER BY purchase_amount_usd DESC;

-- Analysis 3C: Segment summary
SELECT
  CASE
    WHEN purchase_amount_usd >= 1000
      AND previous_purchases >= 20  THEN 'High Value'
    WHEN purchase_amount_usd >= 500
      OR  previous_purchases >= 10  THEN 'Mid Value'
    ELSE                                 'Low Value'
  END                                                     AS customer_segment,
  COUNT(*)                                                AS total_customers,
  ROUND(AVG(purchase_amount_usd), 2)                      AS avg_spend,
  ROUND(AVG(previous_purchases), 1)                       AS avg_previous_purchases
FROM `retail-customer-analysis.shopping.transactions`
WHERE purchase_amount_usd IS NOT NULL
  AND previous_purchases  IS NOT NULL
GROUP BY customer_segment
ORDER BY avg_spend DESC;


-- Analysis 3D: Repeat vs one-time buyers
-- Compares behavior of first-time buyers (previous_purchases = 0) vs repeat customers
SELECT
  CASE
    WHEN previous_purchases = 0 THEN 'First-time buyer'
    ELSE 'Repeat buyer'
  END                                              AS buyer_type,
  COUNT(*)                                         AS total_customers,
  ROUND(AVG(purchase_amount_usd), 2)               AS avg_spend,
  ROUND(AVG(review_rating), 2)                     AS avg_review_rating,
  COUNTIF(subscription_status = 'Yes')             AS subscribers,
  ROUND(COUNTIF(subscription_status = 'Yes') * 100.0 / COUNT(*), 1) AS subscriber_pct,
  COUNTIF(discount_applied = 'Yes')                AS used_discount,
  ROUND(COUNTIF(discount_applied = 'Yes') * 100.0 / COUNT(*), 1)    AS discount_pct
FROM `retail-customer-analysis.shopping.transactions`
WHERE purchase_amount_usd IS NOT NULL
  AND previous_purchases IS NOT NULL
GROUP BY buyer_type;
