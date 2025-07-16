# NoSQL Databases & MongoDB Basics

## ✅ 0. Initial Setup: Create DB and Populate Collections

```js
use classicmodels;

// Drop collections if they already exist (for reset)
db.customers.drop();
db.products.drop();
db.orders.drop();
db.users.drop();
db.posts.drop();
```

```js
// Create collections explicitly
db.createCollection("customers");
db.createCollection("products");
db.createCollection("orders");
db.createCollection("users");
db.createCollection("posts");
```

### ✅ Insert Customers

```js
db.customers.insertMany([
  {
    customerNumber: 103,
    customerName: "Atelier graphique",
    country: "France",
    orders: [
      {
        orderNumber: 10100,
        orderDate: new Date("2023-07-01"),
        status: "Shipped",
        items: [
          { productCode: "S18_1749", quantity: 30, priceEach: 136.00 },
          { productCode: "S18_2248", quantity: 50, priceEach: 55.09 }
        ]
      }
    ]
  },
  {
    customerNumber: 104,
    customerName: "Signal Gift Stores",
    country: "USA",
    orders: []
  }
]);
```

---

### ✅ Insert Products

```js
db.products.insertMany([
  { productCode: "S10_1678", name: "1969 Harley Davidson Ultimate Chopper", price: 48.81, stock: 100 },
  { productCode: "S10_1949", name: "1952 Alpine Renault 1300", price: 98.58, stock: 50 }
]);
```

---

### ✅ Insert Users

```js
db.users.insertMany([
  { name: "Alice", email: "alice@example.com", roles: ["admin", "user"] },
  { name: "Bob", email: "bob@example.com", roles: ["user"] },
  { name: "Carol", email: "carol@example.com", roles: [] }
]);
```

---

### ✅ Insert Posts

```js
db.posts.insertMany([
  { title: "MongoDB Tips", comments: ["Good", "Helpful"] },
  { title: "ACID vs BASE", comments: ["Nice", "Detailed", "Well-written"] },
  { title: "Sharding Explained", comments: [] }
]);
```

---

## 🗃️ 1. Introduction to NoSQL Databases

**NoSQL** (“Not Only SQL”) databases emerged to address **scalability** and **schema-flexibility** challenges faced by traditional relational systems when dealing with large volumes of semi-structured or unstructured data.

### 🔑 Key Characteristics

* **Schema-less data models**: Each record can have different structures, enabling rapid development and iteration
* **Horizontal scalability**: Data is distributed across clusters of commodity servers (scale-out) instead of upgrading a single machine (scale-up)
* **Eventual consistency (BASE)**: Trades strict ACID guarantees for high availability and partition tolerance in distributed environments

### 📦 Main NoSQL Data Models

* **Document Stores**
  *e.g., MongoDB, CouchDB*
  ➤ Store JSON/BSON documents with nested fields
  ➤ Great for catalogs, user profiles, and CMSs

* **Key-Value Stores**
  *e.g., Redis, DynamoDB*
  ➤ Simple key-to-value access
  ➤ Ideal for caching, session stores, counters

* **Wide-Column Stores**
  *e.g., Cassandra, HBase*
  ➤ Columns grouped into families
  ➤ Optimized for time-series and analytics workloads

* **Graph Databases**
  *e.g., Neo4j, Amazon Neptune*
  ➤ Store data as nodes and edges
  ➤ Ideal for relationships, social networks, fraud detection

---

## 🍃 2. MongoDB Basics

**MongoDB** is an open-source, document-oriented NoSQL database written in C++. It stores data in **BSON** (binary JSON) format and is designed for flexibility and scale.

### 🚀 Core Features

* **Flexible schema**: Documents in the same collection may have different fields
* **Rich query language**: Supports filtering, projections, aggregation pipelines, and geospatial queries
* **Indexing**: Includes single-field, compound, multikey, full-text, and geospatial indexes
* **Replication**: Uses replica sets for high availability and automatic failover
* **Sharding**: Distributes large datasets across multiple servers for horizontal scalability

---

### 🛠 Getting Started

1. **Install MongoDB** (available for Linux, Windows, macOS) or use **MongoDB Atlas** for a cloud-based solution
2. Connect via the **`mongosh`** shell, **MongoDB Compass**, or a **programming language driver**
3. Create databases and collections dynamically—no DDL required

---

### 🧾 Example MongoDB Document

In the `users` collection:

```json
{
  "_id": { "$oid": "6512f1d8c5f4a9a1b2c3d4e5" },
  "name": "Alice",
  "email": "alice@example.com",
  "roles": ["admin", "user"],
  "profile": {
    "age": 30,
    "city": "Mumbai"
  },
  "createdAt": { "$date": "2025-07-14T10:00:00Z" }
}
```


## 3. CRUD Operations in MongoDB (Now Ready-to-Run)

### ✅ 3.1 Create

```js
// Insert one new customer
db.customers.insertOne({
  customerNumber: 105,
  customerName: "Tokyo Traders",
  country: "Japan",
  orders: []
});

// Insert more products
db.products.insertMany([
  { productCode: "S12_1099", name: "Ferrari Enzo", price: 144.00, stock: 30 },
  { productCode: "S18_3232", name: "Porsche 911 Carrera", price: 75.50, stock: 20 }
]);
```

---

### ✅ 3.2 Read

```js
// Find customers in France
db.customers.find({ country: "France" }, { customerName: 1 });

// Get a product by code
db.products.findOne({ productCode: "S10_1678" });
```

---

### ✅ 3.3 Update

```js
// Add an order to customer 104
db.customers.updateOne(
  { customerNumber: 104 },
  {
    $push: {
      orders: {
        orderNumber: 10105,
        status: "In Process",
        orderDate: new Date(),
        items: [
          { productCode: "S10_1949", quantity: 2, priceEach: 98.58 }
        ]
      }
    }
  }
);

// Update a product price
db.products.updateOne(
  { productCode: "S10_1678" },
  { $set: { price: 52.00 } }
);
```

---

### ✅ 3.4 Delete

```js
// Delete one product
db.products.deleteOne({ productCode: "S10_1949" });

// Delete all customers from test regions
db.customers.deleteMany({ country: /Test/i });
```

---

