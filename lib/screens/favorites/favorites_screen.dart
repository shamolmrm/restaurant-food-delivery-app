import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/cards/restaurant_card.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../restaurant/restaurant_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Favorites ❤️', showBack: false),
      body: Consumer<HomeProvider>(
        builder: (_, provider, __) {
          final favs = provider.getFavoriteRestaurants();
          if (favs.isEmpty) {
            return const EmptyState(
              emoji: '❤️',
              title: 'No favorites yet',
              subtitle:
                  'Tap the heart on any restaurant to save it here',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favs.length,
            itemBuilder: (_, i) => RestaurantCard(
              restaurant: favs[i],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      RestaurantDetailScreen(restaurantId: favs[i].id),
                ),
              ),
              isHorizontal: false,
            ),
          );
        },
      ),
    );
  }
}
