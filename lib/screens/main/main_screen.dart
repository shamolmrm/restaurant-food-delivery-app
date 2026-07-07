import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../cart/cart_screen.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = context.watch<CartProvider>().itemCount;
    final notifCount = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToCart(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: badges.Badge(
          showBadge: cartCount > 0,
          badgeContent: Text(
            '$cartCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: AppColors.error,
            padding: EdgeInsets.all(4),
          ),
          child: const Icon(Iconsax.bag_2, color: Colors.white, size: 24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 4,
        indicatorColor: AppColors.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: Icon(Iconsax.home,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
            selectedIcon: const Icon(Iconsax.home5, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: badges.Badge(
              showBadge: false,
              child: Icon(Iconsax.heart,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
            ),
            selectedIcon:
                const Icon(Iconsax.heart5, color: AppColors.primary),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: badges.Badge(
              showBadge: notifCount > 0,
              badgeContent: Text(
                '$notifCount',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
              badgeStyle: const badges.BadgeStyle(
                  badgeColor: AppColors.error, padding: EdgeInsets.all(3)),
              child: Icon(Iconsax.user,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
            ),
            selectedIcon:
                const Icon(Iconsax.user5, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _goToCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }
}
