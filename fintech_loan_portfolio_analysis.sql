
-- =====================================================
-- PROJECT: Kenyan Fintech Lending & Credit Risk Analysis
-- AUTHOR: Juliet Opuche
-- DATABASE: fintech_db
-- TOOL: MySQL 8.0
-- DESCRIPTION: Analyse loan performance, defaults,
-- repayments and borrower credit risk using SQL.


CREATE SCHEMA fintech_db; 

USE fintech_db;
-- to confirm the database exixts

SHOW DATABASES;

-- Select our Kenyan fintech database
USE fintech_db;

-- Create the loans table
CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    amount_paid DECIMAL(12,2) DEFAULT 0.00,
    outstanding_balance DECIMAL(12,2) NOT NULL,
    credit_score INT,
    loan_term_months INT NOT NULL,

    CHECK (loan_amount > 0),
    CHECK (amount_paid >= 0),
    CHECK (outstanding_balance >= 0),
    CHECK (status IN ('Repaid', 'Active', 'Defaulted'))
);


-- =====================================================
-- SECTION 2: INSERT SAMPLE LOAN DATA
-- =====================================================

USE fintech_db;

INSERT INTO loans (
    loan_id,
    customer_id,
    loan_amount,
    status,
    loan_date,
    due_date,
    amount_paid,
    outstanding_balance,
    credit_score,
    loan_term_months
)
VALUES
(101, 1001, 15000, 'Repaid',    '2026-01-05', '2026-04-05', 15000, 0,     720, 3),
(102, 1002, 25000, 'Defaulted', '2026-01-10', '2026-04-10',  5000, 20000, 480, 3),
(103, 1003, 10000, 'Active',    '2026-08-01', '2026-11-01',  3000, 7000, 650, 3),
(104, 1001, 30000, 'Repaid',    '2026-02-01', '2026-05-01', 30000, 0,     740, 3),
(105, 1004, 20000, 'Defaulted', '2026-02-15', '2026-05-15',     0, 20000, 450, 3),
(106, 1005, 12000, 'Repaid',    '2026-03-01', '2026-06-01', 12000, 0,     690, 3),
(107, 1006, 40000, 'Active',    '2026-09-01', '2026-12-01', 10000, 30000, 680, 3),
(108, 1002, 18000, 'Defaulted', '2026-03-10', '2026-06-10',  2000, 16000, 490, 3),
(109, 1007,  8000, 'Repaid',    '2026-04-01', '2026-07-01',  8000, 0,     710, 3),
(110, 1008, 22000, 'Active',    '2026-09-15', '2026-12-15',  5000, 17000, 620, 3),
(111, 1009, 50000, 'Defaulted', '2026-01-20', '2026-04-20', 10000, 40000, 430, 3),
(112, 1010, 14000, 'Repaid',    '2026-05-01', '2026-08-01', 14000, 0,     700, 3),
(113, 1003, 16000, 'Active',    '2026-09-20', '2026-12-20',  4000, 12000, 660, 3),
(114, 1011, 28000, 'Defaulted', '2026-02-05', '2026-05-05',  8000, 20000, 510, 3),
(115, 1012,  9000, 'Repaid',    '2026-06-01', '2026-09-01',  9000, 0,     730, 3),
(116, 1005, 35000, 'Active',    '2026-09-25', '2026-12-25',  7000, 28000, 670, 3),
(117, 1013, 18000, 'Defaulted', '2026-03-15', '2026-06-15',  3000, 15000, 470, 3),
(118, 1014, 11000, 'Repaid',    '2026-07-01', '2026-10-01', 11000, 0,     705, 3),
(119, 1015, 45000, 'Active',    '2026-10-01', '2027-01-01',  5000, 40000, 640, 3),
(120, 1016, 24000, 'Repaid',    '2026-07-15', '2026-10-15', 24000, 0,     715, 3);



-- Check the number of loans
SELECT COUNT(*) AS total_loans 
FROM loans;

-- Preview the records
SELECT *
FROM loans
ORDER BY loan_id;

-- calculate basic lending metrics using SQL Aggregations
-- Total number of loans ,total_amount_lent,average loan amount,total_outstanding_balance
SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_amount_lent,
    AVG(loan_amount) AS average_loan_amount,
    SUM(outstanding_balance) AS total_outstanding_balance
FROM loans;

