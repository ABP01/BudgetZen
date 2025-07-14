import '../../core/config/api_config.dart';
import '../../core/services/api_service.dart';
import '../models/transaction.dart';

class TransactionService {
  final ApiService _apiService = ApiService();

  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
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
      throw Exception('Erreur lors de la récupération des transactions: $e');
    }
  }

  Future<List<Transaction>> getAllTransactions() async {
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
      throw Exception('Erreur lors de la récupération des transactions: $e');
    }
  }

  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await _apiService.post(
        ApiConfig.transactionsEndpoint,
        transaction.toJson(),
      );

      return Transaction.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la création de la transaction: $e');
    }
  }

  Future<Transaction> updateTransaction(int id, Transaction transaction) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.transactionsEndpoint}/$id',
        transaction.toJson(),
      );

      return Transaction.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la transaction: $e');
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _apiService.delete('${ApiConfig.transactionsEndpoint}/$id');
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la transaction: $e');
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
    return transactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );
  }

  double getTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((transaction) => transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalExpenses(List<Transaction> transactions) {
    return transactions
        .where((transaction) => transaction.isExpense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
  }
}
