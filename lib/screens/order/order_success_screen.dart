import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../order/order_tracking_screen.dart';
import '../main/main_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success animation
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎉', style: TextStyle(fontSize: 72)),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 32),

              Text(
                'Order Placed!',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.success,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),

              const SizedBox(height: 12),

              Text(
                'Your order #${order.id.substring(order.id.length - 6)} has been placed successfully.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Restaurant',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            )),
                        Text(order.restaurantName,
                            style: AppTextStyles.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            )),
                        Text('৳${order.total.toInt()}',
                            style: AppTextStyles.priceSmall
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Delivery',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            )),
                        Text('30-45 min',
                            style: AppTextStyles.titleSmall
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),

              const Spacer(),

              GradientButton(
                label: 'Track Order 🛵',
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) =>
                        OrderTrackingScreen(orderId: order.id),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => const MainScreen()),
                  (route) => false,
                ),
                child: Text(
                  'Back to Home',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
