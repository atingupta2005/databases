# Relational vs Non-Relational Databases

**Using ClassicModels (SQL) and a MongoDB document schema**

This guide explores the two dominant data-storage paradigms—tabular, schema-driven **relational databases** and flexible, schema-less **non-relational (NoSQL)** stores. You’ll learn their core differences, strengths, and when to choose each.

---

## 1. Overview

Relational databases organize data into **tables** with strict schemas and strong transactional guarantees.
Non-relational databases (NoSQL) store data in **document**, **key-value**, **column-family**, or **graph** formats, prioritizing **scalability** and **flexibility** over rigid structure.

---

## 2. Relational Databases

### 2.1 Key Characteristics

* Tables with **defined columns and data types**
* **Primary keys** uniquely identify rows; **foreign keys** link tables
* SQL for querying, filtering, aggregation, and updates
* **ACID** compliance ensures reliable transactions
* Scales vertically (more RAM/CPU) with limited horizontal scale

---

### 2.2 Common Examples

* MySQL
* PostgreSQL
* Microsoft SQL Server
* Oracle
* SQLite

---

### 2.3 Hands-On Example: ClassicModels in MySQL

#### 1. Table Definition: `products`

```sql
CREATE TABLE products (
  productCode        VARCHAR(15) PRIMARY KEY,
  productName        VARCHAR(70),
  productLine        VARCHAR(50),
  buyPrice           DECIMAL(10,2)
);
```

#### 2. Inserting Sample Data

```sql
INSERT INTO products (productCode, productName, productLine, buyPrice) VALUES
('S10_1678', '1969 Harley Davidson Ultimate Chopper', 'Motorcycles', 48.81),
('S10_1949', '1952 Alpine Renault 1300', 'Classic Cars', 98.58);
```

#### 3. Join Query: Orders with Product Info

```sql
SELECT o.orderNumber, p.productName, od.quantityOrdered, od.priceEach
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
LIMIT 5;
```

---

## 3. Non-Relational Databases

### 3.1 Key Characteristics

* Schema-less (or loosely enforced) data models
* Horizontal scaling via sharding or replication
* Eventual consistency or tunable consistency (BASE)
* Handles **semi-structured/unstructured** data
* Faster for insert-heavy, real-time applications

---

### 3.2 NoSQL Data Models

* **Key-Value** (e.g., Redis)
* **Document Store** (e.g., MongoDB)
* **Column Family** (e.g., Cassandra)
* **Graph** (e.g., Neo4j)

---

### 3.3 Common NoSQL Examples

* **MongoDB** (document)
* **Redis** (key-value)
* **Cassandra** (column-family)
* **Neo4j** (graph)
* **Amazon DynamoDB** (document & key-value hybrid)

---

### 3.4 Hands-On Example: MongoDB Document Model

Imagine the ClassicModels `customers`, `orders`, and `orderdetails` tables embedded into one document:

#### 1. Insert a document into `customers` collection:

```js
db.customers.insertOne({
  customerNumber: 103,
  customerName: "Atelier graphique",
  contactName: "Carine Schmitt",
  city: "Nantes",
  country: "France",
  orders: [
    {
      orderNumber: 10100,
      orderDate: "2003-01-06",
      status: "Shipped",
      orderDetails: [
        { productCode: "S18_1749", quantityOrdered: 30, priceEach: 136.00 },
        { productCode: "S18_2248", quantityOrdered: 50, priceEach: 55.09 }
      ]
    }
  ]
});
```

#### 2. Query orders by customer country:

```js
db.customers.find(
  { country: "France" },
  { customerName: 1, orders: 1 }
);
```

#### 3. Update an embedded field:

```js
db.customers.updateOne(
  { customerNumber: 103, "orders.orderNumber": 10100 },
  { $set: { "orders.$.status": "Delivered" } }
);
```

---

## 4. Feature Comparison

| Aspect            | Relational (SQL)       | Non-Relational (NoSQL)                  |
| ----------------- | ---------------------- | --------------------------------------- |
| Schema            | Fixed, strict          | Flexible, dynamic                       |
| Query Language    | SQL                    | MongoDB Query API / JSON DSL            |
| Transactions      | Full ACID              | BASE / limited transaction scope        |
| Scaling           | Vertical (scale-up)    | Horizontal (scale-out)                  |
| Data Type Support | Structured (tables)    | Semi-structured / nested                |
| Typical Use Cases | OLTP, reporting, joins | Real-time analytics, microservices, IoT |

---

## 5. Choosing Between SQL and NoSQL

| Choose SQL if...                               | Choose NoSQL if...                                |
| ---------------------------------------------- | ------------------------------------------------- |
| Data is highly structured                      | Schema changes frequently                         |
| You need strong consistency and constraints    | You prioritize speed and scale                    |
| Reporting, joins, and ACID transactions matter | You store nested, document-like data              |
| Workloads are write-light, read-heavy          | Workloads are write-heavy or globally distributed |

---

