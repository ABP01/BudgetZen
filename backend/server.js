import dotenv from "dotenv";
import express from "express";
import { sql } from "./config/db.js";
import { redis } from './config/upstash.js';
import rateLimiter from "./middleware/rateLimiter.js";

import transactionRoute from "./routes/transactionsRoute.js";

dotenv.config();

const PORT = process.env.PORT || 5001;

const app = express();

// middleware to parse JSON bodies
app.use(rateLimiter);
app.use(express.json());



app.use("/api/transactions", transactionRoute);


async function initDB() {

  try {
    await sql`CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY, 
    user_id VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL, 
    category VARCHAR(255) NOT NULL,
    created_at DATE NOT NULL DEFAULT CURRENT_DATE
    )`
    console.log("Database initialized successfully");
  } catch (error) {
    console.error("Database initialization failed:", error);
    process.exit(1);
  }
}

// our custom simple middleware 
app.get("/", (req, res) => {
  res.send("Welcome to the BudgetZen API!");
});




redis.set('foo','bar').then(console.log);
redis.get('foo').then(console.log);

initDB().then(() => {
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
});