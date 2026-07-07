import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/rider_model.dart';
import '../models/staff_model.dart';
import '../core/constants/dummy_data.dart';

class AdminProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _orderFilter = 'All';
  List<OrderModel> _orders = [];
  List<RiderModel> _riders = [];
  List<StaffModel> _staff = [];

  bool get isLoading => _isLoading;
  String get orderFilter => _orderFilter;
  List<RiderModel> get riders => _riders;
  List<StaffModel> get staff => _staff;

  List<OrderModel> get allOrders => _orders;

  List<OrderModel> get filteredOrders {
    if (_orderFilter == 'All') return _orders;
    return _orders.where((o) {
      switch (_orderFilter) {
        case 'Pending': return o.status == OrderStatus.pending || o.status == OrderStatus.confirmed;
        case 'Preparing': return o.status == OrderStatus.preparing;
        case 'On the Way': return o.status == OrderStatus.onTheWay;
        case 'Delivered': return o.status == OrderStatus.delivered;
        case 'Cancelled': return o.status == OrderStatus.cancelled;
        default: return true;
      }
    }).toList();
  }

  // Stats
  int get todayOrders => _orders.where((o) {
    final now = DateTime.now();
    return o.placedAt.day == now.day &&
        o.placedAt.month == now.month &&
        o.placedAt.year == now.year;
  }).length;

  double get todayRevenue => _orders.where((o) {
    final now = DateTime.now();
    return o.placedAt.day == now.day &&
        o.placedAt.month == now.month &&
        o.placedAt.year == now.year &&
        o.status != OrderStatus.cancelled;
  }).fold(0, (sum, o) => sum + o.total);

  int get activeOrders => _orders.where((o) =>
      o.status == OrderStatus.pending ||
      o.status == OrderStatus.preparing ||
      o.status == OrderStatus.onTheWay).length;

  int get activeRiders =>
      _riders.where((r) => r.status != RiderStatus.offline).length;

  double get totalRevenue => _orders
      .where((o) => o.status != OrderStatus.cancelled)
      .fold(0, (sum, o) => sum + o.total);

  // Weekly sales (last 7 days)
  List<double> get weeklySales {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return _orders
          .where((o) =>
              o.placedAt.day == day.day &&
              o.placedAt.month == day.month &&
              o.status != OrderStatus.cancelled)
          .fold<double>(0, (sum, o) => sum + o.total);
    });
  }

  List<String> get weekDayLabels {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return days[day.weekday - 1];
    });
  }

  AdminProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _orders = adminDummyOrders;
    _riders = dummyRiders;
    _staff = dummyKitchenStaff;
    _isLoading = false;
    notifyListeners();
  }

  void setOrderFilter(String filter) {
    _orderFilter = filter;
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final old = _orders[idx];
    _orders[idx] = OrderModel(
      id: old.id,
      restaurantId: old.restaurantId,
      restaurantName: old.restaurantName,
      restaurantImage: old.restaurantImage,
      items: old.items,
      deliveryAddress: old.deliveryAddress,
      subtotal: old.subtotal,
      deliveryFee: old.deliveryFee,
      discount: old.discount,
      total: old.total,
      paymentMethod: old.paymentMethod,
      status: status,
      placedAt: old.placedAt,
      estimatedDeliveryAt: old.estimatedDeliveryAt,
      riderId: old.riderId,
      riderName: old.riderName,
      riderPhone: old.riderPhone,
      riderPhoto: old.riderPhoto,
      trackingNote: old.trackingNote,
    );
    notifyListeners();
  }

  String generateReport() {
    final now = DateTime.now();
    final buf = StringBuffer();
    buf.writeln('╔════════════════════════════════╗');
    buf.writeln('║     FEASTLY — SALES REPORT     ║');
    buf.writeln('╚════════════════════════════════╝');
    buf.writeln('Generated: ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    buf.writeln('');
    buf.writeln('━━━━━━ TODAY\'S SUMMARY ━━━━━━');
    buf.writeln('Orders Today   : $todayOrders');
    buf.writeln('Revenue Today  : ৳${todayRevenue.toInt()}');
    buf.writeln('Active Orders  : $activeOrders');
    buf.writeln('Active Riders  : $activeRiders');
    buf.writeln('');
    buf.writeln('━━━━━━ ALL TIME ━━━━━━');
    buf.writeln('Total Orders   : ${_orders.length}');
    buf.writeln('Total Revenue  : ৳${totalRevenue.toInt()}');
    buf.writeln('Avg Order Value: ৳${_orders.isEmpty ? 0 : (totalRevenue / _orders.length).toInt()}');
    buf.writeln('');
    buf.writeln('━━━━━━ ORDER STATUS ━━━━━━');
    for (final s in OrderStatus.values) {
      final count = _orders.where((o) => o.status == s).length;
      buf.writeln('${s.name.padRight(12)}: $count');
    }
    buf.writeln('');
    buf.writeln('━━━━━━ RECENT ORDERS ━━━━━━');
    for (final o in _orders.take(10)) {
      buf.writeln('#${o.id}  ${o.restaurantName}  ৳${o.total.toInt()}  ${o.status.name}');
    }
    buf.writeln('');
    buf.writeln('━━━━━━ RIDERS ━━━━━━');
    for (final r in _riders) {
      buf.writeln('${r.name} (${r.status.name}) — ${r.todayDeliveries} deliveries today');
    }
    buf.writeln('');
    buf.writeln('━━━━━━ KITCHEN STAFF ━━━━━━');
    for (final s in _staff) {
      buf.writeln('${s.name} [${s.roleLabel}] — ${s.ordersToday} orders today');
    }
    buf.writeln('');
    buf.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buf.writeln('Feastly Admin Dashboard Report');
    return buf.toString();
  }
}
