# Banking Data Analysis

## Python + PostgreSQL SQL + Tableau Public

An end-to-end banking analytics project that analyzes a synthetic
relational banking dataset using **Python/Pandas** and
**PostgreSQL/SQL**, with the results presented through interactive
**Tableau Public dashboards**.

The project intentionally uses both Python and SQL for analysis. Python
provides flexibility for exploration, transformation, aggregation, and
validation, while SQL demonstrates the ability to solve business
questions directly on a relational database. Using both approaches also
provides a practical way to cross-check analytical results.

------------------------------------------------------------------------

## Project Overview

This project analyzes banking operations across customers, branches,
employees, accounts, loans, loan repayments, cards, card transactions,
account transactions, and customer support.

The dataset contains approximately **5.9 million records across 10
cleaned tables**, including 2 million account-level transactions and 3
million card transactions.

### Business Objectives

-   Analyze customer demographics, income, and credit profiles
-   Measure branch deposits, customers, loans, and transaction activity
-   Understand account balances and transaction behavior
-   Analyze loan portfolios, defaults, repayment behavior, and customer
    exposure
-   Measure card spending and fraud exposure
-   Analyze transaction channels and transaction types
-   Evaluate customer-support volume, resolution, and satisfaction
-   Convert analytical findings into business-focused dashboard insights

------------------------------------------------------------------------

## Dataset

  -----------------------------------------------------------------------------
  Table                                              Rows Description
  -------------------------- ---------------------------- ---------------------
  `branches_cleaned.csv`                              150 Branch information

  `employee_cleaned.csv`                            1,800 Employee and branch
                                                          information

  `customers_cleaned.csv`                          60,000 Customer
                                                          demographics, income,
                                                          and credit profile

  `accounts_cleaned.csv`                           95,000 Customer accounts and
                                                          balances

  `loan_cleaned.csv`                               22,000 Loan portfolio and
                                                          loan status

  `loan_pay_cleaned.csv`                          600,000 Loan repayment
                                                          history

  `card_cleaned.csv`                               65,000 Debit/credit card
                                                          information

  `card_trans_cleaned.csv`                      3,000,000 Card transactions and
                                                          fraud indicators

  `tranc_cleaned.csv`                           2,000,000 Account-level
                                                          transactions

  `sup_tic_cleaned.csv`                            25,000 Customer support
                                                          tickets
  -----------------------------------------------------------------------------

### Relationships

``` text
branches
   ├── employees
   ├── accounts
   └── loans

customers
   ├── accounts
   ├── loans
   ├── cards
   └── support tickets

accounts
   ├── transactions
   └── cards

loans
   └── loan payments

cards
   └── card transactions
```

------------------------------------------------------------------------

## Technology Stack

### Python / Pandas

Used for: - Exploratory data analysis - Grouping and aggregation - Data
transformation - Business analysis - Validation - Customer and risk
analysis

### PostgreSQL / SQL

Used for: - Relational data analysis - Joins - Aggregations -
Filtering - Subqueries - `CASE` expressions - `HAVING` - Window
functions - Business-question analysis

### Tableau Public

Used for: - KPI reporting - Interactive dashboards - Trend analysis -
Comparative analysis - Risk and fraud monitoring - Business storytelling

------------------------------------------------------------------------

## Analytical Approach

``` text
Cleaned CSV Data
       ↓
Python / Pandas Analysis
       ↓
PostgreSQL Database
       ↓
SQL Business Analysis
       ↓
Cross-check & Validate Results
       ↓
Tableau Public Dashboards
       ↓
Business Insights
```

### Why both Python and SQL?

The same business objective can often be solved in multiple ways.

**Python/Pandas**

``` python
loan.groupby("loan_type")["loan_amount"].sum()
```

**SQL**

``` sql
SELECT
    loan_type,
    SUM(loan_amount) AS total_loan_amount
FROM loan_cleaned
GROUP BY loan_type
ORDER BY total_loan_amount DESC;
```

Using both approaches demonstrates the ability to:

-   Analyze data programmatically with Python
-   Work directly with relational databases using SQL
-   Translate business questions into different analytical approaches
-   Cross-check analytical results
-   Choose the appropriate tool for the task

------------------------------------------------------------------------

## Python Analysis

The Jupyter Notebook supports transaction-level and broader banking
analysis.

### Customer Analysis

