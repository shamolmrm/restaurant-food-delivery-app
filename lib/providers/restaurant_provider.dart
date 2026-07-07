import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/food_item_model.dart';
import '../models/review_model.dart';
import '../core/constants/dummy_data.dart';

class RestaurantProvider extends ChangeNotifier {
  RestaurantModel? _currentRestaurant;
  List<FoodItemModel> _menuItems = [];
  List<ReviewModel> _reviews = [];
  String _selectedMenuCategory = 'All';
  bool _isLoading = false;

  RestaurantModel? get currentRestaurant => _currentRestaurant;
  List<FoodItemModel> get menuItems => _menuItems;
  List<ReviewModel> get reviews => _reviews;
  String get selectedMenuCategory => _selectedMenuCategory;
  bool get isLoading => _isLoading;

  List<String> get menuCategories {
    final categories = <String>{'All'};
    for (final item in _menuItems) {
      categories.add(item.category);
    }
    return categories.toList();
  }

  List<FoodItemModel> get filteredMenu {
    if (_selectedMenuCategory == 'All') return _menuItems;
    return _menuItems
        .where((i) => i.category == _selectedMenuCategory)
        .toList();
  }

  double get avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.fold(0.0, (sum, r) => sum + r.rating) / _reviews.length;
  }

  Map<int, int> get ratingBreakdown {
    final map = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in _reviews) {
      final star = r.rating.round().clamp(1, 5);
      map[star] = (map[star] ?? 0) + 1;
    }
    return map;
  }

  Future<void> loadRestaurant(String restaurantId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _currentRestaurant = dummyRestaurants.firstWhere(
      (r) => r.id == restaurantId,
      orElse: () => dummyRestaurants.first,
    );
    _menuItems = dummyFoodItems
        .where((f) => f.restaurantId == restaurantId)
        .toList();
    if (_menuItems.isEmpty) {
      _menuItems = dummyFoodItems.take(4).toList();
    }
    _reviews = dummyReviews
        .where((r) => r.restaurantId == restaurantId)
        .toList();
    if (_reviews.isEmpty) {
      _reviews = dummyReviews;
    }
    _selectedMenuCategory = 'All';

    _isLoading = false;
    notifyListeners();
  }

  void setMenuCategory(String category) {
    _selectedMenuCategory = category;
    notifyListeners();
  }
}
