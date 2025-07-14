class CurrencyService {
  static const String currencySymbol = 'FCFA';
  static const String currencyCode = 'XOF';

  /// Formate un montant en devise CFA
  static String formatAmount(double amount, {bool includeSymbol = true}) {
    if (includeSymbol) {
      return '${amount.toStringAsFixed(0)} $currencySymbol';
    }
    return amount.toStringAsFixed(0);
  }

  /// Formate un montant avec signe pour les transactions
  static String formatTransactionAmount(
    double amount,
    bool isIncome, {
    bool includeSymbol = true,
  }) {
    final prefix = isIncome ? '+' : '-';
    final formattedAmount = formatAmount(
      amount.abs(),
      includeSymbol: includeSymbol,
    );
    return '$prefix$formattedAmount';
  }

  /// Parse un montant depuis une chaîne
  static double parseAmount(String amountString) {
    // Supprime les espaces et le symbole de devise
    final cleanString = amountString
        .replaceAll(currencySymbol, '')
        .replaceAll(' ', '')
        .replaceAll(',', '.')
        .trim();

    return double.tryParse(cleanString) ?? 0.0;
  }

  /// Formate pour l'affichage avec séparateurs de milliers
  static String formatWithSeparators(
    double amount, {
    bool includeSymbol = true,
  }) {
    final parts = amount.toStringAsFixed(0).split('.');
    final integerPart = parts[0];

    // Ajoute des espaces comme séparateurs de milliers
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ' ';
      }
      formattedInteger += integerPart[i];
    }

    if (includeSymbol) {
      return '$formattedInteger $currencySymbol';
    }
    return formattedInteger;
  }
}