-   Customer count
-   Income by occupation
-   Credit-score analysis
-   Customer segmentation
-   High-income / low-credit customers

### Branch Analysis

-   Deposit base
-   Customer count
-   Loan activity
-   Transaction activity
-   Employee distribution

### Account Analysis

-   Account types
-   Account balances
-   Multiple-account customers
-   High-balance customers

### Loan Analysis

-   Loan portfolio by type
-   Average loan amount
-   Loan status
-   Default rates
-   Late-payment analysis
-   Paid vs outstanding principal
-   Customer loan exposure

### Transaction Analysis

-   Transaction types
-   Transaction channels
-   Monthly transaction volume
-   Transaction value

------------------------------------------------------------------------

## SQL Analysis

The PostgreSQL analysis is organized into seven business-focused SQL
files:

``` text
KPI_ANALYSIS.sql
customers analysis.sql
branch Performance.sql
Account & Deposit Analysis.sql
Loan & Credit Risk.sql
Card & Fraud Analysis.sql
Customer Supports.sql
```

### KPI Analysis

-   Total customers
-   Total branches
-   Total loans
-   Loan portfolio
-   Card transactions
-   Support tickets
-   Average credit score

### Customer Analysis

-   Average income by occupation
-   Credit score by occupation
-   Credit-score bands
-   High-income / low-credit customers
-   Geographic concentration
-   State-level income analysis

### Branch Performance

-   Deposit base by branch
-   Customers served
-   Loans issued
-   Transaction volume
-   Employee count
-   High-deposit / low-loan branches

### Account & Deposit Analysis

-   Account-type distribution
-   Total and average balances
-   Branch deposits
-   Multiple-account customers
-   High-value customers
-   High-deposit branches

### Loan & Credit Risk

-   Loan portfolio distribution
-   Average loan size
-   Loan status
-   Default rate by loan type
-   Branch default rate
-   Repeat late payers
-   Late-payment rate by loan type
-   Paid vs outstanding principal
-   Combined customer-risk indicators

### Card & Fraud Analysis

-   Card-type distribution
-   Credit-limit analysis
-   Merchant-category spending
-   Transaction analysis
-   Unusual activity
-   High-value transactions
-   High-volume customers/accounts

### Customer Support

-   Ticket volume by issue type
-   Satisfaction analysis
-   Resolution time
-   Resolution vs satisfaction
-   Customer-segment support analysis

------------------------------------------------------------------------

## Tableau Public Dashboards

The project contains **7 dashboards**.

### 1. PRIMEBANK \| Executive Banking Overview

High-level management view covering: - Total Customers - Total
Deposits - Loans Issued - Cards in Circulation - Loan portfolio by
type - Loan status - Top branches by deposits - Average income by
occupation

### 2. PRIMEBANK \| CUSTOMER 360

**Customer Base & Credit Profile**

Includes: - Customer base - Average annual income - Average credit
score - Gender distribution - State distribution - Customer acquisition
trend - Income vs credit score

### 3. PRIMEBANK \| BRANCH PERFORMANCE

**Branch Network & Operational Performance**

Includes: - Total branches - Deposit base - Customers served - Loans
issued - Top branches by deposits - Deposit base by state - Customers vs
loans - Branch performance leaderboard

### 4. PRIMEBANK \| MONEY MOVEMENT

**Account Health & Transaction Intelligence**

Includes: - Total accounts - Active accounts - Average account balance -
Total transactions - Monthly transaction activity - Transaction volume
by channel - Transaction mix - Account health - Money movement by
transaction type

### 5. PRIMEBANK \| LOAN COMMAND CENTER

**Portfolio Health • Credit Exposure • Repayment Performance**

Includes: - Loans issued - Loan portfolio - Average loan size - Default
rate - Monthly loan portfolio trend - Loan portfolio by type - Loan
status mix - Loan value by status - Default rate by loan type

### 6. PRIMEBANK \| FRAUD COMMAND CENTER

**Card Intelligence • Fraud Detection • Merchant Risk**

Key KPIs: - Total Cards - Total Card Spend - Fraud Rate - Average Card
Spending

Includes: - Fraud activity trend - Merchant risk analysis - Fraud vs
normal card spending - Card-type fraud exposure - Fraud hotspots

### 7. PRIMEBANK \| RISK COMMAND CENTER

**Credit Risk • Default • Customer Exposure**

