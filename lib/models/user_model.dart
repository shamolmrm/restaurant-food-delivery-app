class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final int loyaltyPoints;
  final double totalSavings;
  final int totalOrders;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.loyaltyPoints = 0,
    this.totalSavings = 0,
    this.totalOrders = 0,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    int? loyaltyPoints,
    double? totalSavings,
    int? totalOrders,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      totalSavings: totalSavings ?? this.totalSavings,
      totalOrders: totalOrders ?? this.totalOrders,
      createdAt: createdAt,
    );
  }
}
