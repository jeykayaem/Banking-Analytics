-- =========================================================
-- 03_ACCOUNT_ANALYSIS
-- Banking Data Analytics Project
-- =========================================================

-- 1. Account distribution by account type

SELECT
    account_type,
    COUNT(account_id) AS NumberOfAccounts
FROM accounts
GROUP BY account_type
ORDER BY NumberOfAccounts DESC;


-- 2. Customers with multiple accounts

SELECT
    customer_id,
    COUNT(account_id) AS NumberOfAccounts
FROM accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 1
ORDER BY NumberOfAccounts DESC;


-- 3. Customer-level balance analysis

SELECT
    customer_id,
    COUNT(account_id) AS NumberOfAccounts,
    SUM(balance_usd) AS TotalBalance,
    AVG(balance_usd) AS AvgBalance
FROM accounts
GROUP BY customer_id
ORDER BY TotalBalance DESC;


-- 4. Customers with total balances above $300,000

WITH CustomerBalances AS (
    SELECT
        customer_id,
        COUNT(account_id) AS NumberOfAccounts,
        SUM(balance_usd) AS TotalBalance,
        AVG(balance_usd) AS AvgBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT *
FROM CustomerBalances
WHERE TotalBalance > 300000
ORDER BY TotalBalance DESC;


-- 5. Customers with more than 3 accounts
--    and total balances above $400,000

WITH CustomerBalances AS (
    SELECT
        customer_id,
        COUNT(account_id) AS NumberOfAccounts,
        SUM(balance_usd) AS TotalBalance,
        AVG(balance_usd) AS AvgBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT *
FROM CustomerBalances
WHERE NumberOfAccounts > 3
  AND TotalBalance > 400000
ORDER BY TotalBalance DESC;


-- 6. Top 5 customers by total account balance
--    Include customer information

WITH CustomerBalances AS (
    SELECT
        customer_id,
        SUM(balance_usd) AS TotalBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cb.TotalBalance
FROM customers c
INNER JOIN CustomerBalances cb
    ON cb.customer_id = c.customer_id
ORDER BY cb.TotalBalance DESC
LIMIT 5;