import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFA28EF9); // #a28ef9
  static const Color secondary = Color(0xFF6366F1); // Couleur secondaire
  static const Color accent = Color(0xFFEC4899); // Couleur accent
  static const Color success = Color(0xFFA4F5A6); // #a4f5a6
  static const Color warning = Color(0xFFFFD89D); // #ffd89d
  static const Color info = Color(0xFF3B82F6); // Couleur info
  static const Color background = Color(0xFFECEEF0); // #eceef0

  // Variations of primary colors
  static const Color primaryLight = Color(0xFFB8A5FB);
  static const Color primaryDark = Color(0xFF8B77F7);
  static const Color primaryExtraLight = Color(0xFFE5E0FE);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color white = Color(0xFFFFFFFF);

  // Additional UI colors
  static const Color error = Color(0xFFEF4444);
  static const Color border = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x1A000000);

  // Card and surface colors
  static const Color cardBackground = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFF8F9FA);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFFB8F7BA)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFFDE2A7)],
  );
}
