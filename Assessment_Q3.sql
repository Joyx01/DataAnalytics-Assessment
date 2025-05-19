WITH dataset_end AS (
    SELECT DATE(MAX(transaction_date)) AS max_date
    FROM savings_savingsaccount
),
last_inflows AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        DATE(MAX(s.transaction_date)) AS last_transaction_date
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE s.confirmed_amount > 0
      AND p.is_deleted = 0
      AND p.is_archived = 0
      AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
),
inactivity_check AS (
    SELECT
        li.plan_id,
        li.owner_id,
        li.type,
        li.last_transaction_date,
        DATEDIFF(de.max_date, li.last_transaction_date) AS inactivity_days
    FROM last_inflows li
    CROSS JOIN dataset_end de
)
SELECT *
FROM inactivity_check
WHERE inactivity_days > 365;
