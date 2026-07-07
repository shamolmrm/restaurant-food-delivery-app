import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/food_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/buttons/gradient_button.dart';

class FoodDetailSheet extends StatefulWidget {
  final FoodItemModel food;

  const FoodDetailSheet({super.key, required this.food});

  @override
  State<FoodDetailSheet> createState() => _FoodDetailSheetState();
}

class _FoodDetailSheetState extends State<FoodDetailSheet> {
  int _quantity = 1;
  String _size = 'Regular';
  double _spiceLevel = 1;
  final List<String> _selectedAddons = [];
  final _noteCtrl = TextEditingController();

  final _sizes = ['Regular', 'Large', 'XL'];
  final _addons = [
    {'name': 'Extra Cheese', 'price': 30},
    {'name': 'Extra Sauce', 'price': 20},
    {'name': 'Add Fries', 'price': 60},
    {'name': 'Extra Patty', 'price': 80},
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  double get _addonTotal => _selectedAddons.fold(0, (sum, name) {
        final addon = _addons.firstWhere((a) => a['name'] == name,
            orElse: () => {'price': 0});
        return sum + (addon['price'] as int).toDouble();
      });

  double get _total =>
      (widget.food.price + _addonTotal) * _quantity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  // Food image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.food.imageUrl,
                          height: 260,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      if (widget.food.isBestseller)
                        Positioned(
                          bottom: 12,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '🔥 Bestseller',
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.food.name,
                                style: AppTextStyles.headlineMedium,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '৳${widget.food.price.toInt()}',
                                  style: AppTextStyles.price.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (widget.food.hasDiscount)
                                  Text(
                                    '৳${widget.food.originalPrice.toInt()}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                      decoration:
                                          TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: widget.food.rating,
                              itemBuilder: (_, __) => const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFB627)),
                              itemCount: 5,
                              itemSize: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.food.rating} (${widget.food.reviewCount} reviews)',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _badge(
                              '⏱ ${widget.food.prepTime}',
                              AppColors.primaryContainer,
                              AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            _badge(
                              '🔥 ${widget.food.calories} cal',
                              AppColors.warningLight,
                              AppColors.warning,
                            ),
                            if (widget.food.isVegetarian) ...[
                              const SizedBox(width: 8),
                              _badge('🌿 Veg',
                                  AppColors.successLight,
                                  AppColors.success),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),
                        Text(
                          widget.food.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),

                        const Divider(height: 32),

                        // Size selector
                        const Text('Size', style: AppTextStyles.titleLarge),
                        const SizedBox(height: 10),
                        Row(
                          children: _sizes.map((s) {
                            final isSelected = _size == s;
                            return GestureDetector(
                              onTap: () => setState(() => _size = s),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 10),
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.darkSurfaceVariant
                                          : AppColors.surfaceVariant),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const Divider(height: 32),

                        // Add-ons
                        const Text('Add-ons',
                            style: AppTextStyles.titleLarge),
                        const SizedBox(height: 10),
                        ..._addons.map((addon) {
                          final name = addon['name'] as String;
                          final price = addon['price'] as int;
                          final isSelected =
                              _selectedAddons.contains(name);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedAddons.remove(name);
                                } else {
                                  _selectedAddons.add(name);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : (isDark
                                        ? AppColors.darkSurfaceVariant
                                        : AppColors.surfaceVariant),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.add_circle_outline,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textTertiary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(name,
                                        style: AppTextStyles.bodyMedium),
                                  ),
                                  Text(
                                    '+৳$price',
                                    style: AppTextStyles.labelMedium
                                        .copyWith(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const Divider(height: 32),

                        // Spice level
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Spice Level',
                                style: AppTextStyles.titleLarge),
                            Text(
                              _spiceLabel(_spiceLevel),
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _spiceLevel,
                          min: 0,
                          max: 3,
                          divisions: 3,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.border,
                          onChanged: (v) =>
                              setState(() => _spiceLevel = v),
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: ['Mild', 'Medium', 'Hot', 'Extra Hot']
                              .map((s) => Text(s,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textTertiary,
                                  )))
                              .toList(),
                        ),

                        const Divider(height: 32),

                        const Text('Special Instructions',
                            style: AppTextStyles.titleLarge),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _noteCtrl,
                          maxLines: 2,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'E.g. No onions, extra sauce...',
                            hintStyle: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textHint),
                            filled: true,
                            fillColor: isDark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          color: AppColors.primary,
                        ),
                        Text(
                          '$_quantity',
                          style: AppTextStyles.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => setState(() => _quantity++),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      label: 'Add to Cart • ৳${_total.toInt()}',
                      onPressed: () {
                        final cart = context.read<CartProvider>();
                        for (var i = 0; i < _quantity; i++) {
                          cart.addItem(widget.food);
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.food.name} added to cart!',
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(color: fg),
      ),
    );
  }

  String _spiceLabel(double level) {
    switch (level.toInt()) {
      case 0:
        return 'Mild 😊';
      case 1:
        return 'Medium 🌶️';
      case 2:
        return 'Hot 🔥';
      case 3:
        return 'Extra Hot 💥';
      default:
        return 'Mild';
    }
  }
}
