# Introduction to Databases & SQL – Gyan Data

This module builds your foundation in data storage and retrieval using SQL. 

## What Is a Database

A **database** is an organized collection of structured information, or **data**, stored electronically. Relational databases store data in **tables**, each made up of **rows** (records) and **columns** (attributes).  

Benefits of using a relational database:  
- Data Integrity: Enforced by schemas, keys, and constraints  
- Scalability: Can handle millions of rows efficiently  
- Concurrency: Multiple users can read/write safely  
- SQL Standard: Powerful, declarative language for querying  

Real-world analogy: Think of a database as a library.  
- Tables are bookshelves  
- Rows are books  
- Columns are chapters in each book  

---

## SQL Basics

**SQL** (Structured Query Language) is the industry standard for interacting with relational databases.  

1. Data Definition Language (DDL)  
   - CREATE, ALTER, DROP — define and modify schemas  
2. Data Manipulation Language (DML)  
   - SELECT, INSERT, UPDATE, DELETE — read and change data  
3. Data Control Language (DCL)  
   - GRANT, REVOKE — permission management  
4. Transaction Control  
   - COMMIT, ROLLBACK — ensure safe, all-or-nothing operations  

We’ll assume a **MySQL** environment. Commands shown below can be adapted to PostgreSQL, SQL Server, or SQLite.

---

## Setting Up the Sample Table

1. Save the attached CSV as `customers.csv` in your working directory.  
2. Connect to MySQL:  
   ```bash
   mysql -u your_user -p your_database
   ```  
3. Create and load the **customers** table:

   ```sql
   -- Remove if exists
   DROP TABLE IF EXISTS customers;

   -- Define schema matching the CSV header
   CREATE TABLE customers (
     customerid              BIGINT,
     cust_consttype_id       INT,
     cust_categoryid         INT,
     profession              VARCHAR(50),
     age                     INT,
     sex                     CHAR(1),
     marital_status          CHAR(1),
     qualification           VARCHAR(20),
     no_of_dependent         INT,
     occupation              VARCHAR(50),
     position                VARCHAR(20),
     gross_income            DECIMAL(18,4),
     pre_jobyears            INT,
     nettakehomeincome       DECIMAL(18,4),
     branch_pincode          VARCHAR(6)
   );

   -- Load data from CSV
   LOAD DATA LOCAL INFILE 'customers.csv'
   INTO TABLE customers
   FIELDS TERMINATED BY ','
   OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 ROWS;
   ```

---

## Basic SQL Queries

### 1. Retrieving All Rows

Fetch every column for the first 10 customers:

```sql
SELECT *
FROM Customers
LIMIT 10;
```

### 2. Selecting Specific Columns

Show only `customerid`, `age`, and `gross_income`:

```sql
SELECT customerid,
       age,
       gross_income
FROM Customers
LIMIT 5;
```

### 3. Filtering with WHERE

Find customers older than 40:

```sql
SELECT customerid,
       age,
       nettakehomeincome
FROM Customers
WHERE age > 40
ORDER BY age;
```

### 4. Combining Conditions

Male customers under 35 with gross income above 100,000:

```sql
SELECT customerid,
       age,
       sex,
       gross_income
FROM Customers
WHERE sex = 'M'
  AND age < 35
  AND gross_income > 100000;
```

### 5. Sorting Results

List the top 5 earners by net take-home income:

```sql
SELECT customerid,
       nettakehomeincome
FROM Customers
ORDER BY nettakehomeincome DESC
LIMIT 5;
```

### 6. Column Aliasing

Rename output column headers for clarity:

```sql
SELECT customerid        AS id,
       age               AS customer_age,
       nettakehomeincome AS net_income
FROM Customers
LIMIT 5;
```

---

## Hands-On Exercises

1. List all **female** customers (`sex = 'F'`) with qualification **POSTGRAD**.  
2. Retrieve customers aged between 30 and 40 (inclusive).  
3. Show `customerid`, `profession`, and `branch_pincode` for those whose `gross_income` is `0`.  
4. Count how many customers have no dependents (`no_of_dependent = 0`).  
5. Display distinct values of `qualification` present in the dataset.  

---