import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/currency_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/stats_card.dart';
import '../widgets/transaction_tile.dart';
import 'notifications_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final transactionProvider = context.read<TransactionProvider>();

      // Set user ID in transaction provider
      if (authProvider.userId != null) {
        transactionProvider.setCurrentUserId(authProvider.userId!);
      }

      // Load transactions
      transactionProvider.loadTransactions();
    });
  }

  String _formatCurrency(double amount) {
    return CurrencyService.formatAmount(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<TransactionProvider>().loadTransactions();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour !',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              Text(
                                'BudgetZen',
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                            ],
                          ),
                          Consumer<NotificationProvider>(
                            builder: (context, notificationProvider, child) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsListScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Icon(
                                        Icons.notifications_outlined,
                                        color: AppColors.primary,
                                      ),
                                      if (notificationProvider.unreadCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: AppColors.error,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              '${notificationProvider.unreadCount}',
                                              style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Cards
              SliverToBoxAdapter(
                child: Consumer<TransactionProvider>(
                  builder: (context, provider, child) {
                    if (provider.status == TransactionStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (provider.status == TransactionStatus.error) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Erreur de chargement',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  provider.errorMessage ??
                                      'Une erreur est survenue',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => provider.loadTransactions(),
                                  child: const Text('Réessayer'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Balance principale
                          StatsCard(
                            title: 'Solde total',
                            value: _formatCurrency(provider.totalBalance),
                            subtitle: 'Mise à jour récente',
                            icon: Icon(
                              Icons.account_balance_wallet,
                              color: AppColors.white,
                              size: 28,
                            ),
                            gradient: AppColors.primaryGradient,
                          ),
                          const SizedBox(height: 16),

                          // Revenus et Dépenses
                          Row(
                            children: [
                              Expanded(
                                child: StatsCard(
                                  title: 'Revenus',
                                  value: _formatCurrency(provider.totalIncome),
                                  icon: Icon(
                                    Icons.trending_up,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                  gradient: AppColors.successGradient,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatsCard(
                                  title: 'Dépenses',
                                  value: _formatCurrency(
                                    provider.totalExpenses,
                                  ),
                                  icon: Icon(
                                    Icons.trending_down,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                  gradient: AppColors.warningGradient,
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

              // Section Transactions Récentes
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions récentes',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigation vers l'écran des transactions
                        },
                        child: const Text('Voir tout'),
                      ),
                    ],
                  ),
                ),
              ),

              // Liste des Transactions
              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  if (provider.transactions.isEmpty) {
                    return SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune transaction',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Commencez par ajouter votre première transaction',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textLight),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final recentTransactions = provider.transactions
                      .take(5)
                      .toList();

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final transaction = recentTransactions[index];
                      return TransactionTile(
                        transaction: transaction,
                        onTap: () {
                          // Navigation vers les détails de la transaction
                        },
                        onEdit: () {
                          // Navigation vers l'édition de la transaction
                        },
                        onDelete: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Supprimer la transaction'),
                              content: const Text(
                                'Êtes-vous sûr de vouloir supprimer cette transaction ?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Supprimer'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true && transaction.id != null) {
                            try {
                              await provider.deleteTransaction(transaction.id!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Transaction supprimée'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      );
                    }, childCount: recentTransactions.length),
                  );
                },
              ),

              // Espacement en bas
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
