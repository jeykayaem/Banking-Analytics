use BankingAnalytics;

DROP TABLE IF EXISTS customers;

USE bankinganalytics;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(30) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    city VARCHAR(100),
    credit_score INT,
    created_at DATE
);

USE bankinganalytics;

LOAD DATA LOCAL INFILE
'C:/Workspace/bank transaction analytics/New folder/banking_dataset_kaggle/data/csv/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, email, city, credit_score, created_at);


SET GLOBAL local_infile = ON;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'secure_file_priv';
USE bankinganalytics;

USE bankinganalytics;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, email, city, credit_score, created_at);

CREATE TABLE accounts (
    account_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(30),
    account_type VARCHAR(50),
    balance_usd DECIMAL(15,2),
    open_date DATE
);
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/accounts.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(account_id, customer_id, account_type, balance_usd, open_date);
SELECT COUNT(*) AS OrphanAccounts
FROM accounts a
LEFT JOIN customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    COUNT(*) AS TotalAccounts,
    COUNT(DISTINCT customer_id) AS CustomersWithAccounts
FROM accounts;

USE bankinganalytics;

DROP TABLE IF EXISTS loans;

CREATE TABLE loans (
    loan_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(30),
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(6,3),
    start_date DATE
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loans.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loan_id, customer_id, loan_amount, interest_rate, start_date);

SELECT COUNT(*) AS OrphanLoans
FROM loans l
LEFT JOIN customers c
    ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    COUNT(*) AS TotalLoans,
    COUNT(DISTINCT customer_id) AS CustomersWithLoans,
    SUM(loan_amount) AS TotalLoanAmount,
    AVG(interest_rate) AS AvgInterestRate
FROM loans;

USE bankinganalytics;

DROP TABLE IF EXISTS cards;

CREATE TABLE cards (
    card_id VARCHAR(30) PRIMARY KEY,
    account_id VARCHAR(30),
    card_type VARCHAR(50),
    expiration_date DATE
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cards.csv'
INTO TABLE cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(card_id, account_id, card_type, expiration_date);

SELECT COUNT(*) AS OrphanCards
FROM cards c
LEFT JOIN accounts a
    ON c.account_id = a.account_id
WHERE a.account_id IS NULL;

CREATE TABLE merchants (
    merchant_id VARCHAR(30) PRIMARY KEY,
    merchant_name VARCHAR(150),
    city VARCHAR(100)
);
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/merchants.csv'
INTO TABLE merchants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(card_id, account_id, card_type, expiration_date

SELECT COUNT(*) AS TotalBranches
FROM branches;

SELECT COUNT(*) AS TotalMerchants
FROM merchants;


