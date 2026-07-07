class AddressModel {
  final String id;
  final String label;
  final String fullAddress;
  final String area;
  final String city;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.area,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? label,
    String? fullAddress,
    String? area,
    String? city,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      area: area ?? this.area,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
