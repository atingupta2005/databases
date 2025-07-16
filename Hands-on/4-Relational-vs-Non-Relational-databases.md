# Relational vs Non-Relational Databases

This guide explores the two dominant data-storage paradigms—tabular, schema-driven relational databases and flexible, schema-less non-relational (NoSQL) stores. You’ll learn their core differences, strengths, and when to choose each.

---

## 1. Overview

Relational databases organize data into tables of rows and columns with a fixed schema and strong ACID guarantees. Non-relational databases (NoSQL) store data in document, key-value, column-family, or graph formats, trading some transactional strictness for horizontal scalability and flexible schemas.

---

## 2. Relational Databases

### 2.1 Key Characteristics

- Tables with well-defined columns and data types  
- Primary keys uniquely identify rows; foreign keys link tables  
- SQL for querying, reporting, and enforcing business rules  
- ACID compliance ensures atomic, consistent, isolated, durable transactions  
- Vertical scaling (bigger server) and limited horizontal scaling

### 2.2 Common Examples

- MySQL  
- PostgreSQL  
- Microsoft SQL Server  
- Oracle Database  
- SQLite

### 2.3 Hands-On Example: MySQL

1. Create a `products` table:
   ```sql
   CREATE TABLE products (
     product_id   INT PRIMARY KEY,
     name         VARCHAR(100),
     price        DECIMAL(10,2)
   );
   ```
2. Insert sample data:
   ```sql
   INSERT INTO products VALUES
     (1, 'Widget', 19.99),
     (2, 'Gadget', 29.49);
   ```
3. Query with a JOIN:
   ```sql
   -- Assume orders table exists with product_id FK
   SELECT o.order_id, p.name, p.price
   FROM orders o
   JOIN products p ON o.product_id = p.product_id;
   ```

---

## 3. Non-Relational Databases

### 3.1 Key Characteristics

- Schema-less storage: documents, key-values, wide columns, or graphs  
- Horizontal scaling across commodity servers  
- Eventual consistency models (BASE) or tunable consistency  
- Designed for large volumes of unstructured or semi-structured data  
- Flexible data models adapt to changing requirements

### 3.2 Four NoSQL Data Models

- **Key-Value Stores** (e.g., Redis): O(1) lookups by unique key  
- **Document Stores** (e.g., MongoDB): JSON/BSON documents with nested fields  
- **Column-Family Stores** (e.g., Cassandra): sparse, wide tables grouped by column families  
- **Graph Databases** (e.g., Neo4j): nodes and relationships for highly interconnected data

### 3.3 Common Examples

- MongoDB (document)  
- Redis (key-value)  
- Apache Cassandra (column-family)  
- Neo4j (graph)  
- Amazon DynamoDB (key-value/document hybrid)

### 3.4 Hands-On Example: MongoDB

1. Create a `customers` collection:
   ```js
   db.customers.insertMany([
     { _id: 12001000, name: 'Atin', city: 'Mumbai' },
     { _id: 12001001, name: 'Riya', city: 'Delhi' }
   ]);
   ```
2. Query by city:
   ```js
   db.customers.find({ city: 'Mumbai' }, { name: 1 });
   ```
3. Update a document:
   ```js
   db.customers.updateOne(
     { _id: 12001000 },
     { $set: { city: 'New Delhi' } }
   );
   ```

---

## 4. Feature Comparison

| Aspect                | Relational (SQL)               | Non-Relational (NoSQL)           |
|-----------------------|--------------------------------|----------------------------------|
| Schema                | Fixed, rigid                   | Dynamic, flexible                |
| Query Language        | SQL                            | API calls / query DSL            |
| Transactions          | ACID                           | BASE / tunable consistency       |
| Scaling               | Vertical (limited horizontal)  | Horizontal (sharding)            |
| Data Types            | Structured                      | Structured, semi/unstructured    |
| Typical Use Cases     | OLTP, reporting, complex joins | Big data, real-time, flexible     |

---

## 5. Choosing Between SQL and NoSQL

- Use **relational** when your data is highly structured, relationships and transactions matter, you need complex joins, and strong consistency.  
- Use **non-relational** when your data is large, unstructured or evolving, you require horizontal scale and flexible schemas, and can tolerate eventual consistency.

---

## 6. Exercises

1. Design a **relational** schema for an e-commerce site: `users`, `products`, `orders`.  
2. Model the same domain in **MongoDB** as collections with nested order items.  
3. Benchmark a query that filters 1 million rows by index vs. full table scan in MySQL.  
4. Shard a MongoDB collection across two replica sets and measure read/write performance.