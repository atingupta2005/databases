# 4. Database Transactions & Optimization

**Using the ClassicModels Sample Database**

This module covers core techniques to make your data operations both **correct** and **fast**. We’ll explore:

* Database Transactions & ACID Properties
* Indexes & Performance Optimization
* Normalization vs. Denormalization

---

## 4.1 Database Transactions & ACID Properties

A **transaction** is a unit of work that must succeed or fail as a whole. Transactions guarantee the **ACID** properties:

* **Atomicity**: All statements succeed or none do
* **Consistency**: Data moves from one valid state to another
* **Isolation**: Concurrent transactions don’t interfere
* **Durability**: Committed changes survive crashes

---

### 🧪 Hands-On Examples (Using `customers` and `payments`)

#### 1. Transfer Payment Credits Between Customers

```sql
START TRANSACTION;

-- Deduct 1000 from Customer 103
UPDATE customers
SET creditLimit = creditLimit - 1000
WHERE customerNumber = 103;

-- Add 1000 to Customer 114
UPDATE customers
SET creditLimit = creditLimit + 1000
WHERE customerNumber = 114;

COMMIT;
```

#### 2. Rolling Back on Validation Failure

```sql
START TRANSACTION;

UPDATE customers
SET creditLimit = creditLimit - 500
WHERE customerNumber = 103;

-- Validate that creditLimit is not negative
SELECT creditLimit FROM customers
WHERE customerNumber = 103;

-- If creditLimit < 0, ROLLBACK
-- Simulate manually here
ROLLBACK;
-- Otherwise:
-- COMMIT;
```

#### 3. Demonstrating Isolation Levels

```sql
-- Session A
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT creditLimit FROM customers WHERE customerNumber = 103;

-- Session B (another connection)
UPDATE customers
SET creditLimit = creditLimit + 500
WHERE customerNumber = 103;
COMMIT;

-- Session A again: rerun SELECT to see isolation behavior
```

---

## 4.2 Indexes & Performance Optimization

Indexes allow MySQL to **efficiently locate rows** rather than scanning entire tables.

### ✅ Why Use Indexes?

* Speeds up `WHERE`, `JOIN`, and `ORDER BY` operations
* Helps optimize filtering and grouping
* Adds overhead for `INSERT`, `UPDATE`, `DELETE`

---

### 🧪 Creating Indexes

#### 1. Single-Column Index on `country`

```sql
CREATE INDEX idx_customers_country
ON customers(country);
```

#### 2. Composite Index on `status` and `orderDate` in `orders`

```sql
CREATE INDEX idx_orders_status_date
ON orders(status, orderDate);
```

---

### 🔍 Comparing Performance

#### Without Index

```sql
EXPLAIN SELECT * 
FROM customers
WHERE country = 'USA';
```

#### After Creating Index

```sql
EXPLAIN SELECT * 
FROM customers
WHERE country = 'USA';
```

> Look for `type: ref` and `key: idx_customers_country` in the result.

---

### 📦 Covering Index Example

Create an index that covers both `country` and `creditLimit`:

```sql
CREATE INDEX idx_customers_country_credit
ON customers(country, creditLimit);
```

Now this query may be covered by the index:

```sql
SELECT creditLimit
FROM customers
WHERE country = 'USA';
```

---

### 🛠 Index Maintenance Tips

* Avoid indexing low-cardinality columns (e.g., boolean fields)
* Run `ANALYZE TABLE` and `OPTIMIZE TABLE` periodically
* Drop unused indexes to reduce write overhead

---

## 4.3 Normalization vs. Denormalization

---

### ✅ Normalization

**Goal**: Eliminate redundancy and ensure integrity
**Process**: Break large tables into smaller ones based on dependencies

---

#### 🧱 Example: Normalize `customers` by extracting `salesRepEmployeeNumber`

```sql
-- Create salesRep table
CREATE TABLE sales_reps (
  employeeNumber INT PRIMARY KEY,
  repName VARCHAR(100)
);

-- Populate from employees
INSERT INTO sales_reps
SELECT employeeNumber, CONCAT(firstName, ' ', lastName)
FROM employees;

-- Link to customers
ALTER TABLE customers
ADD FOREIGN KEY (salesRepEmployeeNumber) REFERENCES sales_reps(employeeNumber);
```

> This removes duplication of sales rep names across multiple customers.

---

### 🔁 Denormalization

**Goal**: Improve read performance by flattening or duplicating data
**Tradeoff**: May introduce update anomalies and larger storage usage

---

#### 🧾 Example: Create a denormalized customer-order snapshot

```sql
CREATE TABLE customer_order_summary AS
SELECT
  c.customerNumber,
  c.customerName,
  o.orderNumber,
  o.status,
  SUM(od.quantityOrdered * od.priceEach) AS order_total
FROM customers AS c
JOIN orders AS o ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber;
```
