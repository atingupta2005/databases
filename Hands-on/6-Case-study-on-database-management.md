# ✅ Case Study: Managing Customer Orders & Payments at ClassicModels

This case study presents an end-to-end walkthrough of database design and operations for a global scale model distributor, **ClassicModels**. We cover:

* Business background & objectives
* Requirements gathering
* Conceptual and logical modeling
* Physical implementation
* Key query patterns and reporting
* Performance optimization & maintenance
* Lessons learned and best practices

---

## 1. Business Background & Objectives

**ClassicModels** is a global distributor of collectible model vehicles. It serves thousands of customers across multiple regions and tracks orders, payments, product inventory, and customer support via a relational database.

Key goals:

* Manage customer accounts, sales reps, orders, and payments
* Ensure inventory accuracy and product categorization
* Generate fast reports for business insights
* Enable smooth order-to-cash operations with auditability

---

## 2. Requirements Gathering

### ✅ Functional Requirements

* Track customer demographics, credit limits, and assigned sales reps
* Maintain hierarchical product catalog by category (productLine)
* Record all orders, including line items, status, and delivery info
* Capture payments (check-based) and enable reconciliation
* Produce business reports:

  * Revenue per region or product line
  * Monthly order volumes
  * Credit risk (customers near or over their credit limit)

### 🔒 Non-Functional Requirements

* ACID compliance for orders and payments
* Indexed queries for real-time dashboards
* Daily incremental backups with full weekly snapshots
* Scalable schema supporting >1 million orders

---

## 3. Conceptual & Logical Modeling

### 3.1 Conceptual Entities

* **Customer**: contact and billing info
* **Order**: placed by customers
* **Order Details**: line items per order
* **Product**: items in catalog
* **Payment**: check-based transaction
* **Employee**: sales representatives
* **Office**: branch location of employees

### 3.2 Logical Diagram

```
[customers]──1──∞──[orders]──1──∞──[orderdetails]──∞──1──[products]
     │                           │
     ∞                           ∞
  [payments]                [employees]──∞──[offices]
```

---

## 4. Physical Implementation

### 4.1 Key Table Definitions

```sql
CREATE TABLE customers (
  customerNumber INT PRIMARY KEY,
  customerName VARCHAR(50),
  contactLastName VARCHAR(50),
  contactFirstName VARCHAR(50),
  phone VARCHAR(50),
  addressLine1 VARCHAR(50),
  city VARCHAR(50),
  country VARCHAR(50),
  creditLimit DECIMAL(10,2),
  salesRepEmployeeNumber INT,
  FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employees(employeeNumber)
);

CREATE TABLE orders (
  orderNumber INT PRIMARY KEY,
  orderDate DATE,
  requiredDate DATE,
  shippedDate DATE,
  status VARCHAR(15),
  comments TEXT,
  customerNumber INT,
  FOREIGN KEY (customerNumber) REFERENCES customers(customerNumber)
);

CREATE TABLE orderdetails (
  orderNumber INT,
  productCode VARCHAR(15),
  quantityOrdered INT,
  priceEach DECIMAL(10,2),
  PRIMARY KEY (orderNumber, productCode),
  FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber),
  FOREIGN KEY (productCode) REFERENCES products(productCode)
);
```

---

## 5. Key Query Patterns & Reporting

### 5.1 Total Order Value by Customer

```sql
SELECT
  c.customerName,
  SUM(od.quantityOrdered * od.priceEach) AS total_spent
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY total_spent DESC
LIMIT 10;
```

---

### 5.2 Late Shipments Summary

```sql
SELECT
  o.orderNumber,
  o.shippedDate,
  o.requiredDate,
  DATEDIFF(o.shippedDate, o.requiredDate) AS delay_days
FROM orders o
WHERE o.shippedDate > o.requiredDate
ORDER BY delay_days DESC
LIMIT 10;
```

---

### 5.3 Revenue by Product Line

```sql
SELECT
  p.productLine,
  SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY total_revenue DESC;
```

---

### 5.4 Top Customers by Payment Volume

```sql
SELECT
  c.customerName,
  SUM(p.amount) AS total_paid
FROM payments p
JOIN customers c ON p.customerNumber = c.customerNumber
GROUP BY c.customerName
ORDER BY total_paid DESC
LIMIT 10;
```

---

## 6. Performance Optimization & Maintenance

### 🔍 6.1 Index Strategy

* `orders(customerNumber)` — for customer-based filtering
* `payments(customerNumber)` — for reconciliation queries
* `products(productLine)` — for product group summaries
* Composite: `orderdetails(orderNumber, productCode)`

### ⚙ 6.2 Monitoring Tools

* Use `EXPLAIN` to verify index usage
* Enable slow query log
* Periodic review of `SHOW INDEXES FROM <table>`

### 🧹 6.3 Archival Strategy

* Archive `orders` and `orderdetails` older than 5 years
* Create materialized views for frequently accessed aggregates
* Use partitioning by `orderDate` if table size exceeds 1M rows

### 💾 6.4 Backup & Recovery

* Automate nightly backups via `mysqldump`
* Enable binary logs for point-in-time recovery
* Test restore from backup monthly

---

## 7. Lessons Learned & Best Practices

* Normalize for data integrity, denormalize only for analytics
* Avoid using NULLable FKs unless optional by design
* Use compound indexes for JOIN-heavy workloads
* Protect `creditLimit` with appropriate constraints
* Monitor storage bloat from overly wide `TEXT` or `BLOB` columns
* Regularly purge test/demo data from production environments

