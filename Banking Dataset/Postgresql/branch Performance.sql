-- =========================================================
-- GROUP 2 — BRANCH PERFORMANCE
-- =========================================================


-- Q1. Which branches hold the highest total deposits?

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    ROUND(SUM(a.balance)::numeric, 2) AS total_deposits
FROM branches_cleaned b
JOIN accounts_cleaned a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY total_deposits DESC;


-- Q2. Which branches have the highest number of customers?

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(DISTINCT a.customer_id) AS customer_count
FROM branches_cleaned b
JOIN accounts_cleaned a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY customer_count DESC;


-- Q3. Which branches issue the most loans?

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(DISTINCT l.loan_id) AS loan_count
FROM branches_cleaned b
JOIN loan_cleaned l
    ON b.branch_id = l.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY loan_count DESC;


-- Q4. Which branches have the highest transaction volume?

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(DISTINCT t.transaction_id) AS transaction_count,
    ROUND(SUM(t.amount)::numeric, 2) AS transaction_value
FROM branches_cleaned b
JOIN accounts_cleaned a
    ON b.branch_id = a.branch_id
JOIN tranc_cleaned t
    ON a.account_id = t.account_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY transaction_count DESC;


-- Q5. Which branches have the highest employee count?

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(DISTINCT e.employee_id) AS employee_count
FROM branches_cleaned b
JOIN employee_cleaned e
    ON b.branch_id = e.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY employee_count DESC;


-- Q6. Which branches have high deposits
--     but relatively low loan activity?

WITH branch_deposits AS (
    SELECT
        branch_id,
        SUM(balance) AS total_deposits,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM accounts_cleaned
    GROUP BY branch_id
),
branch_loans AS (
    SELECT
        branch_id,
        COUNT(DISTINCT loan_id) AS loan_count
    FROM loan_cleaned
    GROUP BY branch_id
),
thresholds AS (
    SELECT
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY total_deposits) AS high_deposit_threshold,
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY loan_count) AS low_loan_threshold
    FROM branch_deposits bd
    JOIN branch_loans bl
        ON bd.branch_id = bl.branch_id
)
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    bd.customer_count,
    ROUND(bd.total_deposits::numeric, 2) AS total_deposits,
    bl.loan_count
FROM branch_deposits bd
JOIN branch_loans bl
    ON bd.branch_id = bl.branch_id
JOIN branches_cleaned b
    ON bd.branch_id = b.branch_id
CROSS JOIN thresholds t
WHERE bd.total_deposits >= t.high_deposit_threshold
  AND bl.loan_count <= t.low_loan_threshold
ORDER BY bd.total_deposits DESC;


