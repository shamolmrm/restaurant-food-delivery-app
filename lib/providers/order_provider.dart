import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../core/constants/dummy_data.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  OrderModel? _activeOrder;
  bool _isLoading = false;
  bool _isPlacing = false;

  List<OrderModel> get orders => _orders;
  OrderModel? get activeOrder => _activeOrder;
  bool get isLoading => _isLoading;
  bool get isPlacing => _isPlacing;

  List<OrderModel> get activeOrders =>
      _orders.where((o) => o.isActive).toList();
  List<OrderModel> get pastOrders =>
      _orders.where((o) => !o.isActive).toList();

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _orders = dummyOrders;
    if (_orders.any((o) => o.isActive)) {
      _activeOrder = _orders.firstWhere((o) => o.isActive);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<OrderModel?> placeOrder({
    required String restaurantId,
    required String restaurantName,
    required String restaurantImage,
    required List<OrderItemModel> items,
    required deliveryAddress,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    required String paymentMethod,
  }) async {
    _isPlacing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 2000));

    final order = OrderModel(
      id: 'ord${DateTime.now().millisecondsSinceEpoch}',
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
      items: items,
      deliveryAddress: deliveryAddress,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      status: OrderStatus.confirmed,
      placedAt: DateTime.now(),
      estimatedDeliveryAt: DateTime.now().add(const Duration(minutes: 35)),
      riderId: 'rider1',
      riderName: 'Sajib Mia',
      riderPhone: '+8801912345678',
      riderPhoto: 'https://i.pravatar.cc/100?img=12',
    );

    _orders.insert(0, order);
    _activeOrder = order;
    _isPlacing = false;
    notifyListeners();
    return order;
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
