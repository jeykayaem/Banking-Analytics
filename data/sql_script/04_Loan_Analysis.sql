-- =========================================================
-- 04_LOAN_ANALYSIS
-- Banking Data Analytics Project
-- =========================================================


-- 1. Loan portfolio summary
-- Find total, minimum, maximum, and average loan amount

SELECT
    SUM(loan_amount) AS TotalLoanAmount,
    MIN(loan_amount) AS MinLoanAmount,
    MAX(loan_amount) AS MaxLoanAmount,
    AVG(loan_amount) AS AvgLoanAmount
FROM loans;


-- 2. Interest rate analysis
-- Find minimum, maximum, and average interest rate

SELECT
    MIN(interest_rate) AS MinInterestRate,
    MAX(interest_rate) AS MaxInterestRate,
    AVG(interest_rate) AS AvgInterestRate
FROM loans;


-- 3. Customers with multiple loans
-- List customers who hold more than one loan

SELECT
    customer_id,
    COUNT(loan_id) AS NoOfLoans
FROM loans
GROUP BY customer_id
HAVING COUNT(loan_id) > 1
ORDER BY NoOfLoans DESC;


-- 4. Number of customers with multiple loans

SELECT
    COUNT(*) AS CustomersWithMultipleLoans
FROM (
    SELECT
        customer_id
    FROM loans
    GROUP BY customer_id
    HAVING COUNT(loan_id) > 1
) AS MultipleLoans;


-- 5. Top 10 customers by total loan exposure

SELECT
    customer_id,
    COUNT(loan_id) AS NoOfLoans,
    SUM(loan_amount) AS TotalLoanAmount
FROM loans
GROUP BY customer_id
ORDER BY TotalLoanAmount DESC
LIMIT 10;