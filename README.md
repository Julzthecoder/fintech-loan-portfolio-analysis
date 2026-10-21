# Fintech Loan Portfolio & Credit Risk Analysis Using SQL

## Project Overview

This project uses MySQL to analyze a simulated fintech lending portfolio. It explores loan repayment performance, default patterns, customer borrowing behavior, and portfolio concentration.

The project is inspired by the types of business questions faced by digital lending companies. It is an independent portfolio project and is not affiliated to any company.

## Objectives

- Calculate the overall loan default rate and repayment rate.
- Analyze loan distribution by status.
- Summarize loan amounts using aggregate functions.
- Identify customers with repeated loan defaults.
- Calculate customer-level default rates.
- Rank customers by total borrowing and default history.
- Analyze customer borrowing as a percentage of the total portfolio.
- Apply advanced SQL techniques to support credit risk analysis.

## Tools and Technologies

- MySQL 8.0
- MySQL Workbench
- SQL

## SQL Skills Demonstrated

- Filtering with `WHERE`
- Aggregation using `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`
- Grouping with `GROUP BY` and filtering groups with `HAVING`
- Conditional logic using `CASE`
- Common Table Expressions (CTEs)
- Window functions, including `RANK()`, `LAG()`, and `SUM() OVER()`
- Percentage calculations and business metrics

## Business Questions

1. What percentage of recorded loans are defaulted?
2. How are loans distributed across repaid, defaulted, and active statuses?
3. What are the total and average loan amounts?
4. Which customers have multiple defaults?
5. Which customers account for the largest share of borrowing?
6. How does loan performance vary by customer?

## Key Findings

The overall default rate calculated from the sample data was 30%. Other analyses examined loan status distribution, customer borrowing patterns, repeated defaults, and repayment performance.

These findings describe the sample dataset only and should not be interpreted as actual industry-wide default rates.

## Project Files

- `fintech_loan_portfolio_analysis.sql` — SQL script containing the project setup and analysis queries.

## Disclaimer

This project uses simulated or sample data for educational and portfolio purposes. It does not represent actual borrower records or official data from any lending company.
