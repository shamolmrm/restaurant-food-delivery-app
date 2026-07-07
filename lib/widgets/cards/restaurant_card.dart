import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/restaurant_model.dart';
import '../../providers/home_provider.dart';
import '../loaders/shimmer_loader.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;
  final bool isHorizontal;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? _HorizontalCard(restaurant: restaurant, onTap: onTap)
        : _VerticalCard(restaurant: restaurant, onTap: onTap);
  }
}

class _HorizontalCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const _HorizontalCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.cardRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerLoader(
                      width: double.infinity,
                      height: 140,
                      borderRadius: AppDimensions.cardRadius,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 140,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                          child: Text('🍽️',
                              style: TextStyle(fontSize: 40))),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.cardRadius),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.darkOverlayGradient,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: restaurant.isOpen
                          ? AppColors.success
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      restaurant.isOpen ? 'Open' : 'Closed',
                      style: AppTextStyles.badge
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _FavoriteButton(
                      restaurantId: restaurant.id),
                ),
                Positioned(
                  bottom: 8,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      _InfoChip(
                          icon: Iconsax.timer,
                          label: restaurant.deliveryTime),
                      const SizedBox(width: 6),
                      _InfoChip(
                          icon: Iconsax.location,
                          label: restaurant.distance),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Iconsax.star5,
                          color: Color(0xFFFFB627), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.rating}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${_formatCount(restaurant.reviewCount)})',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        restaurant.deliveryFee == 0
                            ? 'Free delivery'
                            : '৳${restaurant.deliveryFee.toInt()} delivery',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: restaurant.deliveryFee == 0
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

class _VerticalCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const _VerticalCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ShimmerLoader(
                    width: 90, height: 90, borderRadius: 12),
                errorWidget: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: AppColors.surfaceVariant,
                  child: const Center(
                      child: Text('🍽️',
                          style: TextStyle(fontSize: 32))),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _FavoriteButton(
                          restaurantId: restaurant.id, small: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _SmallInfo(
                          icon: Iconsax.star5,
                          label: '${restaurant.rating}',
                          color: const Color(0xFFFFB627)),
                      _SmallInfo(
                          icon: Iconsax.timer,
                          label: restaurant.deliveryTime),
                      _SmallInfo(
                          icon: Iconsax.location,
                          label: restaurant.distance),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final String restaurantId;
  final bool small;

  const _FavoriteButton(
      {required this.restaurantId, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final isFav = provider.isFavorite(restaurantId);
        return GestureDetector(
          onTap: () => provider.toggleFavorite(restaurantId),
          child: Container(
            padding: EdgeInsets.all(small ? 4 : 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppColors.error : AppColors.textSecondary,
              size: small ? 16 : 20,
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.badge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SmallInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _SmallInfo(
      {required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 12,
            color: color ??
                (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary)),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
