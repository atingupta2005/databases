# Advanced SQL Queries – Gyan Data

In this hands-on module, you’ll master  
- Data Retrieval & Joins  
- Aggregation & Grouping  
- Subqueries & Common Table Expressions (CTEs)  

---

## 0. Sample Table Setup

Run these once in your MySQL terminal (adjust file paths):

```sql
-- CUSTOMERS
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customerid            INT,
  cust_consttype_id     INT,
  cust_categoryid       INT,
  profession            VARCHAR(50),
  age                   INT,
  sex                   CHAR(1),
  marital_status        CHAR(1),
  qualification         VARCHAR(20),
  no_of_dependent       INT,
  occupation            VARCHAR(50),
  position              VARCHAR(20),
  gross_income          DECIMAL(18,4),
  pre_jobyears          INT,
  nettakehomeincome     DECIMAL(18,4),
  branch_pincode        VARCHAR(6)
);
LOAD DATA LOCAL INFILE 'Customers_31JAN2019 - Short.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- LMS
DROP TABLE IF EXISTS lms;
CREATE TABLE lms (
  agreementid           INT,
  customerid            INT,
  loan_amt              DECIMAL(18,2),
  net_disbursed_amt     DECIMAL(18,2),
  interest_start_date   DATE,
  current_roi           DECIMAL(5,2),
  orignal_roi           DECIMAL(5,2),
  current_tenor         INT,
  orignal_tenor         INT,
  dueday                INT,
  authorizationdate     DATE,
  city                  VARCHAR(30),
  pre_emi_dueamt        DECIMAL(18,4),
  pre_emi_received_amt  DECIMAL(18,4),
  pre_emi_os_amount     DECIMAL(18,4),
  emi_dueamt            DECIMAL(18,4),
  emi_received_amt      DECIMAL(18,4),
  emi_os_amount         DECIMAL(18,4),
  excess_available      DECIMAL(18,4),
  excess_adjusted_amt   DECIMAL(18,4),
  balance_excess        DECIMAL(18,4),
  net_receivable        DECIMAL(18,4),
  outstanding_principal DECIMAL(18,4),
  paid_principal        DECIMAL(18,4),
  paid_interest         DECIMAL(18,4),
  monthopening          DECIMAL(18,4),
  last_receipt_date     DATE,
  last_receipt_amount   DECIMAL(18,4),
  net_ltv               DECIMAL(5,2),
  completed_tenure      INT,
  balance_tenure        INT,
  dpd                   INT,
  foir                  DECIMAL(5,2),
  product               VARCHAR(10),
  schemeid              VARCHAR(10),
  npa_in_last_month     INT,
  npa_in_current_month  INT,
  mob                   INT
);
LOAD DATA LOCAL INFILE 'LMS_31JAN2019 - Short.csv'
INTO TABLE lms
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- RF_FINAL_DATA
DROP TABLE IF EXISTS rf_final_data;
CREATE TABLE rf_final_data (
  ticketid              INT,
  type                  VARCHAR(20),
  subtype               VARCHAR(50),
  status                VARCHAR(20),
  date                  DATETIME,
  preprocessed_email    TEXT,
  preprocessed_subject  TEXT,
  masked_customerid     INT,
  masked_agreementid    INT
);
LOAD DATA LOCAL INFILE 'RF_Final_Data - Short.csv'
INTO TABLE rf_final_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

---

## 1. Data Retrieval & Joins

Joins let you combine related rows from different tables.

### 1.1 INNER JOIN  
Show each customer with their loan count and total disbursed:

```sql
SELECT
  c.customerid,
  c.age,
  COUNT(l.agreementid)        AS loan_count,
  SUM(l.net_disbursed_amt)    AS total_disbursed
FROM customers AS c
INNER JOIN lms AS l
  ON c.customerid = l.customerid
GROUP BY c.customerid;
```

### 1.2 LEFT JOIN  
List all customers and any support tickets they’ve raised:

```sql
SELECT
  c.customerid,
  c.branch_pincode,
  COUNT(r.ticketid)            AS ticket_count
FROM customers AS c
LEFT JOIN rf_final_data AS r
  ON c.customerid = r.masked_customerid
GROUP BY c.customerid
ORDER BY ticket_count DESC
LIMIT 10;
```

### 1.3 FULL OUTER JOIN (via UNION)  
Show loans or tickets even if no matching customer exists:

```sql
-- Loans without a customer
SELECT l.agreementid, l.customerid, NULL AS ticketid
FROM lms AS l
LEFT JOIN customers AS c
  ON l.customerid = c.customerid
WHERE c.customerid IS NULL

UNION

-- Tickets without a customer
SELECT NULL AS agreementid, r.masked_customerid, r.ticketid
FROM rf_final_data AS r
LEFT JOIN customers AS c
  ON r.masked_customerid = c.customerid
WHERE c.customerid IS NULL;
```

### 1.4 CROSS JOIN  
Combine every city in `lms` with every qualification in `customers`:

```sql
SELECT DISTINCT
  l.city,
  c.qualification
