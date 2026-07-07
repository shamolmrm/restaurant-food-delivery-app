import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../providers/address_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../order/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;

  final _paymentMethods = [
    {'id': 'bkash', 'name': 'bKash', 'icon': '💜', 'desc': 'Mobile banking'},
    {'id': 'nagad', 'name': 'Nagad', 'icon': '🟠', 'desc': 'Mobile banking'},
    {'id': 'card', 'name': 'Credit/Debit Card', 'icon': '💳', 'desc': 'Visa, Mastercard'},
    {'id': 'cod', 'name': 'Cash on Delivery', 'icon': '💵', 'desc': 'Pay when delivered'},
  ];

  String _selectedPayment = 'cod';

  final _steps = ['Address', 'Payment', 'Confirm'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                StepProgressIndicator(
                  totalSteps: 3,
                  currentStep: _step + 1,
                  size: 6,
                  selectedColor: AppColors.primary,
                  unselectedColor: AppColors.border,
                  roundedEdges: const Radius.circular(4),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _steps.asMap().entries.map((e) {
                    final isDone = e.key < _step;
                    final isActive = e.key == _step;
                    return Text(
                      e.value,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDone || isActive
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          Expanded(
            child: _buildCurrentStep(context, isDark),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              boxShadow: AppShadows.bottomNavShadow,
            ),
            child: _step < 2
                ? GradientButton(
                    label: 'Continue',
                    onPressed: () => setState(() => _step++),
                  )
                : Consumer<OrderProvider>(
                    builder: (_, orderProvider, __) => GradientButton(
                      label: 'Place Order',
                      isLoading: orderProvider.isPlacing,
                      onPressed: () => _placeOrder(context),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, bool isDark) {
    switch (_step) {
      case 0:
        return _AddressStep(isDark: isDark);
      case 1:
        return _PaymentStep(
          paymentMethods: _paymentMethods,
          selected: _selectedPayment,
          onSelect: (id) {
            setState(() => _selectedPayment = id);
            context.read<CartProvider>().setPayment(
                _paymentMethods.firstWhere((p) => p['id'] == id)['name'] as String);
          },
        );
      case 2:
        return _ConfirmStep(
            selectedPayment: _paymentMethods
                .firstWhere((p) => p['id'] == _selectedPayment));
      default:
        return const SizedBox();
    }
  }

  Future<void> _placeOrder(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();
    final address = context.read<AddressProvider>().selected;
    final nav = Navigator.of(context);

    if (address == null) return;

    final items = cart.items
        .map((ci) => OrderItemModel(
              item: ci.item,
              quantity: ci.quantity,
              price: ci.item.price,
            ))
        .toList();

    final order = await orders.placeOrder(
      restaurantId: cart.items.first.item.restaurantId,
      restaurantName: 'Restaurant',
      restaurantImage: cart.items.first.item.imageUrl,
      items: items,
      deliveryAddress: address,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      discount: cart.discount,
      total: cart.total,
      paymentMethod: cart.selectedPayment,
    );

    if (!mounted) return;
    cart.clear();
    if (order != null) {
      nav.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: order),
        ),
        (route) => route.isFirst,
      );
    }
  }
}

class _AddressStep extends StatelessWidget {
  final bool isDark;
  const _AddressStep({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Delivery Address', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        ...addressProvider.addresses.map((a) => GestureDetector(
              onTap: () => addressProvider.selectAddress(a),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: addressProvider.selected?.id == a.id
                        ? AppColors.primary
                        : AppColors.border,
                    width:
                        addressProvider.selected?.id == a.id ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: addressProvider.selected?.id == a.id
                            ? AppColors.primaryContainer
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        a.label == 'Home'
                            ? Iconsax.home
                            : Iconsax.building,
                        color: addressProvider.selected?.id == a.id
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(a.label,
                                  style: AppTextStyles.titleSmall),
                              if (a.isDefault) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius:
                                        BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Default',
                                    style: AppTextStyles.badge.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            a.fullAddress,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (addressProvider.selected?.id == a.id)
                      const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.primary, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Add New Address',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final List<Map<String, String>> paymentMethods;
  final String selected;
  final ValueChanged<String> onSelect;

  const _PaymentStep({
    required this.paymentMethods,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Payment Method', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        ...paymentMethods.map((method) {
          final isSelected = selected == method['id'];
          return GestureDetector(
            onTap: () => onSelect(method['id']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(method['icon']!,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(method['name']!,
                            style: AppTextStyles.titleSmall),
                        Text(
                          method['desc']!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle,
                        color: AppColors.primary, size: 22),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ConfirmStep extends StatelessWidget {
  final Map<String, String> selectedPayment;
  const _ConfirmStep({required this.selectedPayment});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final address = context.watch<AddressProvider>().selected;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Order Summary', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: cart.items
                .map((ci) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text('${ci.quantity}x',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                              )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(ci.item.name,
                                style: AppTextStyles.bodyMedium),
                          ),
                          Text('৳${ci.total.toInt()}',
                              style: AppTextStyles.labelMedium),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 12),

        if (address != null)
          _InfoCard(
            icon: Iconsax.location,
            title: 'Delivery to ${address.label}',
            subtitle: address.fullAddress,
          ),

        const SizedBox(height: 8),

        _InfoCard(
          icon: Icons.payment,
          title: 'Payment',
          subtitle:
              '${selectedPayment['icon']} ${selectedPayment['name']}',
        ),

        const SizedBox(height: 8),

        const _InfoCard(
          icon: Iconsax.timer,
          title: 'Estimated Delivery',
          subtitle: '30-45 minutes',
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _TotalRow('Subtotal', '৳${cart.subtotal.toInt()}'),
              _TotalRow(
                  'Delivery',
                  cart.deliveryFee == 0
                      ? 'FREE'
                      : '৳${cart.deliveryFee.toInt()}'),
              _TotalRow('Platform fee',
                  '৳${cart.platformFee.toInt()}'),
              if (cart.discount > 0)
                _TotalRow(
                    'Discount', '-৳${cart.discount.toInt()}',
                    color: AppColors.success),
              const Divider(height: 20),
              _TotalRow(
                  'Total', '৳${cart.total.toInt()}',
                  isBold: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelMedium),
              Text(subtitle,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _TotalRow(this.label, this.value,
      {this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.titleSmall
                : AppTextStyles.bodyMedium,
          ),
          Text(
            value,
            style: (isBold
                    ? AppTextStyles.titleSmall
                    : AppTextStyles.bodyMedium)
                .copyWith(
              color: color ?? (isBold ? AppColors.primary : null),
              fontWeight: isBold ? FontWeight.w700 : null,
            ),
          ),
        ],
      ),
    );
  }
}
