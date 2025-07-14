import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/notification_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Paramètres de notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notifications,
                      color: AppColors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gérez vos préférences de notifications',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Paramètres de notifications
              _buildSettingsCard(context, 'Alertes Budget', [
                _buildSwitchTile(
                  context,
                  'Alertes de budget',
                  'Recevoir des alertes quand vous dépassez votre budget',
                  Icons.warning_amber,
                  notificationProvider.budgetAlertsEnabled,
                  (value) => notificationProvider.setBudgetAlerts(value),
                ),
              ]),

              const SizedBox(height: 16),

              _buildSettingsCard(context, 'Rappels de transactions', [
                _buildSwitchTile(
                  context,
                  'Rappels de transactions',
                  'Recevoir des rappels pour ajouter vos transactions',
                  Icons.receipt_long,
                  notificationProvider.transactionRemindersEnabled,
                  (value) =>
                      notificationProvider.setTransactionReminders(value),
                ),
              ]),

              const SizedBox(height: 16),

              _buildSettingsCard(context, 'Rapports', [
                _buildSwitchTile(
                  context,
                  'Rapports mensuels',
                  'Recevoir un résumé mensuel de vos finances',
                  Icons.analytics,
                  notificationProvider.monthlyReportsEnabled,
                  (value) => notificationProvider.setMonthlyReports(value),
                ),
              ]),

              const SizedBox(height: 16),

              _buildSettingsCard(context, 'Sécurité', [
                _buildSwitchTile(
                  context,
                  'Alertes de sécurité',
                  'Recevoir des alertes pour les activités de sécurité',
                  Icons.security,
                  notificationProvider.securityAlertsEnabled,
                  (value) => notificationProvider.setSecurityAlerts(value),
                ),
              ]),

              const SizedBox(height: 32),

              // Test notifications
              ElevatedButton.icon(
                onPressed: () {
                  notificationProvider.showBudgetAlert(
                    context,
                    'Exemple d\'alerte budget : Vous avez dépassé votre budget nourriture',
                  );
                },
                icon: const Icon(Icons.notifications),
                label: const Text('Tester les notifications'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryExtraLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}
