import '../models/transaction.dart';

class LocalTransactionService {
  static final List<Transaction> _localTransactions = [
    Transaction(
      id: 1,
      userId: 'user_123',
      title: 'Salaire Janvier',
      amount: 2500.0,
      category: 'Salaire',
      type: 'income',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 2,
      userId: 'user_123',
      title: 'Courses alimentaires',
      amount: 85.50,
      category: 'Alimentation',
      type: 'expense',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 3,
      userId: 'user_123',
      title: 'Transport mensuel',
      amount: 75.0,
      category: 'Transport',
      type: 'expense',
      createdAt: DateTime.now(),
    ),
    Transaction(
      id: 4,
      userId: 'user_123',
      title: 'Freelance',
      amount: 400.0,
      category: 'Freelance',
      type: 'income',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    // Simule un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    return _localTransactions
        .where((transaction) => transaction.userId == userId)
        .toList();
  }

  Future<List<Transaction>> getAllTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_localTransactions);
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newTransaction = transaction.copyWith(
      id: _localTransactions.length + 1,
    );

    _localTransactions.add(newTransaction);
    return newTransaction;
  }

  Future<void> deleteTransaction(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _localTransactions.removeWhere((t) => t.id == id);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _localTransactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _localTransactions[index] = transaction;
      return transaction;
    }
    throw Exception('Transaction non trouvée');
  }

  double getTotalBalance(List<Transaction> transactions) {
    return transactions.fold<double>(0, (sum, transaction) {
      return sum +
          (transaction.isIncome ? transaction.amount : -transaction.amount);
    });
  }

  double getTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.isIncome)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalExpenses(List<Transaction> transactions) {
    return transactions
        .where((t) => t.isExpense)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
  }
}
