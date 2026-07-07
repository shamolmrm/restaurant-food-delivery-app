import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common/custom_app_bar.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().getOrderById(orderId) ??
        context.watch<OrderProvider>().orders.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      const _TrackStep(
        title: 'Order Confirmed',
        subtitle: 'Your order has been confirmed',
        icon: '✅',
        isDone: true,
      ),
      _TrackStep(
        title: 'Preparing Your Food',
        subtitle: 'The restaurant is cooking your order',
        icon: '👨‍🍳',
        isDone: order.status.index >= OrderStatus.preparing.index,
      ),
      _TrackStep(
        title: 'Rider Picked Up',
        subtitle: 'Rider has picked up your order',
        icon: '📦',
        isDone: order.status.index >= OrderStatus.pickedUp.index,
      ),
      _TrackStep(
        title: 'On the Way',
        subtitle: 'Your rider is heading to you',
        icon: '🛵',
        isDone: order.status.index >= OrderStatus.onTheWay.index,
        isActive: order.status == OrderStatus.onTheWay,
      ),
      _TrackStep(
        title: 'Delivered',
        subtitle: 'Enjoy your meal! 😋',
        icon: '🎉',
        isDone: order.status == OrderStatus.delivered,
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Track Order'),
      body: Column(
        children: [
          // Map placeholder
          Container(
            height: 220,
            color: const Color(0xFFE8F5E9),
            child: Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🗺️', style: TextStyle(fontSize: 60)),
                      SizedBox(height: 8),
                      Text(
                        'Live map view',
                        style: TextStyle(
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (order.trackingNote != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x1A000000), blurRadius: 10)
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('📍',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.trackingNote!,
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ETA card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Arrival',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            Text(
                              '~15 minutes',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          order.statusLabel,
                          style: AppTextStyles.labelMedium
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Rider info
                if (order.riderName != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: order.riderPhoto != null
                              ? NetworkImage(order.riderPhoto!)
                              : null,
                          backgroundColor: AppColors.primaryContainer,
                          child: order.riderPhoto == null
                              ? const Text('🛵',
                                  style: TextStyle(fontSize: 24))
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.riderName!,
                                  style: AppTextStyles.titleMedium),
                              Text('Your delivery rider',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  )),
                              const Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Color(0xFFFFB627), size: 14),
                                  Text(' 4.9',
                                      style: AppTextStyles.labelSmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _ActionBtn(
                              icon: Iconsax.call,
                              onTap: () {},
                            ),
                            const SizedBox(width: 8),
                            _ActionBtn(
                              icon: Iconsax.message,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                const Text('Order Status', style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),

                ...steps.asMap().entries.map(
                      (e) => _TimelineTile(
                        step: e.value,
                        isFirst: e.key == 0,
                        isLast: e.key == steps.length - 1,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackStep {
  final String title;
  final String subtitle;
  final String icon;
  final bool isDone;
  final bool isActive;

  const _TrackStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDone,
    this.isActive = false,
  });
}

class _TimelineTile extends StatelessWidget {
  final _TrackStep step;
  final bool isFirst;
  final bool isLast;

  const _TimelineTile({
    required this.step,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 44,
        height: 44,
        indicator: Container(
          decoration: BoxDecoration(
            color: step.isDone
                ? AppColors.success
                : step.isActive
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(step.icon, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
      beforeLineStyle: LineStyle(
        color: step.isDone ? AppColors.success : AppColors.border,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.title,
              style: AppTextStyles.titleSmall.copyWith(
                color: step.isDone
                    ? AppColors.success
                    : step.isActive
                        ? AppColors.primary
                        : AppColors.textTertiary,
              ),
            ),
            Text(
              step.subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}
