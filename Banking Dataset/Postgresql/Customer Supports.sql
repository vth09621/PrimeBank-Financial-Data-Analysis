-- ============================================================
-- Customer Support Analysis
-- ============================================================


-- Q1 — Which support issues occur most frequently?
-- ------------------------------------------------------------
SELECT
    issue_type,
    COUNT(ticket_id) AS ticket_count
FROM
    sup_tic_cleaned
GROUP BY
    issue_type
ORDER BY
    ticket_count DESC;


-- Q2 — Which issues have the lowest satisfaction scores?
-- ------------------------------------------------------------
SELECT
    issue_type,
    AVG(satisfaction_score) AS avg_satisfaction_score
FROM
    sup_tic_cleaned
GROUP BY
    issue_type
ORDER BY
    avg_satisfaction_score ASC;


-- Q3 — Which support issues take the longest to resolve?
-- ------------------------------------------------------------
SELECT
    issue_type,
    AVG(date_resolved - date_opened) AS avg_resolution_time
FROM
    sup_tic_cleaned
WHERE
    date_resolved IS NOT NULL
GROUP BY
    issue_type
ORDER BY
    avg_resolution_time DESC;


-- Q4 — Does resolution time affect satisfaction?
-- ------------------------------------------------------------
SELECT
    issue_type,
    AVG(date_resolved - date_opened) AS avg_resolution_days,
    AVG(satisfaction_score)          AS avg_satisfaction_score
FROM
    sup_tic_cleaned
WHERE
    date_resolved IS NOT NULL
GROUP BY
    issue_type
ORDER BY
    avg_resolution_days DESC;


-- Q5 — Which customer segments generate the most support tickets
--      and lowest satisfaction?
-- ------------------------------------------------------------
SELECT
    c.occupation,
    COUNT(s.ticket_id)        AS total_support_tickets,
    AVG(s.satisfaction_score) AS avg_satisfaction_score
FROM
    sup_tic_cleaned  s
JOIN
    customers_cleaned c ON s.customer_id = c.customer_id
GROUP BY
    c.occupation
ORDER BY
    total_support_tickets DESC;
