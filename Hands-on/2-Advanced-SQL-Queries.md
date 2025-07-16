# Advanced SQL Queries – Gyan Data

**Using the ClassicModels Sample Database**

In this hands-on module, you’ll master:

* Data Retrieval & Joins
* Aggregation & Grouping
* Subqueries & Common Table Expressions (CTEs)

---

## 1. Data Retrieval & Joins

Joins let you combine related rows from different tables using foreign keys.

---

### 1.1 INNER JOIN

**Show each customer with their total number of orders and total ordered value.**

```sql
SELECT
  c.customerNumber,
  c.customerName,
  COUNT(o.orderNumber)         AS order_count,
  SUM(od.quantityOrdered * od.priceEach) AS total_value
FROM customers AS c
INNER JOIN orders AS o
  ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails AS od
  ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber;
```

---

### 1.2 LEFT JOIN

**List all customers and the number of orders they've placed (including those with zero).**

```sql
SELECT
  c.customerNumber,
  c.customerName,
  COUNT(o.orderNumber) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
  ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber
ORDER BY order_count DESC
LIMIT 10;
```

---

## 2. Aggregation & Grouping

Summarize rows into metrics using aggregate functions.

---

### 2.1 Basic Aggregates

```sql
-- Total number of customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Total amount paid by all customers
SELECT SUM(amount) AS total_payments FROM payments;
```

---

### 2.2 GROUP BY

**Total ordered amount by each customer.**

```sql
SELECT 
  c.customerName,
  SUM(od.quantityOrdered * od.priceEach) AS total_spent
FROM customers AS c
JOIN orders AS o ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber
ORDER BY total_spent DESC
LIMIT 10;
```

---

### 2.3 HAVING

**List customers who spent more than 100,000.**

```sql
SELECT 
  c.customerName,
  SUM(od.quantityOrdered * od.priceEach) AS total_spent
FROM customers AS c
JOIN orders AS o ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber
HAVING total_spent > 100000;
```

---

## 3. Subqueries & CTEs

Use subqueries and common table expressions to simplify complex logic.

---

### 3.1 Subqueries

#### 3.1.1 Scalar Subquery

**Customers whose credit limit is above the average credit limit.**

```sql
SELECT customerName, creditLimit
FROM customers
WHERE creditLimit > (
  SELECT AVG(creditLimit)
  FROM customers
);
```

---

#### 3.1.2 IN Subquery

**Customers who have made at least one payment.**

```sql
SELECT customerName
FROM customers
WHERE customerNumber IN (
  SELECT DISTINCT customerNumber
  FROM payments
);
```

---

### 3.2 Common Table Expressions (CTEs)

**List orders where the total value is above average order value.**

```sql
WITH order_totals AS (
  SELECT 
    o.orderNumber,
    SUM(od.quantityOrdered * od.priceEach) AS total_amount
  FROM orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  GROUP BY o.orderNumber
)
SELECT *
FROM order_totals
WHERE total_amount > (
  SELECT AVG(total_amount) FROM order_totals
);
```

---

