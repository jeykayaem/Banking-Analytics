-- =========================================================
-- 05_CARD_ANALYSIS
-- Banking Data Analytics Project
-- =========================================================


-- 1. Card distribution by card type
-- How many cards does the bank have for each card type?

SELECT
    card_type,
    COUNT(card_id) AS NumberOfCards
FROM cards
GROUP BY card_type
ORDER BY NumberOfCards DESC;


-- 2. Cards per account
-- How many cards does each account have?

SELECT
    account_id,
    COUNT(card_id) AS NumberOfCards
FROM cards
GROUP BY account_id
ORDER BY NumberOfCards DESC;


-- 3. Accounts with multiple cards
-- Which accounts have more than one card?

SELECT
    account_id,
    COUNT(card_id) AS NumberOfCards
FROM cards
GROUP BY account_id
HAVING COUNT(card_id) > 1
ORDER BY NumberOfCards DESC;


-- 4. Number of accounts with multiple cards

SELECT
    COUNT(*) AS AccountsWithMultipleCards
FROM (
    SELECT
        account_id
    FROM cards
    GROUP BY account_id
    HAVING COUNT(card_id) > 1
) AS MultipleCards;


-- 5. Cards per customer
-- How many cards does each customer hold across all accounts?

SELECT
    a.customer_id,
    COUNT(DISTINCT a.account_id) AS NumberOfAccounts,
    COUNT(c.card_id) AS NumberOfCards
FROM accounts a
INNER JOIN cards c
    ON c.account_id = a.account_id
GROUP BY a.customer_id
ORDER BY NumberOfCards DESC;


-- 6. Customers with more than 5 cards

SELECT
    COUNT(*) AS CustomersWithMoreThan5Cards
FROM (
    SELECT
        a.customer_id
    FROM accounts a
    INNER JOIN cards c
        ON c.account_id = a.account_id
    GROUP BY a.customer_id
    HAVING COUNT(c.card_id) > 5
) AS HighCardCustomers;


-- 7. Credit vs Debit card ownership
-- How many unique customers hold each card type?

SELECT
    c.card_type,
    COUNT(DISTINCT a.customer_id) AS UniqueCustomers,
    COUNT(c.card_id) AS NumberOfCards
FROM accounts a
INNER JOIN cards c
    ON c.account_id = a.account_id
GROUP BY c.card_type
ORDER BY NumberOfCards DESC;


-- 8. Customers who hold both Credit and Debit cards

SELECT
    COUNT(*) AS CustomersWithBothCardTypes
FROM (
    SELECT
        a.customer_id
    FROM accounts a
    INNER JOIN cards c
        ON c.account_id = a.account_id
    GROUP BY a.customer_id
    HAVING COUNT(DISTINCT c.card_type) = 2
) AS BothCreditDebit;