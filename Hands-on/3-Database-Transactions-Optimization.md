# 4. Database Transactions & Optimization

This module covers core techniques to make your data operations both **correct** and **fast**. We’ll explore:

- Database Transactions & ACID Properties  
- Indexes & Performance Optimization  
- Normalization vs. Denormalization  

---

## 4.1 Database Transactions & ACID Properties

A **transaction** is a unit of work that must succeed or fail as a whole. Transactions guarantee the ACID properties:

- **Atomicity**: All statements succeed or none do.  
- **Consistency**: Data moves from one valid state to another.  
- **Isolation**: Concurrent transactions do not interfere.  
- **Durability**: Committed changes survive crashes.

### Hands-On Examples

1.  Simple money-transfer example (using a hypothetical `balances` table):

    ```sql
    -- Start a transaction
    START TRANSACTION;

    -- Deduct 1000 from Customer A
    UPDATE balances
    SET balance = balance - 1000
    WHERE customerid = 12001001;

    -- Simulate error: negative balance?
    -- UPDATE balances SET balance = balance - 999999 WHERE customerid = 12001001;

    -- Add 1000 to Customer B
    UPDATE balances
    SET balance = balance + 1000
    WHERE customerid = 12001002;

    -- Commit all changes together
    COMMIT;
    ```

2.  Rolling back on error:

    ```sql
    START TRANSACTION;

    UPDATE balances
    SET balance = balance - 500
    WHERE customerid = 12001003;

    -- Some validation failure
    SELECT IF(balance < 0, ROLLBACK, 'OK')
    FROM balances
    WHERE customerid = 12001003;

    -- If no errors
    COMMIT;
    ```

3.  Demonstrating isolation levels:

    ```sql
    -- Session A
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
    SELECT nettakehomeincome FROM customers WHERE customerid = 12001018;

    -- Session B
    UPDATE customers SET nettakehomeincome = nettakehomeincome + 1000
    WHERE customerid = 12001018;
    COMMIT;

    -- Back in Session A: re‐run the SELECT to see if it changes mid-transaction.
    ```

---

## 4.2 Indexes & Performance Optimization

Indexes let the database locate rows without scanning the entire table.  

### Why Index?

- Speeds up `WHERE` filters and `JOIN` conditions  
- Supports efficient sorting (`ORDER BY`) and grouping (`GROUP BY`)  
- But: indexes add overhead on writes and consume storage

### Creating Indexes

1.  Single-column index on branch pincode:

    ```sql
    CREATE INDEX idx_customers_pincode
    ON customers(branch_pincode);
    ```

2.  Composite index on ticket type and status:

    ```sql
    CREATE INDEX idx_rf_type_status
    ON rf_final_data(type, status);
    ```

### Comparing Performance

1.  Without index:

    ```sql
    EXPLAIN SELECT *
    FROM customers
    WHERE branch_pincode = '400070';
    ```

2.  After creating `idx_customers_pincode`:

    ```sql
    EXPLAIN SELECT *
    FROM customers
    WHERE branch_pincode = '400070';
    ```

    Notice `type: ref` and use of `key: idx_customers_pincode` in the query plan.

### Covering Index

If a query only needs indexed columns, the database can return results **from the index itself**:

```sql
CREATE INDEX idx_customers_pincode_income
ON customers(branch_pincode, nettakehomeincome);
```

Now:

```sql
SELECT nettakehomeincome
FROM customers
WHERE branch_pincode = '400070';
```

can be served directly from the index.

### Index Maintenance Tips

- Avoid indexing very low-cardinality columns (e.g., `sex`).  
- Periodically `ANALYZE TABLE` and `OPTIMIZE TABLE` to refresh statistics.  
- Drop unused indexes to speed up `INSERT/UPDATE/DELETE`.

---

## 4.3 Normalization vs. Denormalization

### Normalization

Organizing tables to eliminate redundancy and ensure data integrity.

- **1NF**: Atomic values (no repeated groups).  
- **2NF**: No partial dependencies on a composite key.  
- **3NF**: No transitive dependencies—non-key columns depend only on the primary key.

#### Example: Extracting Branch Info

Current `customers` table repeats `branch_pincode`. Normalize by creating a `branches` table:

```sql
-- New table
CREATE TABLE branches (
  branch_pincode CHAR(6) PRIMARY KEY,
  city           VARCHAR(30),
  region         VARCHAR(20)
);

-- Populate (example)
INSERT INTO branches VALUES
('400070','Mumbai','West'),
('110001','New Delhi','North');

-- Drop city from customers and link via foreign key
ALTER TABLE customers
DROP COLUMN branch_pincode,
ADD COLUMN branch_pincode CHAR(6),
ADD FOREIGN KEY (branch_pincode) REFERENCES branches(branch_pincode);
```

### Denormalization

Combining tables or duplicating data to speed reads at the cost of storage and write complexity.

#### Example: Customer + Loan Snapshot

```sql
CREATE TABLE customer_loan_snapshot AS
SELECT
  c.customerid,
  c.qualification,
  l.agreementid,
  l.outstanding_principal
FROM customers AS c
JOIN lms       AS l USING (customerid);
```

This wide table lets you retrieve customer plus loan info in one read—ideal for dashboards or high-read workloads.

---

**Key Takeaways**

- Wrap related statements in `BEGIN/COMMIT` to enforce ACID.  
- Use `EXPLAIN` to verify index usage; design single- and composite indexes for your most common filters and joins.  
- Normalize to enforce integrity, denormalize selectively to optimize read performance.