-- Count loans by status
-- This groups the portfolio into Repaid, Active and Defaulted loans.


SELECT
    status,
    COUNT(*) AS number_of_loans,
    SUM(loan_amount) AS total_loan_amount,
    SUM(outstanding_balance) AS outstanding_balance
FROM loans
GROUP BY status
ORDER BY number_of_loans DESC;

-- Calculate the default rate
--  i will define the loan-count default rate as the number of defaulted loans divided by the total number of loans

SELECT
    COUNT(*) AS total_loans,
    SUM(CASE
        WHEN status = 'Defaulted' THEN 1
        ELSE 0
    END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'Defaulted' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM loans;
-- The CASE expression counts only loans whose status is Defaulted. ROUND(..., 2) formats the rate to two decimal places.

-- Calculate the value-weighted default rate
-- proportion of the original amount lent  associated with defaulted loans.

SELECT
    SUM(loan_amount) AS total_amount_lent,
    SUM(CASE
        WHEN status = 'Defaulted' THEN loan_amount
        ELSE 0
    END) AS amount_in_default,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'Defaulted' THEN loan_amount
            ELSE 0
        END) / SUM(loan_amount),
        2
    ) AS value_weighted_default_rate_pct
FROM loans;
-- percentage default rate
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE
        WHEN status = 'defaulted' THEN 1
        ELSE 0
    END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'defaulted' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS default_rate_percentage
FROM loans;

-- Loan repayment performance by status
SELECT
    status,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS percentage_of_loans
FROM loans
GROUP BY status
ORDER BY total_loans DESC;
-- GROUP BY — summarising loan records by status.
-- COUNT() — measuring the number of loans in each category.
-- Subqueries — calculating percentages against the total portfolio.

-- Calculate the total loan amount issued
-- how much money has been disbursed to borrowers
SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_amount_issued,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    MIN(loan_amount) AS smallest_loan,
    MAX(loan_amount) AS largest_loan
FROM loans;

-- Identify high-risk customers
SELECT
    customer_id,
    COUNT(*) AS defaulted_loans
FROM loans
WHERE status = 'defaulted'
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY defaulted_loans DESC;

-- WHERE filters for defaulted loans.
-- GROUP BY customer_id groups records by customer.
-- ORDER BY ranks customers from the most defaults to the fewest.
-- HAVING COUNT(*) > 1 returns customers with more than one defaulted loan.

-- Calculate the default rate for each customer
-- What percentage of each customer's loans have defaulted?
SELECT
    customer_id,
    COUNT(*) AS total_loans,
    SUM(CASE
        WHEN status = 'defaulted' THEN 1
        ELSE 0
    END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'defaulted' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS customer_default_rate
FROM loans
GROUP BY customer_id
ORDER BY customer_default_rate DESC;

-- Analyse default rates by loan amount
-- Are larger loans associated with more defaults?
-- investigate whether loan size is related to repayment risk.
SELECT
    CASE
        WHEN loan_amount < 10000 THEN 'Small Loan'
        WHEN loan_amount <= 30000 THEN 'Medium Loan'
        ELSE 'Large Loan'
    END AS loan_category,
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN status = 'defaulted' THEN 1
            ELSE 0
        END
    ) AS defaulted_loans,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN status = 'defaulted' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS default_rate_percentage
FROM loans
GROUP BY loan_category
ORDER BY default_rate_percentage DESC;

-- Outstanding loan portfolio
-- How much money is still tied up in loans that have not been repaid?
SELECT
    status,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_amount,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
WHERE status IN ('Active', 'Defaulted')
GROUP BY status
ORDER BY total_loan_amount DESC;

-- Active: Shows loans that are currently active.
-- Defaulted: Shows loans that have defaulted.
-- Repaid: Excluded because these loans have been repaid.
-- SUM(loan_amount): Calculates the original loan amounts for each status.
-- AVG(loan_amount): Calculates the average original loan amount for each status.

-- Rank customers by their total borrowed amount
-- Which customers have borrowed the largest total amounts?
WITH customer_borrowing AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS total_borrowed,
        COUNT(*) AS total_loans
    FROM loans
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_borrowed,
    total_loans,
    RANK() OVER (
        ORDER BY total_borrowed DESC
    ) AS borrowing_rank
