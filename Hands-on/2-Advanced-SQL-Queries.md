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

### 1.3 FULL OUTER JOIN (Emulated via UNION)

**Show customers or orders where a match is missing on the other side.**

```sql
-- Orders with no matching customer (unlikely but possible in bad data)
SELECT o.orderNumber, o.customerNumber, NULL AS customerName
FROM orders AS o
LEFT JOIN customers AS c ON o.customerNumber = c.customerNumber
WHERE c.customerNumber IS NULL

UNION

-- Customers with no orders
SELECT NULL AS orderNumber, c.customerNumber, c.customerName
FROM customers AS c
LEFT JOIN orders AS o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;
```

---

### 1.4 CROSS JOIN

**List every customer name with every product line (Cartesian product).**

```sql
SELECT c.customerName, p.productLine
FROM customers AS c
CROSS JOIN productlines AS p
LIMIT 20;
```

---

### 1.5 SELF JOIN

**Find pairs of employees who report to the same manager.**

```sql
SELECT 
  e1.firstName AS emp1,
  e2.firstName AS emp2,
  e1.reportsTo AS manager_id
FROM employees AS e1
JOIN employees AS e2
  ON e1.reportsTo = e2.reportsTo
WHERE e1.employeeNumber < e2.employeeNumber;
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

### 2.4 Multi-Column Grouping

**Show number of orders by status and country.**

```sql
SELECT 
  o.status,
  c.country,
  COUNT(*) AS order_count
FROM orders AS o
JOIN customers AS c ON o.customerNumber = c.customerNumber
GROUP BY o.status, c.country
ORDER BY order_count DESC
LIMIT 10;
```

---

### 2.5 ROLLUP

**Total payments by country and customer (with subtotals).**

```sql
SELECT 
  c.country,
  c.customerName,
  SUM(p.amount) AS total_paid
FROM payments AS p
JOIN customers AS c ON p.customerNumber = c.customerNumber
GROUP BY c.country, c.customerName WITH ROLLUP;
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

#### 3.1.3 Correlated Subquery

**List customers with their rank by credit limit within their country.**

```sql
SELECT c1.customerName,
       c1.country,
       c1.creditLimit,
       (
         SELECT COUNT(*) + 1
         FROM customers c2
         WHERE c2.country = c1.country
           AND c2.creditLimit > c1.creditLimit
       ) AS credit_rank
FROM customers c1
ORDER BY country, credit_rank;
```

---

### 3.2 Common Table Expressions (CTEs)

#### 3.2.1 Single CTE

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

#### 3.2.2 Multiple CTEs

**Customers with total payments above the global average.**

```sql
WITH customer_payments AS (
  SELECT customerNumber, SUM(amount) AS total_paid
  FROM payments
  GROUP BY customerNumber
),
avg_payments AS (
  SELECT AVG(total_paid) AS avg_paid
  FROM customer_payments
)
SELECT cp.customerNumber,
       cp.total_paid,
       ap.avg_paid
FROM customer_payments cp, avg_payments ap
WHERE cp.total_paid > ap.avg_paid;
```

---

## 🧠 Hands-On Exercises

1. **INNER JOIN**: List customers who have placed orders and total value they’ve ordered.
2. **LEFT JOIN + HAVING**: Find customers who never ordered.
3. **GROUP BY**: Show average order value per customer.
4. **ROLLUP**: Count orders grouped by `status` and `customerNumber`, including subtotals.
5. **Scalar Subquery**: Find orders whose total value is above average.
6. **Correlated Subquery**: List products along with how many others are priced higher.


Here are the **solutions** to all 6 hands-on exercises, based on the `ClassicModels` database. These use only valid fields and relationships from the schema.

---

## ✅ Exercise Solutions (ClassicModels)

---

### **1. INNER JOIN**

**List customers who have placed orders and total value they’ve ordered.**

```sql
SELECT 
  c.customerNumber,
  c.customerName,
  SUM(od.quantityOrdered * od.priceEach) AS total_order_value
FROM customers AS c
JOIN orders AS o ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName;
```

---

### **2. LEFT JOIN + HAVING**

**Find customers who never ordered.**

```sql
SELECT 
  c.customerNumber,
  c.customerName,
  COUNT(o.orderNumber) AS order_count
FROM customers AS c
LEFT JOIN orders AS o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
HAVING order_count = 0;
```

---

### **3. GROUP BY**

**Show average order value per customer.**

```sql
SELECT 
  c.customerNumber,
  c.customerName,
  ROUND(AVG(od.quantityOrdered * od.priceEach), 2) AS avg_order_value
FROM customers AS c
JOIN orders AS o ON c.customerNumber = o.customerNumber
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName;
```

---

### **4. ROLLUP**

**Count orders grouped by `status` and `customerNumber`, including subtotals.**

```sql
SELECT 
  o.status,
  o.customerNumber,
  COUNT(*) AS order_count
FROM orders AS o
GROUP BY o.status, o.customerNumber WITH ROLLUP;
```

---

### **5. Scalar Subquery**

**Find orders whose total value is above the average order value.**

```sql
SELECT 
  o.orderNumber,
  SUM(od.quantityOrdered * od.priceEach) AS order_total
FROM orders AS o
JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber
HAVING order_total > (
  SELECT AVG(total_value)
  FROM (
    SELECT 
      orderNumber,
      SUM(quantityOrdered * priceEach) AS total_value
    FROM orderdetails
    GROUP BY orderNumber
  ) AS order_summaries
);
```

---

### **6. Correlated Subquery**

**List products along with how many other products are priced higher.**

```sql
SELECT 
  p1.productCode,
  p1.productName,
  p1.buyPrice,
  (
    SELECT COUNT(*)
    FROM products AS p2
    WHERE p2.buyPrice > p1.buyPrice
  ) AS higher_priced_count
FROM products AS p1
ORDER BY higher_priced_count DESC;
```
