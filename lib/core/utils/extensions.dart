import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPhone => RegExp(r'^(\+88)?01[3-9]\d{8}$').hasMatch(this);
}

extension NumExtensions on num {
  String get asCurrency => '৳${toStringAsFixed(0)}';

  String get asRating => toStringAsFixed(1);

  String formatCount() {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}k';
    return toString();
  }
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor => isDark ? AppColors.darkSurface : AppColors.surface;
  Color get textColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get subtextColor =>
      isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get bgColor =>
      isDark ? AppColors.darkBackground : AppColors.background;
  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.border;

  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

extension DateExtensions on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '$day/$month/$year';
  }

  String get formatted => '$day/$month/$year';

  String get timeFormatted {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $suffix';
  }
}
