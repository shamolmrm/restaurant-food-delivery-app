import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/restaurant_model.dart';
import '../../providers/home_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/cards/food_card.dart';
import '../../widgets/cards/offer_card.dart';
import '../../widgets/cards/restaurant_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/loaders/shimmer_loader.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../search/search_screen.dart';
import '../notifications/notifications_screen.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _offerController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _offerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const _HomeShimmer();
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => provider.loadData(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HomeHeader(isDark: isDark),
                ),
                SliverToBoxAdapter(
                  child: _SearchBar(onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SearchScreen()),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: _OffersCarousel(
                    controller: _offerController,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _CategoriesRow(),
                ),
                SliverToBoxAdapter(
                  child: _PopularRestaurants(),
                ),
                SliverToBoxAdapter(
                  child: _TrendingSection(),
                ),
                SliverToBoxAdapter(
                  child: _TodaysSpecials(),
                ),
                SliverToBoxAdapter(
                  child: _PromoBanner(),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final bool isDark;
  const _HomeHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final notifCount =
        context.watch<NotificationProvider>().unreadCount;
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.location5,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Deliver to',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Bashundhara, Dhaka',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          badges.Badge(
            showBadge: notifCount > 0,
            badgeContent: Text(
              '$notifCount',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: AppColors.error,
              padding: EdgeInsets.all(4),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const NotificationsScreen()),
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Iconsax.notification,
                  size: 22,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Iconsax.search_normal,
                color: AppColors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Search restaurants or dishes...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.setting_4,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OffersCarousel extends StatefulWidget {
  final PageController controller;
  const _OffersCarousel({required this.controller});

  @override
  State<_OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<_OffersCarousel> {
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final offers = context.read<HomeProvider>().offers;
      if (offers.length < 2) return;
      final next = (_page + 1) % offers.length;
      widget.controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offers = context.watch<HomeProvider>().offers;
    if (offers.isEmpty) return const SizedBox();

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: widget.controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: offers.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: OfferCard(offer: offers[index]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _page,
          count: offers.length,
          effect: const WormEffect(
            dotColor: AppColors.border,
            activeDotColor: AppColors.primary,
            dotHeight: 6,
            dotWidth: 6,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final categories = provider.categories;
    final selected = provider.selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SectionHeader(title: '🍽️ Categories'),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length + 1,
            itemBuilder: (_, index) {
              if (index == 0) {
                final isAll = selected == 'all';
                return GestureDetector(
                  onTap: () => provider.setCategory('all'),
                  child: _CategoryChip(
                    emoji: '🍽️',
                    label: 'All',
                    isSelected: isAll,
                    color: AppColors.primary,
                  ),
                );
              }
              final cat = categories[index - 1];
              final isSelected =
                  selected.toLowerCase() == cat.name.toLowerCase();
              return GestureDetector(
                onTap: () => provider.setCategory(cat.name),
                child: _CategoryChip(
                  emoji: cat.emoji,
                  label: cat.name,
                  isSelected: isSelected,
                  color: cat.color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final Color color;

  const _CategoryChip({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? color : (isDark ? AppColors.darkSurfaceVariant : AppColors.surface),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : AppColors.border,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected
                  ? color
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularRestaurants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final filtered = provider.filteredRestaurants;
    final featured = filtered.where((r) => r.isFeatured).toList();
    final restaurants = featured.isEmpty ? filtered : featured;
    if (restaurants.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: SectionHeader(
            title: 'Popular Near You 🔥',
            actionLabel: 'See All',
            onAction: () {},
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: restaurants.length,
            itemBuilder: (_, index) => RestaurantCard(
              restaurant: restaurants[index],
              onTap: () => _openRestaurant(context, restaurants[index]),
              isHorizontal: true,
            ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2),
          ),
        ),
      ],
    );
  }

  void _openRestaurant(BuildContext context, RestaurantModel r) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestaurantDetailScreen(restaurantId: r.id),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurants =
        context.watch<HomeProvider>().filteredRestaurants.take(3).toList();
    if (restaurants.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: SectionHeader(
            title: 'Trending Now 📈',
            actionLabel: 'See All',
            onAction: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: restaurants
                .map(
                  (r) => RestaurantCard(
                    restaurant: r,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            RestaurantDetailScreen(restaurantId: r.id),
                      ),
                    ),
                    isHorizontal: false,
                  ).animate().fadeIn(),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _TodaysSpecials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foods = context.watch<HomeProvider>().filteredFoods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: SectionHeader(
            title: "Today's Specials ⭐",
            actionLabel: 'See All',
            onAction: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: foods.length.clamp(0, 6),
            itemBuilder: (_, index) => AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 400),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: FoodCard(food: foods[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'LIMITED TIME',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'FREE delivery on\nyour first 3 orders!',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Order Now',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Text('🎉', style: TextStyle(fontSize: 72)),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3);
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const ShimmerLoader(height: 52),
          const SizedBox(height: 16),
          const ShimmerLoader(height: 150, borderRadius: 16),
          const SizedBox(height: 24),
          Row(
            children: List.generate(
              4,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    ShimmerLoader(width: 56, height: 56, borderRadius: 28),
                    SizedBox(height: 8),
                    ShimmerLoader(width: 44, height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const ShimmerLoader(height: 20, width: 160),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              2,
              (_) => const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerRestaurantCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
