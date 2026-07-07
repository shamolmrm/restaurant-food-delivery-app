import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/food_item_model.dart';
import '../core/constants/dummy_data.dart';

enum SearchResultType { restaurants, foods }

class SearchProvider extends ChangeNotifier {
  String _query = '';
  bool _isLoading = false;
  SearchResultType _resultType = SearchResultType.restaurants;
  List<RestaurantModel> _restaurantResults = [];
  List<FoodItemModel> _foodResults = [];
  final List<String> _recentSearches = ['Burger', 'Kacchi', 'Pizza', 'Sushi'];
  final List<String> _trending = [
    'Smash Burger 🍔',
    'Kacchi Biryani 🍛',
    'Margherita Pizza 🍕',
    'Sushi Roll 🍱',
    'Red Velvet 🍰',
    'Chicken Wrap 🌯',
  ];

  String get query => _query;
  bool get isLoading => _isLoading;
  SearchResultType get resultType => _resultType;
  List<RestaurantModel> get restaurantResults => _restaurantResults;
  List<FoodItemModel> get foodResults => _foodResults;
  List<String> get recentSearches => _recentSearches;
  List<String> get trending => _trending;
  bool get hasResults =>
      _restaurantResults.isNotEmpty || _foodResults.isNotEmpty;

  Future<void> search(String query) async {
    _query = query;
    if (query.isEmpty) {
      _restaurantResults = [];
      _foodResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    final q = query.toLowerCase();
    _restaurantResults = dummyRestaurants.where((r) {
      return r.name.toLowerCase().contains(q) ||
          r.cuisine.toLowerCase().contains(q) ||
          r.categories.any((c) => c.toLowerCase().contains(q));
    }).toList();

    _foodResults = dummyFoodItems.where((f) {
      return f.name.toLowerCase().contains(q) ||
          f.description.toLowerCase().contains(q) ||
          f.category.toLowerCase().contains(q);
    }).toList();

    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setResultType(SearchResultType type) {
    _resultType = type;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _restaurantResults = [];
    _foodResults = [];
    notifyListeners();
  }

  void removeRecent(String search) {
    _recentSearches.remove(search);
    notifyListeners();
  }
}
