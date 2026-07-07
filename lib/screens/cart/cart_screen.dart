import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponCtrl = TextEditingController();

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Cart 🛒',
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) {
              if (cart.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Clear Cart?'),
                      content: const Text(
                          'Are you sure you want to remove all items?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cart.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear',
                              style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Clear',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.error),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return const EmptyState(
              emoji: '🛒',
              title: 'Your cart is empty',
              subtitle:
                  'Add some delicious food to get started!',
              actionLabel: 'Browse Restaurants',
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...cart.items.map(
                      (ci) => Slidable(
                        key: ValueKey(ci.item.id),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (_) =>
                                  cart.removeItem(ci.item.id),
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              icon: Iconsax.trash,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                        child: _CartItemTile(cartItem: ci),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Coupon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponCtrl,
                              style: AppTextStyles.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Enter promo code',
                                hintStyle: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.textHint),
                                prefixIcon: const Icon(
                                    Iconsax.ticket_discount,
                                    color: AppColors.primary,
                                    size: 20),
                                filled: true,
                                fillColor: AppColors.surfaceVariant,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (cart.appliedCoupon != null) {
                                cart.removeCoupon();
                                _couponCtrl.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coupon removed'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                final code = _couponCtrl.text.trim();
                                if (code.isEmpty) return;
                                final applied = cart.applyCoupon(code);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(applied
                                        ? '🎉 Coupon applied!'
                                        : 'Invalid coupon code'),
                                    backgroundColor: applied
                                        ? AppColors.success
                                        : AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryLight
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                cart.appliedCoupon != null
                                    ? 'Remove'
                                    : 'Apply',
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Summary
                    _OrderSummary(cart: cart),

                    const SizedBox(height: 8),
                    Text(
                      '💡 Try codes: FIRST50, FREEDEL, BKASH20',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),

              // Checkout button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: AppShadows.bottomNavShadow,
                ),
                child: GradientButton(
                  label:
                      'Checkout • ৳${cart.total.toInt()}',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const CheckoutScreen()),
                  ),
                  suffix: const Icon(Iconsax.arrow_right_3,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: cartItem.item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceVariant,
                child: const Center(
                    child: Text('🍽️',
                        style: TextStyle(fontSize: 28))),
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
                        cartItem.item.name,
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cart.removeItem(cartItem.item.id),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Iconsax.trash, color: AppColors.error, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '৳${cartItem.item.price.toInt()} each',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => cart.updateQuantity(
                                cartItem.item.id, cartItem.quantity - 1),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.remove,
                                  size: 16, color: AppColors.primary),
                            ),
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: AppTextStyles.labelMedium,
                          ),
                          GestureDetector(
                            onTap: () =>
                                cart.updateQuantity(cartItem.item.id,
                                    cartItem.quantity + 1),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.add,
                                  size: 16, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '৳${cartItem.total.toInt()}',
                      style: AppTextStyles.priceSmall
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          _Row('Subtotal', '৳${cart.subtotal.toInt()}'),
          const SizedBox(height: 8),
          _Row(
            'Delivery fee',
            cart.deliveryFee == 0
                ? 'FREE'
                : '৳${cart.deliveryFee.toInt()}',
            valueColor:
                cart.deliveryFee == 0 ? AppColors.success : null,
          ),
          const SizedBox(height: 8),
          _Row('Platform fee', '৳${cart.platformFee.toInt()}'),
          if (cart.discount > 0) ...[
            const SizedBox(height: 8),
            _Row(
              'Discount (${cart.appliedCoupon})',
              '-৳${cart.discount.toInt()}',
              valueColor: AppColors.success,
            ),
          ],
          const Divider(height: 24),
          _Row(
            'Total',
            '৳${cart.total.toInt()}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _Row(this.label, this.value,
      {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTextStyles.titleLarge : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: (isBold
                  ? AppTextStyles.titleLarge
                  : AppTextStyles.bodyMedium)
              .copyWith(
            color: valueColor ??
                (isBold ? AppColors.primary : null),
            fontWeight: isBold ? FontWeight.w700 : null,
          ),
        ),
      ],
    );
  }
}
