import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/food_item_model.dart';
import '../../providers/cart_provider.dart';
import '../loaders/shimmer_loader.dart';

class FoodCard extends StatelessWidget {
  final FoodItemModel food;
  final VoidCallback? onTap;

  const FoodCard({super.key, required this.food, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.cardRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: food.imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerLoader(
                      height: 130,
                      borderRadius: AppDimensions.cardRadius,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 130,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                          child: Text('🍽️',
                              style: TextStyle(fontSize: 36))),
                    ),
                  ),
                ),
                if (food.isBestseller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '🔥 Bestseller',
                        style: AppTextStyles.badge
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                if (food.hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${food.discountPercent.toInt()}%',
                        style: AppTextStyles.badge
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Iconsax.star5,
                          color: Color(0xFFFFB627), size: 11),
                      const SizedBox(width: 3),
                      Text('${food.rating}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            '৳${food.price.toInt()}',
                            style: AppTextStyles.priceSmall
                                .copyWith(
                                    color: AppColors.primary),
                          ),
                          if (food.hasDiscount)
                            Text(
                              '৳${food.originalPrice.toInt()}',
                              style: AppTextStyles.labelSmall
                                  .copyWith(
                                color: AppColors.textTertiary,
                                decoration:
                                    TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      _AddToCartButton(food: food),
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

class _AddToCartButton extends StatelessWidget {
  final FoodItemModel food;

  const _AddToCartButton({required this.food});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final qty = cart.getItemQuantity(food.id);
        if (qty > 0) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () =>
                      cart.updateQuantity(food.id, qty - 1),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.remove,
                        color: Colors.white, size: 16),
                  ),
                ),
                Text(
                  '$qty',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => cart.addItem(food),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.add,
                        color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          );
        }
        return GestureDetector(
          onTap: () => cart.addItem(food),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          ),
        );
      },
    );
  }
}
