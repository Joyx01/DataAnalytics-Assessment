WITH max_transaction_date AS (
    SELECT MAX(transaction_date) AS latest_date
    FROM savings_savingsaccount
),
user_tenure AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, m.latest_date) AS tenure_months
    FROM users_customuser u
    CROSS JOIN max_transaction_date m
),
transactions_summary AS (
    SELECT
        s.owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        AVG(s.confirmed_amount) / 100 AS avg_transaction_value_naira
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0
    GROUP BY s.owner_id
),
clv_calc AS (
    SELECT
        u.customer_id,
        u.name,
        u.tenure_months,
        t.total_transactions,
        FORMAT(((t.total_transactions / NULLIF(u.tenure_months, 0)) * 12 * (0.001 * t.avg_transaction_value_naira)), 2) AS estimated_clv
    FROM user_tenure u
    JOIN transactions_summary t ON u.customer_id = t.customer_id
)
SELECT *
FROM clv_calc
ORDER BY CAST(estimated_clv AS DECIMAL(10,2)) DESC;