Includes: - Support ticket volume - Open/resolved ticket monitoring -
Average satisfaction - Monthly ticket trend - Issue-type analysis -
Support performance - Ticket status mix

------------------------------------------------------------------------

## Data Quality & Validation

The cleaned datasets were checked for:

-   Missing values
-   Duplicate records
-   Data types
-   Key fields
-   Relationships between tables
-   Aggregation consistency

Using Python and SQL as two analytical paths allows important results to
be cross-checked rather than relying on a single calculation
environment.

For multi-table analysis, aggregations must be handled carefully to
avoid **join fan-out**, where one-to-many relationships can
unintentionally multiply records and inflate totals.

------------------------------------------------------------------------

## Project Structure

``` text
Banking-Data-Analysis/
│
├── data/
│   ├── accounts_cleaned.csv
│   ├── branches_cleaned.csv
│   ├── card_cleaned.csv
│   ├── card_trans_cleaned.csv
│   ├── customers_cleaned.csv
│   ├── employee_cleaned.csv
│   ├── loan_cleaned.csv
│   ├── loan_pay_cleaned.csv
│   ├── sup_tic_cleaned.csv
│   └── tranc_cleaned.csv
│
├── sql/
│   ├── KPI_ANALYSIS.sql
│   ├── customers analysis.sql
│   ├── branch Performance.sql
│   ├── Account & Deposit Analysis.sql
│   ├── Loan & Credit Risk.sql
│   ├── Card & Fraud Analysis.sql
│   └── Customer Supports.sql
│
├── python/
│   └── banking.ipynb
│
├── dashboard/
│   └── Tableau Public dashboards
│
├── report/
│   └── Project Report.pdf
│
└── README.md
```

------------------------------------------------------------------------

## How to Run

### 1. Python

Install the required packages:

``` bash
pip install pandas jupyter
```

Open the notebook:

``` bash
jupyter notebook
```

Then open:

``` text
banking.ipynb
```

### 2. PostgreSQL

Create a PostgreSQL database and load the cleaned CSV files into tables
using these exact table names:

``` text
accounts_cleaned
branches_cleaned
card_cleaned
card_trans_cleaned
customers_cleaned
employee_cleaned
loan_cleaned
loan_pay_cleaned
sup_tic_cleaned
tranc_cleaned
```

Run the SQL files using pgAdmin, DBeaver, or another PostgreSQL client.

### 3. Tableau Public

Connect Tableau to the PostgreSQL data or prepared analytical outputs
and build the dashboard views described above.

------------------------------------------------------------------------

## Project Scope

This is a **descriptive and diagnostic analytics project**.

It focuses on: - Bank-wide KPIs - Customer analysis - Branch
performance - Account and transaction analysis - Loan and credit-risk
analysis - Card and fraud analysis - Customer support analysis

It does **not** implement predictive credit-scoring, machine-learning
risk models, or statistical forecasting.

------------------------------------------------------------------------

## Skills Demonstrated

### Data Analysis

-   Data cleaning
-   Exploratory analysis
-   Aggregation
-   Segmentation
-   KPI development
-   Business-question analysis

### Python

-   Pandas
-   GroupBy
-   Aggregation
-   Merge
-   Filtering
-   Data transformation

### SQL

-   SELECT
-   WHERE
-   GROUP BY
-   HAVING
-   ORDER BY
-   JOINs
-   Subqueries
-   CASE expressions
-   Aggregations
-   Window functions

### Database

-   Relational schema understanding
-   Primary and foreign keys
-   Multi-table analysis
-   Query-performance awareness

### Tableau

-   Dashboard design
-   KPI cards
-   Filters
-   Trend charts
-   Comparative analysis
-   Risk and fraud visualization
-   Business storytelling

### Business Analytics

-   Customer segmentation
-   Branch performance
-   Credit risk
-   Fraud monitoring
-   Operational analysis
-   Customer-support analysis

------------------------------------------------------------------------

## Author

**Vaibhav Singh**

**Project:** Banking Data Analysis\
**Stack:** Python / Pandas • PostgreSQL / SQL • Tableau Public

------------------------------------------------------------------------

## Final Takeaway

This project demonstrates an end-to-end analytics workflow:

> **Data → Python Analysis → SQL Analysis → Validation → Tableau
> Dashboard → Business Insights**

The key strength of the project is the use of **both Python and SQL to
analyze the banking data**, followed by Tableau dashboards that turn the
analysis into a business-friendly reporting experience.
