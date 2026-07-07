import 'food_item_model.dart';
import 'address_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

class OrderItemModel {
  final FoodItemModel item;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.item,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;
}

class OrderModel {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final List<OrderItemModel> items;
  final AddressModel deliveryAddress;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime placedAt;
  final DateTime? estimatedDeliveryAt;
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final String? riderPhoto;
  final String? trackingNote;

  const OrderModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.items,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.placedAt,
    this.estimatedDeliveryAt,
    this.riderId,
    this.riderName,
    this.riderPhone,
    this.riderPhoto,
    this.trackingNote,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive => status != OrderStatus.delivered &&
      status != OrderStatus.cancelled;
}
