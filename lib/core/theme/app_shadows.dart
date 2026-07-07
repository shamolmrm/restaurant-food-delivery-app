import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x40FF6B35),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];

  static List<BoxShadow> primaryShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];
}
