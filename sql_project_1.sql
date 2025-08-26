-- SQL Project 1: Advanced Queries on a Hypothetical Financial Dataset

-- This script demonstrates advanced SQL queries using a hypothetical financial dataset.
-- We will assume the following tables exist in a database:
-- 1. `Transactions` table: Stores individual financial transactions.
--    - `transaction_id` (INT, PRIMARY KEY)
--    - `account_id` (INT)
--    - `transaction_date` (DATE)
--    - `amount` (DECIMAL)
--    - `transaction_type` (VARCHAR)
--    - `category` (VARCHAR)
-- 2. `Accounts` table: Stores account information.
--    - `account_id` (INT, PRIMARY KEY)
--    - `customer_id` (INT)
--    - `account_type` (VARCHAR)
--    - `balance` (DECIMAL)
-- 3. `Customers` table: Stores customer information.
--    - `customer_id` (INT, PRIMARY KEY)
--    - `first_name` (VARCHAR)
--    - `last_name` (VARCHAR)
--    - `email` (VARCHAR)
--    - `registration_date` (DATE)


-- 1. Common Table Expression (CTE) to find the top 5 customers by total transaction amount
WITH CustomerTotalTransactions AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(t.amount) AS total_transaction_amount
    FROM
        Customers c
    JOIN
        Accounts a ON c.customer_id = a.customer_id
    JOIN
        Transactions t ON a.account_id = t.account_id
    GROUP BY
        c.customer_id, c.first_name, c.last_name
)
SELECT
    ctt.first_name,
    ctt.last_name,
    ctt.total_transaction_amount
FROM
    CustomerTotalTransactions ctt
ORDER BY
    ctt.total_transaction_amount DESC
LIMIT 5;


-- 2. Window Function to calculate a running total of transactions for each account
SELECT
    transaction_id,
    account_id,
    transaction_date,
    amount,
    SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS running_balance
FROM
    Transactions
ORDER BY
    account_id, transaction_date;


-- 3. Subquery to find accounts with no transactions in the last 6 months
SELECT
    a.account_id,
    a.account_type,
    a.balance
FROM
    Accounts a
WHERE
    a.account_id NOT IN (
        SELECT DISTINCT
            t.account_id
        FROM
            Transactions t
        WHERE
            t.transaction_date >= DATE("now", "-6 months")
    );


-- 4. Using CASE statement for conditional aggregation (e.g., total income vs. total expense)
SELECT
    account_id,
    SUM(CASE WHEN transaction_type = "Deposit" THEN amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN transaction_type = "Withdrawal" THEN amount ELSE 0 END) AS total_withdrawals,
    SUM(CASE WHEN transaction_type = "Deposit" THEN amount ELSE -amount END) AS net_change
FROM
    Transactions
GROUP BY
    account_id;


-- 5. Joining multiple tables and filtering with HAVING clause
SELECT
    c.first_name,
    c.last_name,
    a.account_type,
    COUNT(t.transaction_id) AS number_of_transactions,
    AVG(t.amount) AS average_transaction_amount
FROM
    Customers c
JOIN
    Accounts a ON c.customer_id = a.customer_id
JOIN
    Transactions t ON a.account_id = t.account_id
WHERE
    t.transaction_date BETWEEN "2024-01-01" AND "2024-12-31"
GROUP BY
    c.first_name, c.last_name, a.account_type
HAVING
    COUNT(t.transaction_id) > 10
ORDER BY
    number_of_transactions DESC;


-- 6. Recursive CTE (Example: Hierarchical data, e.g., organizational structure or transaction chains)
-- This is a more complex example and would require a specific dataset structure.
-- For a financial context, it could be used to trace a chain of related transactions.
-- Let's assume a table `TransactionFlow` with `from_transaction_id` and `to_transaction_id`

-- Example: Find all transactions related to a specific initial transaction (e.g., a large deposit)
-- WITH RECURSIVE TransactionChain AS (
--     SELECT
--         tf.from_transaction_id,
--         tf.to_transaction_id,
--         1 AS level
--     FROM
--         TransactionFlow tf
--     WHERE
--         tf.from_transaction_id = [initial_transaction_id]
--
--     UNION ALL
--
--     SELECT
--         tf.from_transaction_id,
--         tf.to_transaction_id,
--         tc.level + 1
--     FROM
--         TransactionFlow tf
--     JOIN
--         TransactionChain tc ON tf.from_transaction_id = tc.to_transaction_id
-- )
-- SELECT DISTINCT from_transaction_id, to_transaction_id FROM TransactionChain;


-- 7. Using analytical functions for ranking (e.g., rank customers by balance within each account type)
SELECT
    account_id,
    customer_id,
    balance,
    account_type,
    RANK() OVER (PARTITION BY account_type ORDER BY balance DESC) as rank_within_type
FROM
    Accounts
ORDER BY
    account_type, rank_within_type;


-- 8. Pivot-like aggregation using conditional SUM and GROUP BY
-- (e.g., total transaction amount by category for each account)
SELECT
    account_id,
    SUM(CASE WHEN category = "Food" THEN amount ELSE 0 END) AS total_food_expenses,
    SUM(CASE WHEN category = "Travel" THEN amount ELSE 0 END) AS total_travel_expenses,
    SUM(CASE WHEN category = "Utilities" THEN amount ELSE 0 END) AS total_utilities_expenses
FROM
    Transactions
GROUP BY
    account_id;


-- 9. Correlated Subquery (Example: Find customers whose average transaction amount is higher than the overall average)
SELECT
    c.first_name,
    c.last_name,
    AVG(t.amount) AS customer_avg_transaction
FROM
    Customers c
JOIN
    Accounts a ON c.customer_id = a.customer_id
JOIN
    Transactions t ON a.account_id = t.account_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
HAVING
    AVG(t.amount) > (SELECT AVG(amount) FROM Transactions);


-- 10. Using EXISTS for checking existence (e.g., customers who have made transactions in all categories)
-- This query is more complex and requires a predefined list of all categories.
-- For demonstration, let's simplify to customers who have made at least one transaction in 'Food' and 'Travel' categories.
SELECT
    c.first_name,
    c.last_name
FROM
    Customers c
WHERE
    EXISTS (
        SELECT 1
        FROM Accounts a
        JOIN Transactions t ON a.account_id = t.account_id
        WHERE a.customer_id = c.customer_id AND t.category = "Food"
    )
    AND EXISTS (
        SELECT 1
        FROM Accounts a
        JOIN Transactions t ON a.account_id = t.account_id
        WHERE a.customer_id = c.customer_id AND t.category = "Travel"
    );


-- Note: To run these queries, you would need to set up a database (e.g., SQLite, PostgreSQL, MySQL)
-- and populate it with sample data for the `Customers`, `Accounts`, and `Transactions` tables.
-- The specific syntax might vary slightly depending on the SQL database system you are using.


