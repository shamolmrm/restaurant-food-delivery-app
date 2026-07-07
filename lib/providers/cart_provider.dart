import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import '../models/address_model.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/dummy_data.dart';

class CartItem {
  final FoodItemModel item;
  int quantity;
  final String? specialNote;

  CartItem({
    required this.item,
    required this.quantity,
    this.specialNote,
  });

  double get total => item.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedCoupon;
  double _discount = 0;
  AddressModel? _selectedAddress;
  String _selectedPayment = 'Cash on Delivery';

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  bool get isEmpty => _items.isEmpty;
  String? get appliedCoupon => _appliedCoupon;
  double get discount => _discount;
  AddressModel? get selectedAddress => _selectedAddress;
  String get selectedPayment => _selectedPayment;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.total);

  double get deliveryFee {
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0;
    return _items.isEmpty ? 0 : 30;
  }

  double get platformFee => _items.isEmpty ? 0 : AppConstants.platformFee;

  double get total =>
      subtotal + deliveryFee + platformFee - _discount;

  void addItem(FoodItemModel item) {
    final idx = _items.indexWhere((ci) => ci.item.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(item: item, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((ci) => ci.item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    final idx = _items.indexWhere((ci) => ci.item.id == itemId);
    if (idx >= 0) {
      _items[idx].quantity = quantity;
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final validCoupons = {
      'FIRST50': 0.5,
      'FREEDEL': 0.0,
      'BKASH20': 0.2,
      'SAVE10': 0.1,
    };

    if (validCoupons.containsKey(code.toUpperCase())) {
      _appliedCoupon = code.toUpperCase();
      _discount = subtotal * (validCoupons[code.toUpperCase()] ?? 0);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _discount = 0;
    notifyListeners();
  }

  void setAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void setPayment(String method) {
    _selectedPayment = method;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _appliedCoupon = null;
    _discount = 0;
    _selectedAddress ??= dummyAddresses.isNotEmpty ? dummyAddresses.first : null;
    notifyListeners();
  }

  CartProvider() {
    _selectedAddress =
        dummyAddresses.isNotEmpty ? dummyAddresses.first : null;
  }

  int getItemQuantity(String itemId) {
    final idx = _items.indexWhere((ci) => ci.item.id == itemId);
    return idx >= 0 ? _items[idx].quantity : 0;
  }
}
