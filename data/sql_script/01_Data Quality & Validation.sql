SELECT
    (SELECT COUNT(*) FROM customers) AS TotalCustomers,
    (SELECT COUNT(*) FROM accounts) AS TotalAccounts,
    (SELECT COUNT(*) FROM loans) AS TotalLoans,
    (SELECT COUNT(*) FROM cards) AS TotalCards,
    (SELECT COUNT(*) FROM branches) AS TotalBranches,
    (SELECT COUNT(*) FROM merchants) AS TotalMerchants;
    
SELECT COUNT(distinct customer_id) FROM customers;

SELECT
    customer_id,
    COUNT(*) AS Occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    SUM(customer_id IS NULL) AS NullCustomerID,
    SUM(first_name IS NULL) AS NullFirstName,
	SUM(last_name IS NULL) AS Nulllast_name,
    SUM(email IS NULL) AS Nullemail,
    SUM(city IS NULL) AS Nullcity,
	SUM(credit_score IS NULL) AS Nullcredit_score,
    SUM(created_at IS NULL) AS Nullcreated_at
FROM customers;

-- Project Task 4 — Validate Credit Score
SELECT
    MIN(credit_score) AS MinScore,
    MAX(credit_score) AS MaxScore,
    AVG(credit_score) AS AvgScore
FROM customers;

SELECT
    MIN(created_at) AS creatdate,
    MAX(created_at) AS createend
FROM customers;

SELECT
    MIN(balance_usd) AS Minbal,
    MAX(balance_usd) AS Maxbal,
    AVG(balance_usd) AS Avgbal
FROM accounts;

-- Show each account_type and the number of accounts for that type, sorted from the highest number of accounts to the lowest.
SELECT
    account_type,
    COUNT(account_id) AS NumberOfAccounts
FROM accounts
GROUP BY account_type
ORDER BY NumberOfAccounts DESC;

-- For each account type, show the number of accounts, total balance, and average balance. Sort by highest total balance.
SELECT
    account_type,
    COUNT(account_id) AS NumberOfAccounts,
	sum(balance_usd) as sumofbalance,
    avg(balance_usd) as avgbalance
FROM accounts
GROUP BY account_type
ORDER BY sum(balance_usd) DESC;
-- Which customers hold the highest total account balances?
SELECT
    c.customer_id,c.first_name,c.last_name,
    count(a.account_type) as noofaccount,
	sum(a.balance_usd) as totalaccountbalances
FROM accounts a
inner join customers c ON c.customer_id =a.customer_id
group by customer_id
ORDER BY totalaccountbalances DESC
limit 10;
-- How many customers have more than one account?
SELECT COUNT(*) AS CustomersWithMultipleAccounts
FROM (
    SELECT
        customer_id,
        COUNT(account_id) AS NoOfAccounts
    FROM accounts
    GROUP BY customer_id
    HAVING COUNT(account_id) > 1
) AS MultipleAccounts;

-- “Show customers whose total account balance is greater than the average total balance per customer.”

SELECT
    AVG(total_account_balance) AS AvgCustomerTotalBalance
FROM (
    SELECT
        customer_id,
        SUM(balance_usd) AS total_account_balance
    FROM accounts
    GROUP BY customer_id
) AS CustomerTotals;

SELECT
    customer_id,
    total_account_balance
FROM (
    SELECT
        customer_id,
        SUM(balance_usd) AS total_account_balance
    FROM accounts
    GROUP BY customer_id
) AS CustomerTotals
WHERE total_account_balance > (
    SELECT AVG(total_account_balance)
    FROM (
        SELECT
            customer_id,
            SUM(balance_usd) AS total_account_balance
        FROM accounts
        GROUP BY customer_id
    ) AS AvgTotals
);


WITH SavingsAccounts AS (
    SELECT *
    FROM accounts
    WHERE account_type = 'Savings'
)
SELECT *
FROM SavingsAccounts;


-- Now create a CTE called HighBalanceAccounts containing accounts where:
-- balance_usd > 150000
WITH HighBalanceAccounts AS (
    SELECT *
    FROM accounts
    WHERE balance_usd > 150000
)
SELECT *
FROM HighBalanceAccounts;

