import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/router_config.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';

void main() {
  runApp(const BudgetZenApp());
}

class BudgetZenApp extends StatelessWidget {
  const BudgetZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'BudgetZen',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
