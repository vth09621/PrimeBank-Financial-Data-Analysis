-- ============================================================
-- KPI Analysis
-- ============================================================


-- How many customers does the bank have?
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_customers
FROM
    customers_cleaned;


-- How many branches are there?
-- ------------------------------------------------------------
SELECT
    COUNT(branch_id) AS total_branches
FROM
    branches_cleaned;


-- How many loans have been issued?
-- ------------------------------------------------------------
SELECT
    COUNT(loan_id) AS total_loans_issued
FROM
    loan_cleaned;


-- Calculate total loan amount issued.
-- ------------------------------------------------------------
SELECT
    SUM(loan_amount) AS total_loan_amount
FROM
    loan_cleaned;


-- Find total card transactions.
-- ------------------------------------------------------------
SELECT
    COUNT(card_id) AS total_card_transactions
FROM
    card_trans_cleaned;


-- Count total support tickets.
-- ------------------------------------------------------------
SELECT
    COUNT(ticket_id) AS total_support_tickets
FROM
    sup_tic_cleaned;


-- Find average customer credit score.
-- ------------------------------------------------------------
SELECT
    ROUND(AVG(credit_score)::numeric, 1) AS avg_credit_score
FROM
    customers_cleaned;
