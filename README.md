#  Advanced Queries on a Hypothetical Financial Dataset

## Project Overview
This project showcases a variety of advanced SQL query techniques that are essential for complex data retrieval and analysis in a relational database environment. The queries are designed for a hypothetical financial dataset, demonstrating how to extract meaningful insights from transactional and customer data.

## Hypothetical Database Schema
This project assumes the existence of the following tables:

1.  **`Customers` table:** Stores customer details.
    -   `customer_id` (INT, PRIMARY KEY)
    -   `first_name` (VARCHAR)
    -   `last_name` (VARCHAR)
    -   `email` (VARCHAR)
    -   `registration_date` (DATE)

2.  **`Accounts` table:** Stores financial account information.
    -   `account_id` (INT, PRIMARY KEY)
    -   `customer_id` (INT, FOREIGN KEY to `Customers`)
    -   `account_type` (VARCHAR) - e.g., 'Savings', 'Checking', 'Investment'
    -   `balance` (DECIMAL)

3.  **`Transactions` table:** Stores individual financial transactions.
    -   `transaction_id` (INT, PRIMARY KEY)
    -   `account_id` (INT, FOREIGN KEY to `Accounts`)
    -   `transaction_date` (DATE)
    -   `amount` (DECIMAL)
    -   `transaction_type` (VARCHAR) - e.g., 'Deposit', 'Withdrawal', 'Transfer'
    -   `category` (VARCHAR) - e.g., 'Food', 'Travel', 'Utilities', 'Salary'

## Key SQL Concepts Demonstrated
-   **Common Table Expressions (CTEs):** Used for breaking down complex queries into logical, readable steps.
-   **Window Functions:** Applied for calculations across a set of table rows that are related to the current row (e.g., `SUM() OVER (PARTITION BY ... ORDER BY ...)` for running totals, `RANK()` for ranking within groups).
-   **Subqueries:** Employed for filtering data based on the result of another query.
-   **Conditional Aggregation (CASE statements):** Used within aggregate functions to perform different calculations based on conditions (e.g., separating deposits and withdrawals).
-   **JOINs:** Combining data from multiple tables (`INNER JOIN`).
-   **HAVING Clause:** Filtering grouped results based on aggregate conditions.
-   **Correlated Subqueries:** Subqueries that depend on the outer query for their execution.
-   **EXISTS Operator:** Used to test for the existence of rows in a subquery.
-   **Recursive CTEs (Conceptual):** Briefly touched upon for hierarchical data traversal, though not fully implemented without a specific hierarchical dataset.

## Files in this Project
-   `sql_project_1.sql`: The SQL script containing all the advanced queries with detailed comments explaining each section.

## How to Use This Project
1.  **Database Setup:** To execute these queries, you will need a relational database system (e.g., SQLite, PostgreSQL, MySQL, SQL Server, Oracle).
2.  **Schema Creation:** Create the `Customers`, `Accounts`, and `Transactions` tables in your chosen database, adhering to the schema described above.
3.  **Populate with Sample Data:** Insert sample data into these tables. The queries are designed to work with realistic financial transaction data.
4.  **Execute Queries:** Run the queries from `sql_project_1.sql` in your database client or through a programming language that connects to your database.

## Learning Outcomes
By studying and executing these queries, you will gain a deeper understanding of:
-   Writing efficient and complex SQL queries.
-   Leveraging advanced SQL features for data analysis.
-   Solving real-world data problems using SQL.
-   Structuring SQL code for readability and maintainability.

## Note on Database Specifics
While the queries are written in standard SQL, minor syntax adjustments might be necessary depending on the specific SQL dialect of your database system (e.g., date functions like `DATE("now", "-6 months")` might vary).


