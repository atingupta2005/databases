# NoSQL Databases & MongoDB Basics

**With E-Commerce Data Model Inspired by ClassicModels**

This guide introduces you to the world of non-relational databases, focusing on **MongoDB**—a document-oriented NoSQL store. All examples below are fully runnable and based on a classic e-commerce schema.

---

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
        orderDate: ISODate("2023-07-01"),
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

## 1. Introduction to NoSQL Databases

(No changes — content still valid and comprehensive.)

---

## 2. MongoDB Basics

(No changes — intro and concepts remain the same.)

---

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

## 4. Further Exercises – With Data and Solutions

---

### 🧪 Exercise 1: Query Posts with >2 Comments

```js
db.posts.find(
  { $expr: { $gt: [ { $size: "$comments" }, 2 ] } }
);
```

---

### 🧪 Exercise 2: Indexing + explain()

```js
db.customers.createIndex({ customerName: 1, country: 1 });

db.customers.find(
  { customerName: "Signal Gift Stores", country: "USA" }
).explain("executionStats");
```

---

### 🧪 Exercise 3: Aggregation – Avg Roles per User

```js
db.users.aggregate([
  {
    $project: {
      name: 1,
      roleCount: { $size: "$roles" }
    }
  },
  {
    $group: {
      _id: null,
      avgRoleCount: { $avg: "$roleCount" }
    }
  }
]);
```

---

### 🧪 Exercise 4: Multi-Doc Transaction – Stock & Order

```js
const session = db.getMongo().startSession();
session.startTransaction();

try {
  const productsColl = session.getDatabase("classicmodels").products;
  const ordersColl = session.getDatabase("classicmodels").orders;

  // Decrease stock
  productsColl.updateOne(
    { productCode: "S10_1678" },
    { $inc: { stock: -1 } },
    { session }
  );

  // Insert order
  ordersColl.insertOne({
    orderNumber: 10110,
    customerNumber: 104,
    items: [{ productCode: "S10_1678", quantity: 1 }],
    orderDate: new Date()
  }, { session });

  session.commitTransaction();
} catch (e) {
  session.abortTransaction();
}
session.endSession();
```
