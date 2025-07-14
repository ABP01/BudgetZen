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
    res.status(500).json({ error: "Échec de la récupération des transactions" });
  }
}

async function createTransaction(req, res) {
  try {
    const { user_id, title, amount, type, category } = req.body;
    if (!user_id || !title || !amount || !type || !category) {
      return res.status(400).json({ error: "Tous les champs sont obligatoires" });
    }

    // Validate type
    if (!['income', 'expense'].includes(type)) {
      return res.status(400).json({ error: "Le type doit être 'income' ou 'expense'" });
    }

    const transaction = await sql`
          INSERT INTO transactions (user_id, title, amount, type, category)
          VALUES (${user_id}, ${title}, ${amount}, ${type}, ${category})
          RETURNING *
        `;
    console.log("Transaction insérée avec succès : ", transaction[0]);
    return res.status(201).json(transaction[0]);
  } catch (error) {
    console.error("Erreur lors de l'insertion de la transaction :", error);
    res.status(500).json({ error: "Échec de l'insertion de la transaction" });
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
      return res.status(404).json({ error: "Transaction non trouvée" });
    }
    console.log("Transaction supprimée avec succès : ", result[0]);
    return res.status(200).json(result[0]);
  } catch (error) {
    console.error("Erreur lors de la suppression de la transaction :", error);
    res.status(500).json({ error: "Échec de la suppression de la transaction" });
  }
}

async function updateTransaction(req, res) {
  const { id } = req.params;
  const { user_id, title, amount, type, category } = req.body;

  if (!user_id || !title || !amount || !type || !category) {
    return res.status(400).json({ error: "Tous les champs sont obligatoires" });
  }

  // Validate type
  if (!['income', 'expense'].includes(type)) {
    return res.status(400).json({ error: "Le type doit être 'income' ou 'expense'" });
  }

  try {
    const result = await sql`
          UPDATE transactions
          SET user_id = ${user_id}, title = ${title}, amount = ${amount}, type = ${type}, category = ${category}
          WHERE id = ${id}
          RETURNING *
        `;
    if (result.length === 0) {
      return res.status(404).json({ error: "Transaction non trouvée" });
    }
    console.log("Transaction mise à jour avec succès : ", result[0]);
    return res.status(200).json(result[0]);
  } catch (error) {
    console.error("Erreur lors de la mise à jour de la transaction :", error);
    res.status(500).json({ error: "Échec de la mise à jour de la transaction" });
  }
}

async function getSummaryByUserId(req, res) {
  try {
    const { user_id } = req.params;
    
    const incomeResult = await sql`
      SELECT COALESCE(SUM(amount), 0) AS total_income
      FROM transactions
      WHERE user_id = ${user_id} AND type = 'income';
    `;

    const expenseResult = await sql`
      SELECT COALESCE(SUM(amount), 0) AS total_expense
      FROM transactions
      WHERE user_id = ${user_id} AND type = 'expense';
    `;

    const balance = parseFloat(incomeResult[0].total_income) - parseFloat(expenseResult[0].total_expense);

    return res.status(200).json({
      balance: balance,
      income: parseFloat(incomeResult[0].total_income),
      expenses: parseFloat(expenseResult[0].total_expense),
    });
  } catch (error) {
    console.error("Erreur lors de la récupération du résumé :", error);
    res.status(500).json({ error: "Échec de la récupération du résumé" });
  }
}

export {
  createTransaction,
  deleteTransaction, getSummaryByUserId, getTransactionsByUserId, updateTransaction
};

