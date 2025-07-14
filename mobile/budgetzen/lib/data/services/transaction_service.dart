import '../../core/config/api_config.dart';
import '../../core/services/api_service.dart';
import '../models/transaction.dart';
import 'local_transaction_service.dart';

class TransactionService {
  final ApiService _apiService = ApiService();
  final LocalTransactionService _localService = LocalTransactionService();
  bool _useLocalMode = false;

  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    if (_useLocalMode) {
      return await _localService.getTransactionsByUserId(userId);
    }

    try {
      final response = await _apiService.get(
        ApiConfig.transactionsEndpoint,
        queryParams: {'user_id': userId},
      );

      List<dynamic> transactionList = [];

      if (response.containsKey('data') && response['data'] is List) {
        transactionList = response['data'] as List<dynamic>;
      } else if (response.values.isNotEmpty && response.values.first is List) {
        transactionList = response.values.first as List<dynamic>;
      }

      return transactionList
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('🔄 Connexion au serveur échouée, basculement en mode local');
      _useLocalMode = true;
      return await _localService.getTransactionsByUserId(userId);
    }
  }

  Future<List<Transaction>> getAllTransactions() async {
    if (_useLocalMode) {
      return await _localService.getAllTransactions();
    }

    try {
      final response = await _apiService.get(ApiConfig.transactionsEndpoint);

      List<dynamic> transactionList = [];

      if (response.containsKey('data') && response['data'] is List) {
        transactionList = response['data'] as List<dynamic>;
      } else if (response.values.isNotEmpty && response.values.first is List) {
        transactionList = response.values.first as List<dynamic>;
      }

      return transactionList
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('🔄 Connexion au serveur échouée, basculement en mode local');
      _useLocalMode = true;
      return await _localService.getAllTransactions();
    }
  }

  Future<Transaction> createTransaction(Transaction transaction) async {
    if (_useLocalMode) {
      return await _localService.addTransaction(transaction);
    }

    try {
      final response = await _apiService.post(
        ApiConfig.transactionsEndpoint,
        transaction.toJson(),
      );

      return Transaction.fromJson(response);
    } catch (e) {
      print('🔄 Connexion au serveur échouée, basculement en mode local');
      _useLocalMode = true;
      return await _localService.addTransaction(transaction);
    }
  }

  Future<Transaction> updateTransaction(int id, Transaction transaction) async {
    if (_useLocalMode) {
      return await _localService.updateTransaction(transaction);
    }

    try {
      final response = await _apiService.put(
        '${ApiConfig.transactionsEndpoint}/$id',
        transaction.toJson(),
      );

      return Transaction.fromJson(response);
    } catch (e) {
      print('🔄 Connexion au serveur échouée, basculement en mode local');
      _useLocalMode = true;
      return await _localService.updateTransaction(transaction);
    }
  }

  Future<void> deleteTransaction(int id) async {
    if (_useLocalMode) {
      return await _localService.deleteTransaction(id);
    }

    try {
      await _apiService.delete('${ApiConfig.transactionsEndpoint}/$id');
    } catch (e) {
      print('🔄 Connexion au serveur échouée, basculement en mode local');
      _useLocalMode = true;
      return await _localService.deleteTransaction(id);
    }
  }

  Future<Map<String, double>> getCategoryStats(String userId) async {
    try {
      final transactions = await getTransactionsByUserId(userId);
      final Map<String, double> categoryStats = {};

      for (final transaction in transactions) {
        final category = transaction.category;
        final amount = transaction.amount.abs(); // Prendre la valeur absolue

        if (categoryStats.containsKey(category)) {
          categoryStats[category] = categoryStats[category]! + amount;
        } else {
          categoryStats[category] = amount;
        }
      }

      return categoryStats;
    } catch (e) {
      throw Exception('Erreur lors du calcul des statistiques: $e');
    }
  }

  Future<Map<String, double>> getMonthlyStats(String userId) async {
    try {
      final transactions = await getTransactionsByUserId(userId);
      final Map<String, double> monthlyStats = {};

      for (final transaction in transactions) {
        final monthKey =
            '${transaction.createdAt.year}-${transaction.createdAt.month.toString().padLeft(2, '0')}';

        if (monthlyStats.containsKey(monthKey)) {
          monthlyStats[monthKey] = monthlyStats[monthKey]! + transaction.amount;
        } else {
          monthlyStats[monthKey] = transaction.amount;
        }
      }

      return monthlyStats;
    } catch (e) {
      throw Exception('Erreur lors du calcul des statistiques mensuelles: $e');
    }
  }

  double getTotalBalance(List<Transaction> transactions) {
    return _localService.getTotalBalance(transactions);
  }

  double getTotalIncome(List<Transaction> transactions) {
    return _localService.getTotalIncome(transactions);
  }

  double getTotalExpenses(List<Transaction> transactions) {
    return _localService.getTotalExpenses(transactions);
  }
}
