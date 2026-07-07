class FoodItemModel {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String category;
  final bool isBestseller;
  final bool isVegetarian;
  final bool isSpicy;
  final int calories;
  final String prepTime;
  final List<String> badges;
  int quantity;

  FoodItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.category,
    required this.isBestseller,
    required this.isVegetarian,
    required this.isSpicy,
    required this.calories,
    required this.prepTime,
    required this.badges,
    this.quantity = 0,
  });

  bool get hasDiscount => originalPrice > price;
  double get discountPercent =>
      hasDiscount ? ((originalPrice - price) / originalPrice * 100) : 0;

  FoodItemModel copyWith({int? quantity}) {
    return FoodItemModel(
      id: id,
      restaurantId: restaurantId,
      name: name,
      description: description,
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      category: category,
      isBestseller: isBestseller,
      isVegetarian: isVegetarian,
      isSpicy: isSpicy,
      calories: calories,
      prepTime: prepTime,
      badges: badges,
      quantity: quantity ?? this.quantity,
    );
  }
}
