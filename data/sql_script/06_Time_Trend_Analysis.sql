-- =========================================================
-- 06_TIME_TREND_ANALYSIS
-- Banking Data Analytics Project
-- =========================================================


-- 1. New customers by year

SELECT 
    YEAR(created_at) AS Year,
    COUNT(customer_id) AS NewCustomers
FROM customers
GROUP BY YEAR(created_at)
ORDER BY Year;


-- 2. New accounts opened by year

SELECT 
    YEAR(open_date) AS Year,
    COUNT(account_id) AS NewAccounts
FROM accounts
GROUP BY YEAR(open_date)
ORDER BY Year;


-- 3. Loan activity by year

SELECT 
    YEAR(start_date) AS Year,
    COUNT(loan_id) AS NewLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    AVG(loan_amount) AS AvgLoanAmount
FROM loans
GROUP BY YEAR(start_date)
ORDER BY Year;