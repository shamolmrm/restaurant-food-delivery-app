import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final Color? backgroundColor;
  final Color? titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = true,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: backgroundColor ??
          (isDark ? AppColors.darkSurface : AppColors.surface),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBack
          ? leading ??
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Iconsax.arrow_left,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
          : leading,
      title: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: titleColor ??
              (isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary),
        ),
      ),
      actions: actions,
    );
  }
}
