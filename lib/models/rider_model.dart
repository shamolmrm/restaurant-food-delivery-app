enum RiderStatus { available, onDelivery, offline }

class RiderModel {
  final String id;
  final String name;
  final String phone;
  final String photo;
  final RiderStatus status;
  final String? currentOrderId;
  final String? currentOrderAddress;
  final int totalDeliveries;
  final int todayDeliveries;
  final double rating;
  final String vehicle;
  final String area;

  const RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.photo,
    required this.status,
    this.currentOrderId,
    this.currentOrderAddress,
    required this.totalDeliveries,
    required this.todayDeliveries,
    required this.rating,
    required this.vehicle,
    required this.area,
  });
}