-- Basic #3 — Aggregate inside a CTE
-- Suppose we want to calculate the total account balance for each customer.
WITH CustomerBalances AS (
SELECT
    customer_id,
    SUM(balance_usd) AS TotalBalance
FROM accounts
GROUP BY customer_id
)
SELECT *
FROM CustomerBalances;

-- Show only customers whose total account balance is greater than $300,000.
WITH CustomerBalances AS (
SELECT
    customer_id,
    SUM(balance_usd) AS TotalBalance
FROM accounts
GROUP BY customer_id
)
SELECT *
FROM CustomerBalances
 where TotalBalance > 300000;
-- How many customers have TotalBalance > 300000?
WITH CustomerBalances AS (
    SELECT
        customer_id,
        SUM(balance_usd) AS TotalBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT count(*)
FROM CustomerBalances
WHERE TotalBalance > 300000;

-- CTE Basic #6 — Average using the CTE
-- What is the average total account balance per customer?
WITH CustomerBalances AS (
    SELECT
        customer_id,
        SUM(balance_usd) AS TotalBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT avg(TotalBalance)
FROM CustomerBalances;
-- Show the top 5 customers with the highest combined account balances.
WITH CustomerBalances AS (
    SELECT
        customer_id,
        SUM(balance_usd) AS TotalBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT *
FROM CustomerBalances
ORDER BY TotalBalance DESC
LIMIT 5;

--
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

-- For each customer, calculate their number of accounts, total balance, and average account balance. Then show only customers with more than 3 accounts.
WITH CustomerBalances AS (
    SELECT
        customer_id,
        count(account_id) as noofaccount,
        SUM(balance_usd) AS TotalBalance,
		avg(balance_usd) AS AvgBalance
    FROM accounts
    GROUP BY customer_id
)
select * from
CustomerBalances
    where noofaccount  > 3
;
-- Show customers who have more than 3 accounts AND a total balance greater than $400,000. Sort the highest total balance first.
WITH CustomerBalances AS (
    SELECT
        customer_id,
        count(account_id) as noofaccount,
        SUM(balance_usd) AS TotalBalance,
		avg(balance_usd) AS AvgBalance
    FROM accounts
    GROUP BY customer_id
)
select * from
CustomerBalances
    where (noofaccount  > 3) and (TotalBalance > 400000)
    order by TotalBalance desc
;
-- Business question: Calculate the total loan amount for each customer.
WITH CustomerLoans AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS TotalLoanAmount
    FROM loans
    GROUP BY customer_id
)
SELECT *
FROM CustomerLoans;
-- “Show total loan amount by customer AND count how many loans each customer has.”
WITH CustomerLoans AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS TotalLoanAmount,
        count(loan_id) AS noof_loan
    FROM loans
    GROUP BY customer_id
)
SELECT
        *
FROM CustomerLoans;
-- and join them to compare a customer’s total account balance vs total loan amount.

WITH CustomerLoans AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS TotalLoanAmount,
        COUNT(loan_id) AS NoOfLoan
    FROM loans
    GROUP BY customer_id
),
CustomerBalances AS (
    SELECT
        customer_id,
        COUNT(account_id) AS NoOfAccount,
        SUM(balance_usd) AS TotalBalance,
        AVG(balance_usd) AS AvgBalance
    FROM accounts
    GROUP BY customer_id
)
SELECT
    cb.customer_id,
    cb.NoOfAccount,
    cb.TotalBalance,
    cb.AvgBalance,
    cl.NoOfLoan,
    cl.TotalLoanAmount,
    cl.TotalLoanAmount - cb.TotalBalance AS LoanExposureGap
FROM CustomerBalances cb
INNER JOIN CustomerLoans cl
    ON cl.customer_id = cb.customer_id
WHERE cl.TotalLoanAmount > cb.TotalBalance
-- Your next step can be to sort customers by highest LoanExposureGap.
order by LoanExposureGap desc
;

-- Which customers have total loan exposure greater than their total account balance, ranked by the largest exposure gap?
