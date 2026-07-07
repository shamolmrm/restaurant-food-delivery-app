class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String restaurantId;
  final double rating;
  final String comment;
  final List<String> photoUrls;
  final DateTime createdAt;
  final String? orderItems;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.restaurantId,
    required this.rating,
    required this.comment,
    this.photoUrls = const [],
    required this.createdAt,
    this.orderItems,
  });
}
