# NoSQL Databases & MongoDB Basics

This guide introduces you to the world of non-relational databases, focusing on MongoDB—a leading document-oriented NoSQL store—and covers foundational CRUD operations.

---

## 1. Introduction to NoSQL Databases

NoSQL databases (“Not Only SQL”) emerged to address scalability and schema-flexibility challenges that traditional relational systems face when handling ever-growing volumes of semi-structured or unstructured data.  

Key characteristics:  
- Schema-less data models allow each record to have different structures, enabling rapid iteration.  
- Horizontal scalability distributes data across clusters of commodity servers, rather than scaling up a single machine.  
- Eventual consistency (BASE) trades strict ACID guarantees for high availability and partition tolerance in distributed environments.  

Main NoSQL data models:  
- **Document stores** (e.g., MongoDB, CouchDB): JSON/BSON documents with nested fields, ideal for content management and catalogs.  
- **Key-value stores** (e.g., Redis, DynamoDB): Simple lookups by unique keys, perfect for session caching and real-time counters.  
- **Wide-column stores** (e.g., Cassandra, HBase): Sparse tables optimized for large-scale analytics and time-series data.  
- **Graph databases** (e.g., Neo4j, Amazon Neptune): Nodes and edges store highly connected data, powering social networks and fraud detection.  

---

## 2. MongoDB Basics

MongoDB is an open-source, document-oriented NoSQL database written in C++, storing data in BSON (binary JSON) format. It combines flexibility, rich query capabilities, and horizontal scaling.  

Core features:  
- **Flexible schema**: Documents in the same collection can have different fields and structures.  
- **Rich query language**: Supports filtering, projection, aggregation pipelines, and geospatial queries via a JSON-like syntax.  
- **Indexing**: Single-field, compound, multikey, text, and geospatial indexes accelerate read performance.  
- **Replication**: Automatic failover and data redundancy via replica sets ensures high availability.  
- **Sharding**: Distributes data across multiple shards for horizontal scalability and load balancing.  

Getting started:  
1. **Install MongoDB** on your platform (Linux, Windows, macOS) or use **MongoDB Atlas** (cloud-hosted).  
2. Launch the **mongo** shell or connect via a driver in your application language.  
3. Create a database and collection on first write—no DDL required.  

Example document in the `users` collection:  
```js
{
  _id: ObjectId("6512f1d8c5f4a9a1b2c3d4e5"),
  name: "Alice",
  email: "alice@example.com",
  roles: ["admin","user"],
  profile: { age: 30, city: "Mumbai" },
  createdAt: ISODate("2025-07-14T10:00:00Z")
}
```

---

## 3. CRUD Operations in MongoDB

Perform basic data operations directly via the mongo shell or a driver. Each method targets a single collection.

### 3.1 Create

- **`insertOne(doc)`**: Add one document.  
- **`insertMany([doc1, doc2, …])`**: Add multiple documents.

```js
// Insert a single user
db.users.insertOne({
  name: "Bob",
  email: "bob@example.com",
  roles: ["user"]
});

// Insert multiple users
db.users.insertMany([
  { name: "Carol", email: "carol@example.com" },
  { name: "Dave",  email: "dave@example.com"  }
]);
```


### 3.2 Read

- **`find(filter, projection)`**: Retrieve all matching documents.  
- **`findOne(filter, projection)`**: Retrieve the first matching document.

```js
// All admins, only show name and email
db.users.find(
  { roles: "admin" },
  { _id: 0, name: 1, email: 1 }
);

// Single user lookup
db.users.findOne({ email: "alice@example.com" });
```


### 3.3 Update

- **`updateOne(filter, updateDoc)`**: Modify the first matching document.  
- **`updateMany(filter, updateDoc)`**: Modify all matching documents.  
- **`replaceOne(filter, replacementDoc)`**: Replace the entire document.

```js
// Promote Bob to admin
db.users.updateOne(
  { email: "bob@example.com" },
  { $addToSet: { roles: "admin" } }
);

// Change default role for all users without roles
db.users.updateMany(
  { roles: { $exists: false } },
  { $set: { roles: ["user"] } }
);

// Replace Carol's document completely
db.users.replaceOne(
  { name: "Carol" },
  { name: "Carol", email: "carol@newdomain.com", roles: ["editor"] }
);
```


### 3.4 Delete

- **`deleteOne(filter)`**: Remove the first matching document.  
- **`deleteMany(filter)`**: Remove all matching documents.

```js
// Delete Dave by email
db.users.deleteOne({ email: "dave@example.com" });

// Remove all test users
db.users.deleteMany({ email: /@test\.com$/ });
```


---

## 4. Further Exercises

1. Insert three sample blog posts into a `posts` collection and query those with more than 10 comments.  
2. Create a compound index on `users(email, createdAt)` and use `explain()` to compare query plans with and without the index.  
3. Write an aggregation pipeline to calculate average `roles` array length per user.  
4. Demonstrate a multi-document ACID transaction updating two collections: decrement product stock and insert order.

Explore these operations in MongoDB Atlas or your local instance to solidify your NoSQL and MongoDB fundamentals.