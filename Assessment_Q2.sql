WITH customer_txns AS (
    SELECT
        u.id AS owner_id,
        COUNT(s.id) AS total_transactions,
        -- Calculate months active: difference between first and last transaction dates (minimum 1 month to avoid divide by zero)
        GREATEST(DATEDIFF(MAX(s.transaction_date), MIN(s.transaction_date)) / 30.0, 1) AS months_active,
        -- Average transactions per month (floating point)
        COUNT(s.id) / GREATEST(DATEDIFF(MAX(s.transaction_date), MIN(s.transaction_date)) / 30.0, 1) AS avg_txns_per_month
    FROM users_customuser u
    JOIN savings_savingsaccount s ON s.owner_id = u.id
    WHERE s.transaction_status = 'success'
    GROUP BY u.id
),
categorized AS (
    SELECT
        owner_id,
        total_transactions,
        months_active,
        avg_txns_per_month,
        CASE
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_txns
)
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
