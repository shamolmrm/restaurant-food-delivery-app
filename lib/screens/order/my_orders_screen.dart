import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Orders',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTextStyles.labelMedium,
              tabs: const [Tab(text: 'Active'), Tab(text: 'Past')],
            ),
          ),
        ],
        showBack: true,
      ),
      body: Consumer<OrderProvider>(
        builder: (_, provider, __) => TabBarView(
          controller: _tabController,
          children: [
            _OrderList(orders: provider.activeOrders, isActive: true),
            _OrderList(orders: provider.pastOrders, isActive: false),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isActive;

  const _OrderList({required this.orders, required this.isActive});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyState(
        emoji: isActive ? '🛵' : '📋',
        title: isActive ? 'No active orders' : 'No past orders',
        subtitle: isActive
            ? 'Place an order and track it here'
            : 'Your order history will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        if (order.isActive) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OrderTrackingScreen(orderId: order.id),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: order.restaurantImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                          child: Text('🍽️',
                              style: TextStyle(fontSize: 24))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.restaurantName,
                          style: AppTextStyles.titleMedium),
                      Text(
                        '${order.items.length} items • ৳${order.total.toInt()}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusBadge(status: order.status),
                    ],
                  ),
                ),
                if (order.isActive)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Iconsax.location,
                        color: AppColors.primary, size: 18),
                  ),
              ],
            ),
            if (!order.isActive) ...[
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(order.placedAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Reorder',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.onTheWay:
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status == OrderStatus.confirmed
            ? 'Confirmed'
            : status == OrderStatus.preparing
                ? 'Preparing'
                : status == OrderStatus.onTheWay
                    ? 'On the Way 🛵'
                    : status == OrderStatus.delivered
                        ? 'Delivered ✅'
                        : status == OrderStatus.cancelled
                            ? 'Cancelled'
                            : 'Processing',
        style: AppTextStyles.badge.copyWith(color: _color),
      ),
    );
  }
}
