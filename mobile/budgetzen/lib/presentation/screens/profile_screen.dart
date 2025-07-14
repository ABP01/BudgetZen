import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/currency_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import 'edit_profile_screen.dart';
import 'loading_demo_screen.dart';
import 'notification_settings_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (mounted) {
        context.go('/register');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Header avec profil
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nom utilisateur
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Text(
                              authProvider.username ?? 'Utilisateur',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Membre depuis ${DateTime.now().year}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.9),
                              ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Statistiques rapides
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Consumer<TransactionProvider>(
                      builder: (context, provider, child) {
                        return Container(
                          padding: const EdgeInsets.all(20),
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
                              Text(
                                'Vos statistiques',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatItem(
                                      context,
                                      'Transactions',
                                      '${provider.transactions.length}',
                                      Icons.receipt_long,
                                      AppColors.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatItem(
                                      context,
                                      'Solde',
                                      CurrencyService.formatAmount(
                                        provider.totalBalance,
                                      ),
                                      Icons.account_balance_wallet,
                                      provider.totalBalance >= 0
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Options du menu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildMenuSection(context, 'Paramètres', [
                          _buildMenuItem(
                            context,
                            'Modifier le profil',
                            Icons.edit,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'Notifications',
                            Icons.notifications_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationSettingsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'Sécurité',
                            Icons.security,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ]),

                        const SizedBox(height: 24),

                        _buildMenuSection(context, 'Support', [
                          _buildMenuItem(
                            context,
                            'Démonstration Skeleton',
                            Icons.animation,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoadingDemoScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'Centre d\'aide',
                            Icons.help_outline,
                            () {
                              _showHelpCenter(context);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'Contactez-nous',
                            Icons.contact_support,
                            () {
                              _contactSupport();
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'À propos',
                            Icons.info_outline,
                            () {
                              _showAboutDialog(context);
                            },
                          ),
                        ]),

                        const SizedBox(height: 24),

                        // Bouton de déconnexion
                        Container(
                          width: double.infinity,
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
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.logout,
                                color: AppColors.error,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              'Déconnexion',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            onTap: _logout,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
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
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
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
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe actuel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mot de passe changé avec succès !'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Les mots de passe ne correspondent pas'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Changer'),
          ),
        ],
      ),
    );
  }

  void _showConnectedDevices(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appareils connectés'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.phone_android,
                color: AppColors.primary,
              ),
              title: const Text('Cet appareil'),
              subtitle: Text(
                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              ),
              trailing: const Chip(
                label: Text('Actuel'),
                backgroundColor: AppColors.success,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Centre d\'aide'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(
                Icons.question_answer,
                color: AppColors.primary,
              ),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                _showFAQ(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.video_library,
                color: AppColors.primary,
              ),
              title: const Text('Tutoriels vidéo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Redirection vers les tutoriels...'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report, color: AppColors.primary),
              title: const Text('Signaler un problème'),
              onTap: () {
                Navigator.pop(context);
                _reportBug(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Questions fréquentes'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView(
            children: [
              ExpansionTile(
                title: const Text('Comment ajouter une transaction ?'),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Appuyez sur le bouton "+" en bas de l\'écran pour ajouter une nouvelle transaction.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Comment définir un budget ?'),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Allez dans l\'onglet Budget et définissez vos limites pour chaque catégorie.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Comment voir mes statistiques ?'),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Consultez l\'onglet Statistiques pour voir vos graphiques et analyses.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _reportBug(BuildContext context) {
    final bugController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signaler un problème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Décrivez le problème rencontré :'),
            const SizedBox(height: 16),
            TextField(
              controller: bugController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Décrivez votre problème...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rapport envoyé ! Merci pour votre retour.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  Future<void> _contactSupport() async {
    const email = 'support@budgetzen.tg';

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contactez-nous à : $email'),
          backgroundColor: AppColors.info,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Copier',
            onPressed: () {
              // Ici on pourrait copier l'email dans le presse-papiers
            },
          ),
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'BudgetZen',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.account_balance_wallet,
          color: AppColors.white,
          size: 32,
        ),
      ),
      children: [
        const Text(
          'BudgetZen vous aide à gérer vos finances personnelles de manière simple et efficace.',
        ),
        const SizedBox(height: 16),
        const Text('Développé avec ❤️ au Togo'),
        const SizedBox(height: 8),
        const Text('© 2025 BudgetZen. Tous droits réservés.'),
      ],
    );
  }
}
