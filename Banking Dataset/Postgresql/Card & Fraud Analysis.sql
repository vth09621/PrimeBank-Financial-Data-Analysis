-- ============================================================
-- Card Fraud Analysis
-- ============================================================


-- Q1 — Distribution of cards by type
-- ------------------------------------------------------------
SELECT
    card_type,
    COUNT(*) AS card_count
FROM
    card_cleaned
GROUP BY
    card_type
ORDER BY
    card_count DESC;


-- Q2 — Which card types have the highest credit limits?
-- ------------------------------------------------------------
SELECT
    card_type,
    MAX(credit_limit) AS highest_credit_limit
FROM
    card_cleaned
GROUP BY
    card_type
ORDER BY
    highest_credit_limit DESC;


-- Q3 — Which merchant categories generate the highest card spending?
-- ------------------------------------------------------------
SELECT
    merchant_category,
    SUM(amount) AS total_spending
FROM
    tranc_cleaned
GROUP BY
    merchant_category
ORDER BY
    total_spending DESC;


-- Q4 — What is the average transaction amount for fraudulent
--      vs legitimate transactions?
-- ------------------------------------------------------------
SELECT
    txn_type,
    AVG(amount) AS avg_transaction_amount
FROM
    tranc_cleaned
GROUP BY
    txn_type
ORDER BY
    avg_transaction_amount DESC;


-- Q5 — Which customers/cards show unusually high transaction
--      activity or fraud exposure?
-- ------------------------------------------------------------
SELECT
    account_id,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount)           AS total_transaction_amount,
    AVG(amount)           AS avg_transaction_amount
FROM
    tranc_cleaned
GROUP BY
    account_id
ORDER BY
    total_transactions DESC;


-- Q6 — Which accounts have the highest total transaction amount?
-- ------------------------------------------------------------
SELECT
    account_id,
    SUM(amount) AS total_transaction_amount
FROM
    tranc_cleaned
GROUP BY
    account_id
ORDER BY
    total_transaction_amount DESC
LIMIT 10;


-- Q7 — Which accounts have both high transaction volume and
--      high transaction value?
-- ------------------------------------------------------------
SELECT
    account_id,
    COUNT(transaction_id) AS transaction_volume,
    SUM(amount)            AS total_transaction_value
FROM
    tranc_cleaned
GROUP BY
    account_id
ORDER BY
    transaction_volume DESC,
    total_transaction_value DESC;