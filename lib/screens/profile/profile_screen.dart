import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../notifications/notifications_screen.dart';
import '../order/my_orders_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(isDark: isDark, user: user),
          ),
          SliverToBoxAdapter(
            child: _StatsRow(user: user),
          ),
          SliverToBoxAdapter(
            child: _MenuSection(isDark: isDark),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool isDark;
  final dynamic user;

  const _ProfileHeader({required this.isDark, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 24,
        right: 24,
        bottom: 28,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Profile',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Iconsax.setting_2,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : '😊',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.edit,
                          color: AppColors.primary, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Guest User',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    if (user?.phone != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user!.phone!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final dynamic user;
  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            value: '${user?.totalOrders ?? 0}',
            label: 'Orders',
            emoji: '🍽️',
          ),
          _divider(),
          _StatItem(
            value: '${user?.loyaltyPoints ?? 0}',
            label: 'Points',
            emoji: '⭐',
          ),
          _divider(),
          _StatItem(
            value: '৳${user?.totalSavings.toInt() ?? 0}',
            label: 'Savings',
            emoji: '💰',
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
      width: 1, height: 40, color: AppColors.border);
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;

  const _StatItem({
    required this.value,
    required this.label,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleLarge),
          Text(
            label,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final bool isDark;
  const _MenuSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(
          icon: Iconsax.bag_2,
          label: 'My Orders',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyOrdersScreen()))),
      _MenuItem(
          icon: Iconsax.notification,
          label: 'Notifications',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()))),
      _MenuItem(
          icon: Iconsax.location,
          label: 'Saved Addresses',
          onTap: () {}),
      _MenuItem(
          icon: Iconsax.wallet,
          label: 'Payment Methods',
          onTap: () {}),
      _MenuItem(
          icon: Iconsax.people,
          label: 'Invite Friends',
          badge: '৳100',
          onTap: () {}),
      _MenuItem(
          icon: Iconsax.message_question,
          label: 'Help Center',
          onTap: () {}),
      _MenuItem(
          icon: Iconsax.setting_2,
          label: 'Settings',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()))),
      _MenuItem(
          icon: Iconsax.star,
          label: 'Rate the App',
          onTap: () {}),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 10,
                    offset: Offset(0, 2))
              ],
            ),
            child: Column(
              children: menuItems
                  .asMap()
                  .entries
                  .map((e) => _MenuTile(
                        item: e.value,
                        isLast: e.key == menuItems.length - 1,
                        isDark: isDark,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Logout
          GestureDetector(
            onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.logout,
                      color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Sign Out',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  final bool isLast;
  final bool isDark;

  const _MenuTile({
    required this.item,
    required this.isLast,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(item.label, style: AppTextStyles.titleSmall),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.badge!,
                  style: AppTextStyles.badge
                      .copyWith(color: AppColors.success),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
