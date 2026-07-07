import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/food_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../widgets/cards/food_card.dart';
import '../../widgets/loaders/shimmer_loader.dart';
import '../food/food_detail_screen.dart';
import '../cart/cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RestaurantProvider>()
          .loadRestaurant(widget.restaurantId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final restaurant = provider.currentRestaurant;
          if (restaurant == null) return const SizedBox();

          return NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.surface,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
                actions: [
                  badges.Badge(
                    showBadge: cartCount > 0,
                    badgeContent: Text('$cartCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    badgeStyle: const badges.BadgeStyle(
                        badgeColor: AppColors.error,
                        padding: EdgeInsets.all(4)),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Iconsax.bag_2,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: restaurant.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ShimmerLoader(
                            height: 260, borderRadius: 0),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                              child: Text('🍽️',
                                  style: TextStyle(fontSize: 60))),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.darkOverlayGradient,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
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
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              restaurant.name,
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant.cuisine,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _InfoTile(
                            icon: Iconsax.star5,
                            label: '${restaurant.rating}',
                            subtitle: '(${restaurant.reviewCount})',
                            color: const Color(0xFFFFB627),
                          ),
                          _divider(),
                          _InfoTile(
                            icon: Iconsax.timer,
                            label: restaurant.deliveryTime,
                            subtitle: 'Delivery',
                          ),
                          _divider(),
                          _InfoTile(
                            icon: Iconsax.location,
                            label: restaurant.distance,
                            subtitle: 'Away',
                          ),
                          _divider(),
                          _InfoTile(
                            icon: Iconsax.wallet,
                            label: restaurant.deliveryFee == 0
                                ? 'Free'
                                : '৳${restaurant.deliveryFee.toInt()}',
                            subtitle: 'Delivery',
                            color: restaurant.deliveryFee == 0
                                ? AppColors.success
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: AppTextStyles.labelLarge,
                    tabs: const [
                      Tab(text: 'Menu'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Info'),
                    ],
                  ),
                  isDark: isDark,
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _MenuTab(provider: provider),
                _ReviewsTab(provider: provider),
                _InfoTab(restaurant: restaurant),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _divider() => Container(
      height: 36,
      width: 1,
      color: AppColors.border.withValues(alpha: 0.5));
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: color ?? AppColors.textPrimary,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _MenuTab extends StatelessWidget {
  final RestaurantProvider provider;
  const _MenuTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    final categories = provider.menuCategories;
    final foods = provider.filteredMenu;

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              final isSelected = provider.selectedMenuCategory == cat;
              return GestureDetector(
                onTap: () => provider.setMenuCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cat,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: foods.length,
            itemBuilder: (_, i) => FoodCard(
              food: foods[i],
              onTap: () => _showFoodDetail(context, foods[i]),
            ),
          ),
        ),
      ],
    );
  }

  void _showFoodDetail(BuildContext context, FoodItemModel food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FoodDetailSheet(food: food),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final RestaurantProvider provider;
  const _ReviewsTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    final reviews = provider.reviews;
    final avg = provider.avgRating;
    final breakdown = provider.ratingBreakdown;
    final total = reviews.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.primary,
                      fontSize: 48,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: avg,
                    itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Color(0xFFFFB627)),
                    itemCount: 5,
                    itemSize: 16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$total reviews',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = breakdown[star] ?? 0;
                    final pct = total > 0 ? count / total : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Text('$star',
                              style: AppTextStyles.labelSmall),
                          const SizedBox(width: 4),
                          const Icon(Icons.star,
                              color: Color(0xFFFFB627), size: 12),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct.toDouble(),
                                backgroundColor: AppColors.border,
                                valueColor:
                                    const AlwaysStoppedAnimation(
                                        AppColors.secondary),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$count',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textTertiary,
                              )),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...reviews.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: r.userPhoto != null
                            ? NetworkImage(r.userPhoto!)
                            : null,
                        backgroundColor: AppColors.primaryContainer,
                        child: r.userPhoto == null
                            ? Text(
                                r.userName[0],
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.userName,
                                style: AppTextStyles.titleSmall),
                            Text(
                              _timeAgo(r.createdAt),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RatingBarIndicator(
                        rating: r.rating,
                        itemBuilder: (_, __) =>
                            const Icon(Icons.star,
                                color: Color(0xFFFFB627)),
                        itemCount: 5,
                        itemSize: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    r.comment,
                    style: AppTextStyles.bodySmall.copyWith(height: 1.6),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}

class _InfoTab extends StatelessWidget {
  final dynamic restaurant;
  const _InfoTab({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('About', style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              Text(
                restaurant.description ??
                    'A great restaurant with delicious food.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _InfoRow(icon: Iconsax.location, label: restaurant.address),
        _InfoRow(
            icon: Iconsax.call,
            label: restaurant.phoneNumber ?? '+880 1700 000000'),
        const _InfoRow(
          icon: Iconsax.timer,
          label: 'Open daily 10:00 AM - 11:00 PM',
        ),
        _InfoRow(
          icon: Iconsax.truck,
          label:
              'Delivery in ${restaurant.deliveryTime} • Min order ৳${restaurant.minOrder.toInt()}',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _TabBarDelegate(this.tabBar, {required this.isDark});

  @override
  double get minExtent => tabBar.preferredSize.height + 1;

  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}
