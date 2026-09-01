-- 1. Customer distribution by credit score band
SELECT
    CASE
        WHEN credit_score < 500 THEN 'Poor'
        WHEN credit_score < 650 THEN 'Fair'
        WHEN credit_score < 750 THEN 'Good'
        ELSE 'Excellent'
    END AS CreditScoreBand,
    COUNT(customer_id) AS NumberOfCustomers
FROM customers
GROUP BY CreditScoreBand
ORDER BY NumberOfCustomers DESC;


-- 2. Customers with loans by credit score band
SELECT
    CASE
        WHEN c.credit_score < 500 THEN 'Poor'
        WHEN c.credit_score < 650 THEN 'Fair'
        WHEN c.credit_score < 750 THEN 'Good'
        ELSE 'Excellent'
    END AS CreditScoreBand,
    COUNT(DISTINCT c.customer_id) AS CustomersWithLoans,
    COUNT(l.loan_id) AS NumberOfLoans,
    SUM(l.loan_amount) AS TotalLoanAmount,
    AVG(l.loan_amount) AS AvgLoanAmount
FROM customers c
INNER JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY CreditScoreBand
ORDER BY TotalLoanAmount DESC;


-- 3. Loan penetration by credit score band
WITH CustomerBands AS (
    SELECT
        CASE
            WHEN credit_score < 500 THEN 'Poor'
            WHEN credit_score < 650 THEN 'Fair'
            WHEN credit_score < 750 THEN 'Good'
            ELSE 'Excellent'
        END AS CreditScoreBand,
        COUNT(DISTINCT customer_id) AS TotalCustomers
    FROM customers
    GROUP BY CreditScoreBand
),
LoanCustomers AS (
    SELECT
        CASE
            WHEN c.credit_score < 500 THEN 'Poor'
            WHEN c.credit_score < 650 THEN 'Fair'
            WHEN c.credit_score < 750 THEN 'Good'
            ELSE 'Excellent'
        END AS CreditScoreBand,
        COUNT(DISTINCT c.customer_id) AS CustomersWithLoans
    FROM customers c
    INNER JOIN loans l
        ON c.customer_id = l.customer_id
    GROUP BY CreditScoreBand
)
SELECT
    cb.CreditScoreBand,
    cb.TotalCustomers,
    lc.CustomersWithLoans,
    ROUND(
        lc.CustomersWithLoans * 100.0 / cb.TotalCustomers,
        2
    ) AS LoanPenetrationPct
FROM CustomerBands cb
INNER JOIN LoanCustomers lc
    ON lc.CreditScoreBand = cb.CreditScoreBand
ORDER BY LoanPenetrationPct DESC;