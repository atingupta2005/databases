# NoSQL Databases & MongoDB Basics

**With E-Commerce Data Model Inspired by ClassicModels**

This guide introduces you to the world of non-relational databases, focusing on **MongoDB**—a leading document-oriented NoSQL store—and covers foundational CRUD operations using an e-commerce-style schema.

---

## 1. Introduction to NoSQL Databases

**NoSQL** (“Not Only SQL”) databases emerged to handle scalability and schema-flexibility challenges found in traditional relational systems.

### 🔑 Key Characteristics

* **Schema-less**: Records can vary in structure
* **Horizontally scalable**: Ideal for distributed systems
* **Eventual consistency**: BASE over ACID in many cases
* **Flexible formats**: JSON-like documents, key-value pairs, graphs, etc.

### 📦 NoSQL Data Models

| Type              | Description           | Examples              |
| ----------------- | --------------------- | --------------------- |
| **Document**      | JSON-like objects     | MongoDB, CouchDB      |
| **Key-Value**     | Simple keys and blobs | Redis, DynamoDB       |
| **Column-Family** | Wide, sparse tables   | Cassandra, HBase      |
| **Graph**         | Nodes and edges       | Neo4j, Amazon Neptune |

---

## 2. MongoDB Basics

MongoDB stores data in **BSON** (Binary JSON) documents and offers:

* 🧠 Flexible schemas
* 🔍 Rich querying and filtering
* ⚡ Fast indexing
* 🔄 Replication
* 🌍 Horizontal scaling via sharding

### 👨‍💻 Getting Started

1. **Install MongoDB** or use [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. **Use mongo shell or Compass GUI**
3. **Write data directly—no schema declaration required**

---

### 📄 Sample MongoDB Document: Customer with Orders

```js
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
}
```

---

## 3. CRUD Operations in MongoDB

### 3.1 Create

```js
// Insert one customer
db.customers.insertOne({
  customerNumber: 104,
  customerName: "Signal Gift Stores",
  country: "USA"
});

// Insert many products
db.products.insertMany([
  { productCode: "S10_1678", name: "Chopper", price: 48.81 },
  { productCode: "S10_1949", name: "Renault 1300", price: 98.58 }
]);
```

---

### 3.2 Read

```js
// Find customers in France
db.customers.find({ country: "France" }, { customerName: 1 });

// Get one product by code
db.products.findOne({ productCode: "S10_1678" });
```

---

### 3.3 Update

```js
// Add an order to a customer
db.customers.updateOne(
  { customerNumber: 104 },
  { $push: {
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

// Update product price
db.products.updateOne(
  { productCode: "S10_1678" },
  { $set: { price: 52.00 } }
);
```

---

### 3.4 Delete

```js
// Delete a product
db.products.deleteOne({ productCode: "S10_1949" });

// Delete customers in test region
db.customers.deleteMany({ country: /Test/i });
```

---

## 4. Further Exercises

Here are 4 advanced MongoDB exercises using your e-commerce data model:

---

### 🧪 Exercise 1: Insert and Query Blog Posts

**Insert into `posts` collection and filter based on comment count.**

✅ **Solution**:

```js
db.posts.insertMany([
  { title: "MongoDB Tips", comments: ["Good", "Helpful"] },
  { title: "ACID vs BASE", comments: ["Nice", "Detailed", "Well-written"] },
  { title: "Sharding Explained", comments: [] }
]);

db.posts.find(
  { $expr: { $gt: [ { $size: "$comments" }, 2 ] } }
);
```

---

### 🧪 Exercise 2: Indexing and `explain()`

**Create a compound index and measure performance.**

✅ **Solution**:

```js
db.customers.createIndex({ customerName: 1, country: 1 });

db.customers.find(
  { customerName: "Signal Gift Stores", country: "USA" }
).explain("executionStats");
```

---

### 🧪 Exercise 3: Aggregation – Average Role Count

✅ **Solution**:

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

### 🧪 Exercise 4: Multi-Document Transaction

✅ **Use case**: Reduce product stock & insert order atomically

```js
const session = db.getMongo().startSession();
session.startTransaction();

try {
  const productsColl = session.getDatabase("classicmodels").products;
  const ordersColl = session.getDatabase("classicmodels").orders;

  productsColl.updateOne(
    { productCode: "S10_1678" },
    { $inc: { stock: -1 } },
    { session }
  );

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

