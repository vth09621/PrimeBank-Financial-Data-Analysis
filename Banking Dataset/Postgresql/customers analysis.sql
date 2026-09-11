-- =========================================================
-- GROUP 1 — CUSTOMER ANALYSIS
-- =========================================================


-- Q1. Which occupation groups have highest average annual income?

SELECT
    occupation,
    ROUND(AVG(annual_income), 2) AS average_income,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customers_cleaned
GROUP BY occupation
ORDER BY average_income DESC;



-- Q2. Which occupation groups have strongest average credit scores?

SELECT
    occupation,
    ROUND(AVG(credit_score), 2) AS average_credit_score,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customers_cleaned
GROUP BY occupation
ORDER BY average_credit_score DESC;



-- Q3. How are customers distributed across credit-score bands?

SELECT
    CASE
        WHEN credit_score < 500 THEN 'Very Low'
        WHEN credit_score < 600 THEN 'Low'
        WHEN credit_score < 700 THEN 'Fair'
        WHEN credit_score < 800 THEN 'Good'
        ELSE 'Excellent'
    END AS credit_score_band,
    COUNT(DISTINCT customer_id) AS customer_count,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0
        / SUM(COUNT(DISTINCT customer_id)) OVER (),
        2
    ) AS percentage
FROM customers_cleaned
GROUP BY
    CASE
        WHEN credit_score < 500 THEN 'Very Low'
        WHEN credit_score < 600 THEN 'Low'
        WHEN credit_score < 700 THEN 'Fair'
        WHEN credit_score < 800 THEN 'Good'
        ELSE 'Excellent'
    END
ORDER BY MIN(credit_score);



-- Q4. Which customer segments combine high income + low credit score?

WITH income_threshold AS (
    SELECT
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY annual_income) AS high_income_limit
    FROM customers_cleaned
)
SELECT
    c.customer_id,
    c.name,
    c.occupation,
    c.annual_income,
    c.credit_score,
    c.city,
    c.state
FROM customers_cleaned c
CROSS JOIN income_threshold t
WHERE c.annual_income >= t.high_income_limit
  AND c.credit_score < 600
ORDER BY c.credit_score ASC, c.annual_income DESC;



-- Q5. Which cities have highest customer concentration?

SELECT
    city,
    COUNT(DISTINCT customer_id) AS customer_count,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0
        / SUM(COUNT(DISTINCT customer_id)) OVER (),
        2
    ) AS percentage
FROM customers_cleaned
GROUP BY city
ORDER BY customer_count DESC;



-- Q6. Which states have highest average customer income?

SELECT
    state,
    ROUND(AVG(annual_income), 2) AS average_income,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customers_cleaned
GROUP BY state
ORDER BY average_income DESC;



-- Q7. What is the relationship between annual income and credit score?

SELECT
    ROUND(
        CORR(annual_income, credit_score)::numeric,
        3
    ) AS income_credit_correlation
FROM customers_cleaned;



-- Q8. Which customer segments have highest account ownership?

SELECT
    c.occupation,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(
        AVG(a.account_count),
        2
    ) AS average_accounts_per_customer
FROM customers_cleaned c
JOIN (
    SELECT
        customer_id,
        COUNT(DISTINCT account_id) AS account_count
    FROM accounts_cleaned
    GROUP BY customer_id
) a
    ON c.customer_id = a.customer_id
GROUP BY c.occupation
ORDER BY average_accounts_per_customer DESC;



-- Q9. Which customers hold multiple accounts and how large are their balances?
SELECT
    a.customer_id,
    c.name,
    c.occupation,
    COUNT(a.account_id) AS account_count,
    ROUND(SUM(a.balance)::numeric, 2) AS total_balance
FROM accounts_cleaned a
JOIN customers_cleaned c
    ON a.customer_id = c.customer_id
GROUP BY
    a.customer_id,
    c.name,
    c.occupation
HAVING COUNT(a.account_id) > 1
ORDER BY
    account_count DESC,
    total_balance DESC;



-- Q10. Which customers hold loans + cards + multiple accounts simultaneously?

WITH account_counts AS (
    SELECT
        customer_id,
        COUNT(DISTINCT account_id) AS account_count
    FROM accounts_cleaned
    GROUP BY customer_id
),
loan_customers AS (
    SELECT DISTINCT customer_id
    FROM loan_cleaned
),
card_customers AS (
    SELECT DISTINCT customer_id
    FROM card_cleaned
)
SELECT
    c.customer_id,
    c.name,
    c.occupation,
    c.annual_income,
    c.credit_score,
    ac.account_count
FROM customers_cleaned c
JOIN account_counts ac
    ON c.customer_id = ac.customer_id
JOIN loan_customers l
    ON c.customer_id = l.customer_id
JOIN card_customers ca
    ON c.customer_id = ca.customer_id
WHERE ac.account_count > 1
ORDER BY ac.account_count DESC, c.credit_score ASC;