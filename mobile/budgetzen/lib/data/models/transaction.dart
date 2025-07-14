class Transaction {
  final int? id;
  final String userId;
  final String title;
  final double amount;
  final String category;
  final String type; // 'income' ou 'expense'
  final DateTime createdAt;

  Transaction({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      type: json['type'] ?? 'expense',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'created_at': createdAt.toIso8601String().split('T')[0],
    };
  }

  Transaction copyWith({
    int? id,
    String? userId,
    String? title,
    double? amount,
    String? category,
    String? type,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';

  @override
  String toString() {
    return 'Transaction{id: $id, userId: $userId, title: $title, amount: $amount, category: $category, type: $type, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.amount == amount &&
        other.category == category &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, title, amount, category, type, createdAt);
  }
}
