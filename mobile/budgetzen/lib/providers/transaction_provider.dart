import 'package:flutter/foundation.dart';

import '../data/models/transaction.dart';
import '../data/services/transaction_service.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  // State
  List<Transaction> _transactions = [];
  TransactionStatus _status = TransactionStatus.initial;
  String? _errorMessage;
  String _currentUserId = "user_123"; // ID utilisateur par défaut

  // Getters
  List<Transaction> get transactions => _transactions;
  TransactionStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get currentUserId => _currentUserId;

  // Filtered transactions
  List<Transaction> get incomeTransactions =>
      _transactions.where((t) => t.isIncome).toList();

  List<Transaction> get expenseTransactions =>
      _transactions.where((t) => t.isExpense).toList();

  // Stats
  double get totalBalance => _transactionService.getTotalBalance(_transactions);
  double get totalIncome => _transactionService.getTotalIncome(_transactions);
  double get totalExpenses =>
      _transactionService.getTotalExpenses(_transactions);

  // Categories
  Set<String> get categories => _transactions.map((t) => t.category).toSet();

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _status = TransactionStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _transactionService.getTransactionsByUserId(
        _currentUserId,
      );
      _status = TransactionStatus.loaded;
    } catch (e) {
      _status = TransactionStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final newTransaction = await _transactionService.createTransaction(
        transaction.copyWith(userId: _currentUserId),
      );
      _transactions.add(newTransaction);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      if (transaction.id == null) {
        throw Exception('ID de transaction manquant pour la mise à jour');
      }

      final updatedTransaction = await _transactionService.updateTransaction(
        transaction.id!,
        transaction,
      );

      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    try {
      await _transactionService.deleteTransaction(transactionId);
      _transactions.removeWhere((t) => t.id == transactionId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, double>> getCategoryStats() async {
    try {
      return await _transactionService.getCategoryStats(_currentUserId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, double>> getMonthlyStats() async {
    try {
      return await _transactionService.getMonthlyStats(_currentUserId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      return t.createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
          t.createdAt.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Méthodes pour le budget
  double getTotalExpenses() {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getExpensesByCategory(String category) {
    return _transactions
        .where((t) => t.isExpense && t.category == category)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void refresh() {
    loadTransactions();
  }
}