FROM lms AS l
CROSS JOIN (
  SELECT DISTINCT qualification
  FROM customers
) AS c
ORDER BY city, qualification
LIMIT 20;
```

### 1.5 SELF JOIN  
Find customers in the same branch whose incomes differ by less than 5,000:

```sql
SELECT
  a.customerid AS cust_a,
  b.customerid AS cust_b,
  ABS(a.gross_income - b.gross_income) AS income_diff
FROM customers AS a
INNER JOIN customers AS b
  ON a.branch_pincode = b.branch_pincode
 AND a.customerid < b.customerid
WHERE ABS(a.gross_income - b.gross_income) < 5000;
```

---

## 2. Aggregation & Grouping

Summarize multiple rows into metrics per group.

### 2.1 Basic Aggregates  

```sql
-- Total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Average loan tenor
SELECT AVG(current_tenor) AS avg_tenor
FROM lms;
```

### 2.2 GROUP BY  
Sum outstanding principal by product:

```sql
SELECT
  product,
  SUM(outstanding_principal)  AS total_outstanding
FROM lms
GROUP BY product
ORDER BY total_outstanding DESC;
```

### 2.3 HAVING  
Branches with more than 50 customers:

```sql
SELECT
  branch_pincode,
  COUNT(*) AS num_customers
FROM customers
GROUP BY branch_pincode
HAVING num_customers > 50;
```

### 2.4 Multi-Column Grouping  
Tickets by type and subtype:

```sql
SELECT
  type,
  subtype,
  COUNT(*) AS ticket_count
FROM rf_final_data
GROUP BY type, subtype
ORDER BY ticket_count DESC
LIMIT 10;
```

### 2.5 ROLLUP  
Customer counts and average net income by sex, qualification, plus totals:

```sql
SELECT
  sex,
  qualification,
  COUNT(*)             AS cnt,
  ROUND(AVG(nettakehomeincome),2) AS avg_net_income
FROM customers
GROUP BY sex, qualification WITH ROLLUP;
```

---

## 3. Subqueries & CTEs

Break complex logic into reusable parts.

### 3.1 Subqueries

#### 3.1.1 Scalar Subquery  
Customers earning above average gross income:

```sql
SELECT
  customerid,
  gross_income
FROM customers
WHERE gross_income > (
  SELECT AVG(gross_income) FROM customers
);
```

#### 3.1.2 IN Subquery  
Customers who’ve opened at least one ticket:

```sql
SELECT
  customerid
FROM customers
WHERE customerid IN (
  SELECT DISTINCT masked_customerid
  FROM rf_final_data
);
```

#### 3.1.3 Correlated Subquery  
Rank customers by number of loans in their branch:

```sql
SELECT
  c.customerid,
  c.branch_pincode,
  (
    SELECT COUNT(*)
    FROM lms AS l2
    WHERE l2.customerid = c.customerid
  ) AS loans_in_branch,
  (
    SELECT COUNT(*)
    FROM customers AS c2
    WHERE c2.branch_pincode = c.branch_pincode
      AND c2.nettakehomeincome > c.nettakehomeincome
  ) + 1 AS income_rank
FROM customers AS c
ORDER BY branch_pincode, income_rank
LIMIT 10;
```

### 3.2 Common Table Expressions (CTEs)

#### 3.2.1 Single CTE  
Customers whose loan outstanding exceeds branch average:

```sql
WITH branch_avg AS (
  SELECT
    customerid,
    AVG(outstanding_principal) OVER (PARTITION BY city) AS avg_out
  FROM lms
)
SELECT
  l.customerid,
  l.outstanding_principal,
  b.avg_out
FROM lms AS l
JOIN branch_avg AS b
  ON l.customerid = b.customerid
WHERE l.outstanding_principal > b.avg_out
LIMIT 10;
```

#### 3.2.2 Multiple CTEs  
Ticket counts + join to average income:

```sql
WITH ticket_cte AS (
  SELECT
    masked_customerid AS customerid,
    COUNT(*) AS tickets
  FROM rf_final_data
  GROUP BY masked_customerid
),
income_cte AS (
  SELECT
    customerid,
    AVG(nettakehomeincome) OVER () AS avg_income
  FROM customers
)
SELECT
  t.customerid,
  t.tickets,
  i.avg_income
FROM ticket_cte AS t
JOIN income_cte AS i
  ON t.customerid = i.customerid
ORDER BY t.tickets DESC
LIMIT 10;
```

---

## Hands-On Exercises

1. **INNER JOIN**: List customers who have at least one loan and one support ticket.  
2. **LEFT JOIN + HAVING**: Find customers with no tickets but at least two loans.  
3. **GROUP BY**: Show average net disbursed amount per city.  
4. **ROLLUP**: Aggregate loan counts by `product, city`.  
5. **Scalar Subquery**: Retrieve tickets created after the average ticket date.  
6. **Correlated Subquery**: For each loan, find how many days it’s been outstanding (`DATEDIFF(CURDATE(), interest_start_date)`).  
7. **CTE Chain**:  
   - CTE1: Compute total EMI received per customer.  
   - CTE2: Flag customers whose EMI total exceeds 80% of their net take-home income.  

---
