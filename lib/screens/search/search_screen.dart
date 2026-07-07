import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/search_provider.dart';
import '../../widgets/cards/food_card.dart';
import '../../widgets/cards/restaurant_card.dart';
import '../../widgets/common/empty_state.dart';
import '../restaurant/restaurant_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      onChanged: (v) =>
                          context.read<SearchProvider>().search(v),
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search restaurants, dishes...',
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
                        prefixIcon: const Icon(Iconsax.search_normal,
                            color: AppColors.textTertiary, size: 20),
                        suffixIcon: Consumer<SearchProvider>(
                          builder: (_, p, __) => p.query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close,
                                      color: AppColors.textTertiary,
                                      size: 20),
                                  onPressed: () {
                                    _ctrl.clear();
                                    p.clearSearch();
                                  },
                                )
                              : const SizedBox(),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (_, provider, __) {
                  if (provider.query.isEmpty) {
                    return _DefaultContent(provider: provider);
                  }
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (!provider.hasResults) {
                    return const EmptyState(
                      emoji: '🔍',
                      title: 'No results found',
                      subtitle:
                          'Try searching for something else',
                    );
                  }
                  return _Results(provider: provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultContent extends StatelessWidget {
  final SearchProvider provider;
  const _DefaultContent({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (provider.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches',
                  style: AppTextStyles.titleLarge),
              GestureDetector(
                onTap: () {},
                child: Text('Clear all',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.recentSearches
                .map((s) => _SearchChip(
                      label: s,
                      icon: Iconsax.clock,
                      onTap: () => context
                          .read<SearchProvider>()
                          .search(s),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        const Text('Trending 🔥', style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.trending
              .map((s) => _SearchChip(
                    label: s,
                    icon: Iconsax.chart_2,
                    onTap: () =>
                        context.read<SearchProvider>().search(s),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SearchChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final SearchProvider provider;
  const _Results({required this.provider});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                  text:
                      'Restaurants (${provider.restaurantResults.length})'),
              Tab(text: 'Dishes (${provider.foodResults.length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                provider.restaurantResults.isEmpty
                    ? const EmptyState(
                        emoji: '🏪',
                        title: 'No restaurants',
                        subtitle: 'Try a different search')
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.restaurantResults.length,
                        itemBuilder: (_, i) => RestaurantCard(
                          restaurant: provider.restaurantResults[i],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                restaurantId:
                                    provider.restaurantResults[i].id,
                              ),
                            ),
                          ),
                          isHorizontal: false,
                        ),
                      ),
                provider.foodResults.isEmpty
                    ? const EmptyState(
                        emoji: '🍽️',
                        title: 'No dishes found',
                        subtitle: 'Try a different search')
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: provider.foodResults.length,
                        itemBuilder: (_, i) =>
                            FoodCard(food: provider.foodResults[i]),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
