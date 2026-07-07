import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C5E);
  static const Color primaryDark = Color(0xFFE04E1A);
  static const Color primaryContainer = Color(0xFFFFEDE6);

  static const Color secondary = Color(0xFFFFB627);
  static const Color secondaryLight = Color(0xFFFFCC60);
  static const Color secondaryDark = Color(0xFFD4940A);
  static const Color secondaryContainer = Color(0xFFFFF6E0);

  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  static const Color border = Color(0xFFE9ECEF);
  static const Color divider = Color(0xFFF1F3F5);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFFD1D5DB);

  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF242424);
  static const Color darkBorder = Color(0xFF2E2E2E);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color overlay = Color(0x80000000);
  static const Color shadowColor = Color(0x1A000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF8C5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFB627), Color(0xFFFFCC60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkOverlayGradient = LinearGradient(
    colors: [Colors.transparent, Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFB627)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF8C5E), Color(0xFFFFB627)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
