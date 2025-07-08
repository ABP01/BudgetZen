import express from 'express';
import {
    createTransaction,
    deleteTransaction,
    getSummaryByUserId,
    getTransactionsByUserId,
    updateTransaction
} from '../controllers/transactionsController.js';

const router = express.Router();

router.get("/:user_id", getTransactionsByUserId);


router.post("/", createTransaction);

router.delete("/:id", deleteTransaction);

router.put("/:id", updateTransaction);

router.get("/summary/:user_id", getSummaryByUserId);
 
export default router;