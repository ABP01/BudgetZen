import { sql } from '../config/db.js';

async function getTransactionsByUserId(req, res) {
  try {
    const { user_id } = req.query;
    let result;
    if (user_id) {
      // fetch transactions for specific user
      result = await sql`
            SELECT * FROM transactions WHERE user_id = ${user_id};
          `;
    } else {
      // fetch all transactions when no user_id provided
      result = await sql`SELECT * FROM transactions;`;
    }
    res.status(200).json(result);
  } catch (error) {
    console.error("Error fetching transactions:", error);
    res.status(500).json({ error: "Failed to fetch transactions" });
  }
}

async function createTransaction(req, res) {
  try {
    const { user_id, title, amount, category } = req.body;
    if (!user_id || !title || !amount || !category) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const transaction = await sql`
          INSERT INTO transactions (user_id, title, amount, category)
          VALUES (${user_id}, ${title}, ${amount}, ${category})
          RETURNING *
        `;
    console.log("Transaction inserted successfully: ", transaction[0]);
    return res.status(201).json(transaction[0]);
  } catch (error) {
    console.error("Error inserting transaction:", error);
    res.status(500).json({ error: "Failed to insert transaction" });
  }
}

async function deleteTransaction(req, res) {
  const { id } = req.params;
  try {
    const result = await sql`
          DELETE FROM transactions WHERE id = ${id}
          RETURNING *
        `;
    if (result.length === 0) {
      return res.status(404).json({ error: "Transaction not found" });
    }
    console.log("Transaction deleted successfully: ", result[0]);
    return res.status(200).json(result[0]);
  } catch (error) {
    console.error("Error deleting transaction:", error);
    res.status(500).json({ error: "Failed to delete transaction" });
  }
}

async function updateTransaction(req, res) {
  const { id } = req.params;
  const { user_id, title, amount, category } = req.body;

  if (!user_id || !title || !amount || !category) {
    return res.status(400).json({ error: "All fields are required" });
  }

  try {
    const result = await sql`
          UPDATE transactions
          SET user_id = ${user_id}, title = ${title}, amount = ${amount}, category = ${category}
          WHERE id = ${id}
          RETURNING *
        `;
    if (result.length === 0) {
      return res.status(404).json({ error: "Transaction not found" });
    }
    console.log("Transaction updated successfully: ", result[0]);
    return res.status(200).json(result[0]);
  } catch (error) {
    console.error("Error updating transaction:", error);
    res.status(500).json({ error: "Failed to update transaction" });
  }
}

async function getSummaryByUserId(req, res) {
  try {
    const { user_id } = req.params;
    const balanceResult = await sql`
      SELECT COALESCE(SUM(CASE WHEN category = 'Income' THEN amount ELSE 0 END), 0) AS total_income,
             COALESCE(SUM(CASE WHEN category = 'Expense' THEN amount ELSE 0 END), 0) AS total_expense,
             COALESCE(SUM(amount), 0) AS balance
      FROM transactions
      WHERE user_id = ${user_id};
    `;

    const incomeResult = await sql`
      SELECT COALESCE(SUM(amount), 0) AS total_income
      FROM transactions
      WHERE user_id = ${user_id} AND category = 'Income';
    `;

    const expenseResult = await sql`
      SELECT COALESCE(SUM(amount), 0) AS total_expense
      FROM transactions
      WHERE user_id = ${user_id} AND category = 'Expense';
    `;
    return res.status(200).json({
      balance: balanceResult[0].balance,
      income: incomeResult[0].total_income,
      expenses: expenseResult[0].total_expense,
    });
  } catch (error) {
    console.error("Error fetching summary:", error);
    res.status(500).json({ error: "Failed to fetch summary" });
  }
}

export {
    createTransaction,
    deleteTransaction, getSummaryByUserId, getTransactionsByUserId, updateTransaction
};