FROM customer_borrowing
ORDER BY borrowing_rank;
-- WITH customer_borrowing AS (...) creates a temporary named result called a CTE.
-- SUM(loan_amount) calculates each customer's total original loan amount.
-- COUNT(*) counts the customer's loans.
-- RANK() OVER (...) ranks customers by total borrowing, with rank 1 assigned to the highest total.
-- ORDER BY borrowing_rank displays the results in rank order.

-- Rank customers by loan defaults
-- Which customers have the highest number of defaulted loans?
WITH customer_defaults AS (
    SELECT
        customer_id,
        COUNT(*) AS defaulted_loans
    FROM loans
    WHERE status = 'Defaulted'
    GROUP BY customer_id
)
SELECT
    customer_id,
    defaulted_loans,
    RANK() OVER (
        ORDER BY defaulted_loans DESC
    ) AS default_rank
FROM customer_defaults
ORDER BY default_rank;
-- WITH customer_defaults AS (...) creates a CTE containing customers with defaulted loans.
-- WHERE status = 'Defaulted' filters for defaulted loans using your actual status value.
-- COUNT(*) counts defaults for each customer.
-- RANK() ranks customers by their number of defaults, with rank 1 assigned to the highest count.


-- Which customers account for the largest share of the total amount lent?
-- What percentage of total lending does each customer account for?
WITH customer_borrowing AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS total_borrowed
    FROM loans
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_borrowed,
    ROUND(
        100.0 * total_borrowed /
        SUM(total_borrowed) OVER (),
        2
    ) AS portfolio_percentage
FROM customer_borrowing
ORDER BY portfolio_percentage DESC;
-- WITH customer_borrowing AS (...) calculates each customer's total original borrowing.
-- SUM(total_borrowed) OVER () calculates the combined borrowing across all customers without colapsing the rows
-- The calculation divides each customer's borrowing by the overall total and multiplies by 100.
-- ORDER BY portfolio_percentage DESC displays customers contributing the largest shares first.


-- Analyse loan performance by customer
-- calculate the repayment performance of each customer, showing the number of repaid, defaulted, and active loans in separate columns.

SELECT
    customer_id,
    COUNT(*) AS total_loans,
    SUM(CASE
        WHEN status = 'Repaid' THEN 1
        ELSE 0
    END) AS repaid_loans,
    SUM(CASE
        WHEN status = 'Defaulted' THEN 1
        ELSE 0
    END) AS defaulted_loans,
    SUM(CASE
        WHEN status = 'Active' THEN 1
        ELSE 0
    END) AS active_loans
FROM loans
GROUP BY customer_id
ORDER BY defaulted_loans DESC, total_loans DESC;


-- Calculate the loan repayment rate
-- What percentage of all recorded loans have been repaid successfully?
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE
        WHEN status = 'Repaid' THEN 1
        ELSE 0
    END) AS repaid_loans,
    ROUND(
        100.0 * SUM(CASE
            WHEN status = 'Repaid' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS repayment_rate_percentage,
    SUM(CASE
        WHEN status = 'Defaulted' THEN 1
        ELSE 0
    END) AS defaulted_loans,
    SUM(CASE
        WHEN status = 'Active' THEN 1
        ELSE 0
    END) AS active_loans
FROM loans;

-- Repayment rate: Percentage of all recorded loans marked as repaid.
-- Defaulted loans: Number of loans marked as defaulted.
-- Active loans: Number of loans that have not yet reached a final status in your dataset.


-- Compare each customer's borrowing with the previous customer
-- How does each customer's total borrowing compare with the customer ranked immediately above them?
-- I will use LAG() to retrieve the previous customer's borrowing total.


WITH customer_borrowing AS (
    SELECT
        customer_id,
        SUM(loan_amount) AS total_borrowed
    FROM loans
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_borrowed,
        LAG(total_borrowed) OVER (
            ORDER BY total_borrowed DESC
        ) AS previous_customer_borrowing
    FROM customer_borrowing
)
SELECT
    customer_id,
    total_borrowed,
    previous_customer_borrowing,
    total_borrowed - previous_customer_borrowing
        AS borrowing_difference
FROM ranked_customers
ORDER BY total_borrowed DESC;
-- LAG() retrieves the borrowing total from the previous row.
-- previous_customer_borrowing shows the total for the customer immediately above in the sorted results.
-- borrowing_difference shows the difference between the current customer's total and that previous customer's total.
-- The first customer will have NULL for the previous borrowing amount because there is no row before it.

























