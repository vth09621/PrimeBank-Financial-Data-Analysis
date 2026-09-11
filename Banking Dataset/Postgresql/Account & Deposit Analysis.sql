-- =========================================
-- Q1. Most common account types
-- =========================================

SELECT
    account_type,
    COUNT(*) AS account_count
FROM accounts_cleaned
GROUP BY account_type
ORDER BY account_count DESC;


-- =========================================
-- Q2. Account types with highest total balance
-- =========================================

SELECT
    account_type,
    COUNT(*) AS account_count,
    ROUND(SUM(balance)::numeric, 2) AS total_balance
FROM accounts_cleaned
GROUP BY account_type
ORDER BY total_balance DESC;


-- =========================================
-- Q3. Account types with highest average balance
-- =========================================

SELECT
    account_type,
    COUNT(*) AS account_count,
    ROUND(AVG(balance)::numeric, 2) AS average_balance
FROM accounts_cleaned
GROUP BY account_type
ORDER BY average_balance DESC;


-- =========================================
-- Q4. Branches with highest total deposits
-- =========================================

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


-- =========================================
-- Q5. High customer count but relatively low deposits
-- =========================================

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    COUNT(DISTINCT a.customer_id) AS customer_count,
    ROUND(SUM(a.balance)::numeric, 2) AS total_deposits
FROM branches_cleaned b
JOIN accounts_cleaned a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city
HAVING
    COUNT(DISTINCT a.customer_id) >
        (SELECT AVG(customer_count)
         FROM (
             SELECT COUNT(DISTINCT customer_id) AS customer_count
             FROM accounts_cleaned
             GROUP BY branch_id
         ) x)
    AND
    SUM(a.balance) <
        (SELECT AVG(total_deposits)
         FROM (
             SELECT SUM(balance) AS total_deposits
             FROM accounts_cleaned
             GROUP BY branch_id
         ) y)
ORDER BY customer_count DESC;


-- =========================================
-- Q6. Percentage of customers owning
--      multiple accounts
-- =========================================

SELECT
    COUNT(*) FILTER (WHERE account_count > 1) AS multiple_account_customers,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) FILTER (WHERE account_count > 1) * 100.0
        / COUNT(*),
        2
    ) AS percentage_multiple_accounts
FROM (
    SELECT
        customer_id,
        COUNT(account_id) AS account_count
    FROM accounts_cleaned
    GROUP BY customer_id
) x;


-- =========================================
-- Q7. Customers with unusually high balances
--      (above 75th percentile)
-- =========================================

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
HAVING
    SUM(a.balance) >
    (
        SELECT PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY total_balance)
        FROM (
            SELECT
                customer_id,
                SUM(balance) AS total_balance
            FROM accounts_cleaned
            GROUP BY customer_id
        ) x
    )
ORDER BY total_balance DESC;


-- =========================================
-- Q8. Branches with unusually high balances
--      (above 75th percentile)
-- =========================================

SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    ROUND(SUM(a.balance)::numeric, 2) AS total_balance
FROM branches_cleaned b
JOIN accounts_cleaned a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city
HAVING
    SUM(a.balance) >
    (
        SELECT PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY total_balance)
        FROM (
            SELECT
                branch_id,
                SUM(balance) AS total_balance
            FROM accounts_cleaned
            GROUP BY branch_id
        ) x
    )
ORDER BY total_balance DESC;