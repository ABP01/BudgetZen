class AppConstants {
  // Devise
  static const String currency = 'FCFA';
  static const String currencySymbol = 'F';
  static const String locale = 'fr_FR';

  // Formatage de devise
  static String formatCurrency(double amount) {
    return '${amount.abs().toStringAsFixed(0)} $currencySymbol';
  }

  static String formatCurrencyWithSign(double amount, bool isPositive) {
    final sign = isPositive ? '+' : '-';
    return '$sign${amount.abs().toStringAsFixed(0)} $currencySymbol';
  }

  // Notifications
  static const String notificationChannelId = 'budgetzen_notifications';
  static const String notificationChannelName = 'BudgetZen Notifications';
  static const String notificationChannelDescription =
      'Notifications pour les alertes budgétaires';

  // Version de l'app
  static const String appVersion = '1.0.0';
  static const String appName = 'BudgetZen';
}
