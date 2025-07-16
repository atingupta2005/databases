# 🗄️ Introduction to Databases & SQL – Gyan Data

**Using the `ClassicModels` Sample Database**

This module builds your foundation in relational data storage and retrieval using SQL. You'll work with the `ClassicModels` sample database, which simulates a mid-sized international car model retailer.

---

## 📚 What Is a Database

A **database** is an organized collection of structured information, stored electronically. Relational databases store data in **tables**, composed of **rows** (records) and **columns** (fields/attributes).

**Benefits of relational databases:**

* ✅ Data Integrity — schemas, keys, constraints enforce correctness
* ✅ Scalability — efficiently handles millions of rows
* ✅ Concurrency — multiple users can read/write safely
* ✅ Declarative Queries — SQL makes data easy to extract

### 🎓 Real-World Analogy

Think of a database as a **library**:

* **Tables** are bookshelves
* **Rows** are books
* **Columns** are chapters or topics in each book

---

## 🛠️ SQL Basics

**SQL** (Structured Query Language) is the standard for interacting with relational databases.

| SQL Component | Keywords                               | Description                        |
| ------------- | -------------------------------------- | ---------------------------------- |
| DDL           | `CREATE`, `ALTER`, `DROP`              | Define and modify table structures |
| DML           | `SELECT`, `INSERT`, `UPDATE`, `DELETE` | Retrieve or change data            |
| DCL           | `GRANT`, `REVOKE`                      | Control user permissions           |
| TCL           | `COMMIT`, `ROLLBACK`                   | Manage multi-step transactions     |

We’ll use a **MySQL** environment with the `ClassicModels` schema.

---

## 🧰 Setting Up the Sample Database

### Step 1: Download SQL File

Download from:
[https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/)

### Step 2: Import into MySQL

```bash
mysql -u your_user -p < mysqlsampledatabase.sql
```

### Step 3: Verify

```sql
USE classicmodels;
SHOW TABLES;
```

---

## 🧱 Table Structure: `customers`


| Column Name              | Data Type     | Description                        |
| ------------------------ | ------------- | ---------------------------------- |
| `customerNumber`         | INT (PK)      | Unique ID for customer             |
| `customerName`           | VARCHAR(50)   | Name of the customer               |
| `contactLastName`        | VARCHAR(50)   | Last name of contact               |
| `contactFirstName`       | VARCHAR(50)   | First name of contact              |
| `phone`                  | VARCHAR(50)   | Contact phone                      |
| `addressLine1/2`         | VARCHAR(50)   | Street address                     |
| `city`                   | VARCHAR(50)   | City                               |
| `state`                  | VARCHAR(50)   | State                              |
| `postalCode`             | VARCHAR(15)   | ZIP or postal code                 |
| `country`                | VARCHAR(50)   | Country                            |
| `salesRepEmployeeNumber` | INT (FK)      | Employee assigned to this customer |
| `creditLimit`            | DECIMAL(10,2) | Credit limit for purchasing        |

---

## 🧪 Basic SQL Queries

### 1. View All Customer Records

```sql
SELECT *
FROM customers
LIMIT 10;
```

---

### 2. View Selected Columns

```sql
SELECT customerNumber, customerName, country
FROM customers
LIMIT 5;
```

---

### 3. Filter Rows Using `WHERE`

```sql
SELECT customerName, city, country
FROM customers
WHERE country = 'France';
```

---

### 4. Combine Multiple Conditions

```sql
SELECT customerName, state, creditLimit
FROM customers
WHERE country = 'USA'
  AND state = 'CA';
```

---

### 5. Sort Results

```sql
SELECT customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 5;
```

---

### 6. Use Column Aliases

```sql
SELECT customerNumber AS id,
       customerName   AS name,
       creditLimit    AS max_credit
FROM customers
LIMIT 5;
```

---

## 💻 Hands-On Exercises

Try solving these queries using the `customers` table.

---

### 🔍 Exercise 1

**List all customers in Germany.**

```sql
SELECT customerNumber,
       customerName,
       city
FROM customers
WHERE country = 'Germany';
```

---

### 💳 Exercise 2

**Find customers with a credit limit between 50,000 and 100,000.**

```sql
SELECT customerName,
       creditLimit
FROM customers
WHERE creditLimit BETWEEN 50000 AND 100000;
```

---

### ☎️ Exercise 3

**Get the contact name and phone number for all customers in Paris.**

```sql
SELECT contactFirstName,
       contactLastName,
       phone
FROM customers
WHERE city = 'Paris';
```

---

### 📊 Exercise 4

**Count the number of customers in the USA.**

```sql
SELECT COUNT(*) AS total_customers
FROM customers
WHERE country = 'USA';
```

---

### 🌍 Exercise 5

**List all distinct countries in the dataset.**

```sql
SELECT DISTINCT country
FROM customers
ORDER BY country;
```

