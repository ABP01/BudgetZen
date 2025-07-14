import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationType { transaction, budget, reminder, security }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [];
  bool _notificationsEnabled = true;
  bool _budgetAlertsEnabled = true;
  bool _transactionRemindersEnabled = true;
  bool _monthlyReportsEnabled = true;
  bool _securityAlertsEnabled = true;

  // Getters existants
  bool get notificationsEnabled => _notificationsEnabled;
  bool get budgetAlertsEnabled => _budgetAlertsEnabled;
  bool get transactionRemindersEnabled => _transactionRemindersEnabled;
  bool get monthlyReportsEnabled => _monthlyReportsEnabled;
  bool get securityAlertsEnabled => _securityAlertsEnabled;

  // Nouveaux getters pour les notifications
  List<NotificationItem> get notifications => _notifications;
  List<NotificationItem> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  NotificationProvider() {
    _loadSettings();
  }

  // Ajouter une notification
  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      data: data,
    );

    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Marquer comme lu
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // Marquer tout comme lu
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }

  // Supprimer une notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  // Supprimer toutes les notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    _budgetAlertsEnabled = prefs.getBool('budget_alerts') ?? true;
    _transactionRemindersEnabled =
        prefs.getBool('transaction_reminders') ?? true;
    _monthlyReportsEnabled = prefs.getBool('monthly_reports') ?? true;
    _securityAlertsEnabled = prefs.getBool('security_alerts') ?? true;
    notifyListeners();
  }

  Future<void> setBudgetAlerts(bool enabled) async {
    _budgetAlertsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('budget_alerts', enabled);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    notifyListeners();
  }

  Future<void> toggleBudgetAlerts() async {
    _budgetAlertsEnabled = !_budgetAlertsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('budget_alerts', _budgetAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleTransactionReminders() async {
    _transactionRemindersEnabled = !_transactionRemindersEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('transaction_reminders', _transactionRemindersEnabled);
    notifyListeners();
  }

  Future<void> setTransactionReminders(bool enabled) async {
    _transactionRemindersEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('transaction_reminders', enabled);
    notifyListeners();
  }

  Future<void> setMonthlyReports(bool enabled) async {
    _monthlyReportsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('monthly_reports', enabled);
    notifyListeners();
  }

  Future<void> setSecurityAlerts(bool enabled) async {
    _securityAlertsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('security_alerts', enabled);
    notifyListeners();
  }

  // Simulation de notification
  void showBudgetAlert(BuildContext context, String message) {
    if (!_budgetAlertsEnabled) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void showTransactionAlert(BuildContext context, String message) {
    if (!_transactionRemindersEnabled) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
