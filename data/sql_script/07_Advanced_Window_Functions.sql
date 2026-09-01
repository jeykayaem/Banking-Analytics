-- =========================================================
-- 07_ADVANCED_WINDOW_FUNCTIONS
-- Banking Data Analytics Project
-- =========================================================


-- 1. Customer-level loan metrics while preserving loan-level detail

SELECT
    customer_id,
    loan_id,
    loan_amount,

    AVG(loan_amount) OVER (
        PARTITION BY customer_id
    ) AS CustomerAvgLoan,

    SUM(loan_amount) OVER (
        PARTITION BY customer_id
    ) AS CustomerTotalLoan,

    COUNT(loan_id) OVER (
        PARTITION BY customer_id
    ) AS CustomerLoanCount

FROM loans;


-- 2. Rank loans within each customer

SELECT
    customer_id,
    loan_id,
    loan_amount,

    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY loan_amount DESC
    ) AS RowNum,

    RANK() OVER (
        PARTITION BY customer_id
        ORDER BY loan_amount DESC
    ) AS LoanRank,

    DENSE_RANK() OVER (
        PARTITION BY customer_id
        ORDER BY loan_amount DESC
    ) AS DenseLoanRank

FROM loans;


-- 3. Top 3 highest-value loans for each customer

WITH RankedLoans AS (
    SELECT
        customer_id,
        loan_id,
        loan_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY loan_amount DESC
        ) AS RowNum
    FROM loans
)
SELECT
    customer_id,
    loan_id,
    loan_amount,
    RowNum
FROM RankedLoans
WHERE RowNum <= 3
ORDER BY customer_id, RowNum;


-- 4. Rank customers by total loan exposure

WITH CustomerLoans AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS TotalLoanAmount
    FROM loans
    GROUP BY customer_id
)
SELECT
    customer_id,
    TotalLoanAmount,

    RANK() OVER (
        ORDER BY TotalLoanAmount DESC
    ) AS LoanRank,

    DENSE_RANK() OVER (
        ORDER BY TotalLoanAmount DESC
    ) AS DenseLoanRank

FROM CustomerLoans;


-- 5. Running total of annual loan amount

WITH YearlyLoans AS (
    SELECT 
        YEAR(start_date) AS Year,
        SUM(loan_amount) AS TotalLoanAmount
    FROM loans
    GROUP BY YEAR(start_date)
)
SELECT
    Year,
    TotalLoanAmount,

    SUM(TotalLoanAmount) OVER (
        ORDER BY Year
    ) AS RunningTotalLoanAmount

FROM YearlyLoans
ORDER BY Year;


-- 6. Year-over-year loan growth using LAG()

WITH YearlyLoans AS (
    SELECT 
        YEAR(start_date) AS Year,
        SUM(loan_amount) AS TotalLoanAmount
    FROM loans
    GROUP BY YEAR(start_date)
),
PreviousYearLoan AS (
    SELECT
        Year,
        TotalLoanAmount,

        LAG(TotalLoanAmount) OVER (
            ORDER BY Year
        ) AS PreviousYearLoan

    FROM YearlyLoans
)
SELECT
    Year,
    TotalLoanAmount,
    PreviousYearLoan,

    ROUND(
        (TotalLoanAmount - PreviousYearLoan)
        / PreviousYearLoan * 100,
        2
    ) AS YoYGrowthPct

FROM PreviousYearLoan
ORDER BY Year;


-- Find the Top 5 customers with the highest total loan exposure.
-- customer_id | TotalLoanAmount | LoanRank

WITH CustomerLoans AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS TotalLoanAmount
    FROM loans
    GROUP BY customer_id
),
RankedLoans AS (
    SELECT
        customer_id,
        TotalLoanAmount,
        RANK() OVER (
            ORDER BY TotalLoanAmount DESC
        ) AS LoanRank
    FROM CustomerLoans
)
SELECT
    customer_id,
    TotalLoanAmount,
    LoanRank
FROM RankedLoans
WHERE LoanRank <= 5
ORDER BY LoanRank;