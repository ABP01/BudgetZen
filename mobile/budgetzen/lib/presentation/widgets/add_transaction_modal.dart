import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/transaction.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

enum TransactionType { income, expense }

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Autre';

  final List<String> _expenseCategories = [
    'Alimentation',
    'Transport',
    'Logement',
    'Santé',
    'Divertissement',
    'Shopping',
    'Éducation',
    'Autre',
  ];

  final List<String> _incomeCategories = [
    'Salaire',
    'Freelance',
    'Investissement',
    'Bonus',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
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
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _selectedType = type;
      _selectedCategory = type == TransactionType.income
          ? _incomeCategories.first
          : _expenseCategories.first;
    });
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final transactionProvider = context.read<TransactionProvider>();

    if (authProvider.userId == null) {
      _showErrorSnackBar('Erreur: Utilisateur non authentifié');
      return;
    }

    try {
      final amount = double.parse(_amountController.text);

      final transaction = Transaction(
        userId: authProvider.userId!,
        title: _titleController.text.trim(),
        amount: amount, // Toujours positif maintenant
        category: _selectedCategory,
        type: _selectedType == TransactionType.income ? 'income' : 'expense',
        createdAt: DateTime.now(),
      );

      await transactionProvider.addTransaction(transaction);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction ajoutée avec succès !'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'ajout: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  'Nouvelle Transaction',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Type selector
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _onTypeChanged(TransactionType.income),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedType ==
                                              TransactionType.income
                                          ? AppColors.success
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.trending_up,
                                          color:
                                              _selectedType ==
                                                  TransactionType.income
                                              ? AppColors.white
                                              : AppColors.success,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Revenu',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color:
                                                    _selectedType ==
                                                        TransactionType.income
                                                    ? AppColors.white
                                                    : AppColors.success,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _onTypeChanged(TransactionType.expense),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedType ==
                                              TransactionType.expense
                                          ? AppColors.error
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.trending_down,
                                          color:
                                              _selectedType ==
                                                  TransactionType.expense
                                              ? AppColors.white
                                              : AppColors.error,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Dépense',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color:
                                                    _selectedType ==
                                                        TransactionType.expense
                                                    ? AppColors.white
                                                    : AppColors.error,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title field
                        CustomTextField(
                          controller: _titleController,
                          label: 'Titre',
                          hint: 'Ex: Courses, Salaire...',
                          prefixIcon: const Icon(Icons.title),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer un titre';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Amount field
                        CustomTextField(
                          controller: _amountController,
                          label: 'Montant',
                          hint: '0.00',
                          prefixIcon: const Icon(Icons.money),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer un montant';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Montant invalide';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Category dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Catégorie',
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items:
                              (_selectedType == TransactionType.income
                                      ? _incomeCategories
                                      : _expenseCategories)
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 32),

                        // Submit button
                        Consumer<TransactionProvider>(
                          builder: (context, provider, child) {
                            return CustomButton(
                              onPressed:
                                  provider.status == TransactionStatus.loading
                                  ? null
                                  : _submitTransaction,
                              text: 'Ajouter la transaction',
                              isLoading:
                                  provider.status == TransactionStatus.loading,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
