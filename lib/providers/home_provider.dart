import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/food_item_model.dart';
import '../models/category_model.dart';
import '../models/offer_model.dart';
import '../core/constants/dummy_data.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _selectedCategory = 'all';
  List<RestaurantModel> _restaurants = [];
  List<FoodItemModel> _trendingFoods = [];
  List<CategoryModel> _categories = [];
  List<OfferModel> _offers = [];
  final Set<String> _favoriteIds = {};

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  List<RestaurantModel> get restaurants => _restaurants;
  List<RestaurantModel> get featuredRestaurants =>
      _restaurants.where((r) => r.isFeatured).toList();
  List<FoodItemModel> get trendingFoods => _trendingFoods;
  List<CategoryModel> get categories => _categories;
  List<OfferModel> get offers => _offers;
  Set<String> get favoriteIds => _favoriteIds;

  List<RestaurantModel> get filteredRestaurants {
    if (_selectedCategory == 'all') return _restaurants;
    return _restaurants.where((r) {
      return r.cuisine.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
          r.categories.any((c) =>
              c.toLowerCase().contains(_selectedCategory.toLowerCase()));
    }).toList();
  }

  List<FoodItemModel> get filteredFoods {
    if (_selectedCategory == 'all') return _trendingFoods.take(6).toList();
    return dummyFoodItems.where((f) =>
      f.category.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
      f.name.toLowerCase().contains(_selectedCategory.toLowerCase())
    ).take(6).toList();
  }

  HomeProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _restaurants = dummyRestaurants;
    _trendingFoods = dummyFoodItems;
    _categories = dummyCategories;
    _offers = dummyOffers;

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String restaurantId) {
    if (_favoriteIds.contains(restaurantId)) {
      _favoriteIds.remove(restaurantId);
    } else {
      _favoriteIds.add(restaurantId);
    }
    notifyListeners();
  }

  bool isFavorite(String restaurantId) => _favoriteIds.contains(restaurantId);

  List<RestaurantModel> getFavoriteRestaurants() {
    return _restaurants.where((r) => _favoriteIds.contains(r.id)).toList();
  }
}
