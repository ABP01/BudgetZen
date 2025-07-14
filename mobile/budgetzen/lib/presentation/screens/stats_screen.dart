import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/stats_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedPeriod = 'Ce mois';
  final List<String> _periods = ['Cette semaine', 'Ce mois', 'Ce trimestre'];

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
                // Header avec statistiques principales
                SliverToBoxAdapter(child: _buildHeader()),

                // Cartes de statistiques rapides
                SliverToBoxAdapter(child: _buildQuickStats()),

                // Graphique des dépenses par catégorie
                SliverToBoxAdapter(child: _buildCategoryChart()),

                // Tendances mensuelles
                SliverToBoxAdapter(child: _buildMonthlyTrends()),

                // Conseils basés sur les données
                SliverToBoxAdapter(child: _buildInsights()),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    'Statistiques',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  // Sélecteur de période
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPeriod,
                        dropdownColor: AppColors.primary,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.white,
                          size: 16,
                        ),
                        items: _periods.map((period) {
                          return DropdownMenuItem(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPeriod = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Balance principale
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance totale',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€${provider.totalBalance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Indicateur de tendance
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: provider.totalBalance >= 0
                              ? AppColors.success.withOpacity(0.2)
                              : AppColors.error.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              provider.totalBalance >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: AppColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              provider.totalBalance >= 0
                                  ? 'Positif'
                                  : 'Négatif',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Revenus',
                  value: '€${provider.totalIncome.toStringAsFixed(0)}',
                  icon: Icon(Icons.trending_up, color: AppColors.success),
                  color: AppColors.success,
                  subtitle:
                      '${provider.incomeTransactions.length} transactions',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatsCard(
                  title: 'Dépenses',
                  value: '€${provider.totalExpenses.abs().toStringAsFixed(0)}',
                  icon: Icon(Icons.trending_down, color: AppColors.error),
                  color: AppColors.error,
                  subtitle:
                      '${provider.expenseTransactions.length} transactions',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final categories = provider.categories.toList();

          if (categories.isEmpty) {
            return _buildNoDataCard('Aucune catégorie de dépenses');
          }

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
                  'Dépenses par catégorie',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // Liste des catégories avec barres
                ...categories.map((category) {
                  final categoryExpenses = provider.getExpensesByCategory(
                    category,
                  );
                  final totalExpenses = provider.totalExpenses.abs();
                  final percentage = totalExpenses > 0
                      ? categoryExpenses.abs() / totalExpenses
                      : 0.0;

                  return _buildCategoryBar(
                    category,
                    categoryExpenses.abs(),
                    percentage,
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryBar(String category, double amount, double percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '€${amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Barre de progression
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${(percentage * 100).toStringAsFixed(1)}% du total',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrends() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
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
              'Tendances',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                final avgExpense = provider.expenseTransactions.isNotEmpty
                    ? provider.totalExpenses.abs() /
                          provider.expenseTransactions.length
                    : 0.0;

                final maxExpense = provider.expenseTransactions.isNotEmpty
                    ? provider.expenseTransactions
                          .map((t) => t.amount.abs())
                          .reduce((a, b) => a > b ? a : b)
                    : 0.0;

                return Column(
                  children: [
                    _buildTrendItem(
                      'Moyenne des dépenses',
                      '€${avgExpense.toStringAsFixed(2)}',
                      Icons.bar_chart,
                      AppColors.warning,
                    ),

                    _buildTrendItem(
                      'Plus grosse dépense',
                      '€${maxExpense.toStringAsFixed(2)}',
                      Icons.arrow_upward,
                      AppColors.error,
                    ),

                    _buildTrendItem(
                      'Catégorie principale',
                      provider.categories.isNotEmpty
                          ? provider.categories.first
                          : 'Aucune',
                      Icons.category,
                      AppColors.primary,
                      isLast: true,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: AppColors.background, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.success.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Analyses personnalisées',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                return Text(
                  _generateInsights(provider),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataCard(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
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
        children: [
          Icon(Icons.bar_chart, size: 48, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _generateInsights(TransactionProvider provider) {
    if (provider.transactions.isEmpty) {
      return 'Commencez à ajouter des transactions pour voir des analyses personnalisées de vos habitudes financières.';
    }

    final insights = <String>[];

    if (provider.totalBalance > 0) {
      insights.add('Votre balance est positive, continuez comme ça !');
    } else {
      insights.add(
        'Votre balance est négative, pensez à réduire vos dépenses.',
      );
    }

    if (provider.expenseTransactions.length >
        provider.incomeTransactions.length) {
      insights.add('Vous avez plus de dépenses que de revenus ce mois.');
    }

    if (insights.isEmpty) {
      insights.add(
        'Continuez à suivre vos finances pour obtenir plus d\'analyses.',
      );
    }

    return insights.join(' ');
  }
}
