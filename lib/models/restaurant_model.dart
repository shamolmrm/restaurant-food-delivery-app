class RestaurantModel {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double minOrder;
  final String distance;
  final String imageUrl;
  final bool isOpen;
  final bool isFeatured;
  final List<String> categories;
  final String address;
  final double latitude;
  final double longitude;
  final String? description;
  final String? phoneNumber;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.distance,
    required this.imageUrl,
    required this.isOpen,
    required this.isFeatured,
    required this.categories,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.phoneNumber,
  });

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? cuisine,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    double? deliveryFee,
    double? minOrder,
    String? distance,
    String? imageUrl,
    bool? isOpen,
    bool? isFeatured,
    List<String>? categories,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    String? phoneNumber,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cuisine: cuisine ?? this.cuisine,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrder: minOrder ?? this.minOrder,
      distance: distance ?? this.distance,
      imageUrl: imageUrl ?? this.imageUrl,
      isOpen: isOpen ?? this.isOpen,
      isFeatured: isFeatured ?? this.isFeatured,
      categories: categories ?? this.categories,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
