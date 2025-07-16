# Case Study: Managing Customer Loans & Support at Acme Finance

This case study walks through end-to-end database management for a mid-sized home-finance company, **Acme Finance**, using three core tables—**customers**, **lms** (loan management), and **rf_final_data** (support tickets). We’ll cover:

- Business background & objectives  
- Requirements gathering  
- Conceptual and logical modeling  
- Physical implementation  
- Key query patterns and reporting  
- Performance optimization & maintenance  
- Lessons learned and best practices  

---

## 1. Business Background & Objectives

Acme Finance offers home loans to retail customers and maintains a support desk for customer inquiries. Key goals:

- Store accurate customer profiles, loan portfolios, and ticket histories  
- Enable fast lookups for servicing, compliance, and dashboards  
- Enforce data integrity across customer, loan, and ticket processes  
- Scale to tens of millions of records with high performance  

---

## 2. Requirements Gathering

**Functional Requirements**  
- Capture customer demographics, income details, and branch information  
- Track each loan’s terms, disbursements, EMIs, and outstanding balances  
- Log support tickets with categories (SOA, foreclosure, certificates), statuses, and timestamps  
- Provide operational reports and dashboards:
  - Outstanding principal by branch  
  - Ticket volume and average resolution time by category  
  - Loan delinquency metrics  

**Non-Functional Requirements**  
- ACID transactions for balance adjustments and status updates  
- Sub-second lookups on primary keys and frequently queried fields  
- Daily backups with point-in-time recovery  
- Ongoing monitoring of slow queries and automated index tuning  

---

## 3. Conceptual & Logical Modeling

### 3.1 Conceptual Entities

- **Customer**: demographics, qualification, net income, branch  
- **Loan (LMS)**: agreement terms, disbursed amount, EMI schedule, balances  
- **Support Ticket**: request type, status, created date  

### 3.2 Logical Schema

```
[customers]───1───∞───[lms]
      │
      1
      │
      ∞
[rf_final_data]
```

- One **customer** can have many **loans**  
- One **customer** can raise many **tickets**  

---

## 4. Physical Implementation

### 4.1 Table Definitions

```sql
CREATE TABLE customers (
  customerid        INT PRIMARY KEY,
  age               INT,
  sex               CHAR(1),
  qualification     VARCHAR(20),
  gross_income      DECIMAL(18,4),
  nettakehomeincome DECIMAL(18,4),
  branch_pincode    CHAR(6),
  INDEX idx_branch  (branch_pincode)
);

CREATE TABLE lms (
  agreementid           INT PRIMARY KEY,
  customerid            INT,
  net_disbursed_amt     DECIMAL(18,2),
  outstanding_principal DECIMAL(18,2),
  emi_dueamt            DECIMAL(18,2),
  emi_received_amt      DECIMAL(18,2),
  current_roi           DECIMAL(5,2),
  FOREIGN KEY (customerid) REFERENCES customers(customerid),
  INDEX idx_lms_cust     (customerid)
);

CREATE TABLE rf_final_data (
  ticketid           INT PRIMARY KEY,
  masked_customerid  INT,
  type               VARCHAR(20),
  status             VARCHAR(20),
  date               DATETIME,
  FOREIGN KEY (masked_customerid) REFERENCES customers(customerid),
  INDEX idx_ticket_cust (masked_customerid)
);
```

### 4.2 Loading Sample Data

```sql
LOAD DATA LOCAL INFILE 'Customers_31JAN2019 - Short.csv' INTO TABLE customers …
LOAD DATA LOCAL INFILE 'LMS_31JAN2019 - Short.csv'       INTO TABLE lms …
LOAD DATA LOCAL INFILE 'RF_Final_Data - Short.csv'        INTO TABLE rf_final_data …
```

---

## 5. Key Query Patterns & Reporting

### 5.1 Total Outstanding by Branch

```sql
SELECT
  c.branch_pincode,
  FORMAT(SUM(l.outstanding_principal),2) AS total_outstanding
FROM customers c
JOIN lms       l ON c.customerid = l.customerid
GROUP BY c.branch_pincode;
```

### 5.2 Ticket Volume & Avg Age by Type

```sql
SELECT
  type,
  COUNT(*)                          AS ticket_count,
  ROUND(AVG(TIMESTAMPDIFF(HOUR, date, NOW())),1) AS avg_age_hours
FROM rf_final_data
WHERE status = 'Close'
GROUP BY type;
```

### 5.3 Delinquency Rate (>30 DPD)

```sql
SELECT
  ROUND(
    SUM(CASE WHEN dpd > 30 THEN 1 ELSE 0 END) 
    / COUNT(*) * 100, 2
  ) AS delinquency_pct
FROM lms;
```

---

## 6. Performance Optimization & Maintenance

### 6.1 Index Strategy

- `customers(branch_pincode)` for branch-level reports  
- `lms(customerid)` for quick loan lookups  
- `rf_final_data(masked_customerid, type, status)` for ticket dashboards  

### 6.2 Monitoring & Tuning

- Use `EXPLAIN` to inspect query plans and identify table scans  
- Enable slow-query logging and review monthly  
- Drop unused or redundant indexes to improve write speed  

### 6.3 Archiving & Partitioning

- Archive **“Close”** tickets older than one year to `tickets_archive`  
- Partition **lms** by disbursement year for time-series queries  

### 6.4 Backup & Recovery

- Nightly full backups via `mysqldump`  
- Binary logs for point-in-time recovery  
- Quarterly restore drills to validate procedures  

---

## 7. Lessons Learned & Best Practices

- **Design for scale**: choose appropriate data types and partitioning schemes  
- **Index judiciously**: focus on fields used in joins, filters, and sorts  
- **Enforce referential integrity**: foreign keys prevent orphaned records  
- **Use transactions** for multi-step operations (EMI postings, status updates)  
- **Archive cold data** to keep hot tables lean and queries fast  
- **Automate maintenance**: index rebuilds, statistics updates, schema changes  

---

This case study provides a practical blueprint for designing, implementing, and managing relational databases at scale—covering data modeling, loading, querying, optimization, and ongoing operations.