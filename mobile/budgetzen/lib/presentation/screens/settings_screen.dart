import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/notification_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Paramètres',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section Notifications
            _buildSection(
              context,
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              children: [
                Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    return SwitchListTile(
                      title: const Text('Notifications push'),
                      subtitle: const Text('Recevoir des notifications'),
                      value: notificationProvider.notificationsEnabled,
                      onChanged: (value) {
                        notificationProvider.toggleNotifications();
                      },
                      activeColor: AppColors.primary,
                    );
                  },
                ),
                Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    return SwitchListTile(
                      title: const Text('Notifications budgets'),
                      subtitle: const Text('Alertes de dépassement de budget'),
                      value: notificationProvider.budgetAlertsEnabled,
                      onChanged: (value) {
                        notificationProvider.toggleBudgetAlerts();
                      },
                      activeColor: AppColors.primary,
                    );
                  },
                ),
                Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    return SwitchListTile(
                      title: const Text('Rappels de transactions'),
                      subtitle: const Text(
                        'Notifications pour saisir les dépenses',
                      ),
                      value: notificationProvider.transactionRemindersEnabled,
                      onChanged: (value) {
                        notificationProvider.toggleTransactionReminders();
                      },
                      activeColor: AppColors.primary,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Section Affichage
            _buildSection(
              context,
              title: 'Affichage',
              icon: Icons.palette_outlined,
              children: [
                ListTile(
                  title: const Text('Thème'),
                  subtitle: const Text('Clair'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showThemeSelector(context);
                  },
                ),
                ListTile(
                  title: const Text('Langue'),
                  subtitle: const Text('Français'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showLanguageSelector(context);
                  },
                ),
                ListTile(
                  title: const Text('Devise'),
                  subtitle: const Text('Franc CFA (XOF)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showCurrencySelector(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Section Sécurité
            _buildSection(
              context,
              title: 'Sécurité',
              icon: Icons.security_outlined,
              children: [
                ListTile(
                  title: const Text('Code PIN'),
                  subtitle: const Text('Modifier le code PIN'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showPinChangeDialog(context);
                  },
                ),
                SwitchListTile(
                  title: const Text('Authentification biométrique'),
                  subtitle: const Text('Utiliser l\'empreinte digitale'),
                  value: false,
                  onChanged: (value) {
                    // Implémenter l'authentification biométrique
                  },
                  activeColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: const Text('Verrouillage automatique'),
                  subtitle: const Text('Verrouiller après inactivité'),
                  value: true,
                  onChanged: (value) {
                    // Implémenter le verrouillage automatique
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Section Données
            _buildSection(
              context,
              title: 'Données',
              icon: Icons.storage_outlined,
              children: [
                ListTile(
                  title: const Text('Sauvegarder les données'),
                  subtitle: const Text('Exporter vers le cloud'),
                  trailing: const Icon(Icons.cloud_upload_outlined),
                  onTap: () {
                    _showBackupDialog(context);
                  },
                ),
                ListTile(
                  title: const Text('Restaurer les données'),
                  subtitle: const Text('Importer depuis le cloud'),
                  trailing: const Icon(Icons.cloud_download_outlined),
                  onTap: () {
                    _showRestoreDialog(context);
                  },
                ),
                ListTile(
                  title: const Text('Effacer toutes les données'),
                  subtitle: const Text('Supprimer définitivement'),
                  trailing: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onTap: () {
                    _showDeleteDataDialog(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Section À propos
            _buildSection(
              context,
              title: 'À propos',
              icon: Icons.info_outlined,
              children: [
                ListTile(
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Afficher les informations de version
                  },
                ),
                ListTile(
                  title: const Text('Conditions d\'utilisation'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Ouvrir les conditions d'utilisation
                  },
                ),
                ListTile(
                  title: const Text('Politique de confidentialité'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Ouvrir la politique de confidentialité
                  },
                ),
                ListTile(
                  title: const Text('Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Contacter le support
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir un thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Clair'),
              value: 'light',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Sombre'),
              value: 'dark',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Automatique'),
              value: 'auto',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: 'fr',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'fr',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une devise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Franc CFA (XOF)'),
              value: 'XOF',
              groupValue: 'XOF',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Euro (EUR)'),
              value: 'EUR',
              groupValue: 'XOF',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Dollar US (USD)'),
              value: 'USD',
              groupValue: 'XOF',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPinChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le code PIN'),
        content: const Text(
          'Cette fonctionnalité sera disponible prochainement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sauvegarder les données'),
        content: const Text(
          'Voulez-vous sauvegarder vos données vers le cloud ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sauvegarde en cours...'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurer les données'),
        content: const Text(
          'Voulez-vous restaurer vos données depuis le cloud ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Restauration en cours...'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Restaurer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer toutes les données'),
        content: const Text(
          'Cette action est irréversible. Toutes vos données seront définitivement supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Données supprimées'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
