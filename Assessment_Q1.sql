SELECT 
    u.id AS owner_id,
    TRIM(CONCAT_WS(' ', u.first_name, u.last_name)) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    REPLACE(FORMAT(SUM(COALESCE(s.confirmed_amount, 0)) / 100, 2), ',', '') AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON p.owner_id = u.id
JOIN savings_savingsaccount s ON s.plan_id = p.id 
    AND s.transaction_status = 'success' 
    AND s.confirmed_amount > 0
GROUP BY u.id, name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits + 0 DESC;
