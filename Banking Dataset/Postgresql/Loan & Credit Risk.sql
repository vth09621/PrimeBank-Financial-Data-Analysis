-- ============================================================
-- GROUP 4 — LOAN & CREDIT RISK
-- ============================================================


-- ============================================================
-- Q1 — What is the loan portfolio distribution by loan type?
-- ============================================================

SELECT
    loan_type,
    COUNT(*) AS loan_count,
    SUM(loan_amount) AS total_loan_amount,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS portfolio_percentage
FROM loan_cleaned
GROUP BY loan_type
ORDER BY total_loan_amount DESC;



-- ============================================================
-- Q2  — Which loan types have the highest average loan amount?
-- ============================================================

SELECT
    loan_type,
    AVG(loan_amount) AS average_loan_amount,
    COUNT(DISTINCT loan_id) AS loan_count
FROM loan_cleaned
GROUP BY loan_type
ORDER BY average_loan_amount DESC;



-- ============================================================
-- Q3 — What percentage of loans are
--       Active / Closed / Defaulted / Written Off?
-- ============================================================

SELECT
    status,
    COUNT(*) AS loan_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_loans
FROM loan_cleaned
GROUP BY status
ORDER BY loan_count DESC;


-- ============================================================
-- Q4 — Which loan types have the highest default rate?
-- ============================================================

SELECT
    loan_type,
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (WHERE status = 'Defaulted') AS defaulted_loans,
    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE status = 'Defaulted')
        / COUNT(*),
        2
    ) AS default_rate_percentage
FROM loan_cleaned
GROUP BY loan_type
ORDER BY default_rate_percentage DESC;



-- ============================================================
-- Q5 — Which branches have the highest loan default rate?
-- ============================================================

SELECT
    l.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT l.loan_id) FILTER (
        WHERE l.status = 'Defaulted'
    ) AS defaulted_loans,
    COUNT(DISTINCT l.loan_id) FILTER (
        WHERE l.status = 'Defaulted'
    ) * 100.0
        / COUNT(DISTINCT l.loan_id) AS default_rate
FROM loan_cleaned AS l
LEFT JOIN branches_cleaned AS b
    ON l.branch_id = b.branch_id
GROUP BY
    l.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY default_rate DESC
LIMIT 10;



-- ============================================================
-- Q6 — Which customers have repeated late payments?
-- ============================================================
WITH customer_late_payments AS (
    SELECT
        l.customer_id,
        SUM(lp.late_payment_flag) AS late_payment_count,
        COUNT(DISTINCT lp.payment_id) AS total_payments
    FROM loan_pay_cleaned AS lp
    LEFT JOIN loan_cleaned AS l
        ON lp.loan_id = l.loan_id
    GROUP BY l.customer_id
    HAVING SUM(lp.late_payment_flag) > 1
)SELECT
    clp.customer_id,
    c.name,
    c.occupation,
    c.credit_score,
    c.annual_income,
    clp.late_payment_count,
    clp.total_payments
FROM customer_late_payments AS clp
LEFT JOIN customers_cleaned AS c
    ON clp.customer_id = c.customer_id
ORDER BY clp.late_payment_count DESC
LIMIT 20;



-- ============================================================
-- Q7 — Which loan types have the highest late-payment rate?
-- ============================================================

SELECT
    l.loan_type,
    COUNT(DISTINCT lp.payment_id) AS total_payments,
    SUM(lp.late_payment_flag) AS late_payments,
    SUM(lp.late_payment_flag) * 100.0
        / COUNT(DISTINCT lp.payment_id) AS late_payment_rate
FROM loan_pay_cleaned AS lp
LEFT JOIN loan_cleaned AS l
    ON lp.loan_id = l.loan_id
GROUP BY l.loan_type
ORDER BY late_payment_rate DESC;




-- ============================================================
-- Q8 — How much principal/interest has been paid
--       vs outstanding?
-- ============================================================


WITH loan_summary AS (
    SELECT
        SUM(loan_amount) AS total_loan_principal
    FROM loan_cleaned
),payment_summary AS (
    SELECT
        SUM(principal_component) AS principal_paid,
        SUM(interest_component) AS interest_paid,
        SUM(amount_paid) AS total_amount_paid
    FROM loan_pay_cleaned
)SELECT
    ls.total_loan_principal AS "Total Loan Principal",
    ps.principal_paid AS "Principal Paid",
    ls.total_loan_principal - ps.principal_paid
        AS "Principal Outstanding",
    ps.interest_paid AS "Interest Paid",
    ps.total_amount_paid AS "Total Amount Paid"
FROM loan_summary AS ls
CROSS JOIN payment_summary AS ps;


-- ============================================================
-- Q9 — Which customers combine:
--       LOW CREDIT SCORE
--       + HIGH LOAN EXPOSURE
--       + LATE PAYMENTS?
-- ============================================================

WITH customer_loan_exposure AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS total_loan_exposure,
        COUNT(DISTINCT loan_id) AS loan_count
    FROM loan_cleaned
    GROUP BY customer_id
),customer_late_payments AS (
    SELECT
        l.customer_id,
        SUM(lp.late_payment_flag) AS late_payment_count
    FROM loan_pay_cleaned AS lp
    LEFT JOIN loan_cleaned AS l
        ON lp.loan_id = l.loan_id
    GROUP BY l.customer_id
),customer_risk AS (
    SELECT
        c.customer_id,
        c.name,
        c.credit_score,
        c.annual_income,
        c.occupation,
        cle.total_loan_exposure,
        cle.loan_count,
        COALESCE(clp.late_payment_count, 0) AS late_payment_count
    FROM customers_cleaned AS c
    INNER JOIN customer_loan_exposure AS cle
        ON c.customer_id = cle.customer_id
    LEFT JOIN customer_late_payments AS clp
        ON c.customer_id = clp.customer_id
),loan_exposure_threshold AS (
    SELECT
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY total_loan_exposure
        ) AS threshold
    FROM customer_risk
)
SELECT
    cr.customer_id,
    cr.name,
    cr.credit_score,
    cr.annual_income,
    cr.occupation,
    cr.total_loan_exposure,
    cr.loan_count,
    cr.late_payment_count
FROM customer_risk AS cr
CROSS JOIN loan_exposure_threshold AS t
WHERE cr.credit_score < 600
  AND cr.total_loan_exposure >= t.threshold
  AND cr.late_payment_count > 0
ORDER BY
    cr.late_payment_count DESC,
    cr.total_loan_exposure DESC;





